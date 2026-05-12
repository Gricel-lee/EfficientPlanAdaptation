# Quick test in cmd:
# ----------
# src/arch/prj-venv/bin/python3 -c "
# from unified_planning.io import PDDLReader
# reader = PDDLReader()
# p = reader.parse_problem(
#     './assets/planningProblem/Test-examples/output_test_example2locs copy/planning_domain.pddl',
#     './assets/planningProblem/Test-examples/output_test_example2locs copy/planning_problem.pddl'
# )
# print('OK:', p.name)
# print('Fluents:', [f.name for f in p.fluents])
# "
# ---------


# test_pddl.py
# Run the ENHSP planner directly on existing PDDL files and save plans to the same directory.
# Usage: python3 src/test_pddl.py  (from project root)

import sys
import os

_VENV_PYTHON = os.path.join(os.path.dirname(os.path.abspath(__file__)), "arch/prj-venv/bin/python3")
if sys.executable != _VENV_PYTHON:
    os.execv(_VENV_PYTHON, [_VENV_PYTHON] + sys.argv)

from unified_planning.io import PDDLReader
from unified_planning.shortcuts import get_environment, OneshotPlanner
from unified_planning.engines import PlanGenerationResultStatus
from unified_planning.shortcuts import MinimizeExpressionOnFinalState

# === PDDL files to test ===
DOMAIN_FILE  = "./assets/planningProblem/Test-examples/output_test_example2locs copy/planning_domain.pddl"
PROBLEM_FILE = "./assets/planningProblem/Test-examples/output_test_example2locs copy/planning_problem.pddl"


if __name__ == "__main__":
    output_dir = os.path.dirname(os.path.abspath(DOMAIN_FILE))

    # Parse
    reader = PDDLReader()
    problem = reader.parse_problem(DOMAIN_FILE, PROBLEM_FILE)
    print(f"[test_pddl] Parsed problem: {problem.name}")

    # Set optimisation metric
    problem.clear_quality_metrics()
    time = problem.fluent("time")
    problem.add_quality_metric(MinimizeExpressionOnFinalState(time()))

    # Suppress engine credits output
    env = get_environment()
    env.credits_stream = None

    # Solving 
    print(f"[test_pddl] Solving problem: {problem.name}...")

    # Solve
    with OneshotPlanner(
        problem_kind=problem.kind,
        # optimality_guarantee=PlanGenerationResultStatus.SOLVED_OPTIMALLY
    ) as planner:
        result = planner.solve(problem)

    print(f"[test_pddl] Status: {result.status}")

    if result.plan is not None:
        plan_path = os.path.join(output_dir, "plan.txt")
        with open(plan_path, "w") as f:
            f.write(str(result.plan))
        print(f"[test_pddl] Plan saved to: {plan_path}")
        print(result.plan)
    else:
        print("[test_pddl] No plan found.")
