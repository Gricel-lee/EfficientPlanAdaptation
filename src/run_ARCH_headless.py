# Authors: Gricel Vazquez
# Last reviewed: Dec 3, 2025

# ==== run_ARCH_headless.py ====
# This script runs the ARCH planner in headless mode.
# It will start the virtual environment, run the planner for a specified problem, and generate PRISM/Evochecker files.
# This file is not accessed by the REST API.

# == Installation
# Set the virtual environment as in README.


# === Usage ===
# Set the paths to your problem in the main() function below.
# In your cmd, from ```<path>/EfficientPlanAdaptation/``` run: 
# ```python3 src/run_ARCH_headless.py```

# Note: If python libraries missing,
# activate the venv in the cmd: ```source src/arch/prj-venv/bin/activate```

import os
import sys

_VENV_PYTHON = os.path.join(os.path.dirname(os.path.abspath(__file__)), "arch/prj-venv/bin/python3")
if sys.executable != _VENV_PYTHON:
    os.execv(_VENV_PYTHON, [_VENV_PYTHON] + sys.argv)
 

import arch.planning.json2pddl as json2pddl
import arch.planning.pddlplanner as pddlplanner
import arch.planning.plan2PMCfile as plan2PMCfile
from arch.config.config import PROBLEM_OUTPUT_DIR, POPULATION_SIZE, MAX_EVALUATIONS, JAR_FILE, NUM_TIMED_RUNS
import arch.runEvo as runEvo
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
from arch.planningProblem.planningProblem import planning_problem


# =============== A) Main function running ARCH ===============
def main(json_file_path, output_dir_name, temperstEngineTimeout=0, one_plan_or_multiple='one'):
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
        plans_found = pddlplanner.runPlanner(fdomain, fproblem, output_dir, jsondata, timeout=temperstEngineTimeout)
    print("[run_ARCH_headless] Plans generation completed.")
    plan = plans_found[0] if plans_found else None


    # Generate PRISM/Evochecker file from PDDL plan
    if one_plan_or_multiple=='one':
        print(f"[run_ARCH_headless] Generating PRISM/Evochecker files for single plan...")
        # args = plan2PMCfile.parsePlan(plan)
        plan2PMCfile.createPRISMfile(output_dir, "plan_1", plan, jsondata, population=POPULATION_SIZE, max_evals=MAX_EVALUATIONS)
        plan2PMCfile.createPRISMfile(output_dir, "plan_1", plan, jsondata, evoChecker=True, population=POPULATION_SIZE, max_evals=MAX_EVALUATIONS)
        
    if one_plan_or_multiple=='multiple':
        print(f"[run_ARCH_headless] Generating PRISM/Evochecker files for multiple plans...")
        plans_found = pddlplanner.runPlanner(fdomain, fproblem, output_dir, timeout=temperstEngineTimeout)
        for i, plan in enumerate(plans_found):
            print(f"[run_ARCH_headless] Generating files for plan {i+1}:\n{plan}")
            
            # Add output folder
            PROBLEM_OUTPUT_DIR[output_dir_name+str(i)] = os.path.join(output_dir, f"output_plan_{i+1}")

            print(f"[run_ARCH_headless] Creating PRISM file...")
            name_file = f"plan_{i+1}"
            plan2PMCfile.createPRISMfile(PROBLEM_OUTPUT_DIR[output_dir_name+str(i)], name_file, plan, jsondata, planNumber=f"_{i+1}", population=POPULATION_SIZE, max_evals=MAX_EVALUATIONS)
            plan2PMCfile.createPRISMfile(PROBLEM_OUTPUT_DIR[output_dir_name+str(i)], name_file, plan, jsondata, evoChecker=True, planNumber=f"_{i+1}", population=POPULATION_SIZE, max_evals=MAX_EVALUATIONS)
    
    # Run EvoChecker
    print(f"[run_ARCH_headless] Running EvoChecker...")
    
    if one_plan_or_multiple=='one':
        _run_evochecker(
            problem_id=output_dir_name + "1",
            json_file_path=json_file_path)
    elif one_plan_or_multiple=='multiple':
        for i in range(len(plans_found)):
            _run_evochecker(problem_id=output_dir_name+str(i),
                            json_file_path=json_file_path,
                            evo_config_file=f"evo_config_{i+1}.properties"
                            )




def _run_evochecker(problem_id, json_file_path, evo_config_file="evo_config.properties"):
    runEvo.main(problem_id, json_file_path, evo_jar_file=JAR_FILE, evo_config_file=evo_config_file)



def _get_files_2plot():
    """ Function to plot results after running EvoChecker. """
    output_dir =  os.path.join(os.path.dirname(json_file_path), output_dir_name)
    
    # Get files that end in "_Front"
    files = []
    for root, dirs, filenames in os.walk(output_dir):
        for filename in filenames:
            if filename.endswith("_Front"):
                files.append(os.path.join(root, filename))
    
    print(f"Files to plot: {files}")
    return files



# =============== B) Generate LaTeX table with Pareto metrics using pymoo ===============

import numpy as np
from pymoo.indicators.hv import HV
from pymoo.indicators.gd import GD
from pymoo.indicators.igd import IGD

