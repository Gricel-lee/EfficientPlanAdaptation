# Authors: Gricel Vazquez
# Last reviewed: Dec 3, 2025

# ==== run_ARCH_headless.py ====
# This script runs the ARCH planner in headless mode.
# This file is not accessed by the REST API, it is run directly to test the planner.
# 
# Set the paths to your problem in the main() function below.

import arch.aux.json2pddl as json2pddl
import arch.aux.pddlplanner as pddlplanner
import arch.aux.plan2PMCfile as plan2PMCfile
import os
from arch.config.config import PROBLEM_OUTPUT_DIR, POPULATION_SIZE, MAX_EVALUATIONS, JAR_FILE, NUM_TIMED_RUNS
import arch.runEvo as runEvo
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
from arch.planningProblem.planningProblem import planning_problem

def main():
    # --- Internal parameters ---
    headless = True
    fdomain='planning_domain.pddl' 
    fproblem='planning_problem.pddl'
    output_dir =  os.path.join(os.path.dirname(json_file_path), output_dir_name)

    # ----- Extract input data into PROBLEM_SPECS -----
    planning_problem.reset()
    planning_problem.set(json_file_path=json_file_path,
                        output_dir_name=output_dir_name,
                        temperstEngineTimeout=temperstEngineTimeout,
                        one_plan_or_multiple=one_plan_or_multiple)


    # ----- Generate PDDL files from JSON -----
    print(f"[run_ARCH_headless] Generated PDDL files from {json_file_path}")
    jsondata = json2pddl.main(json_file_path, output_dir=output_dir, fdomain=fdomain, fproblem=fproblem, headless=headless)
    planning_problem.json_data = jsondata
    
    # Import PDDL problem
    problem = pddlplanner.importPDDLproblem(output_dir, fdomain, fproblem)
    # pddlplanner.printImportedPDDLproblem(problem)

    # --------- Run PDDL planner (single or multiple plans) ---------
    # Also generate PRISM/Evochecker files from PDDL plans
    if True: # one_plan_or_multiple=='multiple' or 'one'
        print(f"[run_ARCH_headless] Generating plans...")
        pddlplanner.runPlanner(fdomain, fproblem, output_dir, jsondata, timeout=temperstEngineTimeout)
    print("[run_ARCH_headless] Plans generation completed.")



if __name__ == "__main__":
    
    # FOR EACH Json in assets/paper-TAAS26-Multiplan/RQ4/2EvoCheckerTimes
    for json_file in os.listdir("../assets/paper-TAAS26-Multiplan/RQ4/2EvoCheckerTimes/"):
        if json_file.endswith(".json"):
            json_file_path = os.path.join("../assets/paper-TAAS26-Multiplan/RQ4/2EvoCheckerTimes/", json_file)
            output_dir_name = "output_data_" + os.path.splitext(json_file)[0]
            temperstEngineTimeout= 20000 # seconds
            one_plan_or_multiple='multiple'
            print(f"Running ARCH headless  {output_dir_name}")
            main()
    