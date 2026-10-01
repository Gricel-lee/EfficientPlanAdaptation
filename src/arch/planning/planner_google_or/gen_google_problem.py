#!/usr/bin/env python3
"""
planning_generator.py
Reads a planning-problem JSON and emits a runnable CP-SAT solver.

Usage:
    python planning_generator.py example.json [output_solver.py]

The generator handles three kinds of task_graph nodes:

  Concrete    — task ID matches an agent's task list; directly schedulable.
  Virtual     — abstract node whose concrete variants share its name as a
                prefix (e.g. "Deliver_Box1" is virtual; "Deliver_Box1_CP"
                and "Deliver_Box1_HP" are its concrete alternatives).
                Exactly one alternative runs.
  Derived-optional — a concrete task whose OR-dependencies are all optional
                (e.g. Drone_Relay).  Its presence is derived from whether
                at least one of those deps is active.

Constraints enforced
--------------------
  AND deps  : task starts after ALL listed predecessors finish.
  OR deps   : task starts after AT LEAST ONE listed predecessor finishes.
  No-overlap: each agent does at most one task at a time.
  max_duration: hard upper bound on the makespan.

Objective: minimise completion time of tasks_to_be_completed.
"""

import heapq
import json
import os
import sys
from collections import defaultdict


# ── Helpers ───────────────────────────────────────────────────────────────────

def load(json_path: str) -> dict:
    with open(json_path) as f:
        return json.load(f)


def safe(s: str) -> str:
    """Make s usable as a Python variable-name segment."""
    for ch in '-. ':
        s = s.replace(ch, '_')
    return s


# ── Travel-time helpers ───────────────────────────────────────────────────────

def parse_task_locations(tasks_raw: list) -> dict:
    """Returns {task_id: {start, end, interchangeable}}."""
    return {
        t['id']: {
            'start':          t.get('start_location', ''),
            'end':            t.get('end_location', ''),
            'interchangeable': t.get('start_end_location_interchangeable', False),
        }
        for t in tasks_raw
    }


def build_agent_graph(paths_raw: list, agent: dict) -> dict:
    """Returns {(from_loc, to_loc): duration} for the agent, both directions."""
    path_ep = {p['id']: (p['start_location'], p['end_location']) for p in paths_raw}
    graph: dict = {}
    for tr in agent.get('travel', []):
        pid, dur = tr['id'], int(tr['duration'])
        if pid in path_ep:
            a, b = path_ep[pid]
            for x, y in ((a, b), (b, a)):
                if (x, y) not in graph or dur < graph[(x, y)]:
                    graph[(x, y)] = dur
    return graph


def dijkstra_travel(graph: dict, from_loc: str, to_loc: str) -> int:
    """Shortest travel time between two locations; 0 if same, 0 if unreachable."""
    if not from_loc or not to_loc or from_loc == to_loc:
        return 0
    dist: dict = {from_loc: 0}
    h = [(0, from_loc)]
    while h:
        d, u = heapq.heappop(h)
        if u == to_loc:
            return d
        if d > dist.get(u, float('inf')):
            continue
        for (a, b), w in graph.items():
            if a == u:
                nd = d + w
                if nd < dist.get(b, float('inf')):
                    dist[b] = nd
                    heapq.heappush(h, (nd, b))
    return 0  # unreachable: no constraint added


def dijkstra_path(graph: dict, from_loc: str, to_loc: str) -> list:
    """Returns the shortest path as [(from, to, duration), ...] hops; [] if same or unreachable."""
    if not from_loc or not to_loc or from_loc == to_loc:
        return []
    dist: dict = {from_loc: 0}
    prev_edge: dict = {}  # node -> (prev_node, edge_weight)
    h = [(0, from_loc)]
    while h:
        d, u = heapq.heappop(h)
        if d > dist.get(u, float('inf')):
            continue
        for (a, b), w in graph.items():
            if a == u:
                nd = d + w
                if nd < dist.get(b, float('inf')):
                    dist[b] = nd
                    prev_edge[b] = (u, w)
                    heapq.heappush(h, (nd, b))
    if to_loc not in prev_edge:
        return []  # unreachable
    hops = []
    node = to_loc
    while node in prev_edge:
        u, w = prev_edge[node]
        hops.append((u, node, w))
        node = u
    hops.reverse()
    return hops


def common_agents(task_a: str, task_b: str, task_to_agents: dict) -> list:
    """Sorted list of agent IDs that can perform both task_a and task_b."""
    a_set = {ag for ag, _ in task_to_agents.get(task_a, [])}
    b_set = {ag for ag, _ in task_to_agents.get(task_b, [])}
    return sorted(a_set & b_set)


# ── Problem parsing ───────────────────────────────────────────────────────────

def parse_agents(agents_raw: list) -> tuple[dict, dict]:
    """
    Returns:
      task_to_agents : {task_id: [(agent_id, duration)]}
      agent_travel   : {agent_id: {path_id: duration}}
    """
    task_to_agents: dict = defaultdict(list)
    agent_travel: dict = {}
    for a in agents_raw:
        agent_travel[a['id']] = {tr['id']: tr['duration'] for tr in a.get('travel', [])}
        for t in a.get('tasks', []):
            mv = t.get('metric_values', t)  # flat fields fallback
            dur = mv.get('duration') or mv.get('duration_direct') or 0
            task_to_agents[t['id']].append((a['id'], int(dur)))
    return dict(task_to_agents), agent_travel


def dep_reachable(tid: str, task_graph: dict) -> set:
    """All tasks reachable by following depends_on edges from tid (inclusive)."""
    visited: set = set()
    stack = [tid]
    while stack:
        t = stack.pop()
        if t in visited:
            continue
        visited.add(t)
        stack.extend(task_graph.get(t, {}).get('depends_on', []))
    return visited


def collect_required(task_graph: dict, targets: list) -> set:
    """Walk dependency graph backwards from targets."""
    required: set = set()
    def visit(tid):
        if tid in required:
            return
        required.add(tid)
        for dep in task_graph.get(tid, {}).get('depends_on', []):
            visit(dep)
    for t in targets:
        visit(t)
    return required


