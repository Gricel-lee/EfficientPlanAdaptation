from typing import Dict
import os
import subprocess
from restapi.model import Problem
import traceback
import arch.runPlanner as runPlanner
import arch.runEvo as runEvo

# Import config variables
print("[LTA-API] Loading configuration from config.ini")
from arch.config.config import *


def _check_json_exists(problem_id: str, json_path: str) -> bool:
    exists = os.path.exists(json_path)
    if not exists:
        print(f"[ERROR-LTA-API] JSON file for problem {problem_id} does not exist at {json_path}.")
    return exists

def _set_status(problem: Problem, status: str, PROBLEM_DATABASE: Dict[str, Problem]):
    problem.status = status
    PROBLEM_DATABASE[problem.id] = problem
    print(f"[LTA-API] Updated status for problem {problem.id} to '{status}'.")

def _error_message(problem: Problem, error_message: str, PROBLEM_DATABASE: Dict[str, Problem]):
    problem.error_message = error_message
    PROBLEM_DATABASE[problem.id] = problem
    print(f"[LTA-API] Updated error message for problem {problem.id} to: '{error_message}'.")


def _run_planner(problem: Problem):
    runPlanner.main(
        problem_id=problem.id,
        json_file_path=problem.json_file
    )

def _run_evochecker(problem: Problem):
    runEvo.main(
        problem_id=problem.id,
        json_file_path=problem.json_file,
        evo_jar_file=JAR_FILE
    )

def run_hybrid_planner(problem: Problem, PROBLEM_DATABASE: Dict[str, Problem]):
    """
    Run the hybrid planner in the background through FastAPI (main.py)
    """    
    try:
        # --- 1. Update problem status to 'processing'
        problem.status = "processing"
        print(f"[LTA-API] Started processing for planning problem {problem.id}")
        
        # --- 2. Checks
        if _check_json_exists(problem.id, problem.json_file) is False:
            _set_status(problem, "failed", PROBLEM_DATABASE)
            _error_message(problem, f"JSON file does not exist: {problem.json_file}.", PROBLEM_DATABASE)
            return
        # TODO: Add more checks, e.g., parsing the JSON file to ensure it has the expected structure.

        #----- 3. Copy libs folder from EvoChecker to the folder containing this script (required for EvoChecker to run)
        subprocess.run(f"cp -r {LIBS_PATH} .", shell=True)
                
        # --- 4. Run Hybrid Planner ---
        print(f"[LTA-API] Running Planner for {problem.id}...")
        _run_planner(problem)
        
        print(f"[LTA-API] Running EvoChecker for {problem.id}...")
        _run_evochecker(problem)
        
        # --- 5. If successful, update status to 'completed' ---
        problem.status = "completed"
        PROBLEM_DATABASE[problem.id] = problem
        print(f"[LTA-API] Successfully completed problem {problem.id}")

    except subprocess.CalledProcessError as e:
        problem.status = "failed"
        PROBLEM_DATABASE[problem.id] = problem
        print(f"[LTA-API-ERROR] Failed to process problem {problem.id}.")
        print(f"--- STDOUT ---\n{e.stdout}")
        print(f"--- STDERR ---\n{e.stderr}")
    except Exception as e:
        problem.status = "failed"
        PROBLEM_DATABASE[problem.id] = problem
        print(f"[LTA-API-ERROR] An unexpected error occurred for problem {problem.id}: {e}")
        traceback.print_exc()
