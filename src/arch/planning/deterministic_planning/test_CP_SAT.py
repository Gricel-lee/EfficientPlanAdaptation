# test_CP_SAT.py
# CP-SAT multi-agent task scheduler for agricultural pick-and-deliver.
#
# Scenario:
#   Locations : l1/l2 (row 1), l3/l4 (row 2), l5 (collection point),
#               l6 (handover point / drone base), l8 (final destination)
#   Agents    : human, tractor, drone
#   Goal      : pick grapes from both rows and deliver to l8
#
# OR-branches: for each row, CP-SAT chooses the fastest delivery path:
#   Branch 0 (direct)  : human carries row-end → l5
#   Branch 1 (via drone): human carries row-end → l6, drone carries l6 → l5
#
# depends_on accepts task IDs *or* branch-group names.
#
# Usage: python3 src/arch/planning/deterministic_planning/test_CP_SAT.py

from __future__ import annotations
import os
import sys


# ----- Test activating virtual environment (if not already active) -----
_VENV_PYTHON = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../../arch/prj-venv/bin/python3")
if sys.executable != _VENV_PYTHON:
    os.execv(_VENV_PYTHON, [_VENV_PYTHON] + sys.argv)
# -----------------------------------------------------------------------

from dataclasses import dataclass, field
from typing import Optional
import math

from ortools.sat.python import cp_model

# ── Time scale ────────────────────────────────────────────────────────────────
SCALE = 10          # integer units per hour (1 unit = 0.1 h = 6 min)
HORIZON = 200       # max makespan in scaled units (= 20 h)


def to_int(hours: float) -> int:
    return round(hours * SCALE)


# ── Location ──────────────────────────────────────────────────────────────────
@dataclass
class Location:
    name: str
    x: float
    y: float

    def distance_to(self, other: Location) -> float:
        return math.sqrt((self.x - other.x) ** 2 + (self.y - other.y) ** 2)

    def travel_time_to(self, other: Location, speed: float = 1.0) -> int:
        if self is other or self.name == other.name:
            return 0
        return to_int(self.distance_to(other) / speed)

    def __repr__(self) -> str:
        return self.name


# ── Task spec ─────────────────────────────────────────────────────────────────
@dataclass
class TaskSpec:
    id: str
    description: str
    loc_start: Location
    loc_end: Location
    eligible_agents: list[str]
    work_time: float
    depends_on: list[str] = field(default_factory=list)  # task IDs or group names
    deadline: Optional[float] = None
    branch: Optional[tuple[str, int]] = None  # (group_name, branch_id 0 or 1)


# ── Agent spec ────────────────────────────────────────────────────────────────
@dataclass
class AgentSpec:
    name: str
    start_location: Location
    speed: float
    fatigue_rate: float = 0.0
    fatigue_budget: float = float('inf')


# ── Branch group ──────────────────────────────────────────────────────────────
@dataclass
class BranchGroup:
    """
    Declares two alternative task chains for a delivery leg.
    CP-SAT picks whichever branch minimises makespan.

    branches = {0: [task_ids for path A], 1: [task_ids for path B]}
    Use the group name in depends_on to depend on whichever branch finishes.
    """
    name: str
    branches: dict[int, list[str]]