def find_or_optional(task_graph: dict, targets: list, required: set) -> set:
    """Tasks reachable only via OR-dep edges — not force-required by any AND chain.
    These become optional interval vars; AddBoolOr enforces at least one per OR group runs."""
    force = set(t for t in targets if t in required)
    changed = True
    while changed:
        changed = False
        for tid in list(force):
            if task_graph.get(tid, {}).get('dependency_type', 'AND') == 'AND':
                for dep in task_graph.get(tid, {}).get('depends_on', []):
                    if dep in required and dep not in force:
                        force.add(dep)
                        changed = True
    return required - force


def classify_nodes(required: set, task_to_agents: dict, task_graph: dict,
                   targets: set = None) -> tuple[set, set, set]:
    """
    Returns (concrete, virtual, derived_optional).

    derived_optional: concrete tasks whose ALL deps are optional subtasks or
    other derived-optional tasks (fixed-point expansion supports chains).
    Target tasks are never classified as derived-optional.
    """
    concrete = required & set(task_to_agents)
    virtual  = required - concrete

    optional_subs: set = set()
    for vid in virtual:
        alts = [d for d in task_graph.get(vid, {}).get('depends_on', []) if d in concrete]
        optional_subs.update(alts)

    targets_set = targets or set()
    derived_optional: set = set()
    changed = True
    while changed:
        changed = False
        for tid in concrete - optional_subs - derived_optional - targets_set:
            node = task_graph.get(tid, {})
            deps = node.get('depends_on', [])
            if deps and all(d in optional_subs or d in derived_optional for d in deps):
                derived_optional.add(tid)
                changed = True

    return concrete, virtual, derived_optional


# ── Code generation ───────────────────────────────────────────────────────────

