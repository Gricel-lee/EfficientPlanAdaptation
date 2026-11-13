from ortools.sat.python import cp_model
import os

# ─────────────────────────────────────────────────────────────────────
# Auto-generated CP-SAT solver
# Targets       : ['Tractor_Final']
# Max duration  : 350 min
# Virtual nodes : ['Deliver_Box1', 'Deliver_Box2', 'Deliver_Box3', 'Deliver_Box4', 'Row1_done', 'Row2_done', 'Row3_done', 'Row4_done']  (abstract; resolved by alternatives)
# Derived-opt.  : []  (run only when triggered)
# OR-optional   : ['Harvest_Row1', 'Harvest_Row2', 'Harvest_Row3', 'Harvest_Row4']  (at least one per OR-dep group must run)
# ─────────────────────────────────────────────────────────────────────


def main():
    model = cp_model.CpModel()
    horizon = 350

    def make_iv(name, dur):
        s = model.new_int_var(0, horizon, name + "_s")
        e = model.new_int_var(0, horizon, name + "_e")
        model.add(e == s + dur)
        return s, e

    ts  = {}   # ts[task_id]              -> start IntVar
    te  = {}   # te[task_id]              -> end   IntVar
    pr  = {}   # pr[task_id]              -> BoolVar | 1 (presence/active)
    asg = {}   # asg[(task_id, agent_id)] -> BoolVar | 1
    agent_ivs = {a: [] for a in ['human1', 'drone1', 'tractor1']}

    # ── Mandatory concrete tasks ───────────────────────────────────────
    # Tractor_Final  (tractor1, 30 min)
    ts['Tractor_Final'], te['Tractor_Final'] = make_iv('Tractor_Final', 30)
    pr['Tractor_Final']  = 1
    asg[('Tractor_Final', 'tractor1')] = 1
    agent_ivs['tractor1'].append(
        model.new_interval_var(ts['Tractor_Final'], 30, te['Tractor_Final'], 'Tractor_Final_iv'))

    # ── Optional subtasks (concrete alternatives of virtual nodes) ──────
    # Deliver_Box1_CP  (human1, 7 min) — optional alternative
    _p_Deliver_Box1_CP = model.new_bool_var('Deliver_Box1_CP')
    pr['Deliver_Box1_CP']  = _p_Deliver_Box1_CP
    asg[('Deliver_Box1_CP', 'human1')] = _p_Deliver_Box1_CP
    ts['Deliver_Box1_CP'], te['Deliver_Box1_CP'] = make_iv('Deliver_Box1_CP', 7)
    agent_ivs['human1'].append(
        model.new_optional_interval_var(ts['Deliver_Box1_CP'], 7, te['Deliver_Box1_CP'], _p_Deliver_Box1_CP, 'Deliver_Box1_CP_iv'))

    # Deliver_Box1_HP  (human1, 10 min) — optional alternative
    _p_Deliver_Box1_HP = model.new_bool_var('Deliver_Box1_HP')
    pr['Deliver_Box1_HP']  = _p_Deliver_Box1_HP
    asg[('Deliver_Box1_HP', 'human1')] = _p_Deliver_Box1_HP
    ts['Deliver_Box1_HP'], te['Deliver_Box1_HP'] = make_iv('Deliver_Box1_HP', 10)
    agent_ivs['human1'].append(
        model.new_optional_interval_var(ts['Deliver_Box1_HP'], 10, te['Deliver_Box1_HP'], _p_Deliver_Box1_HP, 'Deliver_Box1_HP_iv'))

    # Deliver_Box2_CP  (human1, 7 min) — optional alternative
    _p_Deliver_Box2_CP = model.new_bool_var('Deliver_Box2_CP')
    pr['Deliver_Box2_CP']  = _p_Deliver_Box2_CP
    asg[('Deliver_Box2_CP', 'human1')] = _p_Deliver_Box2_CP
    ts['Deliver_Box2_CP'], te['Deliver_Box2_CP'] = make_iv('Deliver_Box2_CP', 7)
    agent_ivs['human1'].append(
        model.new_optional_interval_var(ts['Deliver_Box2_CP'], 7, te['Deliver_Box2_CP'], _p_Deliver_Box2_CP, 'Deliver_Box2_CP_iv'))

    # Deliver_Box2_HP  (human1, 10 min) — optional alternative
    _p_Deliver_Box2_HP = model.new_bool_var('Deliver_Box2_HP')
    pr['Deliver_Box2_HP']  = _p_Deliver_Box2_HP
    asg[('Deliver_Box2_HP', 'human1')] = _p_Deliver_Box2_HP
    ts['Deliver_Box2_HP'], te['Deliver_Box2_HP'] = make_iv('Deliver_Box2_HP', 10)
    agent_ivs['human1'].append(
        model.new_optional_interval_var(ts['Deliver_Box2_HP'], 10, te['Deliver_Box2_HP'], _p_Deliver_Box2_HP, 'Deliver_Box2_HP_iv'))

    # Deliver_Box3_CP  (human1, 105 min) — optional alternative
    _p_Deliver_Box3_CP = model.new_bool_var('Deliver_Box3_CP')
    pr['Deliver_Box3_CP']  = _p_Deliver_Box3_CP
    asg[('Deliver_Box3_CP', 'human1')] = _p_Deliver_Box3_CP
    ts['Deliver_Box3_CP'], te['Deliver_Box3_CP'] = make_iv('Deliver_Box3_CP', 105)
    agent_ivs['human1'].append(
        model.new_optional_interval_var(ts['Deliver_Box3_CP'], 105, te['Deliver_Box3_CP'], _p_Deliver_Box3_CP, 'Deliver_Box3_CP_iv'))

    # Deliver_Box3_HP  (human1, 10 min) — optional alternative
    _p_Deliver_Box3_HP = model.new_bool_var('Deliver_Box3_HP')
    pr['Deliver_Box3_HP']  = _p_Deliver_Box3_HP
    asg[('Deliver_Box3_HP', 'human1')] = _p_Deliver_Box3_HP
    ts['Deliver_Box3_HP'], te['Deliver_Box3_HP'] = make_iv('Deliver_Box3_HP', 10)
    agent_ivs['human1'].append(
        model.new_optional_interval_var(ts['Deliver_Box3_HP'], 10, te['Deliver_Box3_HP'], _p_Deliver_Box3_HP, 'Deliver_Box3_HP_iv'))

    # Deliver_Box4_CP  (human1, 105 min) — optional alternative
    _p_Deliver_Box4_CP = model.new_bool_var('Deliver_Box4_CP')
    pr['Deliver_Box4_CP']  = _p_Deliver_Box4_CP
    asg[('Deliver_Box4_CP', 'human1')] = _p_Deliver_Box4_CP
    ts['Deliver_Box4_CP'], te['Deliver_Box4_CP'] = make_iv('Deliver_Box4_CP', 105)
    agent_ivs['human1'].append(
        model.new_optional_interval_var(ts['Deliver_Box4_CP'], 105, te['Deliver_Box4_CP'], _p_Deliver_Box4_CP, 'Deliver_Box4_CP_iv'))

    # Deliver_Box4_HP  (human1, 10 min) — optional alternative
    _p_Deliver_Box4_HP = model.new_bool_var('Deliver_Box4_HP')
    pr['Deliver_Box4_HP']  = _p_Deliver_Box4_HP
    asg[('Deliver_Box4_HP', 'human1')] = _p_Deliver_Box4_HP
    ts['Deliver_Box4_HP'], te['Deliver_Box4_HP'] = make_iv('Deliver_Box4_HP', 10)
    agent_ivs['human1'].append(
        model.new_optional_interval_var(ts['Deliver_Box4_HP'], 10, te['Deliver_Box4_HP'], _p_Deliver_Box4_HP, 'Deliver_Box4_HP_iv'))

    # Drone_Relay_Box1  (drone1, 3 min) — optional alternative
    _p_Drone_Relay_Box1 = model.new_bool_var('Drone_Relay_Box1')
    pr['Drone_Relay_Box1']  = _p_Drone_Relay_Box1
    asg[('Drone_Relay_Box1', 'drone1')] = _p_Drone_Relay_Box1
    ts['Drone_Relay_Box1'], te['Drone_Relay_Box1'] = make_iv('Drone_Relay_Box1', 3)
    agent_ivs['drone1'].append(
        model.new_optional_interval_var(ts['Drone_Relay_Box1'], 3, te['Drone_Relay_Box1'], _p_Drone_Relay_Box1, 'Drone_Relay_Box1_iv'))

    # Drone_Relay_Box2  (drone1, 3 min) — optional alternative
    _p_Drone_Relay_Box2 = model.new_bool_var('Drone_Relay_Box2')
    pr['Drone_Relay_Box2']  = _p_Drone_Relay_Box2
    asg[('Drone_Relay_Box2', 'drone1')] = _p_Drone_Relay_Box2
    ts['Drone_Relay_Box2'], te['Drone_Relay_Box2'] = make_iv('Drone_Relay_Box2', 3)
    agent_ivs['drone1'].append(
        model.new_optional_interval_var(ts['Drone_Relay_Box2'], 3, te['Drone_Relay_Box2'], _p_Drone_Relay_Box2, 'Drone_Relay_Box2_iv'))

    # Drone_Relay_Box3  (drone1, 3 min) — optional alternative
    _p_Drone_Relay_Box3 = model.new_bool_var('Drone_Relay_Box3')
    pr['Drone_Relay_Box3']  = _p_Drone_Relay_Box3
    asg[('Drone_Relay_Box3', 'drone1')] = _p_Drone_Relay_Box3
    ts['Drone_Relay_Box3'], te['Drone_Relay_Box3'] = make_iv('Drone_Relay_Box3', 3)
    agent_ivs['drone1'].append(
        model.new_optional_interval_var(ts['Drone_Relay_Box3'], 3, te['Drone_Relay_Box3'], _p_Drone_Relay_Box3, 'Drone_Relay_Box3_iv'))

    # Drone_Relay_Box4  (drone1, 3 min) — optional alternative
    _p_Drone_Relay_Box4 = model.new_bool_var('Drone_Relay_Box4')
    pr['Drone_Relay_Box4']  = _p_Drone_Relay_Box4
    asg[('Drone_Relay_Box4', 'drone1')] = _p_Drone_Relay_Box4
    ts['Drone_Relay_Box4'], te['Drone_Relay_Box4'] = make_iv('Drone_Relay_Box4', 3)
    agent_ivs['drone1'].append(
        model.new_optional_interval_var(ts['Drone_Relay_Box4'], 3, te['Drone_Relay_Box4'], _p_Drone_Relay_Box4, 'Drone_Relay_Box4_iv'))

    # ── OR-optional tasks (at least one per OR-dep group must run) ───────
    # Harvest_Row1  (human1, 3 min) — OR-optional
    _p_Harvest_Row1 = model.new_bool_var('Harvest_Row1')
    pr['Harvest_Row1']  = _p_Harvest_Row1
    asg[('Harvest_Row1', 'human1')] = _p_Harvest_Row1
    ts['Harvest_Row1'], te['Harvest_Row1'] = make_iv('Harvest_Row1', 3)
    agent_ivs['human1'].append(
        model.new_optional_interval_var(ts['Harvest_Row1'], 3, te['Harvest_Row1'], _p_Harvest_Row1, 'Harvest_Row1_iv'))

    # Harvest_Row2  (human1, 3 min) — OR-optional
    _p_Harvest_Row2 = model.new_bool_var('Harvest_Row2')
    pr['Harvest_Row2']  = _p_Harvest_Row2
    asg[('Harvest_Row2', 'human1')] = _p_Harvest_Row2
    ts['Harvest_Row2'], te['Harvest_Row2'] = make_iv('Harvest_Row2', 3)
    agent_ivs['human1'].append(
        model.new_optional_interval_var(ts['Harvest_Row2'], 3, te['Harvest_Row2'], _p_Harvest_Row2, 'Harvest_Row2_iv'))

    # Harvest_Row3  (human1, 3 min) — OR-optional
    _p_Harvest_Row3 = model.new_bool_var('Harvest_Row3')
    pr['Harvest_Row3']  = _p_Harvest_Row3
    asg[('Harvest_Row3', 'human1')] = _p_Harvest_Row3
    ts['Harvest_Row3'], te['Harvest_Row3'] = make_iv('Harvest_Row3', 3)
    agent_ivs['human1'].append(
        model.new_optional_interval_var(ts['Harvest_Row3'], 3, te['Harvest_Row3'], _p_Harvest_Row3, 'Harvest_Row3_iv'))

    # Harvest_Row4  (human1, 3 min) — OR-optional
    _p_Harvest_Row4 = model.new_bool_var('Harvest_Row4')
    pr['Harvest_Row4']  = _p_Harvest_Row4
    asg[('Harvest_Row4', 'human1')] = _p_Harvest_Row4
    ts['Harvest_Row4'], te['Harvest_Row4'] = make_iv('Harvest_Row4', 3)
    agent_ivs['human1'].append(
        model.new_optional_interval_var(ts['Harvest_Row4'], 3, te['Harvest_Row4'], _p_Harvest_Row4, 'Harvest_Row4_iv'))

    # ── Direction vars (True = start→end, False = end→start) ──────────
    _dir_Harvest_Row1 = model.new_bool_var('Harvest_Row1_dir')
    _dir_Harvest_Row2 = model.new_bool_var('Harvest_Row2_dir')
    _dir_Harvest_Row3 = model.new_bool_var('Harvest_Row3_dir')
    _dir_Harvest_Row4 = model.new_bool_var('Harvest_Row4_dir')

    # ── Virtual nodes (canonical vars bound to whichever alternative runs) ─
    ts['Deliver_Box1'] = model.new_int_var(0, horizon, 'Deliver_Box1_s')
    te['Deliver_Box1'] = model.new_int_var(0, horizon, 'Deliver_Box1_e')
    # Deliver_Box1  → one of ['Deliver_Box1_CP', 'Deliver_Box1_HP'] when active (alternative of another virtual node)
    _p_Deliver_Box1 = model.new_bool_var('Deliver_Box1_active')
    pr['Deliver_Box1']  = _p_Deliver_Box1
    model.add_at_most_one([_p_Deliver_Box1_CP, _p_Deliver_Box1_HP])
    model.add_bool_or([_p_Deliver_Box1_CP, _p_Deliver_Box1_HP, ~_p_Deliver_Box1])
    model.add(ts['Deliver_Box1'] == ts['Deliver_Box1_CP']).OnlyEnforceIf(_p_Deliver_Box1_CP)
    model.add(te['Deliver_Box1'] == te['Deliver_Box1_CP']).OnlyEnforceIf(_p_Deliver_Box1_CP)
    model.add(ts['Deliver_Box1'] == ts['Deliver_Box1_HP']).OnlyEnforceIf(_p_Deliver_Box1_HP)
    model.add(te['Deliver_Box1'] == te['Deliver_Box1_HP']).OnlyEnforceIf(_p_Deliver_Box1_HP)

    ts['Deliver_Box2'] = model.new_int_var(0, horizon, 'Deliver_Box2_s')
    te['Deliver_Box2'] = model.new_int_var(0, horizon, 'Deliver_Box2_e')
    # Deliver_Box2  → one of ['Deliver_Box2_CP', 'Deliver_Box2_HP'] when active (alternative of another virtual node)
    _p_Deliver_Box2 = model.new_bool_var('Deliver_Box2_active')
    pr['Deliver_Box2']  = _p_Deliver_Box2
    model.add_at_most_one([_p_Deliver_Box2_CP, _p_Deliver_Box2_HP])
    model.add_bool_or([_p_Deliver_Box2_CP, _p_Deliver_Box2_HP, ~_p_Deliver_Box2])
    model.add(ts['Deliver_Box2'] == ts['Deliver_Box2_CP']).OnlyEnforceIf(_p_Deliver_Box2_CP)
    model.add(te['Deliver_Box2'] == te['Deliver_Box2_CP']).OnlyEnforceIf(_p_Deliver_Box2_CP)
    model.add(ts['Deliver_Box2'] == ts['Deliver_Box2_HP']).OnlyEnforceIf(_p_Deliver_Box2_HP)
    model.add(te['Deliver_Box2'] == te['Deliver_Box2_HP']).OnlyEnforceIf(_p_Deliver_Box2_HP)

    ts['Deliver_Box3'] = model.new_int_var(0, horizon, 'Deliver_Box3_s')
    te['Deliver_Box3'] = model.new_int_var(0, horizon, 'Deliver_Box3_e')
    # Deliver_Box3  → one of ['Deliver_Box3_CP', 'Deliver_Box3_HP'] when active (alternative of another virtual node)
    _p_Deliver_Box3 = model.new_bool_var('Deliver_Box3_active')
    pr['Deliver_Box3']  = _p_Deliver_Box3
    model.add_at_most_one([_p_Deliver_Box3_CP, _p_Deliver_Box3_HP])
    model.add_bool_or([_p_Deliver_Box3_CP, _p_Deliver_Box3_HP, ~_p_Deliver_Box3])
    model.add(ts['Deliver_Box3'] == ts['Deliver_Box3_CP']).OnlyEnforceIf(_p_Deliver_Box3_CP)
    model.add(te['Deliver_Box3'] == te['Deliver_Box3_CP']).OnlyEnforceIf(_p_Deliver_Box3_CP)
    model.add(ts['Deliver_Box3'] == ts['Deliver_Box3_HP']).OnlyEnforceIf(_p_Deliver_Box3_HP)
    model.add(te['Deliver_Box3'] == te['Deliver_Box3_HP']).OnlyEnforceIf(_p_Deliver_Box3_HP)

    ts['Deliver_Box4'] = model.new_int_var(0, horizon, 'Deliver_Box4_s')
    te['Deliver_Box4'] = model.new_int_var(0, horizon, 'Deliver_Box4_e')
    # Deliver_Box4  → one of ['Deliver_Box4_CP', 'Deliver_Box4_HP'] when active (alternative of another virtual node)
    _p_Deliver_Box4 = model.new_bool_var('Deliver_Box4_active')
    pr['Deliver_Box4']  = _p_Deliver_Box4
    model.add_at_most_one([_p_Deliver_Box4_CP, _p_Deliver_Box4_HP])
    model.add_bool_or([_p_Deliver_Box4_CP, _p_Deliver_Box4_HP, ~_p_Deliver_Box4])
    model.add(ts['Deliver_Box4'] == ts['Deliver_Box4_CP']).OnlyEnforceIf(_p_Deliver_Box4_CP)
    model.add(te['Deliver_Box4'] == te['Deliver_Box4_CP']).OnlyEnforceIf(_p_Deliver_Box4_CP)
    model.add(ts['Deliver_Box4'] == ts['Deliver_Box4_HP']).OnlyEnforceIf(_p_Deliver_Box4_HP)
    model.add(te['Deliver_Box4'] == te['Deliver_Box4_HP']).OnlyEnforceIf(_p_Deliver_Box4_HP)

    ts['Row1_done'] = model.new_int_var(0, horizon, 'Row1_done_s')
    te['Row1_done'] = model.new_int_var(0, horizon, 'Row1_done_e')
    # Row1_done  → exactly one of ['Drone_Relay_Box1', 'Deliver_Box1']
    pr['Row1_done']  = model.new_bool_var('Row1_done_active')
    model.add_exactly_one([_p_Drone_Relay_Box1, _p_Deliver_Box1])
    model.add(pr['Row1_done'] == 1)
    model.add(ts['Row1_done'] == ts['Drone_Relay_Box1']).OnlyEnforceIf(_p_Drone_Relay_Box1)
    model.add(te['Row1_done'] == te['Drone_Relay_Box1']).OnlyEnforceIf(_p_Drone_Relay_Box1)
    model.add(ts['Row1_done'] == ts['Deliver_Box1']).OnlyEnforceIf(_p_Deliver_Box1)
    model.add(te['Row1_done'] == te['Deliver_Box1']).OnlyEnforceIf(_p_Deliver_Box1)

    ts['Row2_done'] = model.new_int_var(0, horizon, 'Row2_done_s')
    te['Row2_done'] = model.new_int_var(0, horizon, 'Row2_done_e')
    # Row2_done  → exactly one of ['Drone_Relay_Box2', 'Deliver_Box2']
    pr['Row2_done']  = model.new_bool_var('Row2_done_active')
    model.add_exactly_one([_p_Drone_Relay_Box2, _p_Deliver_Box2])
    model.add(pr['Row2_done'] == 1)
    model.add(ts['Row2_done'] == ts['Drone_Relay_Box2']).OnlyEnforceIf(_p_Drone_Relay_Box2)
    model.add(te['Row2_done'] == te['Drone_Relay_Box2']).OnlyEnforceIf(_p_Drone_Relay_Box2)
    model.add(ts['Row2_done'] == ts['Deliver_Box2']).OnlyEnforceIf(_p_Deliver_Box2)
    model.add(te['Row2_done'] == te['Deliver_Box2']).OnlyEnforceIf(_p_Deliver_Box2)

    ts['Row3_done'] = model.new_int_var(0, horizon, 'Row3_done_s')
    te['Row3_done'] = model.new_int_var(0, horizon, 'Row3_done_e')
    # Row3_done  → exactly one of ['Drone_Relay_Box3', 'Deliver_Box3']
    pr['Row3_done']  = model.new_bool_var('Row3_done_active')
    model.add_exactly_one([_p_Drone_Relay_Box3, _p_Deliver_Box3])
    model.add(pr['Row3_done'] == 1)
    model.add(ts['Row3_done'] == ts['Drone_Relay_Box3']).OnlyEnforceIf(_p_Drone_Relay_Box3)
    model.add(te['Row3_done'] == te['Drone_Relay_Box3']).OnlyEnforceIf(_p_Drone_Relay_Box3)
    model.add(ts['Row3_done'] == ts['Deliver_Box3']).OnlyEnforceIf(_p_Deliver_Box3)
    model.add(te['Row3_done'] == te['Deliver_Box3']).OnlyEnforceIf(_p_Deliver_Box3)

    ts['Row4_done'] = model.new_int_var(0, horizon, 'Row4_done_s')
    te['Row4_done'] = model.new_int_var(0, horizon, 'Row4_done_e')
    # Row4_done  → exactly one of ['Drone_Relay_Box4', 'Deliver_Box4']
    pr['Row4_done']  = model.new_bool_var('Row4_done_active')
    model.add_exactly_one([_p_Drone_Relay_Box4, _p_Deliver_Box4])
    model.add(pr['Row4_done'] == 1)
    model.add(ts['Row4_done'] == ts['Drone_Relay_Box4']).OnlyEnforceIf(_p_Drone_Relay_Box4)
    model.add(te['Row4_done'] == te['Drone_Relay_Box4']).OnlyEnforceIf(_p_Drone_Relay_Box4)
    model.add(ts['Row4_done'] == ts['Deliver_Box4']).OnlyEnforceIf(_p_Deliver_Box4)
    model.add(te['Row4_done'] == te['Deliver_Box4']).OnlyEnforceIf(_p_Deliver_Box4)

    # ── Initial positioning (agent start → first task) ─────────────────
    model.add(ts['Harvest_Row1'] >= 1).only_enforce_if([_p_Harvest_Row1, _dir_Harvest_Row1])
    model.add(ts['Harvest_Row2'] >= 2).only_enforce_if([_p_Harvest_Row2, _dir_Harvest_Row2])
    model.add(ts['Harvest_Row2'] >= 3).only_enforce_if([_p_Harvest_Row2, ~_dir_Harvest_Row2])
    model.add(ts['Harvest_Row3'] >= 5).only_enforce_if([_p_Harvest_Row3, _dir_Harvest_Row3])
    model.add(ts['Harvest_Row3'] >= 6).only_enforce_if([_p_Harvest_Row3, ~_dir_Harvest_Row3])

    # ── Dependencies ──────────────────────────────────────────────────
    model.add_implication(_p_Deliver_Box1_CP, _p_Harvest_Row1)
    model.add(ts['Deliver_Box1_CP'] >= te['Harvest_Row1']).only_enforce_if([_dir_Harvest_Row1, _p_Harvest_Row1, _p_Deliver_Box1_CP])
    model.add(ts['Deliver_Box1_CP'] >= te['Harvest_Row1'] + 1).only_enforce_if([~_dir_Harvest_Row1, _p_Harvest_Row1, _p_Deliver_Box1_CP])
    model.add_implication(_p_Deliver_Box1_HP, _p_Harvest_Row1)
    model.add(ts['Deliver_Box1_HP'] >= te['Harvest_Row1']).only_enforce_if([_dir_Harvest_Row1, _p_Harvest_Row1, _p_Deliver_Box1_HP])
    model.add(ts['Deliver_Box1_HP'] >= te['Harvest_Row1'] + 1).only_enforce_if([~_dir_Harvest_Row1, _p_Harvest_Row1, _p_Deliver_Box1_HP])
    model.add_implication(_p_Deliver_Box2_CP, _p_Harvest_Row2)
    model.add(ts['Deliver_Box2_CP'] >= te['Harvest_Row2']).only_enforce_if([_dir_Harvest_Row2, _p_Harvest_Row2, _p_Deliver_Box2_CP])
    model.add(ts['Deliver_Box2_CP'] >= te['Harvest_Row2'] + 1).only_enforce_if([~_dir_Harvest_Row2, _p_Harvest_Row2, _p_Deliver_Box2_CP])
    model.add_implication(_p_Deliver_Box2_HP, _p_Harvest_Row2)
    model.add(ts['Deliver_Box2_HP'] >= te['Harvest_Row2']).only_enforce_if([_dir_Harvest_Row2, _p_Harvest_Row2, _p_Deliver_Box2_HP])
    model.add(ts['Deliver_Box2_HP'] >= te['Harvest_Row2'] + 1).only_enforce_if([~_dir_Harvest_Row2, _p_Harvest_Row2, _p_Deliver_Box2_HP])
    model.add_implication(_p_Deliver_Box3_CP, _p_Harvest_Row3)
    model.add(ts['Deliver_Box3_CP'] >= te['Harvest_Row3']).only_enforce_if([_dir_Harvest_Row3, _p_Harvest_Row3, _p_Deliver_Box3_CP])
    model.add(ts['Deliver_Box3_CP'] >= te['Harvest_Row3'] + 1).only_enforce_if([~_dir_Harvest_Row3, _p_Harvest_Row3, _p_Deliver_Box3_CP])
    model.add_implication(_p_Deliver_Box3_HP, _p_Harvest_Row3)
    model.add(ts['Deliver_Box3_HP'] >= te['Harvest_Row3']).only_enforce_if([_dir_Harvest_Row3, _p_Harvest_Row3, _p_Deliver_Box3_HP])
    model.add(ts['Deliver_Box3_HP'] >= te['Harvest_Row3'] + 1).only_enforce_if([~_dir_Harvest_Row3, _p_Harvest_Row3, _p_Deliver_Box3_HP])
    model.add_implication(_p_Harvest_Row4, _p_Deliver_Box3)
    model.add(ts['Harvest_Row4'] >= te['Deliver_Box3_CP'] + 6).only_enforce_if([_dir_Harvest_Row4, _p_Deliver_Box3_CP, _p_Harvest_Row4])
    model.add(ts['Harvest_Row4'] >= te['Deliver_Box3_CP'] + 5).only_enforce_if([~_dir_Harvest_Row4, _p_Deliver_Box3_CP, _p_Harvest_Row4])
    model.add(ts['Harvest_Row4'] >= te['Deliver_Box3_HP'] + 9).only_enforce_if([_dir_Harvest_Row4, _p_Deliver_Box3_HP, _p_Harvest_Row4])
    model.add(ts['Harvest_Row4'] >= te['Deliver_Box3_HP'] + 8).only_enforce_if([~_dir_Harvest_Row4, _p_Deliver_Box3_HP, _p_Harvest_Row4])
    model.add_implication(_p_Deliver_Box4_CP, _p_Harvest_Row4)
    model.add(ts['Deliver_Box4_CP'] >= te['Harvest_Row4']).only_enforce_if([_dir_Harvest_Row4, _p_Harvest_Row4, _p_Deliver_Box4_CP])
    model.add(ts['Deliver_Box4_CP'] >= te['Harvest_Row4'] + 1).only_enforce_if([~_dir_Harvest_Row4, _p_Harvest_Row4, _p_Deliver_Box4_CP])
    model.add_implication(_p_Deliver_Box4_HP, _p_Harvest_Row4)
    model.add(ts['Deliver_Box4_HP'] >= te['Harvest_Row4']).only_enforce_if([_dir_Harvest_Row4, _p_Harvest_Row4, _p_Deliver_Box4_HP])
    model.add(ts['Deliver_Box4_HP'] >= te['Harvest_Row4'] + 1).only_enforce_if([~_dir_Harvest_Row4, _p_Harvest_Row4, _p_Deliver_Box4_HP])
    model.add_implication(_p_Drone_Relay_Box1, _p_Deliver_Box1_HP)
    model.add(ts['Drone_Relay_Box1'] >= te['Deliver_Box1_HP']).only_enforce_if([_p_Deliver_Box1_HP, _p_Drone_Relay_Box1])
    model.add_implication(_p_Drone_Relay_Box2, _p_Deliver_Box2_HP)
    model.add(ts['Drone_Relay_Box2'] >= te['Deliver_Box2_HP']).only_enforce_if([_p_Deliver_Box2_HP, _p_Drone_Relay_Box2])
    model.add_implication(_p_Drone_Relay_Box3, _p_Deliver_Box3_HP)
    model.add(ts['Drone_Relay_Box3'] >= te['Deliver_Box3_HP']).only_enforce_if([_p_Deliver_Box3_HP, _p_Drone_Relay_Box3])
    model.add_implication(_p_Drone_Relay_Box4, _p_Deliver_Box4_HP)
    model.add(ts['Drone_Relay_Box4'] >= te['Deliver_Box4_HP']).only_enforce_if([_p_Deliver_Box4_HP, _p_Drone_Relay_Box4])
    model.add(ts['Tractor_Final'] >= te['Drone_Relay_Box1']).only_enforce_if(_p_Drone_Relay_Box1)
    model.add(ts['Tractor_Final'] >= te['Deliver_Box1_CP']).only_enforce_if([_p_Deliver_Box1, _p_Deliver_Box1_CP])
    model.add(ts['Tractor_Final'] >= te['Deliver_Box1_HP']).only_enforce_if([_p_Deliver_Box1, _p_Deliver_Box1_HP])
    model.add(ts['Tractor_Final'] >= te['Drone_Relay_Box2']).only_enforce_if(_p_Drone_Relay_Box2)
    model.add(ts['Tractor_Final'] >= te['Deliver_Box2_CP']).only_enforce_if([_p_Deliver_Box2, _p_Deliver_Box2_CP])
    model.add(ts['Tractor_Final'] >= te['Deliver_Box2_HP']).only_enforce_if([_p_Deliver_Box2, _p_Deliver_Box2_HP])
    model.add(ts['Tractor_Final'] >= te['Drone_Relay_Box3']).only_enforce_if(_p_Drone_Relay_Box3)
    model.add(ts['Tractor_Final'] >= te['Deliver_Box3_CP']).only_enforce_if([_p_Deliver_Box3, _p_Deliver_Box3_CP])
    model.add(ts['Tractor_Final'] >= te['Deliver_Box3_HP']).only_enforce_if([_p_Deliver_Box3, _p_Deliver_Box3_HP])
    model.add(ts['Tractor_Final'] >= te['Drone_Relay_Box4']).only_enforce_if(_p_Drone_Relay_Box4)
    model.add(ts['Tractor_Final'] >= te['Deliver_Box4_CP']).only_enforce_if([_p_Deliver_Box4, _p_Deliver_Box4_CP])
    model.add(ts['Tractor_Final'] >= te['Deliver_Box4_HP']).only_enforce_if([_p_Deliver_Box4, _p_Deliver_Box4_HP])

    # ── Pairwise travel (same-agent, no dep ordering) ────────────────
    # pairwise travel: Deliver_Box1_CP ↔ Deliver_Box1_HP (human1)
    _ord_Deliver_Box1_CP_Deliver_Box1_HP = model.new_bool_var('Deliver_Box1_CP_before_Deliver_Box1_HP')
    model.add(ts['Deliver_Box1_HP'] >= te['Deliver_Box1_CP'] + 5).only_enforce_if([_ord_Deliver_Box1_CP_Deliver_Box1_HP, _p_Deliver_Box1_CP, _p_Deliver_Box1_HP])
    model.add(ts['Deliver_Box1_CP'] >= te['Deliver_Box1_HP'] + 8).only_enforce_if([~_ord_Deliver_Box1_CP_Deliver_Box1_HP, _p_Deliver_Box1_CP, _p_Deliver_Box1_HP])

    # pairwise travel: Deliver_Box1_CP ↔ Deliver_Box2_CP (human1)
    _ord_Deliver_Box1_CP_Deliver_Box2_CP = model.new_bool_var('Deliver_Box1_CP_before_Deliver_Box2_CP')
    model.add(ts['Deliver_Box2_CP'] >= te['Deliver_Box1_CP'] + 5).only_enforce_if([_ord_Deliver_Box1_CP_Deliver_Box2_CP, _p_Deliver_Box1_CP, _p_Deliver_Box2_CP])
    model.add(ts['Deliver_Box1_CP'] >= te['Deliver_Box2_CP'] + 5).only_enforce_if([~_ord_Deliver_Box1_CP_Deliver_Box2_CP, _p_Deliver_Box1_CP, _p_Deliver_Box2_CP])

    # pairwise travel: Deliver_Box1_CP ↔ Deliver_Box2_HP (human1)
    _ord_Deliver_Box1_CP_Deliver_Box2_HP = model.new_bool_var('Deliver_Box1_CP_before_Deliver_Box2_HP')
    model.add(ts['Deliver_Box2_HP'] >= te['Deliver_Box1_CP'] + 5).only_enforce_if([_ord_Deliver_Box1_CP_Deliver_Box2_HP, _p_Deliver_Box1_CP, _p_Deliver_Box2_HP])
    model.add(ts['Deliver_Box1_CP'] >= te['Deliver_Box2_HP'] + 8).only_enforce_if([~_ord_Deliver_Box1_CP_Deliver_Box2_HP, _p_Deliver_Box1_CP, _p_Deliver_Box2_HP])

    # pairwise travel: Deliver_Box1_CP ↔ Deliver_Box3_CP (human1)
    _ord_Deliver_Box1_CP_Deliver_Box3_CP = model.new_bool_var('Deliver_Box1_CP_before_Deliver_Box3_CP')
    model.add(ts['Deliver_Box3_CP'] >= te['Deliver_Box1_CP'] + 5).only_enforce_if([_ord_Deliver_Box1_CP_Deliver_Box3_CP, _p_Deliver_Box1_CP, _p_Deliver_Box3_CP])
    model.add(ts['Deliver_Box1_CP'] >= te['Deliver_Box3_CP'] + 5).only_enforce_if([~_ord_Deliver_Box1_CP_Deliver_Box3_CP, _p_Deliver_Box1_CP, _p_Deliver_Box3_CP])

    # pairwise travel: Deliver_Box1_CP ↔ Deliver_Box3_HP (human1)
    _ord_Deliver_Box1_CP_Deliver_Box3_HP = model.new_bool_var('Deliver_Box1_CP_before_Deliver_Box3_HP')
    model.add(ts['Deliver_Box3_HP'] >= te['Deliver_Box1_CP'] + 5).only_enforce_if([_ord_Deliver_Box1_CP_Deliver_Box3_HP, _p_Deliver_Box1_CP, _p_Deliver_Box3_HP])
    model.add(ts['Deliver_Box1_CP'] >= te['Deliver_Box3_HP'] + 8).only_enforce_if([~_ord_Deliver_Box1_CP_Deliver_Box3_HP, _p_Deliver_Box1_CP, _p_Deliver_Box3_HP])

    # pairwise travel: Deliver_Box1_CP ↔ Deliver_Box4_CP (human1)
    _ord_Deliver_Box1_CP_Deliver_Box4_CP = model.new_bool_var('Deliver_Box1_CP_before_Deliver_Box4_CP')
    model.add(ts['Deliver_Box4_CP'] >= te['Deliver_Box1_CP'] + 5).only_enforce_if([_ord_Deliver_Box1_CP_Deliver_Box4_CP, _p_Deliver_Box1_CP, _p_Deliver_Box4_CP])
    model.add(ts['Deliver_Box1_CP'] >= te['Deliver_Box4_CP'] + 5).only_enforce_if([~_ord_Deliver_Box1_CP_Deliver_Box4_CP, _p_Deliver_Box1_CP, _p_Deliver_Box4_CP])

    # pairwise travel: Deliver_Box1_CP ↔ Deliver_Box4_HP (human1)
    _ord_Deliver_Box1_CP_Deliver_Box4_HP = model.new_bool_var('Deliver_Box1_CP_before_Deliver_Box4_HP')
    model.add(ts['Deliver_Box4_HP'] >= te['Deliver_Box1_CP'] + 5).only_enforce_if([_ord_Deliver_Box1_CP_Deliver_Box4_HP, _p_Deliver_Box1_CP, _p_Deliver_Box4_HP])
    model.add(ts['Deliver_Box1_CP'] >= te['Deliver_Box4_HP'] + 8).only_enforce_if([~_ord_Deliver_Box1_CP_Deliver_Box4_HP, _p_Deliver_Box1_CP, _p_Deliver_Box4_HP])

    # pairwise travel: Deliver_Box1_CP ↔ Harvest_Row2 (human1)
    _ord_Deliver_Box1_CP_Harvest_Row2 = model.new_bool_var('Deliver_Box1_CP_before_Harvest_Row2')
    model.add(ts['Harvest_Row2'] >= te['Deliver_Box1_CP'] + 6).only_enforce_if([_ord_Deliver_Box1_CP_Harvest_Row2, _dir_Harvest_Row2, _p_Deliver_Box1_CP, _p_Harvest_Row2])
    model.add(ts['Harvest_Row2'] >= te['Deliver_Box1_CP'] + 5).only_enforce_if([_ord_Deliver_Box1_CP_Harvest_Row2, ~_dir_Harvest_Row2, _p_Deliver_Box1_CP, _p_Harvest_Row2])
    model.add(ts['Deliver_Box1_CP'] >= te['Harvest_Row2'] + 3).only_enforce_if([~_ord_Deliver_Box1_CP_Harvest_Row2, _dir_Harvest_Row2, _p_Deliver_Box1_CP, _p_Harvest_Row2])
    model.add(ts['Deliver_Box1_CP'] >= te['Harvest_Row2'] + 2).only_enforce_if([~_ord_Deliver_Box1_CP_Harvest_Row2, ~_dir_Harvest_Row2, _p_Deliver_Box1_CP, _p_Harvest_Row2])

    # pairwise travel: Deliver_Box1_CP ↔ Harvest_Row3 (human1)
    _ord_Deliver_Box1_CP_Harvest_Row3 = model.new_bool_var('Deliver_Box1_CP_before_Harvest_Row3')
    model.add(ts['Harvest_Row3'] >= te['Deliver_Box1_CP'] + 6).only_enforce_if([_ord_Deliver_Box1_CP_Harvest_Row3, _dir_Harvest_Row3, _p_Deliver_Box1_CP, _p_Harvest_Row3])
    model.add(ts['Harvest_Row3'] >= te['Deliver_Box1_CP'] + 5).only_enforce_if([_ord_Deliver_Box1_CP_Harvest_Row3, ~_dir_Harvest_Row3, _p_Deliver_Box1_CP, _p_Harvest_Row3])
    model.add(ts['Deliver_Box1_CP'] >= te['Harvest_Row3'] + 6).only_enforce_if([~_ord_Deliver_Box1_CP_Harvest_Row3, _dir_Harvest_Row3, _p_Deliver_Box1_CP, _p_Harvest_Row3])
    model.add(ts['Deliver_Box1_CP'] >= te['Harvest_Row3'] + 5).only_enforce_if([~_ord_Deliver_Box1_CP_Harvest_Row3, ~_dir_Harvest_Row3, _p_Deliver_Box1_CP, _p_Harvest_Row3])

    # pairwise travel: Deliver_Box1_CP ↔ Harvest_Row4 (human1)
    _ord_Deliver_Box1_CP_Harvest_Row4 = model.new_bool_var('Deliver_Box1_CP_before_Harvest_Row4')
    model.add(ts['Harvest_Row4'] >= te['Deliver_Box1_CP'] + 6).only_enforce_if([_ord_Deliver_Box1_CP_Harvest_Row4, _dir_Harvest_Row4, _p_Deliver_Box1_CP, _p_Harvest_Row4])
    model.add(ts['Harvest_Row4'] >= te['Deliver_Box1_CP'] + 5).only_enforce_if([_ord_Deliver_Box1_CP_Harvest_Row4, ~_dir_Harvest_Row4, _p_Deliver_Box1_CP, _p_Harvest_Row4])
    model.add(ts['Deliver_Box1_CP'] >= te['Harvest_Row4'] + 9).only_enforce_if([~_ord_Deliver_Box1_CP_Harvest_Row4, _dir_Harvest_Row4, _p_Deliver_Box1_CP, _p_Harvest_Row4])
    model.add(ts['Deliver_Box1_CP'] >= te['Harvest_Row4'] + 8).only_enforce_if([~_ord_Deliver_Box1_CP_Harvest_Row4, ~_dir_Harvest_Row4, _p_Deliver_Box1_CP, _p_Harvest_Row4])

    # pairwise travel: Deliver_Box1_HP ↔ Deliver_Box2_CP (human1)
    _ord_Deliver_Box1_HP_Deliver_Box2_CP = model.new_bool_var('Deliver_Box1_HP_before_Deliver_Box2_CP')
    model.add(ts['Deliver_Box2_CP'] >= te['Deliver_Box1_HP'] + 8).only_enforce_if([_ord_Deliver_Box1_HP_Deliver_Box2_CP, _p_Deliver_Box1_HP, _p_Deliver_Box2_CP])
    model.add(ts['Deliver_Box1_HP'] >= te['Deliver_Box2_CP'] + 5).only_enforce_if([~_ord_Deliver_Box1_HP_Deliver_Box2_CP, _p_Deliver_Box1_HP, _p_Deliver_Box2_CP])

    # pairwise travel: Deliver_Box1_HP ↔ Deliver_Box2_HP (human1)
    _ord_Deliver_Box1_HP_Deliver_Box2_HP = model.new_bool_var('Deliver_Box1_HP_before_Deliver_Box2_HP')
    model.add(ts['Deliver_Box2_HP'] >= te['Deliver_Box1_HP'] + 8).only_enforce_if([_ord_Deliver_Box1_HP_Deliver_Box2_HP, _p_Deliver_Box1_HP, _p_Deliver_Box2_HP])
    model.add(ts['Deliver_Box1_HP'] >= te['Deliver_Box2_HP'] + 8).only_enforce_if([~_ord_Deliver_Box1_HP_Deliver_Box2_HP, _p_Deliver_Box1_HP, _p_Deliver_Box2_HP])

    # pairwise travel: Deliver_Box1_HP ↔ Deliver_Box3_CP (human1)
    _ord_Deliver_Box1_HP_Deliver_Box3_CP = model.new_bool_var('Deliver_Box1_HP_before_Deliver_Box3_CP')
    model.add(ts['Deliver_Box3_CP'] >= te['Deliver_Box1_HP'] + 8).only_enforce_if([_ord_Deliver_Box1_HP_Deliver_Box3_CP, _p_Deliver_Box1_HP, _p_Deliver_Box3_CP])
    model.add(ts['Deliver_Box1_HP'] >= te['Deliver_Box3_CP'] + 5).only_enforce_if([~_ord_Deliver_Box1_HP_Deliver_Box3_CP, _p_Deliver_Box1_HP, _p_Deliver_Box3_CP])

    # pairwise travel: Deliver_Box1_HP ↔ Deliver_Box3_HP (human1)
    _ord_Deliver_Box1_HP_Deliver_Box3_HP = model.new_bool_var('Deliver_Box1_HP_before_Deliver_Box3_HP')
    model.add(ts['Deliver_Box3_HP'] >= te['Deliver_Box1_HP'] + 8).only_enforce_if([_ord_Deliver_Box1_HP_Deliver_Box3_HP, _p_Deliver_Box1_HP, _p_Deliver_Box3_HP])
    model.add(ts['Deliver_Box1_HP'] >= te['Deliver_Box3_HP'] + 8).only_enforce_if([~_ord_Deliver_Box1_HP_Deliver_Box3_HP, _p_Deliver_Box1_HP, _p_Deliver_Box3_HP])

    # pairwise travel: Deliver_Box1_HP ↔ Deliver_Box4_CP (human1)
    _ord_Deliver_Box1_HP_Deliver_Box4_CP = model.new_bool_var('Deliver_Box1_HP_before_Deliver_Box4_CP')
    model.add(ts['Deliver_Box4_CP'] >= te['Deliver_Box1_HP'] + 8).only_enforce_if([_ord_Deliver_Box1_HP_Deliver_Box4_CP, _p_Deliver_Box1_HP, _p_Deliver_Box4_CP])
    model.add(ts['Deliver_Box1_HP'] >= te['Deliver_Box4_CP'] + 5).only_enforce_if([~_ord_Deliver_Box1_HP_Deliver_Box4_CP, _p_Deliver_Box1_HP, _p_Deliver_Box4_CP])

    # pairwise travel: Deliver_Box1_HP ↔ Deliver_Box4_HP (human1)
    _ord_Deliver_Box1_HP_Deliver_Box4_HP = model.new_bool_var('Deliver_Box1_HP_before_Deliver_Box4_HP')
    model.add(ts['Deliver_Box4_HP'] >= te['Deliver_Box1_HP'] + 8).only_enforce_if([_ord_Deliver_Box1_HP_Deliver_Box4_HP, _p_Deliver_Box1_HP, _p_Deliver_Box4_HP])
    model.add(ts['Deliver_Box1_HP'] >= te['Deliver_Box4_HP'] + 8).only_enforce_if([~_ord_Deliver_Box1_HP_Deliver_Box4_HP, _p_Deliver_Box1_HP, _p_Deliver_Box4_HP])

    # pairwise travel: Deliver_Box1_HP ↔ Harvest_Row2 (human1)
    _ord_Deliver_Box1_HP_Harvest_Row2 = model.new_bool_var('Deliver_Box1_HP_before_Harvest_Row2')
    model.add(ts['Harvest_Row2'] >= te['Deliver_Box1_HP'] + 9).only_enforce_if([_ord_Deliver_Box1_HP_Harvest_Row2, _dir_Harvest_Row2, _p_Deliver_Box1_HP, _p_Harvest_Row2])
    model.add(ts['Harvest_Row2'] >= te['Deliver_Box1_HP'] + 8).only_enforce_if([_ord_Deliver_Box1_HP_Harvest_Row2, ~_dir_Harvest_Row2, _p_Deliver_Box1_HP, _p_Harvest_Row2])
    model.add(ts['Deliver_Box1_HP'] >= te['Harvest_Row2'] + 3).only_enforce_if([~_ord_Deliver_Box1_HP_Harvest_Row2, _dir_Harvest_Row2, _p_Deliver_Box1_HP, _p_Harvest_Row2])
    model.add(ts['Deliver_Box1_HP'] >= te['Harvest_Row2'] + 2).only_enforce_if([~_ord_Deliver_Box1_HP_Harvest_Row2, ~_dir_Harvest_Row2, _p_Deliver_Box1_HP, _p_Harvest_Row2])

    # pairwise travel: Deliver_Box1_HP ↔ Harvest_Row3 (human1)
    _ord_Deliver_Box1_HP_Harvest_Row3 = model.new_bool_var('Deliver_Box1_HP_before_Harvest_Row3')
    model.add(ts['Harvest_Row3'] >= te['Deliver_Box1_HP'] + 9).only_enforce_if([_ord_Deliver_Box1_HP_Harvest_Row3, _dir_Harvest_Row3, _p_Deliver_Box1_HP, _p_Harvest_Row3])
    model.add(ts['Harvest_Row3'] >= te['Deliver_Box1_HP'] + 8).only_enforce_if([_ord_Deliver_Box1_HP_Harvest_Row3, ~_dir_Harvest_Row3, _p_Deliver_Box1_HP, _p_Harvest_Row3])
    model.add(ts['Deliver_Box1_HP'] >= te['Harvest_Row3'] + 6).only_enforce_if([~_ord_Deliver_Box1_HP_Harvest_Row3, _dir_Harvest_Row3, _p_Deliver_Box1_HP, _p_Harvest_Row3])
    model.add(ts['Deliver_Box1_HP'] >= te['Harvest_Row3'] + 5).only_enforce_if([~_ord_Deliver_Box1_HP_Harvest_Row3, ~_dir_Harvest_Row3, _p_Deliver_Box1_HP, _p_Harvest_Row3])

    # pairwise travel: Deliver_Box1_HP ↔ Harvest_Row4 (human1)
    _ord_Deliver_Box1_HP_Harvest_Row4 = model.new_bool_var('Deliver_Box1_HP_before_Harvest_Row4')
    model.add(ts['Harvest_Row4'] >= te['Deliver_Box1_HP'] + 9).only_enforce_if([_ord_Deliver_Box1_HP_Harvest_Row4, _dir_Harvest_Row4, _p_Deliver_Box1_HP, _p_Harvest_Row4])
    model.add(ts['Harvest_Row4'] >= te['Deliver_Box1_HP'] + 8).only_enforce_if([_ord_Deliver_Box1_HP_Harvest_Row4, ~_dir_Harvest_Row4, _p_Deliver_Box1_HP, _p_Harvest_Row4])
    model.add(ts['Deliver_Box1_HP'] >= te['Harvest_Row4'] + 9).only_enforce_if([~_ord_Deliver_Box1_HP_Harvest_Row4, _dir_Harvest_Row4, _p_Deliver_Box1_HP, _p_Harvest_Row4])
    model.add(ts['Deliver_Box1_HP'] >= te['Harvest_Row4'] + 8).only_enforce_if([~_ord_Deliver_Box1_HP_Harvest_Row4, ~_dir_Harvest_Row4, _p_Deliver_Box1_HP, _p_Harvest_Row4])

    # pairwise travel: Deliver_Box2_CP ↔ Deliver_Box2_HP (human1)
    _ord_Deliver_Box2_CP_Deliver_Box2_HP = model.new_bool_var('Deliver_Box2_CP_before_Deliver_Box2_HP')
    model.add(ts['Deliver_Box2_HP'] >= te['Deliver_Box2_CP'] + 5).only_enforce_if([_ord_Deliver_Box2_CP_Deliver_Box2_HP, _p_Deliver_Box2_CP, _p_Deliver_Box2_HP])
    model.add(ts['Deliver_Box2_CP'] >= te['Deliver_Box2_HP'] + 8).only_enforce_if([~_ord_Deliver_Box2_CP_Deliver_Box2_HP, _p_Deliver_Box2_CP, _p_Deliver_Box2_HP])

    # pairwise travel: Deliver_Box2_CP ↔ Deliver_Box3_CP (human1)
    _ord_Deliver_Box2_CP_Deliver_Box3_CP = model.new_bool_var('Deliver_Box2_CP_before_Deliver_Box3_CP')
    model.add(ts['Deliver_Box3_CP'] >= te['Deliver_Box2_CP'] + 5).only_enforce_if([_ord_Deliver_Box2_CP_Deliver_Box3_CP, _p_Deliver_Box2_CP, _p_Deliver_Box3_CP])
    model.add(ts['Deliver_Box2_CP'] >= te['Deliver_Box3_CP'] + 5).only_enforce_if([~_ord_Deliver_Box2_CP_Deliver_Box3_CP, _p_Deliver_Box2_CP, _p_Deliver_Box3_CP])

    # pairwise travel: Deliver_Box2_CP ↔ Deliver_Box3_HP (human1)
    _ord_Deliver_Box2_CP_Deliver_Box3_HP = model.new_bool_var('Deliver_Box2_CP_before_Deliver_Box3_HP')
    model.add(ts['Deliver_Box3_HP'] >= te['Deliver_Box2_CP'] + 5).only_enforce_if([_ord_Deliver_Box2_CP_Deliver_Box3_HP, _p_Deliver_Box2_CP, _p_Deliver_Box3_HP])
    model.add(ts['Deliver_Box2_CP'] >= te['Deliver_Box3_HP'] + 8).only_enforce_if([~_ord_Deliver_Box2_CP_Deliver_Box3_HP, _p_Deliver_Box2_CP, _p_Deliver_Box3_HP])

    # pairwise travel: Deliver_Box2_CP ↔ Deliver_Box4_CP (human1)
    _ord_Deliver_Box2_CP_Deliver_Box4_CP = model.new_bool_var('Deliver_Box2_CP_before_Deliver_Box4_CP')
    model.add(ts['Deliver_Box4_CP'] >= te['Deliver_Box2_CP'] + 5).only_enforce_if([_ord_Deliver_Box2_CP_Deliver_Box4_CP, _p_Deliver_Box2_CP, _p_Deliver_Box4_CP])
    model.add(ts['Deliver_Box2_CP'] >= te['Deliver_Box4_CP'] + 5).only_enforce_if([~_ord_Deliver_Box2_CP_Deliver_Box4_CP, _p_Deliver_Box2_CP, _p_Deliver_Box4_CP])

    # pairwise travel: Deliver_Box2_CP ↔ Deliver_Box4_HP (human1)
    _ord_Deliver_Box2_CP_Deliver_Box4_HP = model.new_bool_var('Deliver_Box2_CP_before_Deliver_Box4_HP')
    model.add(ts['Deliver_Box4_HP'] >= te['Deliver_Box2_CP'] + 5).only_enforce_if([_ord_Deliver_Box2_CP_Deliver_Box4_HP, _p_Deliver_Box2_CP, _p_Deliver_Box4_HP])
    model.add(ts['Deliver_Box2_CP'] >= te['Deliver_Box4_HP'] + 8).only_enforce_if([~_ord_Deliver_Box2_CP_Deliver_Box4_HP, _p_Deliver_Box2_CP, _p_Deliver_Box4_HP])

    # pairwise travel: Deliver_Box2_CP ↔ Harvest_Row1 (human1)
    _ord_Deliver_Box2_CP_Harvest_Row1 = model.new_bool_var('Deliver_Box2_CP_before_Harvest_Row1')
    model.add(ts['Harvest_Row1'] >= te['Deliver_Box2_CP'] + 6).only_enforce_if([_ord_Deliver_Box2_CP_Harvest_Row1, _dir_Harvest_Row1, _p_Deliver_Box2_CP, _p_Harvest_Row1])
    model.add(ts['Harvest_Row1'] >= te['Deliver_Box2_CP'] + 5).only_enforce_if([_ord_Deliver_Box2_CP_Harvest_Row1, ~_dir_Harvest_Row1, _p_Deliver_Box2_CP, _p_Harvest_Row1])
    model.add(ts['Deliver_Box2_CP'] >= te['Harvest_Row1'] + 3).only_enforce_if([~_ord_Deliver_Box2_CP_Harvest_Row1, _dir_Harvest_Row1, _p_Deliver_Box2_CP, _p_Harvest_Row1])
    model.add(ts['Deliver_Box2_CP'] >= te['Harvest_Row1'] + 4).only_enforce_if([~_ord_Deliver_Box2_CP_Harvest_Row1, ~_dir_Harvest_Row1, _p_Deliver_Box2_CP, _p_Harvest_Row1])

    # pairwise travel: Deliver_Box2_CP ↔ Harvest_Row3 (human1)
    _ord_Deliver_Box2_CP_Harvest_Row3 = model.new_bool_var('Deliver_Box2_CP_before_Harvest_Row3')
    model.add(ts['Harvest_Row3'] >= te['Deliver_Box2_CP'] + 6).only_enforce_if([_ord_Deliver_Box2_CP_Harvest_Row3, _dir_Harvest_Row3, _p_Deliver_Box2_CP, _p_Harvest_Row3])
    model.add(ts['Harvest_Row3'] >= te['Deliver_Box2_CP'] + 5).only_enforce_if([_ord_Deliver_Box2_CP_Harvest_Row3, ~_dir_Harvest_Row3, _p_Deliver_Box2_CP, _p_Harvest_Row3])
    model.add(ts['Deliver_Box2_CP'] >= te['Harvest_Row3'] + 3).only_enforce_if([~_ord_Deliver_Box2_CP_Harvest_Row3, _dir_Harvest_Row3, _p_Deliver_Box2_CP, _p_Harvest_Row3])
    model.add(ts['Deliver_Box2_CP'] >= te['Harvest_Row3'] + 2).only_enforce_if([~_ord_Deliver_Box2_CP_Harvest_Row3, ~_dir_Harvest_Row3, _p_Deliver_Box2_CP, _p_Harvest_Row3])

    # pairwise travel: Deliver_Box2_CP ↔ Harvest_Row4 (human1)
    _ord_Deliver_Box2_CP_Harvest_Row4 = model.new_bool_var('Deliver_Box2_CP_before_Harvest_Row4')
    model.add(ts['Harvest_Row4'] >= te['Deliver_Box2_CP'] + 6).only_enforce_if([_ord_Deliver_Box2_CP_Harvest_Row4, _dir_Harvest_Row4, _p_Deliver_Box2_CP, _p_Harvest_Row4])
    model.add(ts['Harvest_Row4'] >= te['Deliver_Box2_CP'] + 5).only_enforce_if([_ord_Deliver_Box2_CP_Harvest_Row4, ~_dir_Harvest_Row4, _p_Deliver_Box2_CP, _p_Harvest_Row4])
    model.add(ts['Deliver_Box2_CP'] >= te['Harvest_Row4'] + 6).only_enforce_if([~_ord_Deliver_Box2_CP_Harvest_Row4, _dir_Harvest_Row4, _p_Deliver_Box2_CP, _p_Harvest_Row4])
    model.add(ts['Deliver_Box2_CP'] >= te['Harvest_Row4'] + 5).only_enforce_if([~_ord_Deliver_Box2_CP_Harvest_Row4, ~_dir_Harvest_Row4, _p_Deliver_Box2_CP, _p_Harvest_Row4])

    # pairwise travel: Deliver_Box2_HP ↔ Deliver_Box3_CP (human1)
    _ord_Deliver_Box2_HP_Deliver_Box3_CP = model.new_bool_var('Deliver_Box2_HP_before_Deliver_Box3_CP')
    model.add(ts['Deliver_Box3_CP'] >= te['Deliver_Box2_HP'] + 8).only_enforce_if([_ord_Deliver_Box2_HP_Deliver_Box3_CP, _p_Deliver_Box2_HP, _p_Deliver_Box3_CP])
    model.add(ts['Deliver_Box2_HP'] >= te['Deliver_Box3_CP'] + 5).only_enforce_if([~_ord_Deliver_Box2_HP_Deliver_Box3_CP, _p_Deliver_Box2_HP, _p_Deliver_Box3_CP])

    # pairwise travel: Deliver_Box2_HP ↔ Deliver_Box3_HP (human1)
    _ord_Deliver_Box2_HP_Deliver_Box3_HP = model.new_bool_var('Deliver_Box2_HP_before_Deliver_Box3_HP')
    model.add(ts['Deliver_Box3_HP'] >= te['Deliver_Box2_HP'] + 8).only_enforce_if([_ord_Deliver_Box2_HP_Deliver_Box3_HP, _p_Deliver_Box2_HP, _p_Deliver_Box3_HP])
    model.add(ts['Deliver_Box2_HP'] >= te['Deliver_Box3_HP'] + 8).only_enforce_if([~_ord_Deliver_Box2_HP_Deliver_Box3_HP, _p_Deliver_Box2_HP, _p_Deliver_Box3_HP])

    # pairwise travel: Deliver_Box2_HP ↔ Deliver_Box4_CP (human1)
    _ord_Deliver_Box2_HP_Deliver_Box4_CP = model.new_bool_var('Deliver_Box2_HP_before_Deliver_Box4_CP')
    model.add(ts['Deliver_Box4_CP'] >= te['Deliver_Box2_HP'] + 8).only_enforce_if([_ord_Deliver_Box2_HP_Deliver_Box4_CP, _p_Deliver_Box2_HP, _p_Deliver_Box4_CP])
    model.add(ts['Deliver_Box2_HP'] >= te['Deliver_Box4_CP'] + 5).only_enforce_if([~_ord_Deliver_Box2_HP_Deliver_Box4_CP, _p_Deliver_Box2_HP, _p_Deliver_Box4_CP])

    # pairwise travel: Deliver_Box2_HP ↔ Deliver_Box4_HP (human1)
    _ord_Deliver_Box2_HP_Deliver_Box4_HP = model.new_bool_var('Deliver_Box2_HP_before_Deliver_Box4_HP')
    model.add(ts['Deliver_Box4_HP'] >= te['Deliver_Box2_HP'] + 8).only_enforce_if([_ord_Deliver_Box2_HP_Deliver_Box4_HP, _p_Deliver_Box2_HP, _p_Deliver_Box4_HP])
    model.add(ts['Deliver_Box2_HP'] >= te['Deliver_Box4_HP'] + 8).only_enforce_if([~_ord_Deliver_Box2_HP_Deliver_Box4_HP, _p_Deliver_Box2_HP, _p_Deliver_Box4_HP])

    # pairwise travel: Deliver_Box2_HP ↔ Harvest_Row1 (human1)
    _ord_Deliver_Box2_HP_Harvest_Row1 = model.new_bool_var('Deliver_Box2_HP_before_Harvest_Row1')
    model.add(ts['Harvest_Row1'] >= te['Deliver_Box2_HP'] + 9).only_enforce_if([_ord_Deliver_Box2_HP_Harvest_Row1, _dir_Harvest_Row1, _p_Deliver_Box2_HP, _p_Harvest_Row1])
    model.add(ts['Harvest_Row1'] >= te['Deliver_Box2_HP'] + 8).only_enforce_if([_ord_Deliver_Box2_HP_Harvest_Row1, ~_dir_Harvest_Row1, _p_Deliver_Box2_HP, _p_Harvest_Row1])
    model.add(ts['Deliver_Box2_HP'] >= te['Harvest_Row1'] + 3).only_enforce_if([~_ord_Deliver_Box2_HP_Harvest_Row1, _dir_Harvest_Row1, _p_Deliver_Box2_HP, _p_Harvest_Row1])
    model.add(ts['Deliver_Box2_HP'] >= te['Harvest_Row1'] + 4).only_enforce_if([~_ord_Deliver_Box2_HP_Harvest_Row1, ~_dir_Harvest_Row1, _p_Deliver_Box2_HP, _p_Harvest_Row1])

    # pairwise travel: Deliver_Box2_HP ↔ Harvest_Row3 (human1)
    _ord_Deliver_Box2_HP_Harvest_Row3 = model.new_bool_var('Deliver_Box2_HP_before_Harvest_Row3')
    model.add(ts['Harvest_Row3'] >= te['Deliver_Box2_HP'] + 9).only_enforce_if([_ord_Deliver_Box2_HP_Harvest_Row3, _dir_Harvest_Row3, _p_Deliver_Box2_HP, _p_Harvest_Row3])
    model.add(ts['Harvest_Row3'] >= te['Deliver_Box2_HP'] + 8).only_enforce_if([_ord_Deliver_Box2_HP_Harvest_Row3, ~_dir_Harvest_Row3, _p_Deliver_Box2_HP, _p_Harvest_Row3])
    model.add(ts['Deliver_Box2_HP'] >= te['Harvest_Row3'] + 3).only_enforce_if([~_ord_Deliver_Box2_HP_Harvest_Row3, _dir_Harvest_Row3, _p_Deliver_Box2_HP, _p_Harvest_Row3])
    model.add(ts['Deliver_Box2_HP'] >= te['Harvest_Row3'] + 2).only_enforce_if([~_ord_Deliver_Box2_HP_Harvest_Row3, ~_dir_Harvest_Row3, _p_Deliver_Box2_HP, _p_Harvest_Row3])

    # pairwise travel: Deliver_Box2_HP ↔ Harvest_Row4 (human1)
    _ord_Deliver_Box2_HP_Harvest_Row4 = model.new_bool_var('Deliver_Box2_HP_before_Harvest_Row4')
    model.add(ts['Harvest_Row4'] >= te['Deliver_Box2_HP'] + 9).only_enforce_if([_ord_Deliver_Box2_HP_Harvest_Row4, _dir_Harvest_Row4, _p_Deliver_Box2_HP, _p_Harvest_Row4])
    model.add(ts['Harvest_Row4'] >= te['Deliver_Box2_HP'] + 8).only_enforce_if([_ord_Deliver_Box2_HP_Harvest_Row4, ~_dir_Harvest_Row4, _p_Deliver_Box2_HP, _p_Harvest_Row4])
    model.add(ts['Deliver_Box2_HP'] >= te['Harvest_Row4'] + 6).only_enforce_if([~_ord_Deliver_Box2_HP_Harvest_Row4, _dir_Harvest_Row4, _p_Deliver_Box2_HP, _p_Harvest_Row4])
    model.add(ts['Deliver_Box2_HP'] >= te['Harvest_Row4'] + 5).only_enforce_if([~_ord_Deliver_Box2_HP_Harvest_Row4, ~_dir_Harvest_Row4, _p_Deliver_Box2_HP, _p_Harvest_Row4])

    # pairwise travel: Deliver_Box3_CP ↔ Deliver_Box3_HP (human1)
    _ord_Deliver_Box3_CP_Deliver_Box3_HP = model.new_bool_var('Deliver_Box3_CP_before_Deliver_Box3_HP')
    model.add(ts['Deliver_Box3_HP'] >= te['Deliver_Box3_CP'] + 5).only_enforce_if([_ord_Deliver_Box3_CP_Deliver_Box3_HP, _p_Deliver_Box3_CP, _p_Deliver_Box3_HP])
    model.add(ts['Deliver_Box3_CP'] >= te['Deliver_Box3_HP'] + 8).only_enforce_if([~_ord_Deliver_Box3_CP_Deliver_Box3_HP, _p_Deliver_Box3_CP, _p_Deliver_Box3_HP])

    # pairwise travel: Deliver_Box3_CP ↔ Harvest_Row1 (human1)
    _ord_Deliver_Box3_CP_Harvest_Row1 = model.new_bool_var('Deliver_Box3_CP_before_Harvest_Row1')
    model.add(ts['Harvest_Row1'] >= te['Deliver_Box3_CP'] + 6).only_enforce_if([_ord_Deliver_Box3_CP_Harvest_Row1, _dir_Harvest_Row1, _p_Deliver_Box3_CP, _p_Harvest_Row1])
    model.add(ts['Harvest_Row1'] >= te['Deliver_Box3_CP'] + 5).only_enforce_if([_ord_Deliver_Box3_CP_Harvest_Row1, ~_dir_Harvest_Row1, _p_Deliver_Box3_CP, _p_Harvest_Row1])
    model.add(ts['Deliver_Box3_CP'] >= te['Harvest_Row1'] + 6).only_enforce_if([~_ord_Deliver_Box3_CP_Harvest_Row1, _dir_Harvest_Row1, _p_Deliver_Box3_CP, _p_Harvest_Row1])
    model.add(ts['Deliver_Box3_CP'] >= te['Harvest_Row1'] + 7).only_enforce_if([~_ord_Deliver_Box3_CP_Harvest_Row1, ~_dir_Harvest_Row1, _p_Deliver_Box3_CP, _p_Harvest_Row1])

    # pairwise travel: Deliver_Box3_CP ↔ Harvest_Row2 (human1)
    _ord_Deliver_Box3_CP_Harvest_Row2 = model.new_bool_var('Deliver_Box3_CP_before_Harvest_Row2')
    model.add(ts['Harvest_Row2'] >= te['Deliver_Box3_CP'] + 6).only_enforce_if([_ord_Deliver_Box3_CP_Harvest_Row2, _dir_Harvest_Row2, _p_Deliver_Box3_CP, _p_Harvest_Row2])
    model.add(ts['Harvest_Row2'] >= te['Deliver_Box3_CP'] + 5).only_enforce_if([_ord_Deliver_Box3_CP_Harvest_Row2, ~_dir_Harvest_Row2, _p_Deliver_Box3_CP, _p_Harvest_Row2])
    model.add(ts['Deliver_Box3_CP'] >= te['Harvest_Row2'] + 3).only_enforce_if([~_ord_Deliver_Box3_CP_Harvest_Row2, _dir_Harvest_Row2, _p_Deliver_Box3_CP, _p_Harvest_Row2])
    model.add(ts['Deliver_Box3_CP'] >= te['Harvest_Row2'] + 4).only_enforce_if([~_ord_Deliver_Box3_CP_Harvest_Row2, ~_dir_Harvest_Row2, _p_Deliver_Box3_CP, _p_Harvest_Row2])

    # pairwise travel: Deliver_Box3_HP ↔ Harvest_Row1 (human1)
    _ord_Deliver_Box3_HP_Harvest_Row1 = model.new_bool_var('Deliver_Box3_HP_before_Harvest_Row1')
    model.add(ts['Harvest_Row1'] >= te['Deliver_Box3_HP'] + 9).only_enforce_if([_ord_Deliver_Box3_HP_Harvest_Row1, _dir_Harvest_Row1, _p_Deliver_Box3_HP, _p_Harvest_Row1])
    model.add(ts['Harvest_Row1'] >= te['Deliver_Box3_HP'] + 8).only_enforce_if([_ord_Deliver_Box3_HP_Harvest_Row1, ~_dir_Harvest_Row1, _p_Deliver_Box3_HP, _p_Harvest_Row1])
    model.add(ts['Deliver_Box3_HP'] >= te['Harvest_Row1'] + 6).only_enforce_if([~_ord_Deliver_Box3_HP_Harvest_Row1, _dir_Harvest_Row1, _p_Deliver_Box3_HP, _p_Harvest_Row1])
    model.add(ts['Deliver_Box3_HP'] >= te['Harvest_Row1'] + 7).only_enforce_if([~_ord_Deliver_Box3_HP_Harvest_Row1, ~_dir_Harvest_Row1, _p_Deliver_Box3_HP, _p_Harvest_Row1])

    # pairwise travel: Deliver_Box3_HP ↔ Harvest_Row2 (human1)
    _ord_Deliver_Box3_HP_Harvest_Row2 = model.new_bool_var('Deliver_Box3_HP_before_Harvest_Row2')
    model.add(ts['Harvest_Row2'] >= te['Deliver_Box3_HP'] + 9).only_enforce_if([_ord_Deliver_Box3_HP_Harvest_Row2, _dir_Harvest_Row2, _p_Deliver_Box3_HP, _p_Harvest_Row2])
    model.add(ts['Harvest_Row2'] >= te['Deliver_Box3_HP'] + 8).only_enforce_if([_ord_Deliver_Box3_HP_Harvest_Row2, ~_dir_Harvest_Row2, _p_Deliver_Box3_HP, _p_Harvest_Row2])
    model.add(ts['Deliver_Box3_HP'] >= te['Harvest_Row2'] + 3).only_enforce_if([~_ord_Deliver_Box3_HP_Harvest_Row2, _dir_Harvest_Row2, _p_Deliver_Box3_HP, _p_Harvest_Row2])
    model.add(ts['Deliver_Box3_HP'] >= te['Harvest_Row2'] + 4).only_enforce_if([~_ord_Deliver_Box3_HP_Harvest_Row2, ~_dir_Harvest_Row2, _p_Deliver_Box3_HP, _p_Harvest_Row2])

    # pairwise travel: Deliver_Box4_CP ↔ Deliver_Box4_HP (human1)
    _ord_Deliver_Box4_CP_Deliver_Box4_HP = model.new_bool_var('Deliver_Box4_CP_before_Deliver_Box4_HP')
    model.add(ts['Deliver_Box4_HP'] >= te['Deliver_Box4_CP'] + 5).only_enforce_if([_ord_Deliver_Box4_CP_Deliver_Box4_HP, _p_Deliver_Box4_CP, _p_Deliver_Box4_HP])
    model.add(ts['Deliver_Box4_CP'] >= te['Deliver_Box4_HP'] + 8).only_enforce_if([~_ord_Deliver_Box4_CP_Deliver_Box4_HP, _p_Deliver_Box4_CP, _p_Deliver_Box4_HP])

    # pairwise travel: Deliver_Box4_CP ↔ Harvest_Row1 (human1)
    _ord_Deliver_Box4_CP_Harvest_Row1 = model.new_bool_var('Deliver_Box4_CP_before_Harvest_Row1')
    model.add(ts['Harvest_Row1'] >= te['Deliver_Box4_CP'] + 6).only_enforce_if([_ord_Deliver_Box4_CP_Harvest_Row1, _dir_Harvest_Row1, _p_Deliver_Box4_CP, _p_Harvest_Row1])
    model.add(ts['Harvest_Row1'] >= te['Deliver_Box4_CP'] + 5).only_enforce_if([_ord_Deliver_Box4_CP_Harvest_Row1, ~_dir_Harvest_Row1, _p_Deliver_Box4_CP, _p_Harvest_Row1])
    model.add(ts['Deliver_Box4_CP'] >= te['Harvest_Row1'] + 9).only_enforce_if([~_ord_Deliver_Box4_CP_Harvest_Row1, _dir_Harvest_Row1, _p_Deliver_Box4_CP, _p_Harvest_Row1])
    model.add(ts['Deliver_Box4_CP'] >= te['Harvest_Row1'] + 10).only_enforce_if([~_ord_Deliver_Box4_CP_Harvest_Row1, ~_dir_Harvest_Row1, _p_Deliver_Box4_CP, _p_Harvest_Row1])

    # pairwise travel: Deliver_Box4_CP ↔ Harvest_Row2 (human1)
    _ord_Deliver_Box4_CP_Harvest_Row2 = model.new_bool_var('Deliver_Box4_CP_before_Harvest_Row2')
    model.add(ts['Harvest_Row2'] >= te['Deliver_Box4_CP'] + 6).only_enforce_if([_ord_Deliver_Box4_CP_Harvest_Row2, _dir_Harvest_Row2, _p_Deliver_Box4_CP, _p_Harvest_Row2])
    model.add(ts['Harvest_Row2'] >= te['Deliver_Box4_CP'] + 5).only_enforce_if([_ord_Deliver_Box4_CP_Harvest_Row2, ~_dir_Harvest_Row2, _p_Deliver_Box4_CP, _p_Harvest_Row2])
    model.add(ts['Deliver_Box4_CP'] >= te['Harvest_Row2'] + 6).only_enforce_if([~_ord_Deliver_Box4_CP_Harvest_Row2, _dir_Harvest_Row2, _p_Deliver_Box4_CP, _p_Harvest_Row2])
    model.add(ts['Deliver_Box4_CP'] >= te['Harvest_Row2'] + 7).only_enforce_if([~_ord_Deliver_Box4_CP_Harvest_Row2, ~_dir_Harvest_Row2, _p_Deliver_Box4_CP, _p_Harvest_Row2])

    # pairwise travel: Deliver_Box4_HP ↔ Harvest_Row1 (human1)
    _ord_Deliver_Box4_HP_Harvest_Row1 = model.new_bool_var('Deliver_Box4_HP_before_Harvest_Row1')
    model.add(ts['Harvest_Row1'] >= te['Deliver_Box4_HP'] + 9).only_enforce_if([_ord_Deliver_Box4_HP_Harvest_Row1, _dir_Harvest_Row1, _p_Deliver_Box4_HP, _p_Harvest_Row1])
    model.add(ts['Harvest_Row1'] >= te['Deliver_Box4_HP'] + 8).only_enforce_if([_ord_Deliver_Box4_HP_Harvest_Row1, ~_dir_Harvest_Row1, _p_Deliver_Box4_HP, _p_Harvest_Row1])
    model.add(ts['Deliver_Box4_HP'] >= te['Harvest_Row1'] + 9).only_enforce_if([~_ord_Deliver_Box4_HP_Harvest_Row1, _dir_Harvest_Row1, _p_Deliver_Box4_HP, _p_Harvest_Row1])
    model.add(ts['Deliver_Box4_HP'] >= te['Harvest_Row1'] + 10).only_enforce_if([~_ord_Deliver_Box4_HP_Harvest_Row1, ~_dir_Harvest_Row1, _p_Deliver_Box4_HP, _p_Harvest_Row1])

    # pairwise travel: Deliver_Box4_HP ↔ Harvest_Row2 (human1)
    _ord_Deliver_Box4_HP_Harvest_Row2 = model.new_bool_var('Deliver_Box4_HP_before_Harvest_Row2')
    model.add(ts['Harvest_Row2'] >= te['Deliver_Box4_HP'] + 9).only_enforce_if([_ord_Deliver_Box4_HP_Harvest_Row2, _dir_Harvest_Row2, _p_Deliver_Box4_HP, _p_Harvest_Row2])
    model.add(ts['Harvest_Row2'] >= te['Deliver_Box4_HP'] + 8).only_enforce_if([_ord_Deliver_Box4_HP_Harvest_Row2, ~_dir_Harvest_Row2, _p_Deliver_Box4_HP, _p_Harvest_Row2])
    model.add(ts['Deliver_Box4_HP'] >= te['Harvest_Row2'] + 6).only_enforce_if([~_ord_Deliver_Box4_HP_Harvest_Row2, _dir_Harvest_Row2, _p_Deliver_Box4_HP, _p_Harvest_Row2])
    model.add(ts['Deliver_Box4_HP'] >= te['Harvest_Row2'] + 7).only_enforce_if([~_ord_Deliver_Box4_HP_Harvest_Row2, ~_dir_Harvest_Row2, _p_Deliver_Box4_HP, _p_Harvest_Row2])

    # pairwise travel: Harvest_Row1 ↔ Harvest_Row2 (human1)
    _ord_Harvest_Row1_Harvest_Row2 = model.new_bool_var('Harvest_Row1_before_Harvest_Row2')
    model.add(ts['Harvest_Row2'] >= te['Harvest_Row1'] + 2).only_enforce_if([_ord_Harvest_Row1_Harvest_Row2, _dir_Harvest_Row1, _dir_Harvest_Row2, _p_Harvest_Row1, _p_Harvest_Row2])
    model.add(ts['Harvest_Row2'] >= te['Harvest_Row1'] + 3).only_enforce_if([_ord_Harvest_Row1_Harvest_Row2, _dir_Harvest_Row1, ~_dir_Harvest_Row2, _p_Harvest_Row1, _p_Harvest_Row2])
    model.add(ts['Harvest_Row2'] >= te['Harvest_Row1'] + 3).only_enforce_if([_ord_Harvest_Row1_Harvest_Row2, ~_dir_Harvest_Row1, _dir_Harvest_Row2, _p_Harvest_Row1, _p_Harvest_Row2])
    model.add(ts['Harvest_Row2'] >= te['Harvest_Row1'] + 4).only_enforce_if([_ord_Harvest_Row1_Harvest_Row2, ~_dir_Harvest_Row1, ~_dir_Harvest_Row2, _p_Harvest_Row1, _p_Harvest_Row2])
    model.add(ts['Harvest_Row1'] >= te['Harvest_Row2'] + 4).only_enforce_if([~_ord_Harvest_Row1_Harvest_Row2, _dir_Harvest_Row2, _dir_Harvest_Row1, _p_Harvest_Row1, _p_Harvest_Row2])
    model.add(ts['Harvest_Row1'] >= te['Harvest_Row2'] + 3).only_enforce_if([~_ord_Harvest_Row1_Harvest_Row2, _dir_Harvest_Row2, ~_dir_Harvest_Row1, _p_Harvest_Row1, _p_Harvest_Row2])
    model.add(ts['Harvest_Row1'] >= te['Harvest_Row2'] + 3).only_enforce_if([~_ord_Harvest_Row1_Harvest_Row2, ~_dir_Harvest_Row2, _dir_Harvest_Row1, _p_Harvest_Row1, _p_Harvest_Row2])
    model.add(ts['Harvest_Row1'] >= te['Harvest_Row2'] + 2).only_enforce_if([~_ord_Harvest_Row1_Harvest_Row2, ~_dir_Harvest_Row2, ~_dir_Harvest_Row1, _p_Harvest_Row1, _p_Harvest_Row2])

    # pairwise travel: Harvest_Row1 ↔ Harvest_Row3 (human1)
    _ord_Harvest_Row1_Harvest_Row3 = model.new_bool_var('Harvest_Row1_before_Harvest_Row3')
    model.add(ts['Harvest_Row3'] >= te['Harvest_Row1'] + 5).only_enforce_if([_ord_Harvest_Row1_Harvest_Row3, _dir_Harvest_Row1, _dir_Harvest_Row3, _p_Harvest_Row1, _p_Harvest_Row3])
    model.add(ts['Harvest_Row3'] >= te['Harvest_Row1'] + 6).only_enforce_if([_ord_Harvest_Row1_Harvest_Row3, _dir_Harvest_Row1, ~_dir_Harvest_Row3, _p_Harvest_Row1, _p_Harvest_Row3])
    model.add(ts['Harvest_Row3'] >= te['Harvest_Row1'] + 6).only_enforce_if([_ord_Harvest_Row1_Harvest_Row3, ~_dir_Harvest_Row1, _dir_Harvest_Row3, _p_Harvest_Row1, _p_Harvest_Row3])
    model.add(ts['Harvest_Row3'] >= te['Harvest_Row1'] + 7).only_enforce_if([_ord_Harvest_Row1_Harvest_Row3, ~_dir_Harvest_Row1, ~_dir_Harvest_Row3, _p_Harvest_Row1, _p_Harvest_Row3])
    model.add(ts['Harvest_Row1'] >= te['Harvest_Row3'] + 7).only_enforce_if([~_ord_Harvest_Row1_Harvest_Row3, _dir_Harvest_Row3, _dir_Harvest_Row1, _p_Harvest_Row1, _p_Harvest_Row3])
    model.add(ts['Harvest_Row1'] >= te['Harvest_Row3'] + 6).only_enforce_if([~_ord_Harvest_Row1_Harvest_Row3, _dir_Harvest_Row3, ~_dir_Harvest_Row1, _p_Harvest_Row1, _p_Harvest_Row3])
    model.add(ts['Harvest_Row1'] >= te['Harvest_Row3'] + 6).only_enforce_if([~_ord_Harvest_Row1_Harvest_Row3, ~_dir_Harvest_Row3, _dir_Harvest_Row1, _p_Harvest_Row1, _p_Harvest_Row3])
    model.add(ts['Harvest_Row1'] >= te['Harvest_Row3'] + 5).only_enforce_if([~_ord_Harvest_Row1_Harvest_Row3, ~_dir_Harvest_Row3, ~_dir_Harvest_Row1, _p_Harvest_Row1, _p_Harvest_Row3])

    # pairwise travel: Harvest_Row1 ↔ Harvest_Row4 (human1)
    _ord_Harvest_Row1_Harvest_Row4 = model.new_bool_var('Harvest_Row1_before_Harvest_Row4')
    model.add(ts['Harvest_Row4'] >= te['Harvest_Row1'] + 8).only_enforce_if([_ord_Harvest_Row1_Harvest_Row4, _dir_Harvest_Row1, _dir_Harvest_Row4, _p_Harvest_Row1, _p_Harvest_Row4])
    model.add(ts['Harvest_Row4'] >= te['Harvest_Row1'] + 9).only_enforce_if([_ord_Harvest_Row1_Harvest_Row4, _dir_Harvest_Row1, ~_dir_Harvest_Row4, _p_Harvest_Row1, _p_Harvest_Row4])
    model.add(ts['Harvest_Row4'] >= te['Harvest_Row1'] + 9).only_enforce_if([_ord_Harvest_Row1_Harvest_Row4, ~_dir_Harvest_Row1, _dir_Harvest_Row4, _p_Harvest_Row1, _p_Harvest_Row4])
    model.add(ts['Harvest_Row4'] >= te['Harvest_Row1'] + 10).only_enforce_if([_ord_Harvest_Row1_Harvest_Row4, ~_dir_Harvest_Row1, ~_dir_Harvest_Row4, _p_Harvest_Row1, _p_Harvest_Row4])
    model.add(ts['Harvest_Row1'] >= te['Harvest_Row4'] + 10).only_enforce_if([~_ord_Harvest_Row1_Harvest_Row4, _dir_Harvest_Row4, _dir_Harvest_Row1, _p_Harvest_Row1, _p_Harvest_Row4])
    model.add(ts['Harvest_Row1'] >= te['Harvest_Row4'] + 9).only_enforce_if([~_ord_Harvest_Row1_Harvest_Row4, _dir_Harvest_Row4, ~_dir_Harvest_Row1, _p_Harvest_Row1, _p_Harvest_Row4])
    model.add(ts['Harvest_Row1'] >= te['Harvest_Row4'] + 9).only_enforce_if([~_ord_Harvest_Row1_Harvest_Row4, ~_dir_Harvest_Row4, _dir_Harvest_Row1, _p_Harvest_Row1, _p_Harvest_Row4])
    model.add(ts['Harvest_Row1'] >= te['Harvest_Row4'] + 8).only_enforce_if([~_ord_Harvest_Row1_Harvest_Row4, ~_dir_Harvest_Row4, ~_dir_Harvest_Row1, _p_Harvest_Row1, _p_Harvest_Row4])

    # pairwise travel: Harvest_Row2 ↔ Harvest_Row3 (human1)
    _ord_Harvest_Row2_Harvest_Row3 = model.new_bool_var('Harvest_Row2_before_Harvest_Row3')
    model.add(ts['Harvest_Row3'] >= te['Harvest_Row2'] + 2).only_enforce_if([_ord_Harvest_Row2_Harvest_Row3, _dir_Harvest_Row2, _dir_Harvest_Row3, _p_Harvest_Row2, _p_Harvest_Row3])
    model.add(ts['Harvest_Row3'] >= te['Harvest_Row2'] + 3).only_enforce_if([_ord_Harvest_Row2_Harvest_Row3, _dir_Harvest_Row2, ~_dir_Harvest_Row3, _p_Harvest_Row2, _p_Harvest_Row3])
    model.add(ts['Harvest_Row3'] >= te['Harvest_Row2'] + 3).only_enforce_if([_ord_Harvest_Row2_Harvest_Row3, ~_dir_Harvest_Row2, _dir_Harvest_Row3, _p_Harvest_Row2, _p_Harvest_Row3])
    model.add(ts['Harvest_Row3'] >= te['Harvest_Row2'] + 4).only_enforce_if([_ord_Harvest_Row2_Harvest_Row3, ~_dir_Harvest_Row2, ~_dir_Harvest_Row3, _p_Harvest_Row2, _p_Harvest_Row3])
    model.add(ts['Harvest_Row2'] >= te['Harvest_Row3'] + 4).only_enforce_if([~_ord_Harvest_Row2_Harvest_Row3, _dir_Harvest_Row3, _dir_Harvest_Row2, _p_Harvest_Row2, _p_Harvest_Row3])
    model.add(ts['Harvest_Row2'] >= te['Harvest_Row3'] + 3).only_enforce_if([~_ord_Harvest_Row2_Harvest_Row3, _dir_Harvest_Row3, ~_dir_Harvest_Row2, _p_Harvest_Row2, _p_Harvest_Row3])
    model.add(ts['Harvest_Row2'] >= te['Harvest_Row3'] + 3).only_enforce_if([~_ord_Harvest_Row2_Harvest_Row3, ~_dir_Harvest_Row3, _dir_Harvest_Row2, _p_Harvest_Row2, _p_Harvest_Row3])
    model.add(ts['Harvest_Row2'] >= te['Harvest_Row3'] + 2).only_enforce_if([~_ord_Harvest_Row2_Harvest_Row3, ~_dir_Harvest_Row3, ~_dir_Harvest_Row2, _p_Harvest_Row2, _p_Harvest_Row3])

    # pairwise travel: Harvest_Row2 ↔ Harvest_Row4 (human1)
    _ord_Harvest_Row2_Harvest_Row4 = model.new_bool_var('Harvest_Row2_before_Harvest_Row4')
    model.add(ts['Harvest_Row4'] >= te['Harvest_Row2'] + 5).only_enforce_if([_ord_Harvest_Row2_Harvest_Row4, _dir_Harvest_Row2, _dir_Harvest_Row4, _p_Harvest_Row2, _p_Harvest_Row4])
    model.add(ts['Harvest_Row4'] >= te['Harvest_Row2'] + 6).only_enforce_if([_ord_Harvest_Row2_Harvest_Row4, _dir_Harvest_Row2, ~_dir_Harvest_Row4, _p_Harvest_Row2, _p_Harvest_Row4])
    model.add(ts['Harvest_Row4'] >= te['Harvest_Row2'] + 6).only_enforce_if([_ord_Harvest_Row2_Harvest_Row4, ~_dir_Harvest_Row2, _dir_Harvest_Row4, _p_Harvest_Row2, _p_Harvest_Row4])
    model.add(ts['Harvest_Row4'] >= te['Harvest_Row2'] + 7).only_enforce_if([_ord_Harvest_Row2_Harvest_Row4, ~_dir_Harvest_Row2, ~_dir_Harvest_Row4, _p_Harvest_Row2, _p_Harvest_Row4])
    model.add(ts['Harvest_Row2'] >= te['Harvest_Row4'] + 7).only_enforce_if([~_ord_Harvest_Row2_Harvest_Row4, _dir_Harvest_Row4, _dir_Harvest_Row2, _p_Harvest_Row2, _p_Harvest_Row4])
    model.add(ts['Harvest_Row2'] >= te['Harvest_Row4'] + 6).only_enforce_if([~_ord_Harvest_Row2_Harvest_Row4, _dir_Harvest_Row4, ~_dir_Harvest_Row2, _p_Harvest_Row2, _p_Harvest_Row4])
    model.add(ts['Harvest_Row2'] >= te['Harvest_Row4'] + 6).only_enforce_if([~_ord_Harvest_Row2_Harvest_Row4, ~_dir_Harvest_Row4, _dir_Harvest_Row2, _p_Harvest_Row2, _p_Harvest_Row4])
    model.add(ts['Harvest_Row2'] >= te['Harvest_Row4'] + 5).only_enforce_if([~_ord_Harvest_Row2_Harvest_Row4, ~_dir_Harvest_Row4, ~_dir_Harvest_Row2, _p_Harvest_Row2, _p_Harvest_Row4])

    # pairwise travel: Drone_Relay_Box1 ↔ Drone_Relay_Box2 (drone1)
    _ord_Drone_Relay_Box1_Drone_Relay_Box2 = model.new_bool_var('Drone_Relay_Box1_before_Drone_Relay_Box2')
    model.add(ts['Drone_Relay_Box2'] >= te['Drone_Relay_Box1'] + 1).only_enforce_if([_ord_Drone_Relay_Box1_Drone_Relay_Box2, _p_Drone_Relay_Box1, _p_Drone_Relay_Box2])
    model.add(ts['Drone_Relay_Box1'] >= te['Drone_Relay_Box2'] + 1).only_enforce_if([~_ord_Drone_Relay_Box1_Drone_Relay_Box2, _p_Drone_Relay_Box1, _p_Drone_Relay_Box2])

    # pairwise travel: Drone_Relay_Box1 ↔ Drone_Relay_Box3 (drone1)
    _ord_Drone_Relay_Box1_Drone_Relay_Box3 = model.new_bool_var('Drone_Relay_Box1_before_Drone_Relay_Box3')
    model.add(ts['Drone_Relay_Box3'] >= te['Drone_Relay_Box1'] + 1).only_enforce_if([_ord_Drone_Relay_Box1_Drone_Relay_Box3, _p_Drone_Relay_Box1, _p_Drone_Relay_Box3])
    model.add(ts['Drone_Relay_Box1'] >= te['Drone_Relay_Box3'] + 1).only_enforce_if([~_ord_Drone_Relay_Box1_Drone_Relay_Box3, _p_Drone_Relay_Box1, _p_Drone_Relay_Box3])

    # pairwise travel: Drone_Relay_Box1 ↔ Drone_Relay_Box4 (drone1)
    _ord_Drone_Relay_Box1_Drone_Relay_Box4 = model.new_bool_var('Drone_Relay_Box1_before_Drone_Relay_Box4')
    model.add(ts['Drone_Relay_Box4'] >= te['Drone_Relay_Box1'] + 1).only_enforce_if([_ord_Drone_Relay_Box1_Drone_Relay_Box4, _p_Drone_Relay_Box1, _p_Drone_Relay_Box4])
    model.add(ts['Drone_Relay_Box1'] >= te['Drone_Relay_Box4'] + 1).only_enforce_if([~_ord_Drone_Relay_Box1_Drone_Relay_Box4, _p_Drone_Relay_Box1, _p_Drone_Relay_Box4])

    # pairwise travel: Drone_Relay_Box2 ↔ Drone_Relay_Box3 (drone1)
    _ord_Drone_Relay_Box2_Drone_Relay_Box3 = model.new_bool_var('Drone_Relay_Box2_before_Drone_Relay_Box3')
    model.add(ts['Drone_Relay_Box3'] >= te['Drone_Relay_Box2'] + 1).only_enforce_if([_ord_Drone_Relay_Box2_Drone_Relay_Box3, _p_Drone_Relay_Box2, _p_Drone_Relay_Box3])
    model.add(ts['Drone_Relay_Box2'] >= te['Drone_Relay_Box3'] + 1).only_enforce_if([~_ord_Drone_Relay_Box2_Drone_Relay_Box3, _p_Drone_Relay_Box2, _p_Drone_Relay_Box3])

    # pairwise travel: Drone_Relay_Box2 ↔ Drone_Relay_Box4 (drone1)
    _ord_Drone_Relay_Box2_Drone_Relay_Box4 = model.new_bool_var('Drone_Relay_Box2_before_Drone_Relay_Box4')
    model.add(ts['Drone_Relay_Box4'] >= te['Drone_Relay_Box2'] + 1).only_enforce_if([_ord_Drone_Relay_Box2_Drone_Relay_Box4, _p_Drone_Relay_Box2, _p_Drone_Relay_Box4])
    model.add(ts['Drone_Relay_Box2'] >= te['Drone_Relay_Box4'] + 1).only_enforce_if([~_ord_Drone_Relay_Box2_Drone_Relay_Box4, _p_Drone_Relay_Box2, _p_Drone_Relay_Box4])

    # pairwise travel: Drone_Relay_Box3 ↔ Drone_Relay_Box4 (drone1)
    _ord_Drone_Relay_Box3_Drone_Relay_Box4 = model.new_bool_var('Drone_Relay_Box3_before_Drone_Relay_Box4')
    model.add(ts['Drone_Relay_Box4'] >= te['Drone_Relay_Box3'] + 1).only_enforce_if([_ord_Drone_Relay_Box3_Drone_Relay_Box4, _p_Drone_Relay_Box3, _p_Drone_Relay_Box4])
    model.add(ts['Drone_Relay_Box3'] >= te['Drone_Relay_Box4'] + 1).only_enforce_if([~_ord_Drone_Relay_Box3_Drone_Relay_Box4, _p_Drone_Relay_Box3, _p_Drone_Relay_Box4])

    # ── Agent no-overlap ──────────────────────────────────────────────
    for agent_id, ivs in agent_ivs.items():
        if len(ivs) > 1:
            model.add_no_overlap(ivs)

    # ── Objective: minimise completion of target tasks ────────────────
    model.minimize(te['Tractor_Final'])

    # ── Solve ─────────────────────────────────────────────────────────
    solver = cp_model.CpSolver()
    solver.parameters.num_search_workers = 4
    status = solver.solve(model)

    if status not in [cp_model.OPTIMAL, cp_model.FEASIBLE]:
        print("No solution found within constraints.")
        return

    v = solver.value
    print(f"Solution — makespan: {int(solver.objective_value)} min\n")

    virtual_nodes = ['Deliver_Box1', 'Deliver_Box2', 'Deliver_Box3', 'Deliver_Box4', 'Row1_done', 'Row2_done', 'Row3_done', 'Row4_done']
    _task_locs    = {'Harvest_Row1': ('l1', 'l2'), 'Harvest_Row2': ('l3', 'l4'), 'Harvest_Row3': ('l5', 'l6'), 'Harvest_Row4': ('l7', 'l8'), 'Deliver_Box1_CP': ('l2', 'l9'), 'Deliver_Box1_HP': ('l2', 'l10'), 'Deliver_Box2_CP': ('l4', 'l9'), 'Deliver_Box2_HP': ('l4', 'l10'), 'Deliver_Box3_CP': ('l6', 'l9'), 'Deliver_Box3_HP': ('l6', 'l10'), 'Deliver_Box4_CP': ('l8', 'l9'), 'Deliver_Box4_HP': ('l8', 'l10'), 'Drone_Relay_Box1': ('l10', 'l9'), 'Drone_Relay_Box2': ('l10', 'l9'), 'Drone_Relay_Box3': ('l10', 'l9'), 'Drone_Relay_Box4': ('l10', 'l9'), 'Tractor_Final': ('l9', 'l11')}
    _dir_vars     = {'Harvest_Row1': _dir_Harvest_Row1, 'Harvest_Row2': _dir_Harvest_Row2, 'Harvest_Row3': _dir_Harvest_Row3, 'Harvest_Row4': _dir_Harvest_Row4}
    _agent_init   = {'drone1': 'l10', 'human1': 'l2', 'tractor1': 'l9'}
    _task_intra   = {'Deliver_Box1_CP': ('l2l9', 5), 'Deliver_Box1_HP': ('l2l10', 8), 'Deliver_Box2_CP': ('l4l9', 5), 'Deliver_Box2_HP': ('l4l10', 8), 'Deliver_Box3_CP': ('l6l9', 5), 'Deliver_Box3_HP': ('l6l10', 8), 'Deliver_Box4_CP': ('l8l9', 5), 'Deliver_Box4_HP': ('l8l10', 8), 'Drone_Relay_Box1': ('l9l10', 1), 'Drone_Relay_Box2': ('l9l10', 1), 'Drone_Relay_Box3': ('l9l10', 1), 'Drone_Relay_Box4': ('l9l10', 1), 'Harvest_Row1': ('l1l2', 1), 'Harvest_Row2': ('l3l4', 1), 'Harvest_Row3': ('l5l6', 1), 'Harvest_Row4': ('l7l8', 1), 'Tractor_Final': ('l9l11', 15)}
    _agent_paths  = {('human1', 'l1', 'l10'): [('l1', 'l2', 1), ('l2', 'l10', 8)], ('human1', 'l1', 'l3'): [('l1', 'l2', 1), ('l2', 'l3', 2)], ('human1', 'l1', 'l4'): [('l1', 'l2', 1), ('l2', 'l3', 2), ('l3', 'l4', 1)], ('human1', 'l1', 'l5'): [('l1', 'l2', 1), ('l2', 'l3', 2), ('l3', 'l4', 1), ('l4', 'l5', 2)], ('human1', 'l1', 'l6'): [('l1', 'l2', 1), ('l2', 'l3', 2), ('l3', 'l4', 1), ('l4', 'l5', 2), ('l5', 'l6', 1)], ('human1', 'l1', 'l7'): [('l1', 'l2', 1), ('l2', 'l3', 2), ('l3', 'l4', 1), ('l4', 'l5', 2), ('l5', 'l6', 1), ('l6', 'l7', 2)], ('human1', 'l1', 'l8'): [('l1', 'l2', 1), ('l2', 'l3', 2), ('l3', 'l4', 1), ('l4', 'l5', 2), ('l5', 'l6', 1), ('l6', 'l7', 2), ('l7', 'l8', 1)], ('human1', 'l1', 'l9'): [('l1', 'l2', 1), ('l2', 'l9', 5)], ('human1', 'l10', 'l1'): [('l10', 'l2', 8), ('l2', 'l1', 1)], ('human1', 'l10', 'l9'): [('l10', 'l2', 8), ('l2', 'l9', 5)], ('human1', 'l2', 'l4'): [('l2', 'l3', 2), ('l3', 'l4', 1)], ('human1', 'l2', 'l5'): [('l2', 'l3', 2), ('l3', 'l4', 1), ('l4', 'l5', 2)], ('human1', 'l2', 'l6'): [('l2', 'l3', 2), ('l3', 'l4', 1), ('l4', 'l5', 2), ('l5', 'l6', 1)], ('human1', 'l2', 'l7'): [('l2', 'l3', 2), ('l3', 'l4', 1), ('l4', 'l5', 2), ('l5', 'l6', 1), ('l6', 'l7', 2)], ('human1', 'l2', 'l8'): [('l2', 'l3', 2), ('l3', 'l4', 1), ('l4', 'l5', 2), ('l5', 'l6', 1), ('l6', 'l7', 2), ('l7', 'l8', 1)], ('human1', 'l3', 'l1'): [('l3', 'l2', 2), ('l2', 'l1', 1)], ('human1', 'l3', 'l5'): [('l3', 'l4', 1), ('l4', 'l5', 2)], ('human1', 'l3', 'l6'): [('l3', 'l4', 1), ('l4', 'l5', 2), ('l5', 'l6', 1)], ('human1', 'l3', 'l7'): [('l3', 'l4', 1), ('l4', 'l5', 2), ('l5', 'l6', 1), ('l6', 'l7', 2)], ('human1', 'l3', 'l8'): [('l3', 'l4', 1), ('l4', 'l5', 2), ('l5', 'l6', 1), ('l6', 'l7', 2), ('l7', 'l8', 1)], ('human1', 'l3', 'l9'): [('l3', 'l4', 1), ('l4', 'l9', 5)], ('human1', 'l4', 'l1'): [('l4', 'l3', 1), ('l3', 'l2', 2), ('l2', 'l1', 1)], ('human1', 'l4', 'l2'): [('l4', 'l3', 1), ('l3', 'l2', 2)], ('human1', 'l4', 'l6'): [('l4', 'l5', 2), ('l5', 'l6', 1)], ('human1', 'l4', 'l7'): [('l4', 'l5', 2), ('l5', 'l6', 1), ('l6', 'l7', 2)], ('human1', 'l4', 'l8'): [('l4', 'l5', 2), ('l5', 'l6', 1), ('l6', 'l7', 2), ('l7', 'l8', 1)], ('human1', 'l5', 'l1'): [('l5', 'l4', 2), ('l4', 'l3', 1), ('l3', 'l2', 2), ('l2', 'l1', 1)], ('human1', 'l5', 'l2'): [('l5', 'l4', 2), ('l4', 'l3', 1), ('l3', 'l2', 2)], ('human1', 'l5', 'l3'): [('l5', 'l4', 2), ('l4', 'l3', 1)], ('human1', 'l5', 'l7'): [('l5', 'l6', 1), ('l6', 'l7', 2)], ('human1', 'l5', 'l8'): [('l5', 'l6', 1), ('l6', 'l7', 2), ('l7', 'l8', 1)], ('human1', 'l5', 'l9'): [('l5', 'l6', 1), ('l6', 'l9', 5)], ('human1', 'l6', 'l1'): [('l6', 'l5', 1), ('l5', 'l4', 2), ('l4', 'l3', 1), ('l3', 'l2', 2), ('l2', 'l1', 1)], ('human1', 'l6', 'l2'): [('l6', 'l5', 1), ('l5', 'l4', 2), ('l4', 'l3', 1), ('l3', 'l2', 2)], ('human1', 'l6', 'l3'): [('l6', 'l5', 1), ('l5', 'l4', 2), ('l4', 'l3', 1)], ('human1', 'l6', 'l4'): [('l6', 'l5', 1), ('l5', 'l4', 2)], ('human1', 'l6', 'l8'): [('l6', 'l7', 2), ('l7', 'l8', 1)], ('human1', 'l7', 'l1'): [('l7', 'l6', 2), ('l6', 'l5', 1), ('l5', 'l4', 2), ('l4', 'l3', 1), ('l3', 'l2', 2), ('l2', 'l1', 1)], ('human1', 'l7', 'l2'): [('l7', 'l6', 2), ('l6', 'l5', 1), ('l5', 'l4', 2), ('l4', 'l3', 1), ('l3', 'l2', 2)], ('human1', 'l7', 'l3'): [('l7', 'l6', 2), ('l6', 'l5', 1), ('l5', 'l4', 2), ('l4', 'l3', 1)], ('human1', 'l7', 'l4'): [('l7', 'l6', 2), ('l6', 'l5', 1), ('l5', 'l4', 2)], ('human1', 'l7', 'l5'): [('l7', 'l6', 2), ('l6', 'l5', 1)], ('human1', 'l7', 'l9'): [('l7', 'l8', 1), ('l8', 'l9', 5)], ('human1', 'l8', 'l1'): [('l8', 'l7', 1), ('l7', 'l6', 2), ('l6', 'l5', 1), ('l5', 'l4', 2), ('l4', 'l3', 1), ('l3', 'l2', 2), ('l2', 'l1', 1)], ('human1', 'l8', 'l2'): [('l8', 'l7', 1), ('l7', 'l6', 2), ('l6', 'l5', 1), ('l5', 'l4', 2), ('l4', 'l3', 1), ('l3', 'l2', 2)], ('human1', 'l8', 'l3'): [('l8', 'l7', 1), ('l7', 'l6', 2), ('l6', 'l5', 1), ('l5', 'l4', 2), ('l4', 'l3', 1)], ('human1', 'l8', 'l4'): [('l8', 'l7', 1), ('l7', 'l6', 2), ('l6', 'l5', 1), ('l5', 'l4', 2)], ('human1', 'l8', 'l5'): [('l8', 'l7', 1), ('l7', 'l6', 2), ('l6', 'l5', 1)], ('human1', 'l8', 'l6'): [('l8', 'l7', 1), ('l7', 'l6', 2)], ('human1', 'l9', 'l1'): [('l9', 'l2', 5), ('l2', 'l1', 1)], ('human1', 'l9', 'l10'): [('l9', 'l2', 5), ('l2', 'l10', 8)], ('human1', 'l9', 'l3'): [('l9', 'l4', 5), ('l4', 'l3', 1)], ('human1', 'l9', 'l5'): [('l9', 'l6', 5), ('l6', 'l5', 1)], ('human1', 'l9', 'l7'): [('l9', 'l8', 5), ('l8', 'l7', 1)]}
    plan_lines = []
    for agent_id in agent_ivs:
        schedule = []
        for (tid, aid), presence in asg.items():
            if aid != agent_id or tid in virtual_nodes:
                continue
            active = presence if isinstance(presence, int) else v(presence)
            if active:
                schedule.append((v(ts[tid]), v(te[tid]), tid))
        if not schedule:
            continue
        schedule.sort()
        print(f"=== {agent_id} ===")
        prev_e, prev_loc = 0, _agent_init.get(agent_id, "?")
        for s, e, tid in schedule:
            sl, el = _task_locs.get(tid, ("?", "?"))
            dv = _dir_vars.get(tid)
            if dv is not None and not v(dv):
                sl, el = el, sl  # reversed direction
            if s > prev_e and prev_loc != sl:
                hops = _agent_paths.get((agent_id, prev_loc, sl))
                if hops:
                    t = prev_e
                    for h_from, h_to, h_dur in hops:
                        print(f"  [{t:02d}→{t+h_dur:02d}] Travelling  ({h_from} → {h_to})")
                        plan_lines.append(f"    move({agent_id}, {h_from}, {h_to}) [{t:02d}, {t+h_dur:02d}]")
                        t += h_dur
                else:
                    print(f"  [{prev_e:02d}→{s:02d}] Travelling  ({prev_loc} → {sl})")
                    plan_lines.append(f"    move({agent_id}, {prev_loc}, {sl}) [{prev_e:02d}, {s:02d}]")
            intra = _task_intra.get(tid)
            intra_str = f" [task required distance {intra[1]}]" if intra else ""
            print(f"  [{s:02d}→{e:02d}] {tid} ({sl} → {el}) {intra_str}")
            plan_lines.append(f"    dotask({agent_id}, {tid}, {sl}, {el}) [{s:02d}, {e:02d}]")
            prev_e, prev_loc = e, el
        print()

    plan_path = os.path.dirname(os.path.dirname(os.path.abspath(__file__))) + "/plan.txt"
    with open(plan_path, "w") as f:
        f.write("SequentialPlan:\n" + "\n".join(plan_lines) + "\n")
    print(f"Plan written to: {plan_path}")


if __name__ == '__main__':
    main()