# ── Scenario ──────────────────────────────────────────────────────────────────
def build_scenario() -> tuple[list[TaskSpec], list[AgentSpec], list[BranchGroup]]:
    """
    Pick-And-Deliver-Grapes scenario (human + drone + tractor).

    Row layout (abstract vineyard units):
      l1(0,0) ──── l2(0,5)   row 1  (human traverses while picking)
      l3(1,0) ──── l4(1,5)   row 2
      l5(3.5,5.5)            collection point / tractor base
      l6(0.5,6.0)            handover point / drone base
      l8(5.5,5.5)            final destination
    """
    l1 = Location('l1', 0.0, 0.0)
    l2 = Location('l2', 0.0, 5.0)   # row 1 end
    l3 = Location('l3', 1.0, 0.0)
    l4 = Location('l4', 1.0, 5.0)   # row 2 end
    l5 = Location('l5', 3.5, 5.5)   # collection point
    l6 = Location('l6', 0.5, 6.0)   # handover / drone base
    l8 = Location('l8', 5.5, 5.5)   # final destination

    agents = [
        AgentSpec('human',   start_location=l1, speed=2.0,
                  fatigue_rate=0.5, fatigue_budget=8.0),
        AgentSpec('tractor', start_location=l5, speed=5.0),
        AgentSpec('drone',   start_location=l6, speed=5.0),
    ]

    tasks = [
        # ── Row 1 ──────────────────────────────────────────────────────────
        TaskSpec('pick_r1', 'Pick grapes Row 1  (l1→l2)',
                 loc_start=l1, loc_end=l2,
                 eligible_agents=['human'], work_time=3.0),

        # Branch 0: human carries directly to collection
        TaskSpec('carry_r1_direct', 'Carry Row 1 direct (l2→l5)',
                 loc_start=l2, loc_end=l5,
                 eligible_agents=['human'], work_time=0.5,
                 depends_on=['pick_r1'],
                 branch=('r1_delivery', 0)),

        # Branch 1: human carries to handover, drone finishes
        TaskSpec('carry_r1_handover', 'Carry Row 1 → Handover (l2→l6)',
                 loc_start=l2, loc_end=l6,
                 eligible_agents=['human'], work_time=0.5,
                 depends_on=['pick_r1'],
                 branch=('r1_delivery', 1)),
        TaskSpec('drone_r1', 'Drone: Row 1 Handover→Collection (l6→l5)',
                 loc_start=l6, loc_end=l5,
                 eligible_agents=['drone'], work_time=0.3,
                 depends_on=['carry_r1_handover'],
                 branch=('r1_delivery', 1)),

        # ── Row 2 ──────────────────────────────────────────────────────────
        TaskSpec('pick_r2', 'Pick grapes Row 2  (l3→l4)',
                 loc_start=l3, loc_end=l4,
                 eligible_agents=['human'], work_time=2.0),

        # Branch 0: human carries directly to collection
        TaskSpec('carry_r2_direct', 'Carry Row 2 direct (l4→l5)',
                 loc_start=l4, loc_end=l5,
                 eligible_agents=['human'], work_time=0.5,
                 depends_on=['pick_r2'],
                 branch=('r2_delivery', 0)),

        # Branch 1: human carries to handover, drone finishes
        TaskSpec('carry_r2_handover', 'Carry Row 2 → Handover (l4→l6)',
                 loc_start=l4, loc_end=l6,
                 eligible_agents=['human'], work_time=0.5,
                 depends_on=['pick_r2'],
                 branch=('r2_delivery', 1)),
        TaskSpec('drone_r2', 'Drone: Row 2 Handover→Collection (l6→l5)',
                 loc_start=l6, loc_end=l5,
                 eligible_agents=['drone'], work_time=0.3,
                 depends_on=['carry_r2_handover'],
                 branch=('r2_delivery', 1)),

        # ── Final delivery (waits for whichever delivery path finishes) ────
        TaskSpec('final_delivery', 'Tractor: Collection→Destination (l5→l8)',
                 loc_start=l5, loc_end=l8,
                 eligible_agents=['tractor'], work_time=1.0,
                 depends_on=['r1_delivery', 'r2_delivery'],
                 deadline=122.0),
    ]

    branch_groups = [
        BranchGroup('r1_delivery', {
            0: ['carry_r1_direct'],
            1: ['carry_r1_handover', 'drone_r1'],
        }),
        BranchGroup('r2_delivery', {
            0: ['carry_r2_direct'],
            1: ['carry_r2_handover', 'drone_r2'],
        }),
    ]

    return tasks, agents, branch_groups