def generate(data: dict, json_path: str = None) -> str:
    agents_raw  = data['agents']
    task_graph  = data.get('task_graph', {})
    constraints = data.get('constraints', {})
    max_dur     = int(constraints.get('max_duration', 300))
    targets     = constraints.get('tasks_to_be_completed', [])

    task_to_agents, agent_travel = parse_agents(agents_raw)
    agent_ids   = [a['id'] for a in agents_raw]

    # Validate the user-authored graph. A task_graph node is "virtual" (an abstract
    # choice point, e.g. "Delivered") when its id has no agent assignment. Its
    # depends_on list IS the set of concrete alternatives to choose exactly one
    # of — not a prerequisite chain — so it must be non-empty and combined with
    # "OR" (each alternative carries its own prerequisites as its own task_graph
    # entry, e.g. "Delivered_by_human_Row1": {"depends_on": ["Harvest_Row1"], ...}).
    #
    # Conversely, a concrete task (one agents can actually perform) must combine
    # its dependencies with "AND" — "OR" on a concrete task's dependency edge
    # makes find_or_optional() treat that dependency as skippable rather than
    # mandatory, silently dropping required constraints.
    for tid, tnode in task_graph.items():
        dep_type = tnode.get('dependency_type', 'AND')
        if tid in task_to_agents:
            if dep_type == 'OR':
                sys.exit(
                    f'Task: {tid} must not be defined with "dependency_type": "OR" — '
                    f'"OR" is only allowed for virtual tasks (an id X with no agent '
                    f'assignment, whose "depends_on" lists the concrete alternatives '
                    f'to choose from). See task_graph in {json_path or "<input JSON>"}'
                )
        else:
            depends_on = tnode.get('depends_on', [])
            if not depends_on or dep_type != 'OR':
                sys.exit(
                    f'Virtual task {tid!r} cannot have empty "depends_on" and must be '
                    f'defined with "dependency_type": "OR" (got depends_on={depends_on!r}, '
                    f'dependency_type={dep_type!r}). Its "depends_on" must list the concrete '
                    f'alternatives to choose from. See task_graph in {json_path or "<input JSON>"}'
                )

    # Reverse lookup: concrete/virtual id -> the virtual parent(s) that list it as
    # an alternative in their own depends_on. Used below to pull a virtual parent
    # into `required` whenever one of its alternatives is required some other way
    # (e.g. a task depends directly on one specific alternative, bypassing the choice).
    belongs_to_parent: dict = defaultdict(list)
    for vid, vnode in task_graph.items():
        if vid not in task_to_agents:
            for alt in vnode.get('depends_on', []):
                belongs_to_parent[alt].append(vid)

    # Fixed-point closure: backward-collect dependencies, then pull in any virtual
    # parent whose alternative just became required. A virtual parent's own
    # depends_on IS its alternatives, so collect_required's backward walk already
    # discovers them once the parent itself is required — no separate forward
    # pass is needed the way name-prefix matching used to require.
    required: set = set()
    changed = True
    while changed:
        before = set(required)
        required |= collect_required(task_graph, list(targets) + list(required))
        for tid in list(required):
            for vid in belongs_to_parent.get(tid, []):
                required.add(vid)
        changed = required != before

    concrete, virtual, derived_optional = classify_nodes(required, task_to_agents, task_graph, set(targets))

    # Subtask relationships: a virtual node's alternatives are its own depends_on.
    subtask_map: dict = {
        v: [d for d in task_graph.get(v, {}).get('depends_on', []) if d in concrete]
        for v in virtual
    }
    belongs_to:  dict = {s: v for v, subs in subtask_map.items() for s in subs}
    optional_subs = set(belongs_to)          # subtasks of virtual nodes
    or_optional   = (find_or_optional(task_graph, targets, required)
                     & concrete - optional_subs - derived_optional)
    mandatory_concrete = concrete - optional_subs - derived_optional - or_optional

    # ── Travel-time setup ─────────────────────────────────────────────────────
    task_locs   = parse_task_locations(data.get('tasks', []))
    paths_raw   = data.get('paths', [])
    agent_graphs = {a['id']: build_agent_graph(paths_raw, a) for a in agents_raw}
    agent_initial = {a['id']: a.get('initial_location', '') for a in agents_raw}

    # Interchangeable tasks that have location info — need direction BoolVars
    interchangeable = {tid for tid in required
                       if task_locs.get(tid, {}).get('interchangeable')}
    dir_vars: dict = {}      # {task_id: python_variable_name_string}
    agent_presence: dict = {}  # {(task_id, agent_id): varname | None} for pairwise guards

    def travel(ag_id: str, from_loc: str, to_loc: str) -> int:
        return dijkstra_travel(agent_graphs.get(ag_id, {}), from_loc, to_loc)

    # Intra-task traversal: any task with distinct start and end locations involves
    # physically traversing start→end as part of the task. Add that path duration
    # to the task execution time so the model reflects the true total time.
    loc_to_path_id: dict = {}  # (a, b) -> path_id for direct connections
    for p in paths_raw:
        a, b = p['start_location'], p['end_location']
        loc_to_path_id[(a, b)] = p['id']
        loc_to_path_id[(b, a)] = p['id']

    task_intra: dict = {}  # {task_id: (path_label, traversal_min)} for display
    for tid in sorted(required):
        locs = task_locs.get(tid, {})
        sl, el = locs.get('start', ''), locs.get('end', '')
        if not sl or not el or sl == el:
            continue
        new_entries = []
        for ag_id, dur in task_to_agents.get(tid, []):
            trav = travel(ag_id, sl, el)
            new_entries.append((ag_id, dur + trav))
            if tid not in task_intra and trav > 0:
                path_label = loc_to_path_id.get((sl, el)) or loc_to_path_id.get((el, sl)) or f'{sl}-{el}'
                task_intra[tid] = (path_label, trav)
        if new_entries:
            task_to_agents[tid] = new_entries

    # Precompute hop-by-hop travel paths for display (only multi-hop paths are stored;
    # single-hop travel is already shown correctly by the fallback printer).
    agent_paths: dict = {}  # {(agent_id, from_loc, to_loc): [(from, to, dur), ...]}
    for ag in agents_raw:
        ag_id = ag['id']
        locs: set = {agent_initial.get(ag_id, '')}
        for tid in task_to_agents:
            if any(a == ag_id for a, _ in task_to_agents.get(tid, [])):
                tl = task_locs.get(tid, {})
                locs.update([tl.get('start', ''), tl.get('end', '')])
        locs.discard('')
        g = agent_graphs.get(ag_id, {})
        for src in sorted(locs):
            for dst in sorted(locs):
                if src != dst:
                    hops = dijkstra_path(g, src, dst)
                    if len(hops) > 1:
                        agent_paths[(ag_id, src, dst)] = hops

    def emit_constraint(w_fn, tid: str, dep: str, t: int, guards: list):
        """Emit model.add(ts[tid] >= te[dep] + t) with optional guards."""
        t_str = f' + {t}' if t > 0 else ''
        base   = f'    model.add(ts[{tid!r}] >= te[{dep!r}]{t_str})'
        if not guards:
            w_fn(base)
        elif len(guards) == 1:
            w_fn(f'{base}.only_enforce_if({guards[0]})')
        else:
            w_fn(f'{base}.only_enforce_if([{", ".join(guards)}])')

    def emit_ts_lb(w_fn, tid: str, lb: int, guards: list):
        """Emit model.add(ts[tid] >= lb) with optional guards."""
        base = f'    model.add(ts[{tid!r}] >= {lb})'
        if not guards:
            w_fn(base)
        elif len(guards) == 1:
            w_fn(f'{base}.only_enforce_if({guards[0]})')
        else:
            w_fn(f'{base}.only_enforce_if([{", ".join(guards)}])')

    # ── Emit code ─────────────────────────────────────────────────────────────
    L: list = []
    def w(line: str = ''):
        L.append(line)

    w('from ortools.sat.python import cp_model')
    w('import os')
    w()
    w('# ─────────────────────────────────────────────────────────────────────')
    w('# Auto-generated CP-SAT solver')
    w(f'# Targets       : {targets}')
    w(f'# Max duration  : {max_dur} min')
    w(f'# Virtual nodes : {sorted(virtual)}  (abstract; resolved by alternatives)')
    w(f'# Derived-opt.  : {sorted(derived_optional)}  (run only when triggered)')
    w(f'# OR-optional   : {sorted(or_optional)}  (at least one per OR-dep group must run)')
    w('# ─────────────────────────────────────────────────────────────────────')
    w()
    w()
    w('def main():')
    w('    model = cp_model.CpModel()')
    w(f'    horizon = {max_dur}')
    w()
    w('    def make_iv(name, dur):')
    w('        s = model.new_int_var(0, horizon, name + "_s")')
    w('        e = model.new_int_var(0, horizon, name + "_e")')
    w('        model.add(e == s + dur)')
    w('        return s, e')
    w()
    w('    ts  = {}   # ts[task_id]              -> start IntVar')
    w('    te  = {}   # te[task_id]              -> end   IntVar')
    w('    pr  = {}   # pr[task_id]              -> BoolVar | 1 (presence/active)')
    w('    asg = {}   # asg[(task_id, agent_id)] -> BoolVar | 1')
    w(f'    agent_ivs = {{a: [] for a in {agent_ids!r}}}')
    w()

    # ── Mandatory concrete tasks ───────────────────────────────────────────────
    w('    # ── Mandatory concrete tasks ───────────────────────────────────────')
    for tid in sorted(mandatory_concrete):
        capable = task_to_agents[tid]
        if len(capable) == 1:
            agent_id, dur = capable[0]
            w(f'    # {tid}  ({agent_id}, {dur} min)')
            w(f'    ts[{tid!r}], te[{tid!r}] = make_iv({tid!r}, {dur})')
            w(f'    pr[{tid!r}]  = 1')
            w(f'    asg[({tid!r}, {agent_id!r})] = 1')
            w(f'    agent_ivs[{agent_id!r}].append(')
            w(f'        model.new_interval_var(ts[{tid!r}], {dur}, te[{tid!r}], {(tid+"_iv")!r}))')
            agent_presence[(tid, agent_id)] = None  # always present, no guard
        else:
            agent_names = [a for a, _ in capable]
            w(f'    # {tid}  (agent choice: {agent_names})')
            w(f'    ts[{tid!r}] = model.new_int_var(0, horizon, {(tid+"_s")!r})')
            w(f'    te[{tid!r}] = model.new_int_var(0, horizon, {(tid+"_e")!r})')
            w(f'    pr[{tid!r}]  = 1')
            presences = []
            for agent_id, dur in capable:
                p = f'_p_{safe(tid)}_{safe(agent_id)}'
                w(f'    {p} = model.new_bool_var({(tid+"_"+agent_id)!r})')
                w(f'    asg[({tid!r}, {agent_id!r})] = {p}')
                w(f'    _s, _e = make_iv({(tid+"_"+agent_id)!r}, {dur})')
                w(f'    model.add(ts[{tid!r}] == _s).only_enforce_if({p})')
                w(f'    model.add(te[{tid!r}] == _e).only_enforce_if({p})')
                w(f'    agent_ivs[{agent_id!r}].append(')
                w(f'        model.new_optional_interval_var(_s, {dur}, _e, {p}, {(tid+"_"+agent_id+"_iv")!r}))')
                presences.append(p)
                agent_presence[(tid, agent_id)] = p
            w(f'    model.add_exactly_one([{", ".join(presences)}])')
        w()

    # ── Optional subtasks (concrete alternatives of virtual nodes) ─────────────
    w('    # ── Optional subtasks (concrete alternatives of virtual nodes) ──────')
    for tid in sorted(optional_subs):
        capable = task_to_agents[tid]
        agent_id, dur = capable[0]   # always single-agent for this problem
        p = f'_p_{safe(tid)}'
        w(f'    # {tid}  ({agent_id}, {dur} min) — optional alternative')
        w(f'    {p} = model.new_bool_var({tid!r})')
        w(f'    pr[{tid!r}]  = {p}')
        w(f'    asg[({tid!r}, {agent_id!r})] = {p}')
        w(f'    ts[{tid!r}], te[{tid!r}] = make_iv({tid!r}, {dur})')
        w(f'    agent_ivs[{agent_id!r}].append(')
        w(f'        model.new_optional_interval_var(ts[{tid!r}], {dur}, te[{tid!r}], {p}, {(tid+"_iv")!r}))')
        agent_presence[(tid, agent_id)] = p
        w()

    # ── OR-optional tasks ─────────────────────────────────────────────────────
    if or_optional:
        w('    # ── OR-optional tasks (at least one per OR-dep group must run) ───────')
        for tid in sorted(or_optional):
            capable = task_to_agents[tid]
            p = f'_p_{safe(tid)}'
            if len(capable) == 1:
                agent_id, dur = capable[0]
                w(f'    # {tid}  ({agent_id}, {dur} min) — OR-optional')
                w(f'    {p} = model.new_bool_var({tid!r})')
                w(f'    pr[{tid!r}]  = {p}')
                w(f'    asg[({tid!r}, {agent_id!r})] = {p}')
                w(f'    ts[{tid!r}], te[{tid!r}] = make_iv({tid!r}, {dur})')
                w(f'    agent_ivs[{agent_id!r}].append(')
                w(f'        model.new_optional_interval_var(ts[{tid!r}], {dur}, te[{tid!r}], {p}, {(tid+"_iv")!r}))')
                agent_presence[(tid, agent_id)] = p
            else:
                agent_names = [a for a, _ in capable]
                w(f'    # {tid}  (agent choice: {agent_names}) — OR-optional')
                w(f'    ts[{tid!r}] = model.new_int_var(0, horizon, {(tid+"_s")!r})')
                w(f'    te[{tid!r}] = model.new_int_var(0, horizon, {(tid+"_e")!r})')
                w(f'    {p} = model.new_bool_var({tid!r})')
                w(f'    pr[{tid!r}]  = {p}')
                per_agent_ps = []
                for agent_id, dur in capable:
                    pa = f'_p_{safe(tid)}_{safe(agent_id)}'
                    per_agent_ps.append(pa)
                    w(f'    {pa} = model.new_bool_var({(tid+"_"+agent_id)!r})')
                    w(f'    asg[({tid!r}, {agent_id!r})] = {pa}')
                    w(f'    _s, _e = make_iv({(tid+"_"+agent_id)!r}, {dur})')
                    w(f'    model.add(ts[{tid!r}] == _s).only_enforce_if({pa})')
                    w(f'    model.add(te[{tid!r}] == _e).only_enforce_if({pa})')
                    w(f'    agent_ivs[{agent_id!r}].append(')
                    w(f'        model.new_optional_interval_var(_s, {dur}, _e, {pa}, {(tid+"_"+agent_id+"_iv")!r}))')
                    agent_presence[(tid, agent_id)] = pa
                w(f'    model.add_at_most_one([{", ".join(per_agent_ps)}])')
                for pa in per_agent_ps:
                    w(f'    model.add_implication({pa}, {p})')
                w(f'    model.add_bool_or([{", ".join(per_agent_ps)}, ~{p}])')
            w()
        # For each successor with OR deps, enforce at least one dep runs
        for tid_s, node_s in task_graph.items():
            if tid_s not in required or node_s.get('dependency_type', 'AND') != 'OR':
                continue
            or_opt_deps = [d for d in node_s.get('depends_on', []) if d in or_optional]
            mandatory_deps = [d for d in node_s.get('depends_on', [])
                              if d in required and d not in or_optional]
            if or_opt_deps and not mandatory_deps:
                presences = [f'_p_{safe(d)}' for d in or_opt_deps]
                w(f'    # At least one OR-dep of {tid_s!r} must run')
                w(f'    model.add_bool_or([{", ".join(presences)}])')
                w()

    # ── Direction BoolVars for interchangeable tasks ──────────────────────────
    # Must be emitted before dep generation (dir_vars is referenced there).
    interch_in_model = (mandatory_concrete | optional_subs | or_optional) & interchangeable
    if interch_in_model:
        w('    # ── Direction vars (True = start→end, False = end→start) ──────────')
        for tid in sorted(interch_in_model):
            vname = f'_dir_{safe(tid)}'
            dir_vars[tid] = vname
            w(f'    {vname} = model.new_bool_var({(tid + "_dir")!r})')
        w()

    # ── Virtual nodes (bind canonical vars to active alternative) ─────────────
    if virtual:
        w('    # ── Virtual nodes (canonical vars bound to whichever alternative runs) ─')
        for vid in sorted(virtual):
            subs = subtask_map.get(vid, [])
            if not subs:
                w(f'    # WARNING: {vid!r} — no concrete alternatives found, skipping')
                continue
            w(f'    # {vid}  → exactly one of {subs}')
            w(f'    ts[{vid!r}] = model.new_int_var(0, horizon, {(vid+"_s")!r})')
            w(f'    te[{vid!r}] = model.new_int_var(0, horizon, {(vid+"_e")!r})')
            w(f'    pr[{vid!r}]  = model.new_bool_var({(vid+"_active")!r})')
            plist = [f'_p_{safe(s)}' for s in subs]
            w(f'    model.add_exactly_one([{", ".join(plist)}])')
            w(f'    model.add(pr[{vid!r}] == 1)')   # virtual node is always "done" (one alt runs)
            for st in subs:
                p = f'_p_{safe(st)}'
                w(f'    model.add(ts[{vid!r}] == ts[{st!r}]).OnlyEnforceIf({p})')
                w(f'    model.add(te[{vid!r}] == te[{st!r}]).OnlyEnforceIf({p})')
            w()

    # ── Derived-optional tasks (e.g. Drone_Relay) ─────────────────────────────
    if derived_optional:
        w('    # ── Derived-optional tasks (presence driven by OR-deps) ────────────')
        for tid in sorted(derived_optional):
            capable = task_to_agents[tid]
            agent_id, dur = capable[0]
            node = task_graph.get(tid, {})
            deps = node.get('depends_on', [])
            p = f'_p_{safe(tid)}'
            # Deps that are optional subtasks trigger this task (AddImplication).
            # Deps that are other derived-optional tasks only establish ordering
            # (handled in the Dependencies section — no implication here).
            trigger_deps = [d for d in deps if d in optional_subs]
            trigger_presences = [f'_p_{safe(d)}' for d in trigger_deps]
            w(f'    # {tid}  ({agent_id}, {dur} min) — active iff any of {trigger_deps} is active')
            w(f'    {p} = model.new_bool_var({tid!r})')
            w(f'    pr[{tid!r}]  = {p}')
            w(f'    asg[({tid!r}, {agent_id!r})] = {p}')
            w(f'    ts[{tid!r}], te[{tid!r}] = make_iv({tid!r}, {dur})')
            w(f'    agent_ivs[{agent_id!r}].append(')
            w(f'        model.new_optional_interval_var(ts[{tid!r}], {dur}, te[{tid!r}], {p}, {(tid+"_iv")!r}))')
            for dp in trigger_presences:
                w(f'    model.add_implication({dp}, {p})')
            if trigger_presences:
                w(f'    model.add_bool_or([~{p}, {", ".join(trigger_presences)}])')
                w(f'    # ^ {tid} only runs if at least one of {trigger_deps} is active')
            agent_presence[(tid, agent_id)] = p
            w()

    # ── Initial positioning ───────────────────────────────────────────────────
    # For each agent's root tasks (no same-agent predecessor), ensure the agent
    # can reach the task start from its initial_location before the task begins.
    init_pos_lines: list = []
    for agent_id in agent_ids:
        init_loc = agent_initial.get(agent_id, '')
        if not init_loc:
            continue
        ag_graph = agent_graphs.get(agent_id, {})
        for tid in sorted(required):
            if tid not in task_to_agents:
                continue
            if not any(a == agent_id for a, _ in task_to_agents[tid]):
                continue
            # Root task = no same-agent predecessor exists in the dep chain
            tid_deps = [d for d in task_graph.get(tid, {}).get('depends_on', [])
                        if d in required]
            same_agent_pred = False
            for d in tid_deps:
                if d in task_to_agents and any(a == agent_id for a, _ in task_to_agents[d]):
                    same_agent_pred = True; break
                for sub in subtask_map.get(d, []):
                    if any(a == agent_id for a, _ in task_to_agents.get(sub, [])):
                        same_agent_pred = True; break
                if same_agent_pred:
                    break
            if same_agent_pred:
                continue
            tlocs = task_locs.get(tid, {})
            if not tlocs.get('start'):
                continue
            # Use per-agent presence when available (multi-agent optional tasks),
            # so each agent's travel-time lower-bound only fires when that agent
            # is the one assigned — not when a faster agent is assigned instead.
            p_guard = agent_presence.get((tid, agent_id))
            # p_guard is None (mandatory, no guard), a task-level var (single-agent optional),
            # or a per-agent var (multi-agent optional).
            if tlocs.get('interchangeable') and tid in dir_vars:
                dir_v = dir_vars[tid]
                for t_val, g_dir in [
                    (dijkstra_travel(ag_graph, init_loc, tlocs['start']), dir_v),
                    (dijkstra_travel(ag_graph, init_loc, tlocs['end']),   f'~{dir_v}'),
                ]:
                    if t_val > 0:
                        g = ([x for x in [p_guard, g_dir] if x])
                        init_pos_lines.append((tid, t_val, g))
            else:
                t_val = dijkstra_travel(ag_graph, init_loc, tlocs['start'])
                if t_val > 0:
                    g = ([p_guard] if p_guard else [])
                    init_pos_lines.append((tid, t_val, g))

    # Deduplicate: same (tid, t_val, guards) can appear once per agent when agents share
    # the same initial location and task capability.
    seen_pos: set = set()
    unique_pos_lines: list = []
    for entry in init_pos_lines:
        key = (entry[0], entry[1], tuple(entry[2]))
        if key not in seen_pos:
            seen_pos.add(key)
            unique_pos_lines.append(entry)

    if unique_pos_lines:
        w('    # ── Initial positioning (agent start → first task) ─────────────────')
        for tid, t_val, guards in unique_pos_lines:
            emit_ts_lb(w, tid, t_val, guards)
        w()

    # ── Dependencies ──────────────────────────────────────────────────────────
    # Track ordering BoolVars per OR-optional dep for reverse implications below.
    or_dep_bvars: dict = defaultdict(list)   # {or_optional_dep_id: [bv_varname, ...]}

    def emit_dep_travel(w_fn, tid_task, dep_task, from_loc, to_loc, base_g):
        """Emit per-(dep-agent, tid-agent) pair dependency travel constraints.
        Same-agent pair: actual inter-task travel time.
        Cross-agent pair: t_val=0 — agents are independent, just ordering matters.
        Deduplicates identical (t_val, guards) combinations."""
        dep_ags = task_to_agents.get(dep_task) or [(None, 0)]
        tid_ags = task_to_agents.get(tid_task) or [(None, 0)]
        seen: set = set()
        for ag_d, _ in dep_ags:
            p_d = agent_presence.get((dep_task, ag_d)) if ag_d else None
            for ag_t, _ in tid_ags:
                p_t = agent_presence.get((tid_task, ag_t)) if ag_t else None
                t_val = travel(ag_t, from_loc, to_loc) if (ag_d == ag_t and ag_t) else 0
                g = base_g + [x for x in [p_d, p_t] if x]
                key = (t_val, tuple(g))
                if key not in seen:
                    seen.add(key)
                    emit_constraint(w_fn, tid_task, dep_task, t_val, g)
    w('    # ── Dependencies ──────────────────────────────────────────────────')
    for tid, node in task_graph.items():
        if tid not in required:
            continue
        if tid in virtual:
            # A virtual node's depends_on lists its alternatives, not prerequisites —
            # its ts/te are already bound to whichever alternative runs (see "Virtual
            # nodes" section above). Emitting a precedence constraint here too would
            # contradict that binding (ts[V] == ts[alt] but also ts[V] >= te[alt]).
            continue
        deps = [d for d in node.get('depends_on', []) if d in required]
        if not deps:
            continue
        dep_type = node.get('dependency_type', 'AND')
        is_opt   = tid in optional_subs or tid in derived_optional or tid in or_optional
        p_tid    = f'pr[{tid!r}]' if not is_opt else f'_p_{safe(tid)}'

        if dep_type == 'AND':
            # Determine the successor task's start locations (for travel computation).
            tid_locs   = task_locs.get(tid, {})
            tid_interch = tid_locs.get('interchangeable', False) and tid in dir_vars

            for dep in deps:
                dep_locs   = task_locs.get(dep, {})
                dep_interch = dep_locs.get('interchangeable', False) and dep in dir_vars

                # An AND dependency on an or_optional task must force that task's
                # presence — otherwise the solver can leave dep unscheduled and
                # satisfy the (guarded-on-presence) ordering constraint vacuously.
                # The OR-branch already does this via or_dep_bvars; the AND-branch
                # needs the same safeguard since it has no per-edge "did I use this"
                # bool to hang the reverse-implication off of.
                if dep in or_optional:
                    dep_p = f'_p_{safe(dep)}'
                    if is_opt:
                        w(f'    model.add_implication({p_tid}, {dep_p})')
                    else:
                        w(f'    model.add({dep_p} == 1)')

                if dep in virtual:
                    # Expand virtual dep → per-subtask constraints with travel
                    for sub in subtask_map.get(dep, []):
                        sub_end = task_locs.get(sub, {}).get('end', '')
                        if tid_interch:
                            dir_t = dir_vars[tid]
                            for to_loc, g_dir in [
                                (tid_locs['start'], dir_t),
                                (tid_locs['end'],   f'~{dir_t}'),
                            ]:
                                emit_dep_travel(w, tid, sub, sub_end, to_loc, [g_dir])
                        else:
                            emit_dep_travel(w, tid, sub, sub_end, tid_locs.get('start', ''), [])
                elif dep_interch:
                    dir_d = dir_vars[dep]
                    if tid_interch:
                        dir_t = dir_vars[tid]
                        for from_loc, g_d in [
                            (dep_locs['end'],   dir_d),
                            (dep_locs['start'], f'~{dir_d}'),
                        ]:
                            for to_loc, g_t in [
                                (tid_locs['start'], dir_t),
                                (tid_locs['end'],   f'~{dir_t}'),
                            ]:
                                emit_dep_travel(w, tid, dep, from_loc, to_loc, [g_d, g_t])
                    else:
                        to_loc = tid_locs.get('start', '')
                        for from_loc, g_d in [
                            (dep_locs['end'],   dir_d),
                            (dep_locs['start'], f'~{dir_d}'),
                        ]:
                            emit_dep_travel(w, tid, dep, from_loc, to_loc, [g_d])
                else:
                    # Non-interchangeable concrete dep
                    from_loc = dep_locs.get('end', '')
                    if tid_interch:
                        dir_t = dir_vars[tid]
                        for to_loc, g_t in [
                            (tid_locs['start'], dir_t),
                            (tid_locs['end'],   f'~{dir_t}'),
                        ]:
                            emit_dep_travel(w, tid, dep, from_loc, to_loc, [g_t])
                    else:
                        emit_dep_travel(w, tid, dep, from_loc, tid_locs.get('start', ''), [])
        else:
            bvars = []
            _tid_locs_or    = task_locs.get(tid, {})
            _tid_interch_or = _tid_locs_or.get('interchangeable', False) and tid in dir_vars
            for dep in deps:
                bv = f'_dep_{safe(tid)}_{safe(dep)}'
                dep_is_opt = dep in optional_subs or dep in derived_optional or dep in or_optional
                dep_p = f'_p_{safe(dep)}'
                _dep_locs_or    = task_locs.get(dep, {})
                _dep_interch_or = _dep_locs_or.get('interchangeable', False) and dep in dir_vars
                w(f'    {bv} = model.new_bool_var({(tid+"_after_"+dep)!r})')
                dep_ends = ([(_dep_locs_or.get('end', ''),   dir_vars[dep]),
                              (_dep_locs_or.get('start', ''), f'~{dir_vars[dep]}')]
                             if _dep_interch_or else
                             [(_dep_locs_or.get('end', ''), None)])
                tid_starts = ([(_tid_locs_or.get('start', ''), dir_vars[tid]),
                                (_tid_locs_or.get('end', ''),   f'~{dir_vars[tid]}')]
                               if _tid_interch_or else
                               [(_tid_locs_or.get('start', ''), None)])
                for from_loc, g_d in dep_ends:
                    for to_loc, g_t in tid_starts:
                        emit_dep_travel(w, tid, dep, from_loc, to_loc,
                                        [bv] + [x for x in [g_d, g_t] if x])
                if dep_is_opt:
                    # Guard: solver may only "wait for dep" when dep is actually active.
                    # Without this, an inactive dep's ts/te=0 trivially satisfies the constraint.
                    w(f'    model.add_implication({bv}, {dep_p})')
                if dep in or_optional:
                    or_dep_bvars[dep].append(bv)
                bvars.append(bv)
            if is_opt:
                w(f'    model.add_bool_or([{", ".join(bvars)}, ~{p_tid}])')
                w(f'    # ^ {tid}: when active, must start after at least one ACTIVE dep in {deps}')
            else:
                w(f'    model.add_bool_or([{", ".join(bvars)}])')
                w(f'    # ^ {tid} starts after ANY active dep in {deps}')
    # Reverse implication: an OR-optional dep only runs if chosen by at least one successor.
    if or_dep_bvars:
        w('    # OR-optional deps only run when chosen by a successor')
        for dep_id, bv_list in sorted(or_dep_bvars.items()):
            dep_p = f'_p_{safe(dep_id)}'
            if len(bv_list) == 1:
                w(f'    model.add_implication({dep_p}, {bv_list[0]})')
            else:
                w(f'    model.add_bool_or([{", ".join(bv_list)}, ~{dep_p}])')
        w()
    w()

    # ── Pairwise travel for same-agent tasks with no dep ordering ─────────────
    # When two tasks of the same agent have no dep chain, the no-overlap
    # constraint prevents overlap but doesn't add travel time.  We add an
    # ordering BoolVar + conditional travel constraints for every such pair.
    # Optional tasks get an additional presence guard so the constraint only
    # fires when both tasks are actually active.
    reach_cache: dict = {}
    def cached_reach(tid):
        if tid not in reach_cache:
            reach_cache[tid] = dep_reachable(tid, task_graph)
        return reach_cache[tid]

    # Presence expression: None = always present (mandatory), else var-name string.
    # When ag_id is given, returns the per-agent BoolVar name (e.g. multi-agent tasks).
    def presence_expr(tid, ag_id=None):
        if ag_id is not None and (tid, ag_id) in agent_presence:
            return agent_presence[(tid, ag_id)]
        if tid in optional_subs or tid in derived_optional or tid in or_optional:
            return f'_p_{safe(tid)}'
        return None  # mandatory

    pairwise_lines: list = []
    def wp(s): pairwise_lines.append(s)

    all_agent_tasks = optional_subs | derived_optional | mandatory_concrete | or_optional
    for ag_id in agent_ids:
        ag_tasks = sorted([
            tid for tid in all_agent_tasks
            if any(a == ag_id for a, _ in task_to_agents.get(tid, []))
        ])
        for i, tid_a in enumerate(ag_tasks):
            for tid_b in ag_tasks[i + 1:]:
                if tid_b in cached_reach(tid_a) or tid_a in cached_reach(tid_b):
                    continue  # already ordered through dep chain
                locs_a = task_locs.get(tid_a, {})
                locs_b = task_locs.get(tid_b, {})
                dv_a = dir_vars.get(tid_a)
                dv_b = dir_vars.get(tid_b)
                a_ends   = [(locs_a.get('end',''),   dv_a),
                            (locs_a.get('start',''), f'~{dv_a}')] if dv_a else \
                           [(locs_a.get('end',''),   None)]
                b_starts = [(locs_b.get('start',''), dv_b),
                            (locs_b.get('end',''),   f'~{dv_b}')] if dv_b else \
                           [(locs_b.get('start',''), None)]
                b_ends   = [(locs_b.get('end',''),   dv_b),
                            (locs_b.get('start',''), f'~{dv_b}')] if dv_b else \
                           [(locs_b.get('end',''),   None)]
                a_starts = [(locs_a.get('start',''), dv_a),
                            (locs_a.get('end',''),   f'~{dv_a}')] if dv_a else \
                           [(locs_a.get('start',''), None)]
                any_t = any(travel(ag_id, ae, bs) > 0
                            for ae, _ in a_ends for bs, _ in b_starts) or \
                        any(travel(ag_id, be, as_) > 0
                            for be, _ in b_ends for as_, _ in a_starts)
                if not any_t:
                    continue
                ord_v = f'_ord_{safe(tid_a)}_{safe(tid_b)}'
                p_a = presence_expr(tid_a, ag_id)
                p_b = presence_expr(tid_b, ag_id)
                wp(f'    # pairwise travel: {tid_a} ↔ {tid_b} ({ag_id})')
                wp(f'    {ord_v} = model.new_bool_var({(safe(tid_a)+"_before_"+safe(tid_b))!r})')
                for ae, ga in a_ends:
                    for bs, gb in b_starts:
                        t = travel(ag_id, ae, bs)
                        g = [ord_v] + [x for x in [ga, gb, p_a, p_b] if x]
                        emit_constraint(wp, tid_b, tid_a, t, g)
                for be, gb in b_ends:
                    for as_, ga in a_starts:
                        t = travel(ag_id, be, as_)
                        g = [f'~{ord_v}'] + [x for x in [gb, ga, p_a, p_b] if x]
                        emit_constraint(wp, tid_a, tid_b, t, g)
                wp('')

    if pairwise_lines:
        w('    # ── Pairwise travel (same-agent, no dep ordering) ────────────────')
        for line in pairwise_lines:
            w(line)

    # ── Agent no-overlap ──────────────────────────────────────────────────────
    w('    # ── Agent no-overlap ──────────────────────────────────────────────')
    w('    for agent_id, ivs in agent_ivs.items():')
    w('        if len(ivs) > 1:')
    w('            model.add_no_overlap(ivs)')
    w()

    # ── Objective ─────────────────────────────────────────────────────────────
    w('    # ── Objective: minimise completion of target tasks ────────────────')
    valid_targets = [t for t in targets if t in required]
    if len(valid_targets) == 1:
        w(f'    model.minimize(te[{valid_targets[0]!r}])')
    elif valid_targets:
        w('    makespan = model.new_int_var(0, horizon, "makespan")')
        w(f'    model.add_max_equality(makespan, [{", ".join(f"te[{t!r}]" for t in valid_targets)}])')
        w('    model.minimize(makespan)')
    w()

    # ── Solve ─────────────────────────────────────────────────────────────────
    w('    # ── Solve ─────────────────────────────────────────────────────────')
    w('    solver = cp_model.CpSolver()')
    w('    solver.parameters.num_search_workers = 4')
    w('    status = solver.solve(model)')
    w()
    w('    if status not in [cp_model.OPTIMAL, cp_model.FEASIBLE]:')
    w('        print("No solution found within constraints.")')
    w('        return')
    w()
    w('    v = solver.value')
    w(f'    print(f"Solution — makespan: {{int(solver.objective_value)}} min\\n")')
    w()
    locs_literal = '{' + ', '.join(
        f'{tid!r}: ({info["start"]!r}, {info["end"]!r})'
        for tid, info in task_locs.items()
        if info.get('start') or info.get('end')
    ) + '}'
    # Build a {task_id: varname} literal for direction vars, used at print time.
    dir_vars_literal = '{' + ', '.join(
        f'{tid!r}: {vname}' for tid, vname in sorted(dir_vars.items())
    ) + '}'
    agent_init_literal = '{' + ', '.join(
        f'{aid!r}: {loc!r}' for aid, loc in sorted(agent_initial.items())
    ) + '}'
    task_intra_literal = '{' + ', '.join(
        f'{tid!r}: ({path_label!r}, {trav})'
        for tid, (path_label, trav) in sorted(task_intra.items())
    ) + '}'
    agent_paths_literal = '{' + ', '.join(
        f'{key!r}: {hops!r}'
        for key, hops in sorted(agent_paths.items())
    ) + '}'
    w(f'    virtual_nodes = {sorted(virtual)!r}')
    w(f'    _task_locs    = {locs_literal}')
    w(f'    _dir_vars     = {dir_vars_literal}')
    w(f'    _agent_init   = {agent_init_literal}')
    w(f'    _task_intra   = {task_intra_literal}')
    w(f'    _agent_paths  = {agent_paths_literal}')
    w('    plan_lines = []')
    w('    for agent_id in agent_ivs:')
    w('        schedule = []')
    w('        for (tid, aid), presence in asg.items():')
    w('            if aid != agent_id or tid in virtual_nodes:')
    w('                continue')
    w('            active = presence if isinstance(presence, int) else v(presence)')
    w('            if active:')
    w('                schedule.append((v(ts[tid]), v(te[tid]), tid))')
    w('        if not schedule:')
    w('            continue')
    w('        schedule.sort()')
    w('        print(f"=== {agent_id} ===")')
    w('        prev_e, prev_loc = 0, _agent_init.get(agent_id, "?")')
    w('        for s, e, tid in schedule:')
    w('            sl, el = _task_locs.get(tid, ("?", "?"))')
    w('            dv = _dir_vars.get(tid)')
    w('            if dv is not None and not v(dv):')
    w('                sl, el = el, sl  # reversed direction')
    w('            if s > prev_e and prev_loc != sl:')
    # hops is a list of (from, to, duration) tuples for multi-hop travel; if not present, fallback to single-hop travel.
    w('                hops = _agent_paths.get((agent_id, prev_loc, sl))')
    w('                if hops:')
    w('                    t = prev_e')
    w('                    for h_from, h_to, h_dur in hops:')
    w('                        print(f"  [{t:02d}→{t+h_dur:02d}] Travelling  ({h_from} → {h_to})")')
    w('                        plan_lines.append(f"    move({agent_id}, {h_from}, {h_to}) [{t:02d}, {t+h_dur:02d}]")')
    w('                        t += h_dur')
    w('                else:')
    w('                    print(f"  [{prev_e:02d}→{s:02d}] Travelling  ({prev_loc} → {sl})")')
    w('                    plan_lines.append(f"    move({agent_id}, {prev_loc}, {sl}) [{prev_e:02d}, {s:02d}]")')
    w('            intra = _task_intra.get(tid)')
    w('            intra_str = f" [task required distance {intra[1]}]" if intra else ""')
    w('            print(f"  [{s:02d}→{e:02d}] {tid} ({sl} → {el}) {intra_str}")')
    w('            plan_lines.append(f"    dotask({agent_id}, {tid}, {sl}, {el}) [{s:02d}, {e:02d}]")')
    w('            prev_e, prev_loc = e, el')
    w('        print()')
    w()
    w('    plan_path = os.path.splitext(os.path.abspath(__file__))[0] + "_plan.txt"')
    w('    with open(plan_path, "w") as f:')
    w('        f.write("SequentialPlan:\\n" + "\\n".join(plan_lines) + "\\n")')
    w('    print(f"Plan written to: {plan_path}")')
    w()
    w()
    w("if __name__ == '__main__':")
    w('    main()')

    return '\n'.join(L)


# ── Entry point ───────────────────────────────────────────────────────────────

def main():
    if len(sys.argv) < 2:
        print(f'Usage: python {sys.argv[0]} <problem.json> [output.py]')
        sys.exit(1)

    json_path  = sys.argv[1]

    #name of file
    file_name = os.path.splitext(os.path.basename(json_path))[0]

    out_path = sys.argv[2] if len(sys.argv) > 2 else f'{file_name}.py'

    data = load(json_path)
    code = generate(data, json_path)

    with open(out_path, 'w') as f:
        f.write(code)

    print(f'Solver written to  : {out_path}')
    print(f'Run with           : python {out_path}')


if __name__ == '__main__':
    main()
