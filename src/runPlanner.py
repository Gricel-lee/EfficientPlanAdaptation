'''
Author: Gricel Vazquez
Last reviewed: Feb 4, 2025

This script is used to run the entire process of generating PRISM/Evochecker files from JSON files.
It processes each JSON file in the input directory and generates the corresponding PRISM/Evochecker files.
No other .json files should be present in the input directory.
'''
import sys
import aux.json2pddl as json2pddl
import aux.pddlplanner as pddlplanner
import aux.plan2PMCfile as plan2PMCfile
import aux.auxiliary as auxiliary
import os
import time

def main(input_dir, libs_dir, evo=True, num_runs=1, verbose=True, population=10, max_evals=100):
    '''
    Args:
        input_dir: The directory containing the .json files to be processed. 
        libs_dir: EvoChecker libraries.
        evo: A boolean flag to determine whether to generate Evochecker files (True) or PRISM files (False).
        num_runs: Number of runs to get different execution times (set to 1 if only one run required). In paper, for RQ1 and RQ3 n=31.
        verbose: A boolean flag to determine whether to print additional information.
    Returns:
        None
    
    No other .json files should be present in the input directory.
    
    '''
    
    # Process each JSON file in the input directory
    for json_file in os.listdir(input_dir):
        if json_file.endswith(".json"):
            print("\n----Starting task planning...")
            
            # Get file name without extension
            name_file = os.path.splitext(json_file)[0]
            
            # Get full path
            json_file_path = os.path.join(input_dir, json_file);
            
            if not os.path.isfile(json_file_path):
                raise FileNotFoundError(f"File not found: {json_file_path}")
                sys.exit(1)
            else:
                if verbose: print(f"Processing file: {json_file_path}")
                
            # Create output directory - indexed by file name and run number
            output_dir = os.path.join(os.path.dirname(json_file_path), f"data_{name_file}")
            print(f"[{name_file}] Creating output data folder: {output_dir}")
            auxiliary.createFolder(output_dir)
    
            # Create log file for elapsed time
            time_log_file = output_dir + "/" + f"time-log-planner-{num_runs}runs.txt"
            auxiliary.createFile(time_log_file) 
                
            
            for run in range(1, num_runs+1):
                start_time = time.time()
                                
                # PDDL file names
                file_domain = 'cphs_domain.pddl'
                file_problem = 'cphs_problem.pddl'
                
                try:
                    
                    # Generate PDDL files
                    if verbose: print(f"[{name_file}-{run}]: Generating PDDL files...")
                    json_data = json2pddl.main(json_file_path, output_dir, file_domain, file_problem)
                    
                    # Import PDDL problem
                    print(f"[{name_file}-{run}]: Importing PDDL problem from {output_dir}")
                    problem = pddlplanner.importPDDLproblem(output_dir, file_domain, file_problem)
                    
                    # Run PDDL planner
                    print(f"[{name_file}-{run}]: Running PDDL planner...")
                    plan = pddlplanner.runPlanner(problem, output_dir)
                    
                    # Generate PRISM/Evochecker file from PDDL plan with indexed filenames
                    print(f"[{name_file}-{run}]: Generating PRISM/Evochecker file...")
                    evo_config_file = plan2PMCfile.createPRISMfile(output_dir, name_file, plan, json_data, libs_dir, evoChecker=evo, population=population, max_evals=max_evals)
                    
                    # Log with elapsed time (for the current run)
                    end_time = time.time()
                    elapsed_time = end_time - start_time
                    print(f"[{name_file}-{run}] Elapsed time: {elapsed_time:.2f} seconds")
                    
                    with open(time_log_file, 'a') as f:
                        f.write(f"[{name_file}-{run}] Time elapsed: {elapsed_time:.2f} seconds\n")
                    
                except FileNotFoundError as e:
                    print(f"File not found: {e}")
                    sys.exit(1)
                except Exception as e:
                    print(f"Error processing {json_file} on Run {run}: {e}")
                    sys.exit(1)


if __name__ == "__main__":
    '''
    Usage: This python script is called programatically through the .sh file
    '''
    if len(sys.argv) != 8:
        print("Usage: python run.py <input_dir> <libs_dir> <evo> <num_runs> <verbose> <population> <max_evals>")
        #sys.exit(1)
        # Test
        path = "/home/gnvf500/Gricel-Documents/GithubGris/EfficientPlanAdaptation/src"
        input_dir = path + "/Problems/Agricultural"
        libs_dir = path + "/apps/EvoChecker/libs/runtime"
        evo = True
        num_runs = 1
        verbose = False
        population = 10
        max_evals = 100
        
    else:
        input_dir = sys.argv[1]
        libs_dir = sys.argv[2]
        evo = sys.argv[3]
        num_runs = int(sys.argv[4])
        verbose = sys.argv[5]
        population = sys.argv[6]
        max_evals = sys.argv[7]
    
    main(input_dir, libs_dir, evo, num_runs, verbose, population, max_evals)
    
    print("\n\n----Task planning completed.")
    