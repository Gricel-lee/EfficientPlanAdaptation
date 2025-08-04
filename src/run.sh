#!/bin/bash

#---- This script runs the hybrid planner.
# It first generates a plan and its EvoChecker file
# Then it runs EvoChecker to generate multiple possible uncertainty-augmented plans
# Json folder in set in the INPUT_DIR variable
# Results are stored in the "data_{name of json file}" folder inside the INPUT_DIR folder

#---- Note: Remember to make this file executable by running:
# chmod +x run_task.sh
#---- Note: If EvoChecker stops during iterations, restart terminal and any IDEs ----
#---- Note: All .json files in INPUT_DIR must be planning problems
#---- Note: No folder called "data" must be present from which this .sh file is called (EvoChecker creates one and it will be deleted)
#---- Note: Nor folder called "libs" must be present. A libs folder will be created. It contains the necessary libraries for EvoChecker.

#---- Set variables (change as needed) ----
HP_PATH="/home/gnvf500/Gricel-Documents/GithubGris/EfficientPlanAdaptation/src"
INPUT_DIR=$HP_PATH"/Problems/Agricultural"
PYTHON_SCRIPT_TP=$HP_PATH"/runPlanner.py"
PYTHON_SCRIPT_EVO=$HP_PATH"/runEvo.py"
EVO="True"
# Number of times to run planner and EvoChecker - used to get execution times
NUM_TIMED_RUNS=1
POPULATION_SIZE=25
MAX_EVALUATIONS=200
VERBOSE="True"
# Python virtual environment
SOURCE=$HP_PATH"/prj-venv/bin/activate"
# EvoChecker
JAR_FILE=$HP_PATH"/apps/EvoChecker/EvoChecker-1.1.0.jar"
LIBS_PATH=$HP_PATH"/apps/EvoChecker/libs"
#-----

LD_LIBRARY_PATH=$LIBS_PATH"/runtime"

# Print variables
echo "[SH] Input directory: $INPUT_DIR"
echo "[SH] Output file (EvoChecker file->True, Prism file->False): $EVO"
echo "[SH] Number of timed runs: $NUM_TIMED_RUNS"
echo "[SH] Verbose: $VERBOSE"

#----- Copy libs folder from EvoChecker to the folder containing this script
cp -r $LIBS_PATH .

# Activate python virtual environment
source $SOURCE

# Run python command  #python or python3
echo "[SH] $PYTHON_SCRIPT_TP" "$INPUT_DIR" "$LD_LIBRARY_PATH" "$EVO" "$NUM_TIMED_RUNS" "$VERBOSE" "$POPULATION_SIZE" "$MAX_EVALUATIONS" # print
python3 "$PYTHON_SCRIPT_TP" "$INPUT_DIR" "$LD_LIBRARY_PATH" "$EVO" "$NUM_TIMED_RUNS" "$VERBOSE" "$POPULATION_SIZE" "$MAX_EVALUATIONS" # run

# Wait for the Python script to complete
echo "[SH] Python planning script completed."

# Deactivate python virtual environment
deactivate

#Set environmental variable (check EvoChecker documentation. OSX: DYLD_LIBRARY_PATH = libs/runtime *NIX: LD_LIBRARY_PATH = libs/runtime)
#Linuxs
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH
echo "[SH] LD_LIBRARY_PATH is: $LD_LIBRARY_PATH"

#OSX
#export DYLD_LIBRARY_PATH=$LD_LIBRARY_PATH
# echo "[SH] DYLD_LIBRARY_PATH is: $LD_LIBRARY_PATH"

# Run EvoChecker
echo "[SH] $PYTHON_SCRIPT_EVO" "$INPUT_DIR" "$JAR_FILE" "$EVO" "$NUM_TIMED_RUNS" "$VERBOSE" 
python3 "$PYTHON_SCRIPT_EVO" "$INPUT_DIR" "$JAR_FILE" "$EVO" "$NUM_TIMED_RUNS" "$VERBOSE"


echo [SH] "Hybrid planner completed!"