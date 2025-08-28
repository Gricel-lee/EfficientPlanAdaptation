'''
Author: Gricel Vazquez
Last reviewed: Feb 4, 2025

This script is used to run the entire process of generating PRISM/Evochecker files from JSON files.
It processes each JSON file in the input directory and generates the corresponding PRISM/Evochecker files.
No other .json files should be present in the input directory.
'''
import sys
import arch.aux.json2pddl as json2pddl

import arch.aux.pddlplanner as pddlplanner
# import arch.aux.pddlplannercopy as pddlplanner
import arch.aux.plan2PMCfile as plan2PMCfile
import arch.aux.auxiliary as auxiliary
import os
import time
from arch.config.config import *

def main(problem_id, json_file_path):
    '''
    Args:
        problem_id: Unique identifier for the planning problem.
        json_file_path: The path to the JSON file to be processed.
    Returns:
        None
    '''
    # Process each JSON file in the input directory
    print("\n----Starting task planning...")
    
    # Set variables
    name_file = os.path.splitext(os.path.basename(json_file_path))[0] # get file name without extension
    INPUT_DIR = os.path.dirname(json_file_path)
    output_dir = os.path.join(INPUT_DIR, f"output_{name_file}_{problem_id}") # save to global variable
    PROBLEM_OUTPUT_DIR[problem_id] = output_dir

    # Global variables
    verbose = VERBOSE
    population = POPULATION_SIZE
    max_evals = MAX_EVALUATIONS
    num_runs = NUM_TIMED_RUNS

    if not os.path.isfile(json_file_path):
        raise FileNotFoundError(f"File not found: {json_file_path}")
        # sys.exit(1)
    else:
        if verbose: print(f"[RunPlanner] Processing file: {json_file_path}")
    
    print(f"[RunPlanner] Creating output folder: {output_dir}")
    auxiliary.createFolder(output_dir)
    
    # Create log file for elapsed time
    time_log_file = output_dir + "/" + f"time-log-planner-{num_runs}runs.txt"
    auxiliary.createFile(time_log_file) 
    
    
    for run in range(1, num_runs+1):
        start_time = time.time()
                        
        # PDDL file names
        file_domain = FILE_DOMAIN_PDDL
        file_problem = FILE_PROBLEM_PDDL

        try:
            
            # Generate PDDL files
            if verbose: print(f"[RunPlanner]: Generating PDDL files for {name_file}-{run}...")
            json_data = json2pddl.main(json_file_path, output_dir, file_domain, file_problem)
            
            # Import PDDL problem
            print(f"[RunPlanner]: Importing PDDL problem for {name_file}-{run} from {output_dir}")
            problem = pddlplanner.importPDDLproblem(output_dir, file_domain, file_problem)
            
            # Run PDDL planner
            print(f"[RunPlanner]: Running PDDL planner for {name_file}-{run}...")
            plan = pddlplanner.runPlanner(problem, output_dir)
            
            print(plan)
            
            # Generate PRISM/Evochecker file from PDDL plan with indexed filenames
            print(f"[RunPlanner]: Generating Evochecker files for {name_file}-{run}...")
            evo_config_file = plan2PMCfile.createPRISMfile(output_dir, name_file, plan, json_data, evoChecker=True, population=population, max_evals=max_evals)
            print(f"[RunPlanner]: Generating PRISM file for {name_file}-{run}...")
            evo_config_file = plan2PMCfile.createPRISMfile(output_dir, name_file, plan, json_data, evoChecker=False, population=population, max_evals=max_evals)

            # Log with elapsed time (for the current run)
            end_time = time.time()
            elapsed_time = end_time - start_time
            print(f"[RunPlanner]: Elapsed time for {name_file}-{run}: {elapsed_time:.2f} seconds")

            with open(time_log_file, 'a') as f:
                f.write(f"[RunPlanner]: Time elapsed for {name_file}-{run}: {elapsed_time:.2f} seconds\n")

        except FileNotFoundError as e:
            print(f"File not found: {e}")
            sys.exit(1)
        except Exception as e:
            print(f"Error processing {json_file_path} on Run {run}: {e}")
            sys.exit(1)
    