# Authors: Gricel Vazquez
# Last reviewed: Dec 3, 2025

# ==== run_SHARP_headless.py ====
# This script runs the SHARP planner in headless mode.
# This file is not accessed by the REST API, it is run directly to test the planner.
# 
# Set the paths to your problem in the main() function below.

from importlib.metadata import files
import os
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np


def _get_files_2plot(output_dir):
    """ Function to plot results after running EvoChecker. """
    # output_dir =  os.path.join(os.path.dirname(json_file_path), output_dir_name)
    
    # Get files that end in "_Front"
    files = []
    print(f"---Searching for files in: {output_dir}")
    for root, dirs, filenames in os.walk(output_dir):
        for filename in filenames:
            if filename.endswith("_Front"):
                files.append(os.path.join(root, filename))
    
    print(f"Files to plot: {files}")
    return files

def _get_files_2plot_results():
    files = {}   
    plan_folder = [
                    "output_plan_3/dataevochecker_run8", #plan1
                    "output_plan_4/dataevochecker_run3", #plan2
                    "output_plan_2/dataevochecker_run3", #plan 3
                    "output_plan_1/dataevochecker_run9",  #plan 4
                    "output_plan_5/dataevochecker_run8"] #plan 5

    for idx, folder in enumerate(plan_folder):
        print(f"Processing: {(os.path.join(output_dir_name, folder))}")
        file = _get_files_2plot(os.path.join(output_dir_name, folder))
        print(f"Files found: {file}")
        files[f"Plan{idx+1}"] = file[0]

    print(f"All files to plot: {files}")
    return files


def plot_results():
    # Get files
    files = _get_files_2plot_results()
    

    markers = ['o', 'x', '*', 's', 'd']
    colors  = ['blue', 'red', 'green', 'purple', 'orange']

    plt.figure(figsize=(14, 6))

    # Store all points across all files for Pareto analysis
    all_points = []   # list of (x, y)
    file_points = []  # list of list of points per file

    for plan_name, fpath in files.items():
        print(f"Processing file for {plan_name}: {fpath}")
        x_vals = []
        y_vals = []

        with open(fpath, "r") as f:
            lines = f.readlines()
            data_lines = lines[1:]   # skip header

            for line in data_lines:
                parts = line.strip().split()
                if len(parts) == 2:
                    x, y = map(float, parts)
                    x_vals.append(x)
                    y_vals.append(y)
                    all_points.append((x, y))

        file_points.append((x_vals, y_vals))
        #extract number regex
        import re
        i = int(re.search(r'\d+', plan_name).group())
        plt.scatter(
            x_vals, y_vals,
            marker=markers[i % len(markers)],
            color=colors[i % len(colors)],
            label=f"{plan_name}",
            s=60
        )

    # ---------------------------------------------------------
    #  Compute Pareto Front (MAX X, MIN Y)
    # ---------------------------------------------------------
    def is_pareto_optimal(point, others):
        px, py = point
        for ox, oy in others:
            # Check if (ox, oy) dominates (px, py):
            if (ox >= px and oy <= py) and (ox > px or oy < py):
                return False
        return True

    pareto_points = [p for p in all_points if is_pareto_optimal(p, all_points)]
    pareto_points = np.array(pareto_points)

    # ---------------------------------------------------------
    # Highlight Pareto points
    # ---------------------------------------------------------
    if len(pareto_points) > 0:
        plt.scatter(
            pareto_points[:,0], pareto_points[:,1],
            facecolors='none',
            edgecolors='red',
            alpha=0.7,                # makes the red faint
            s=200,
            linewidths=2,
            label="ARCH solutions"
        )

    # ---------------------------------------------------------
    # Axis labels from header of first file
    # ---------------------------------------------------------
    with open(files[list(files.keys())[0]], "r") as f:
        header = f.readline().strip()

    plt.xlabel(header.split("\t")[0])
    plt.ylabel(header.split("\t")[1])

    # plt.xticks(fontsize=12)
    # plt.yticks(fontsize=12)
    # increase font size for better readability    
    plt.rcParams['font.size'] = 20 # legend
    plt.xlabel(header.split("\t")[0], fontsize=20)
    plt.ylabel(header.split("\t")[1], fontsize=20)
    plt.xticks(fontsize=20)
    plt.yticks(fontsize=20)
    

    # plt.title("Comparison of Plans + Pareto Front (Max X, Min Y)")
    plt.legend()
    plt.grid(True)
    plt.tight_layout()
    #plt.show()
    
    # save
    output_dir =  output_dir_name
    plot_file = os.path.join(output_dir, "plans_comparison_plot.png")
    print(f"Saving plot to {plot_file}")
    plt.savefig(plot_file)
    plt.close()



import numpy as np
from pymoo.indicators.hv import HV
from pymoo.indicators.gd import GD
from pymoo.indicators.igd import IGD



if __name__ == "__main__":
    # >>>NOTE Make sure to be in /src folder when running this script <<<
    for i in range(1):
        print(i+1)
        # >>> Set variables here <<<
        output_dir_name = "../assets/planningProblem/Test-examples/output_data_RQ2_FINAL/"
        
        plot_results()
