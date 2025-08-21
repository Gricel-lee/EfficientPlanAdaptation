import configparser
import os
from sys import platform

# ----- Read the configuration file config.ini------
# Create a parser instance
config = configparser.ConfigParser()
config.read('config.ini')

# Note: in the config.ini file
# - the section [PATHS] contains the path to the project
# - the section [PARAMS] contains required parameters

# Read paths and variables from the config file
HP_PATH =  os.path.abspath(config['PATHS']['HP_PATH'])
# @depricated INPUT_DIR = Input dir is now instantiated from the fastapi json file received
PYTHON_SCRIPT_TP = os.path.join(HP_PATH, "runPlanner.py")
PYTHON_SCRIPT_EVO = os.path.join(HP_PATH, "runEvo.py")
#@TODO: Remove this variable, as unnecessary, now saving both EvoChecker and PRISM files
EVO = config.getboolean('PARAMS', 'EVO', fallback=True)
# Number of times to run planner and EvoChecker - used to get execution times
NUM_TIMED_RUNS = config.getint('PARAMS', 'NUM_TIMED_RUNS', fallback=1)
VERBOSE = config.getboolean('PARAMS', 'VERBOSE', fallback=True)
POPULATION_SIZE = config.getint('PARAMS', 'POPULATION_SIZE')
MAX_EVALUATIONS = config.getint('PARAMS', 'MAX_EVALUATIONS')
# Python virtual environment
SOURCE = os.path.join(HP_PATH, "prj-venv/bin/activate")
JAR_FILE = os.path.join(HP_PATH, "arch/apps/EvoChecker/EvoChecker-1.1.0.jar")
LIBS_PATH = os.path.join(HP_PATH, "arch/apps/EvoChecker/libs")

# Set EvoChecker environment var
# for linux or windows
EVO_LIBRARY_PATH = f"{LIBS_PATH}/runtime"
LD_LIBRARY_PATH_OR_DYLD_LIBRARY_PATH = "LD_LIBRARY_PATH"
# for mac
if platform == "darwin":
    EVO_LIBRARY_PATH = f"{LIBS_PATH}/runtime-amd64"
    LD_LIBRARY_PATH_OR_DYLD_LIBRARY_PATH = "DYLD_LIBRARY_PATH"
    # print("[Config] Running on macOS")
    # print(f"[Config] {LD_LIBRARY_PATH}")
    # print(f"[Config] {LD_LIBRARY_PATH_OR_DYLD_LIBRARY_PATH}")

print(f"[LTA-API] Loaded configuration: HP_PATH={HP_PATH}, NUM_TIMED_RUNS={NUM_TIMED_RUNS}, VERBOSE={VERBOSE}, POPULATION_SIZE={POPULATION_SIZE}, MAX_EVALUATIONS={MAX_EVALUATIONS}")
PYTHON_EXECUTABLE = os.path.join(HP_PATH, "prj-venv/bin/python3")

# Note: Currently only NSGAII is supported
MOEA = "NSGAII"

# Stores problem ID to output directory path
PROBLEM_OUTPUT_DIR = {str: str} 

# PDDL file names
FILE_DOMAIN_PDDL = 'cphs_domain.pddl'
FILE_PROBLEM_PDDL = 'cphs_problem.pddl'