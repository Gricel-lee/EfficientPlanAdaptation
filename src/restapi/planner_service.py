# services/planner_service.py
import uuid
from datetime import datetime
from typing import Dict
import subprocess
import traceback
import os
from fastapi import HTTPException, status
import arch.config.config as config
from arch.config.config import PROBLEM_OUTPUT_DIR, MOEA, LIBS_PATH, JAR_FILE
from restapi.models import Problem, Problem2Create
from restapi.memory_db import PROBLEM_DATABASE
import arch.runPlanner as runPlanner
import arch.runEvo as runEvo

# Import config variables
print("[LTA-API] Loading configuration from config.ini")


def create_and_start_problem(problem_in: Problem2Create) -> Problem:
    problem_id = uuid.uuid4().hex
    print(f"Received {problem_in.description} with ID: {problem_id}")
    new_problem = Problem(
        id=problem_id,
        description=problem_in.description,
        json_file=problem_in.json_file,
        date_creation=datetime.now(),
        status="created"
    )
    print(f"[Service] Adding new problem with ID: {problem_id}")
    PROBLEM_DATABASE[problem_id] = new_problem
    return new_problem

# We can also move other logic here to keep the API layer clean
def get_all_problems() -> list[Problem]:
    return list(PROBLEM_DATABASE.values())

def get_problem_by_id(problem_id: str) -> Problem | None:
    p = PROBLEM_DATABASE.get(problem_id)
    if p is None:
        PROBLEM_DATABASE[problem_id].status = "failed"
        PROBLEM_DATABASE[problem_id].error_message = f"Problem with ID '{problem_id}' not found when retrieving."
        return None
    return p

def delete_problem_by_id(problem_id: str) -> bool:
    if problem_id in PROBLEM_DATABASE:
        del PROBLEM_DATABASE[problem_id]
        return True
    PROBLEM_DATABASE[problem_id].status = "failed"
    PROBLEM_DATABASE[problem_id].error_message = f"Problem with ID '{problem_id}' not found when deleting."
    return False




def _get_pareto_results_filepath(problem_id: str, set_or_front: str = "_Front") -> str:
    # TODO: TEST PROBLEM_OUTPUT_DIR[problem_id] is set correctly
    output_dir = PROBLEM_OUTPUT_DIR[problem_id]
    
    # output_dir = os.path.dirname(PROBLEM_DATABASE[problem_id].json_file)
    
    
    run = 1 # get only first run, more than one run might exist
    results_dir = os.path.join(output_dir, "dataevochecker_run" + str(run) + "/"+MOEA+"/")
    # Check if the results directory exists
    if not os.path.exists(results_dir):
        PROBLEM_DATABASE[problem_id].status = "failed"
        PROBLEM_DATABASE[problem_id].error_message = f"Results directory {results_dir} not found."
        return None
    #search for first file that ends in _FRONT or _SET
    for file in os.listdir(results_dir):
        if file.endswith(set_or_front):
            results_file = os.path.join(results_dir, file)
            break

    if not os.path.exists(results_file):
        PROBLEM_DATABASE[problem_id].status = "failed"
        PROBLEM_DATABASE[problem_id].error_message = "Results file not found. The process may not be complete or it may have failed."
        return None
    return results_file

def _parse_front_results_file(results_file: str, problem_id: str) -> dict | None:
    x_values = []
    y_values = []
    try:
        with open(results_file, "r") as file:
            lines = file.readlines()
            #if the file is empty or less than 2 lines, return error
            if not lines or len(lines) < 2:
                PROBLEM_DATABASE[problem_id].status = "failed"
                PROBLEM_DATABASE[problem_id].error_message = "Results file is empty."
                return None

            # Parse the header line
            header_line = lines[0].strip()
            # Split by tabs
            header_parts = header_line.split("\t",1)
            if len(header_parts) == 2:
                x_label, y_label = header_parts

            
            # Parse the data lines
            for line in lines[1:]:
                line = line.strip()
                if not line:
                    continue
                
                parts = line.split()
                if len(parts) == 2:
                    x_values.append(float(parts[0]))
                    y_values.append(float(parts[1]))

        return {
            "x_label": x_label,
            "y_label": y_label,
            "x_values": x_values,
            "y_values": y_values
        }
    except Exception as e:
        print(f"Error parsing results file {results_file}: {e}")
        return None


def _parse_set_results_file(results_file: str, problem_id: str) -> dict | None:
    """Parses the _SET file with labels and corresponding row values."""
    labels = []
    values = []

    try:
        with open(results_file, "r") as file:
            lines = [line for line in file.readlines() if line.strip()] # Read and remove empty lines
            if not lines or len(lines) < 2:
                # A missing SET file is not a critical error, we can proceed without it.
                print(f"Warning: SET results file '{results_file}' is empty or invalid.")
                return None

            # First non-empty line is the header
            labels = lines[0].strip().split()

            # The rest of the non-empty lines are data
            for line in lines[1:]:
                parts = line.strip().split()
                # Ensure the number of values matches the number of labels
                if len(parts) == len(labels):
                    values.append([float(p) for p in parts])
        
        # print
        # print(f"Parsed SET results from {results_file}:")
        # print(f"Labels: {labels}")
        # print(f"Values: {values}")
        
        return {
            "labels": labels,
            "values": values
        }
    except Exception as e:
        print(f"Error parsing SET results file {results_file}: {e}")
        # Return None but don't set the main problem status to failed
        return None
    

def get_results_for_problem(problem_id: str):
    """
    Fetches and combines results from both _FRONT and _SET files.
    The _FRONT data is required. The _SET data is optional supplementary info.
    """
    problem = get_problem_by_id(problem_id)
    if not problem:
        return None

    # --- Get mandatory FRONT data ---
    front_results_file = _get_pareto_results_filepath(problem_id, set_or_front="_Front")
    if not front_results_file or not os.path.exists(front_results_file):
        PROBLEM_DATABASE[problem_id].status = "failed"
        PROBLEM_DATABASE[problem_id].error_message = "Primary results file (_FRONT) not found."
        return None
    
    combined_results = _parse_front_results_file(front_results_file, problem_id)
    if not combined_results:
        # The error message would have been set inside the parsing function
        return None

    # --- Get optional SET data ---
    set_results_file = _get_pareto_results_filepath(problem_id, set_or_front="_Set")
    set_data = None
    if set_results_file and os.path.exists(set_results_file):
        set_data = _parse_set_results_file(set_results_file, problem_id)
    
    # Add set_data to the results, even if it's None
    combined_results["set_data"] = set_data

    # Final check: ensure the number of rows in SET data matches the number of points in FRONT data
    if set_data and len(combined_results["x_values"]) != len(set_data["values"]):
        print("Warning: Mismatch between number of data points in FRONT and SET files.")
        # Decide how to handle: either nullify set_data or allow it
        combined_results["set_data"] = None # Safest option is to disable tooltips if data is inconsistent
        PROBLEM_DATABASE[problem_id].status = "failed"
        PROBLEM_DATABASE[problem_id].error_message = "Mismatch between FRONT and SET data point numbers."
    return combined_results

    
# @deprecated
# def get_results_for_problem(problem_id: str):
#     problem = get_problem_by_id(problem_id)
#     if not problem:
#         return None

#     results_file = _get_front_results_filepath(problem_id)
#     if not results_file:
#         return None
    
#     # Parse the EvoChecker front results file
#     return _parse_front_results_file(results_file, problem_id)

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