# ── CP-SAT solver ─────────────────────────────────────────────────────────────
def solve(tasks: list[TaskSpec], agents: list[AgentSpec],
          branch_groups: Optional[list[BranchGroup]] = None):
    model = cp_model.CpModel()
    branch_groups = branch_groups or []

    agent_idx = {a.name: i for i, a in enumerate(agents)}
    task_idx  = {t.id:   i for i, t in enumerate(tasks)}

    # Which tasks belong to a branch group
    task_branch: dict[int, tuple[str, int]] = {}
    for bg in branch_groups:
        for bid, tids in bg.branches.items():
            for tid in tids:
                task_branch[task_idx[tid]] = (bg.name, bid)

    intervals: list[dict] = [{} for _ in tasks]
    task_end:  list       = []

    for t_i, task in enumerate(tasks):
        work         = to_int(task.work_time)
        deadline_int = to_int(task.deadline) if task.deadline else HORIZON

        for a_name in task.eligible_agents:
            a_i    = agent_idx[a_name]
            agent  = agents[a_i]
            suffix = f"_{task.id}_{a_name}"

            # Duration = traversal(loc_start → loc_end) + work_time.
            # This ensures the task interval covers both the travel through
            # the task and any extra work, so dependents start after arrival
            # at loc_end.
            internal_travel = task.loc_start.travel_time_to(
                task.loc_end, agent.speed)
            duration = internal_travel + work

            assigned = model.NewBoolVar(f"assigned{suffix}")
            start    = model.NewIntVar(0, HORIZON, f"start{suffix}")
            end      = model.NewIntVar(0, deadline_int, f"end{suffix}")
            interval = model.NewOptionalIntervalVar(
                start, duration, end, assigned, f"interval{suffix}")

            intervals[t_i][a_i] = {
                'start': start, 'end': end,
                'interval': interval, 'assigned': assigned,
                'agent': agent, 'task': task,
            }

        all_assigned = [v['assigned'] for v in intervals[t_i].values()]
        if not all_assigned:
            raise ValueError(f"Task {task.id} has no eligible agents")

        # Branched tasks: assignment controlled by branch var (set below).
        # Non-branched tasks: exactly one agent must do it.
        if t_i not in task_branch:
            model.AddExactlyOne(all_assigned)

        t_end = model.NewIntVar(0, HORIZON, f"end_{task.id}")
        for v in intervals[t_i].values():
            model.Add(t_end >= v['end']).OnlyEnforceIf(v['assigned'])
        task_end.append(t_end)

    # No-overlap per agent
    for a_i in range(len(agents)):
        agent_intervals = [
            intervals[t_i][a_i]['interval']
            for t_i in range(len(tasks))
            if a_i in intervals[t_i]
        ]
        if agent_intervals:
            model.AddNoOverlap(agent_intervals)

    # Branch group constraints
    # branch_vars[group] = 0 → path A active, 1 → path B active
    branch_vars: dict[str, cp_model.BoolVar] = {}
    group_end:   dict[str, cp_model.IntVar]  = {}

    for bg in branch_groups:
        b     = model.NewBoolVar(f"branch_{bg.name}")
        g_end = model.NewIntVar(0, HORIZON, f"group_end_{bg.name}")
        branch_vars[bg.name] = b
        group_end[bg.name]   = g_end

        for bid, tids in bg.branches.items():
            branch_active = b if bid == 1 else b.Not()
            for tid in tids:
                t_i = task_idx[tid]
                for v in intervals[t_i].values():
                    model.Add(v['assigned'] == 1).OnlyEnforceIf(branch_active)
                    model.Add(v['assigned'] == 0).OnlyEnforceIf(branch_active.Not())
                # group_end = max end of tasks in the active branch
                model.Add(g_end >= task_end[t_i]).OnlyEnforceIf(branch_active)

    # Travel-gap constraints (same-agent sequencing with location travel)
    for a_i, agent in enumerate(agents):
        agent_tasks = [t_i for t_i in range(len(tasks)) if a_i in intervals[t_i]]

        # Lower bound: travel from home to first task
        for t_i in agent_tasks:
            home_travel = agent.start_location.travel_time_to(
                tasks[t_i].loc_start, agent.speed)
            if home_travel > 0:
                model.Add(intervals[t_i][a_i]['start'] >= home_travel).OnlyEnforceIf(
                    intervals[t_i][a_i]['assigned'])

        # Pairwise ordering: enforce travel gap between consecutive tasks
        for idx_a, t_i in enumerate(agent_tasks):
            for t_j in agent_tasks[idx_a + 1:]:
                vi = intervals[t_i][a_i]
                vj = intervals[t_j][a_i]

                travel_ij = tasks[t_i].loc_end.travel_time_to(
                    tasks[t_j].loc_start, agent.speed)
                travel_ji = tasks[t_j].loc_end.travel_time_to(
                    tasks[t_i].loc_start, agent.speed)

                i_before_j = model.NewBoolVar(f"order_{t_i}_{t_j}_{a_i}")
                both       = model.NewBoolVar(f"both_{t_i}_{t_j}_{a_i}")
                model.AddBoolAnd([vi['assigned'], vj['assigned']]).OnlyEnforceIf(both)
                model.AddBoolOr([vi['assigned'].Not(), vj['assigned'].Not()]).OnlyEnforceIf(both.Not())

                model.Add(vj['start'] >= vi['end'] + travel_ij).OnlyEnforceIf(
                    [both, i_before_j])
                model.Add(vi['start'] >= vj['end'] + travel_ji).OnlyEnforceIf(
                    [both, i_before_j.Not()])

    # Dependency constraints (task IDs or branch group names)
    for t_i, task in enumerate(tasks):
        for dep_id in task.depends_on:
            if dep_id in group_end:
                end_var = group_end[dep_id]
            else:
                end_var = task_end[task_idx[dep_id]]
            for v in intervals[t_i].values():
                model.Add(v['start'] >= end_var).OnlyEnforceIf(v['assigned'])

    # Fatigue budget per agent
    for a_i, agent in enumerate(agents):
        if agent.fatigue_budget == float('inf') or agent.fatigue_rate == 0:
            continue
        budget = to_int(agent.fatigue_budget / agent.fatigue_rate)
        work_terms = []
        for t_i in range(len(tasks)):
            if a_i not in intervals[t_i]:
                continue
            v    = intervals[t_i][a_i]
            work = to_int(tasks[t_i].work_time)
            w    = model.NewIntVar(0, HORIZON, f"work_{t_i}_{a_i}")
            model.Add(w == work).OnlyEnforceIf(v['assigned'])
            model.Add(w == 0).OnlyEnforceIf(v['assigned'].Not())
            work_terms.append(w)
        if work_terms:
            total_work = model.NewIntVar(0, HORIZON, f"total_work_{a_i}")
            model.Add(total_work == sum(work_terms))
            model.Add(total_work <= budget)

    # Objective: minimize makespan
    makespan = model.NewIntVar(0, HORIZON, 'makespan')
    model.AddMaxEquality(makespan, task_end)
    model.Minimize(makespan)

    solver = cp_model.CpSolver()
    solver.parameters.max_time_in_seconds = 30.0
    status = solver.Solve(model)

    return solver, status, intervals, task_end, tasks, agents, branch_vars


