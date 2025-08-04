from typing import Dict
import os
import subprocess
from restapi.model import Problem
from config.config import *
import traceback
import runPlanner
import runEvo

def _check_json_exists(problem_id: str, json_path: str) -> bool:
    exists = os.path.exists(json_path)
    if not exists:
        print(f"[ERROR-LTA-API] JSON file for problem {problem_id} does not exist at {json_path}.")
    return exists

def _set_status(problem: Problem, status: str, PROBLEM_DATABASE: Dict[str, Problem]):
    problem.status = status
    PROBLEM_DATABASE[problem.id] = problem
    print(f"[LTA-API] Updated status for problem {problem.id} to '{status}'.")

def _run_planner(problem: Problem):
    INPUT_DIR = os.path.dirname(problem.json_file)
    runPlanner.main(
        input_dir=INPUT_DIR,
        libs_dir=LD_LIBRARY_PATH,
        evo=EVO,
        num_runs=NUM_TIMED_RUNS,
        verbose=VERBOSE,
        population=POPULATION_SIZE,
        max_evals=MAX_EVALUATIONS
    )
    # Run the planner script using the temp directory
    # subprocess.run(
    #     [PYTHON_EXECUTABLE, PYTHON_SCRIPT_TP, INPUT_DIR, EVO, NUM_TIMED_RUNS, VERBOSE, POPULATION_SIZE, MAX_EVALUATIONS],
    #     check=True,  # Raises CalledProcessError if the script returns a non-zero exit code
    #     capture_output=True, text=True # Capture output for logging
    # )

def _run_evo_checker(problem: Problem):
    INPUT_DIR = os.path.dirname(problem.json_file)
    runEvo.main(
        input_dir=INPUT_DIR,
        evo_jar_file=JAR_FILE,
        evo=EVO,
        num_runs=NUM_TIMED_RUNS,
        verbose=VERBOSE
    )
    
    # # Run the EvoChecker script
    # subprocess.run(
    #     [PYTHON_EXECUTABLE, PYTHON_SCRIPT_EVO, INPUT_DIR, JAR_FILE, "True", "1", "True"],
    #     check=True,
    #     capture_output=True, text=True
    # ) 

def run_hybrid_planner(problem: Problem, PROBLEM_DATABASE: Dict[str, Problem]):
    """
    Run the hybrid planner in the background through FastAPI.
    """    
    try:
        # --- 1. Update status to 'processing'
        problem.status = "processing"
        print(f"[LTA-API] Started processing for problem {problem.id}")
        
        # --- 2. Checks
        if _check_json_exists(problem.id, problem.json_file) is False:
            _set_status(problem, "failed", PROBLEM_DATABASE)
            return

        #----- 3. Copy libs folder from EvoChecker to the folder containing this script
        subprocess.run(f"cp -r {LIBS_PATH} .", shell=True)
                
        # --- 4. Run Hybrid Planner ---
        print(f"[LTA-API] Running Planner for {problem.id}...")
        _run_planner(problem)
        
        print(f"[LTA-API] Running EvoChecker for {problem.id}...")
        _run_evo_checker(problem)
        
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
