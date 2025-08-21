import sys
import arch.aux.json2pddl as json2pddl
import arch.aux.pddlplanner as pddlplanner
import arch.aux.plan2PMCfile as plan2PMCfile
import arch.aux.auxiliary as auxiliary
import os
import subprocess
import time
import arch.aux.plot as p
import traceback
from arch.config.config import * 

def main(problem_id, json_file_path, evo_jar_file):
    '''
    Args:
        problem_id: Unique identifier for the planning problem.
        json_file_path: The path to the JSON file to be processed.
        evo_jar_file: The path to the EvoChecker JAR file.
            
    Returns:
        None    
    '''
    # Set variables
    INPUT_DIR = os.path.dirname(json_file_path)
    name_file = os.path.splitext(os.path.basename(json_file_path))[0] # get file name without extension
    
    # Global variables
    output_dir = PROBLEM_OUTPUT_DIR[problem_id]
    verbose = VERBOSE
    num_runs = NUM_TIMED_RUNS
        
    # Process each JSON file in the input directory
    print("\n----Starting EvoChecker generation...")
    
    # Get config file
    evo_config_file = os.path.join(output_dir, "evo_config.properties")
    print(f"[RunEvo] Config EvoChecker file: {evo_config_file}")

    # Create log file for elapsed time
    time_log_file = output_dir + "/" + f"time-log-evochecker-{num_runs}runs.txt"
    auxiliary.createFile(time_log_file) 
    
    for run in range(1, num_runs+1):
        start_time = time.time()
        
        # Run EvoChecker
        try:
            # Command that runs the Java program
            command = (
                f"{LD_LIBRARY_PATH_OR_DYLD_LIBRARY_PATH}={EVO_LIBRARY_PATH} "
                f"java -jar {evo_jar_file} {evo_config_file}")
            
            print(f"[RunEvo] Running command: {command}")

            # Run the command and continue, even if it fails
            os.system(f"{command} || true")

        except Exception as e:
            print(f"[RunEvo] Error: {e}")
            traceback.print_exc()
        
        
        # Copy results to output folder
        dir = os.path.join(output_dir, "dataevochecker_run" + str(run))
        print("[{name_file}-{run}] Copying results to output folder: ", dir)
        os.system(f"cp -r ./data/* {dir}")
        print("[{name_file}-{run}] Done. Results saved: ", dir)
        
        # Remove ./data folder (created by EvoChecker)
        os.system("rm -r ./data")
        
        # Log with elapsed time (for the current run)
        end_time = time.time()
        elapsed_time = end_time - start_time
        print(f"[{name_file}-{run}] Elapsed time: {elapsed_time:.2f} seconds")
        
        with open(time_log_file, 'a') as f:
            f.write(f"[{name_file}-{run}] Time elapsed: {elapsed_time:.2f} seconds\n")
        
        # ----- Run for: save plot of Pareto front-----
        
        evo_file = p.get_first_file_with_suffix(os.path.join(dir,MOEA +"/"))    
        print(f"[{name_file}-{run}] Saving plot")
        p.plot_EvoChecker_pareto_front(points = p.read_points_from_Evofile(evo_file))
        p.save_plot(output_dir + '/plot.png')
    
            


# @deprecated
if __name__ == "__main__":
    '''
    Usage: This python script is called programatically through the .sh file
    '''
    if len(sys.argv) != 6:
        print("Usage: python run.py <input_dir> <evo_jar_file> <evo> <num_runs> <verbose>")
        sys.exit(1)
    
    input_dir = sys.argv[1]
    evo_jar_file = sys.argv[2]
    evo = sys.argv[3]
    num_runs = int(sys.argv[4])
    verbose = sys.argv[5]
    
    main(input_dir, evo_jar_file, evo, num_runs, verbose)
    
    print("\n\n----Uncertainty augmentation completed.")