def generate_latex_table_pymoo():
    files = _get_files_2plot()

    # -----------------------------------------
    # Helper to read (x, y) points from file
    # -----------------------------------------
    def read_points(path):
        pts = []
        with open(path, "r") as f:
            lines = f.readlines()[1:]  # skip header
            for line in lines:
                parts = line.strip().split()
                if len(parts) == 2:
                    pts.append(list(map(float, parts)))
        return np.array(pts)

    # Load all plans
    plan_points = [read_points(f) for f in files]

    # Merge all points
    all_points = np.vstack(plan_points)

    # ------------------------------------------------
    # Convert objectives to MINIMIZATION for pymoo
    # ------------------------------------------------
    # Our objective is: MAX X, MIN Y
    # In pymoo:
    #   maximize X -> minimize -X
    #   minimize Y -> minimize Y
    def convert_to_minimization(pts):
        return np.column_stack([-pts[:, 0], pts[:, 1]])

    plan_objs = [convert_to_minimization(p) for p in plan_points]
    all_objs = convert_to_minimization(all_points)

    # ------------------------------------------------
    # Compute Global Pareto Front
    # ------------------------------------------------
    def is_pareto(point, others):
        return not np.any(np.all(others <= point, axis=1) &
                    np.any(others < point, axis=1))

    mask = np.array([is_pareto(p, all_objs) for p in all_objs])
    global_pf = all_objs[mask]

    # ------------------------------------------------
    # Reference point for HV (worst values)
    # ------------------------------------------------
    ref_point = np.max(all_objs, axis=0)

    # pymoo indicators
    hv_indicator = HV(ref_point=ref_point)

    # ------------------------------------------------
    # Compute metrics for each plan
    # ------------------------------------------------
    results = []

    for i, pts in enumerate(plan_objs):

        # local PF for plan
        mask_i = np.array([is_pareto(p, pts) for p in pts])
        plan_pf = pts[mask_i]

        hv = hv_indicator(plan_pf)
        gd = GD(global_pf)(plan_pf)
        igd = IGD(global_pf)(plan_pf)

        results.append((f"plan {i+1}", hv, gd, igd))

    # ------------------------------------------------
    # Metrics for ALL plans combined (PF = global PF)
    # ------------------------------------------------
    hv_all = hv_indicator(global_pf)
    gd_all = 0.0
    igd_all = 0.0

    results.append(("all plans", hv_all, gd_all, igd_all))

    # ------------------------------------------------
    # Build LaTeX table
    # ------------------------------------------------
    latex = []
    latex.append(r"\begin{table}[h!]")
    latex.append(r"\centering")
    latex.append(r"\begin{tabular}{lccc}")
    latex.append(r"\hline")
    latex.append(r"Plan & HV & GD & IGD \\")
    latex.append(r"\hline")

    for plan, hv, gd, igd in results:
        latex.append(f"{plan} & {hv:.6f} & {gd:.6f} & {igd:.6f} \\\\")

    latex.append(r"\hline")
    latex.append(r"\end{tabular}")
    latex.append(r"\caption{Pareto metrics}")
    latex.append(r"\end{table}")

    latex_code = "\n".join(latex)
    print(latex_code)
    
    # save
    output_dir =  os.path.join(os.path.dirname(json_file_path), output_dir_name)
    latex_file = os.path.join(output_dir, "PFmetrics_table.tex")
    print(f"Saving LaTeX table to {latex_file}")
    with open(latex_file, "w") as f:
        f.write(latex_code)
    
    return latex_code




if __name__ == "__main__":

    # === Problem to test ===
    json_file_path = "./assets/planningProblem/Test-examples/example2locs.json"
    output_dir_name = "output_test_example2locs"
    temperstEngineTimeout = 0   # 0 = ENHSP only (no TEMPest); set >0 for multiple plans
    one_plan_or_multiple = "one"
    main(json_file_path, output_dir_name, temperstEngineTimeout, one_plan_or_multiple)

    # === Experiments ===
    # === In assets/paper-TAAS26-Multiplan/ subfolders, a .py file to run each experiment separately is provided. ===
    
    
    # NOTE: To run multiple experiments, e.g., for statistical analysis: Change in  arch.config.config NUM_TIMED_RUNS = 20#config.getint('PARAMS', 'NUM_TIMED_RUNS', fallback=1)
    
    # >>> Set variables here <<<
    
    # Experiment RQ3
    # json_file_path ="../assets/paper-TAAS26-Multiplan/RQ3/Construction_multiplan/data_input_output/construction_input.json"
    # output_dir_name = "output_data_RQ3"
    # temperstEngineTimeout= 2.5 # seconds
    # one_plan_or_multiple='multiple'  # 'one' or 'multiple' plans
    # generate_latex_table_pymoo()
    
    # Experiment RQ4 
    # dirr = "../assets/paper-TAAS26-Multiplan/RQ4/1Non-probab-Multi-plan/JSONs_input/"
    # exp = [1,2,3,4,5,6,7,8,9,10]
    # for exp in exp:
    #     #print this path
    #     import sys
    #     print(f"Processing experiment {exp} in directory {dirr}")
    #     for json_file in os.listdir(dirr):
    #         if json_file.endswith(".json"):
    #             print(f"Running for file: {json_file}")
    #             json_file_path = os.path.join(dirr, json_file)
    #             output_dir_name = f"exp{exp}_output_data_" + os.path.splitext(json_file)[0]
    #             temperstEngineTimeout= 20000 # seconds
    #             one_plan_or_multiple='multiple'
    #             print(f"Running ARCH headless  {output_dir_name}")
    #             main(json_file_path, output_dir_name, temperstEngineTimeout, one_plan_or_multiple)
    
