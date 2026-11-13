#!/bin/bash

#---- This script installs the ARCH hybrid planner (arch_plan package) and everything it needs.
#---- It only installs. To run the planner, open run_planner.ipynb (from Python) or run_planner_ui.ipynb (web app).
# Make this file executable by running:
# chmod +x run.sh
# It can be run again at any time: steps that are already done are skipped.

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Folder of the third-party tools (TemPEST, EvoChecker)
APPS_DIR="$SCRIPT_DIR/apps"

#----- 1 Check Java 17+ (needed by EvoChecker)
JAVA_VERSION=$(java -version 2>&1 | awk -F[\"._] 'NR==1{print $2}')
if [ -z "$JAVA_VERSION" ] || [ "$JAVA_VERSION" -lt 17 ] 2>/dev/null; then
    echo "Java 17+ not found (found: ${JAVA_VERSION:-none}). Installing openjdk-17-jre..."
    sudo apt-get update -qq && sudo apt-get install -y openjdk-17-jre
    sudo update-alternatives --set java /usr/lib/jvm/java-17-openjdk-amd64/bin/java 2>/dev/null || true
fi
echo "Java version: $(java -version 2>&1 | head -1)"

#----- 2 Python virtual environment
VENV_DIR="$SCRIPT_DIR/.venv"
VENV_PYTHON="$VENV_DIR/bin/python"

#----- Create the python virtual environment if it does not exist
if [ ! -x "$VENV_PYTHON" ]; then
    echo "No virtual environment found. Creating $VENV_DIR ..."
    python3 -m venv "$VENV_DIR" || { echo "ERROR: could not create $VENV_DIR"; exit 1; }
fi

#----- Install TemPEST first (it pulls the PySMT version it needs), unless already installed
if ! "$VENV_PYTHON" -c "import tempest" 2>/dev/null; then
    "$VENV_PYTHON" -m pip install "$APPS_DIR/tempest" || { echo "ERROR: TemPEST installation failed."; exit 1; }
fi

#----- ** Install ARCH (using pip configured through pyproject.toml), plus the optional notebook group defined in .toml (for Jupyter notebook support)
"$VENV_PYTHON" -m pip install -e "$SCRIPT_DIR[notebook]" || { echo "ERROR: ARCH installation failed."; exit 1; }

#----- 3 EvoChecker
EVO_DIR="$APPS_DIR/EvoChecker"
LIBS_PATH="$EVO_DIR/libs"

#----- Download EvoChecker (evoCheckerJar branch includes the jar and the runtime libs) if missing
if [ ! -f "$EVO_DIR/EvoChecker-1.1.0.jar" ]; then
    echo "EvoChecker not found. Downloading it into $EVO_DIR ..."
    git clone --depth 1 --branch evoCheckerJar https://github.com/gerasimou/EvoChecker.git "$EVO_DIR" \
        || { echo "ERROR: could not download EvoChecker."; exit 1; }
fi

#----- Make evochecker.jar executable
chmod +x "$EVO_DIR/EvoChecker-1.1.0.jar"

#----- Copy runtime-amd64 folder (macOS libraries) to EvoChecker libs folder
if [ -d "$APPS_DIR/runtime-amd64" ]; then
    cp -r "$APPS_DIR/runtime-amd64" "$LIBS_PATH"
elif [ "$(uname)" == "Darwin" ]; then
    echo "ERROR: runtime-amd64 folder not found in $APPS_DIR/runtime-amd64"
    echo "Please ensure the folder exists before running this script."
    exit 1
fi

#----- Copy libs folder from EvoChecker to src/, the folder the planner runs from
cp -r "$LIBS_PATH" "$SCRIPT_DIR/src/"

echo ""
echo "Installation complete."
echo "To run ARCH, open run_planner.ipynb (from Python) or run_planner_ui.ipynb (web app),"
echo "and select the .venv environment as kernel."
