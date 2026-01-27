# Authors: Gricel Vazquez
# Last reviewed: Dec 3, 2025

# ==== run_SHARP_headless.py ====
# This script runs the SHARP planner in headless mode.
# This file is not accessed by the REST API, it is run directly to test the planner.
# 
# Set the paths to your problem in the main() function below.

from email import header
import arch.aux.json2pddl as json2pddl
import arch.aux.pddlplanner as pddlplanner
import arch.aux.plan2PMCfile as plan2PMCfile
import os
from arch.config.config import PROBLEM_OUTPUT_DIR, POPULATION_SIZE, MAX_EVALUATIONS, PROBLEM_OUTPUT_JSON, JAR_FILE
import arch.runEvo as runEvo
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np

# >>> Set variables here <<<
# json_file_path ="../assets/planningProblem/Test-examples/example.json"
# output_dir_name = "output_data"

json_file_path ="../assets/planningProblem/Test-examples/example6.json"
output_dir_name = "output_data_RQ2_20gen_6"

# json_file_path ="../assets/planningProblem/Test-examples/example5.json"
# output_dir_name = "output_data_RQ2_20gen_5"

temperstEngineTimeout= 10 # seconds
one_plan_or_multiple='multiple'  # 'one' or 'multiple' plans


import os
import re
import numpy as np

def extract_table_data(file_path):
    """Extract plan data from a LaTeX table file."""
    plans = {}
    with open(file_path, 'r') as f:
        content = f.read()
    # match rows like "plan 1 & 8.538508 & 0.000000 & 0.065762 \\"
    pattern = re.compile(r'(\w+\s*\d*)\s*&\s*([\d.]+)\s*&\s*([\d.]+)\s*&\s*([\d.]+)\s*\\\\')
    for match in pattern.finditer(content):
        plan = match.group(1).strip()
        hv = float(match.group(2))
        gd = float(match.group(3))
        igd = float(match.group(4))
        if plan not in plans:
            plans[plan] = {'HV': [], 'GD': [], 'IGD': []}
        plans[plan]['HV'].append(hv)
        plans[plan]['GD'].append(gd)
        plans[plan]['IGD'].append(igd)
    return plans

def combine_tables(file_list):
    combined = {}
    for file_path in file_list:
        table_data = extract_table_data(file_path)
        for plan, metrics in table_data.items():
            if plan not in combined:
                combined[plan] = {'HV': [], 'GD': [], 'IGD': []}
            combined[plan]['HV'].extend(metrics['HV'])
            combined[plan]['GD'].extend(metrics['GD'])
            combined[plan]['IGD'].extend(metrics['IGD'])
    return combined

def compute_mean_std(combined):
    result = {}
    for plan, metrics in combined.items():
        result[plan] = {}
        for metric, values in metrics.items():
            mean = np.mean(values)
            std = np.std(values, ddof=1) if len(values) > 1 else 0.0
            result[plan][metric] = (mean, std)
    return result

def generate_latex_table(result, output_file="combined_table.tex"):
    plans = sorted(result.keys(), key=lambda x: (x != "all plans", x))
    with open(output_file, 'w') as f:
        f.write("\\begin{table}[h!]\n\\centering\n\\begin{tabular}{lccc}\n\\hline\n")
        f.write("Plan & HV & GD & IGD \\\\\n\\hline\n")
        for plan in plans:
            hv, gd, igd = result[plan]['HV'], result[plan]['GD'], result[plan]['IGD']
            f.write(f"{plan} & {hv[0]:.6f} ({hv[1]:.6f}) & {gd[0]:.6f} ({gd[1]:.6f}) & {igd[0]:.6f} ({igd[1]:.6f}) \\\\\n")
        f.write("\\hline\n\\end{tabular}\n\\caption{Combined Pareto metrics (mean and std)}\n\\end{table}\n")
    print(f"Combined table written to {output_file}")

def crawl_directory(directory):
    """Recursively find all .tex files in the given directory."""
    tex_files = []
    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith(".tex"):
                tex_files.append(os.path.join(root, file))
    return tex_files

if __name__ == "__main__":
    # Replace 'path_to_directory' with the directory you want to crawl
    directory_to_crawl = "../output_data_RQ2_20gen_6"
    files = crawl_directory(directory_to_crawl)
    if not files:
        print(f"No .tex files found in {directory_to_crawl}")
    else:
        combined = combine_tables(files)
        result = compute_mean_std(combined)
        generate_latex_table(result)
