import sys
import aux.json2pddl as json2pddl
import aux.pddlplanner as pddlplanner
import aux.plan2PMCfile as plan2PMCfile
import aux.auxiliary as auxiliary
import os
import subprocess
import time

def main(input_dir, evo_jar_file, evo=True, num_runs=1, verbose=True):
    '''
    Args:
        input_dir: The directory containing the .json files to be processed. 
        evo: A boolean flag to determine whether to generate Evochecker files (True) or PRISM files (False).
            
    Returns:
        None
    
    No other .json files should be present in the input directory.
    
    '''
    # Process each JSON file in the input directory
    for json_file in os.listdir(input_dir):
        if json_file.endswith(".json"):
            print("\n----Starting EvoChecker generation...")
            
            # Get file name without extension
            name_file = os.path.splitext(json_file)[0]
            
            # Get full path
            json_file_path = os.path.join(input_dir, json_file);
            
            # Get output folder
            output_dir = os.path.join(os.path.dirname(json_file_path), f"data_{name_file}")
                        
            # Get config file
            evo_config_file = os.path.join(output_dir, "evo_config.properties")
            print(f"[{name_file}] Config EvoChecker file: {evo_config_file}")
            
            # Create log file for elapsed time
            time_log_file = output_dir + "/" + f"time-log-evochecker-{num_runs}runs.txt"
            auxiliary.createFile(time_log_file) 
            
            for run in range(1, num_runs+1):
                start_time = time.time()
                
                # Run EvoChecker
                try:
                    # from terminal: java -jar EvoChecker.jar -c evo_config.properties
                    # os.system(f"java -jar {evo_jar_file} {evo_config_file}")
                    
                    # Command that runs the Java program
                    command = f"java -jar {evo_jar_file} {evo_config_file}"

                    # Run the command and continue, even if it fails
                    os.system(f"{command} || true")

                except Exception as e:
                    print(f"Error: {e}")
                
                
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