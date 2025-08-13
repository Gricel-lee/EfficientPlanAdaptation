#!/bin/bash

#---- This script runs the hybrid planner.
# --- First, set variables in config.ini file
#---- Note: Remember to make this file executable by running:
# chmod +x run_task.sh
#---- Note: If evochecker stops in iterations, restart terminal and any IDEs ----
#---- Note: All .json files in INPUT_DIR must be planning problems
#---- Note: No folder called "data" must be present from which this .sh file is called (EvoChecker creates one and it will be deleted)
#---- Note: No folder called "libs" must be present. A libs folder will be created. It contains the necessary libraries for EvoChecker.

# After running this script, the FastAPI server will be running at http://localhost:8001
# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Make sure to run this script with the LTA argument: sharp or arch
echo $1

# 1 Read HP_PATH from config.ini
HP_PATH=$(grep '^HP_PATH' "$SCRIPT_DIR/config.ini" | cut -d'=' -f2- | xargs)
echo "HP_PATH is: $HP_PATH"

# 2 Run Planner
# ----------2.1 Run ARCH planner
if [ "$1" == "arch" ]; then

    LIBS_PATH=$HP_PATH"/apps/EvoChecker/libs"
    # Python virtual environment
    SOURCE=$HP_PATH"/prj-venv/bin/activate"

    #----- Copy libs folder from EvoChecker to the folder containing this script
    cp -r $LIBS_PATH .

    #----- Activate python virtual environment
    source $SOURCE

    #----- Run FastAPI server
    echo "Running FastAPI server for Hybrid Planning..."

    echo "Running main_arch.py on port 8001"
    fastapi dev main_arch.py --port 8001

# ---------- or 2.2 Run SHARP planner
elif [ "$1" == "sharp" ]; then
    echo "Running main_sharp.py on port 8001"
    fastapi dev main_sharp.py --port 8001

# ---------- else
else
    echo "Invalid argument. Use 'sharp' or 'arch'."
    exit 1
fi
