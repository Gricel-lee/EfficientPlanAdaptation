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

# 1 Read HP_PATH from config.ini
HP_PATH=$(grep '^HP_PATH' "$SCRIPT_DIR/config.ini" | cut -d'=' -f2- | xargs)
echo "HP_PATH is: $HP_PATH"

LIBS_PATH=$HP_PATH"/apps/EvoChecker/libs"
# Python virtual environment
SOURCE=$HP_PATH"/prj-venv/bin/activate"

#----- Copy libs folder from EvoChecker to the folder containing this script
cp -r $LIBS_PATH .

#----- Activate python virtual environment
source $SOURCE

#----- Run FastAPI server
echo "Running FastAPI server for Hybrid Planning..."
fastapi dev main.py --port 8001
