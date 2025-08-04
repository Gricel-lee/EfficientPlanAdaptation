import configparser
import os

# Create a parser instance
config = configparser.ConfigParser()
print("[LTA-API] Loading configuration from config.ini")

# Read the configuration file
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
# EvoChecker
JAR_FILE = os.path.join(HP_PATH, "apps/EvoChecker/EvoChecker-1.1.0.jar")
LIBS_PATH = os.path.join(HP_PATH, "apps/EvoChecker/libs")
LD_LIBRARY_PATH = f"{LIBS_PATH}/runtime"
print(f"[LTA-API] Loaded configuration: HP_PATH={HP_PATH}, EVO={EVO}, NUM_TIMED_RUNS={NUM_TIMED_RUNS}, VERBOSE={VERBOSE}, POPULATION_SIZE={POPULATION_SIZE}, MAX_EVALUATIONS={MAX_EVALUATIONS}")

PYTHON_EXECUTABLE = os.path.join(HP_PATH, "prj-venv/bin/python3")


# # Get the directory of the current file (config.py)
# base_dir = os.path.dirname(os.path.abspath(__file__))
# config_path = os.path.join(base_dir, 'config.ini')

# print(f"[LTA-API] Loading configuration from: {config_path}")
# config.read(config_path)

# # --- PATHS Section ---
# # Read the base path and make it an absolute path
# HP_PATH = os.path.abspath(config['PATHS']['HP_PATH'])
# PYTHON_VENV_PATH = os.path.join(HP_PATH, config['PATHS']['PYTHON_VENV_PATH'])
# PLANNER_SCRIPT = os.path.join(HP_PATH, config['PATHS']['PLANNER_SCRIPT'])
# EVO_SCRIPT = os.path.join(HP_PATH, config['PATHS']['EVO_SCRIPT'])
# EVOCHECKER_JAR = os.path.join(HP_PATH, config['PATHS']['EVOCHECKER_JAR'])

# # --- PARAMETERS Section ---
# EVO = config.getboolean('PARAMETERS', 'EVO', fallback=True)
# NUM_TIMED_RUNS = config.getint('PARAMETERS', 'NUM_TIMED_RUNS', fallback=1)
# VERBOSE = config.getboolean('PARAMETERS', 'VERBOSE', fallback=True)
# POPULATION_SIZE = config.getint('PARAMETERS', 'POPULATION_SIZE', fallback=25)
# MAX_EVALUATIONS = config.getint('PARAMETERS', 'MAX_EVALUATIONS', fallback=200)

# print("[LTA-API] Configuration loaded successfully.")