# ── Print solution ─────────────────────────────────────────────────────────────
def print_solution(solver, status, intervals, task_end_vars,
                   tasks, agents, branch_vars=None):
    status_name = solver.StatusName(status)
    print(f"\n=== CP-SAT Result: {status_name} ===\n")

    if status not in (cp_model.OPTIMAL, cp_model.FEASIBLE):
        print("No solution found.")
        return

    print(f"Makespan: {solver.ObjectiveValue() / SCALE:.1f}h\n")

    if branch_vars:
        print("Delivery paths chosen:")
        for group, b in branch_vars.items():
            chosen = solver.Value(b)
            label  = "Branch 1 (via drone/handover)" if chosen else "Branch 0 (direct carry)"
            print(f"  {group}: {label}")
        print()

    agent_map = {i: a for i, a in enumerate(agents)}
    schedule: dict[str, list] = {a.name: [] for a in agents}
    for t_i, task in enumerate(tasks):
        for a_i, v in intervals[t_i].items():
            if solver.Value(v['assigned']):
                s      = solver.Value(v['start']) / SCALE
                e      = solver.Value(v['end'])   / SCALE
                agent  = agent_map[a_i]
                travel = task.loc_start.distance_to(task.loc_end) / agent.speed
                work   = task.work_time
                schedule[agent.name].append((s, e, task.description, travel, work))

    for agent in agents:
        entries = sorted(schedule[agent.name])
        if not entries:
            continue
        print(f"{agent.name.upper()}  (done at {entries[-1][1]:.1f}h)")
        for s, e, desc, trav, work in entries:
            detail = f"travel {trav:.1f}h + work {work:.1f}h" if trav > 0.01 else f"work {work:.1f}h"
            print(f"  {s:4.1f}→{e:4.1f}h  {desc}  [{detail}]")
        print()


# ── Entry point ───────────────────────────────────────────────────────────────
def main():
    tasks, agents, branch_groups = build_scenario()
    solver, status, intervals, task_end_vars, tasks, agents, branch_vars = solve(
        tasks, agents, branch_groups)
    print_solution(solver, status, intervals, task_end_vars, tasks, agents, branch_vars)


if __name__ == '__main__':
    main()
