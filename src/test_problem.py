# test_problem.py
# Run a planning problem in headless mode for testing.
# Usage: python3 test_problem.py  (from src/)

import sys
import os

# Re-execute with the project virtual environment if not already using it
_VENV_PYTHON = os.path.join(os.path.dirname(os.path.abspath(__file__)), "arch/prj-venv/bin/python3")
if sys.executable != _VENV_PYTHON:
    os.execv(_VENV_PYTHON, [_VENV_PYTHON] + sys.argv)
from run_ARCH_headless import main, _run_evochecker

# === Problem to test ===
json_file_path = "./assets/planningProblem/Test-examples/example2locs.json"
output_dir_name = "output_test_example2locs"
temperstEngineTimeout = 0   # 0 = ENHSP only (no TEMPest); set >0 for multiple plans
one_plan_or_multiple = "one"

if __name__ == "__main__":
    main(json_file_path, output_dir_name, temperstEngineTimeout, one_plan_or_multiple)
