#!/bin/bash

#---- This script runs the hybrid planner.
#---- Note: Remember to first read README in GitHub to download dependencies and create virtual environment.
# Make this file executable by running:
# chmod +x run.sh

# ---- Instructions:
# --- Set parameters in config.ini file (HP_PATH is set automatically)
#---- Note: If evochecker stops in iterations, restart terminal and any IDEs ----
#---- Note: All .json files in INPUT_DIR must be planning problems
#---- Note: No folder called "data" must be present from which this .sh file is called (EvoChecker creates one and it will be deleted)
#---- Note: No folder called "libs" must be present. A libs folder will be created. It contains the necessary libraries for EvoChecker.

# After running this script, the FastAPI server will be running at http://localhost:8001
# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Make sure to run this script with the LTA argument: arch
# or with no argument (defaults to arch)
# (this is to allow for future extensions with other modes)
MODE=${1:-arch}
echo "Running: $MODE"

# 1 Check Java 17+
JAVA_VERSION=$(java -version 2>&1 | awk -F[\"._] 'NR==1{print $2}')
if [ -z "$JAVA_VERSION" ] || [ "$JAVA_VERSION" -lt 17 ] 2>/dev/null; then
    echo "Java 17+ not found (found: ${JAVA_VERSION:-none}). Installing openjdk-17-jre..."
    sudo apt-get update -qq && sudo apt-get install -y openjdk-17-jre
    sudo update-alternatives --set java /usr/lib/jvm/java-17-openjdk-amd64/bin/java 2>/dev/null || true
fi
echo "Java version: $(java -version 2>&1 | head -1)"

# 2 Set and update HP_PATH in config.ini to the src directory
sed -i "s|HP_PATH = .*|HP_PATH = $SCRIPT_DIR/src|" "$SCRIPT_DIR/config.ini"
HP_PATH=$SCRIPT_DIR/src
echo "HP_PATH is: $HP_PATH"

# Python virtual environment
SOURCE=$HP_PATH"/arch/prj-venv/bin/activate"

#----- Activate python virtual environment
source $SOURCE
echo "source $SOURCE" 

# 3 Run Planner
# ----------2.1 Run ARCH planner
if [ "$MODE" == "arch" ]; then

    LIBS_PATH=$HP_PATH"/arch/apps/EvoChecker/libs"

    # Make evochecker.jar executable
    chmod +x "$HP_PATH/arch/apps/EvoChecker/EvoChecker-1.1.0.jar"
    
    #----- Copy runtime-amd64 folder to EvoChecker libs folder
    #try cp -r "$SCRIPT_DIR/arch/apps/runtime-amd64" "$LIBS_PATH"
    if [ -d "$HP_PATH/arch/apps/runtime-amd64" ]; then
        cp -r "$HP_PATH/arch/apps/runtime-amd64" "$LIBS_PATH"
    else
        echo "ERROR: runtime-amd64 folder not found in $HP_PATH/arch/apps/runtime-amd64"
        echo "Please ensure the folder exists before running this script."
        exit 1
    fi

    #----- Copy libs folder from EvoChecker to the folder containing this script
    
    cp -r $LIBS_PATH .

    #----- Run FastAPI server
    echo "Running FastAPI server for Hybrid Planning..."

    echo "Running main_arch.py on port 8001"
    cd "$HP_PATH" && fastapi dev main_arch.py --port 8001

# ---------- else
else
    echo "Invalid argument '$MODE'. Use 'arch' or run with no argument."
    exit 1
fi

