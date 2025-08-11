import configparser
import os

# ----- Read the configuration file config.ini------
print("[LTA-API] Loading configuration from config.ini")

# Create a parser instance
config = configparser.ConfigParser()
config.read('config.ini')

# Read paths and variables from the config file
HP_PATH =  os.path.abspath(config['PATHS']['HP_PATH'])
# @depricated INPUT_DIR = Input dir is now instantiated from the fastapi json file received
PYTHON_SCRIPT_TP = os.path.join(HP_PATH, "runPlanner.py")
PYTHON_SCRIPT_EVO = os.path.join(HP_PATH, "runEvo.py")
EVO = config.getboolean('PARAMS', 'EVO', fallback=True)
# Number of times to run planner and EvoChecker - used to get execution times
NUM_TIMED_RUNS = config.getint('PARAMS', 'NUM_TIMED_RUNS', fallback=1)
VERBOSE = config.getboolean('PARAMS', 'VERBOSE', fallback=True)
POPULATION_SIZE = config.getint('PARAMS', 'POPULATION_SIZE')
MAX_EVALUATIONS = config.getint('PARAMS', 'MAX_EVALUATIONS')
# Python virtual environment
SOURCE = os.path.join(HP_PATH, "prj-venv/bin/activate")
JAR_FILE = os.path.join(HP_PATH, "apps/EvoChecker/EvoChecker-1.1.0.jar")
LIBS_PATH = os.path.join(HP_PATH, "apps/EvoChecker/libs")
LD_LIBRARY_PATH = f"{LIBS_PATH}/runtime"
print(f"[LTA-API] Loaded configuration: HP_PATH={HP_PATH}, EVO={EVO}, NUM_TIMED_RUNS={NUM_TIMED_RUNS}, VERBOSE={VERBOSE}, POPULATION_SIZE={POPULATION_SIZE}, MAX_EVALUATIONS={MAX_EVALUATIONS}")

PYTHON_EXECUTABLE = os.path.join(HP_PATH, "prj-venv/bin/python3")