import configparser
import os
from sys import platform

# ----- Read the configuration file config.ini------
# Create a parser instance
config = configparser.ConfigParser()
config.read(os.path.join(os.path.dirname(os.path.abspath(__file__)), '../../../config.ini'))

# Note: in the config.ini file the section [PARAMS] contains required parameters

# Folder of the installed arch_plan package. Paths are located relative to it, so they
# do not have to be configured by hand.
PACKAGE_DIR: str = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
# @depricated INPUT_DIR = Input dir is now instantiated from the fastapi json file received
#@TODO: Remove this variable, as unnecessary, now saving both EvoChecker and PRISM files
EVO = config.getboolean('PARAMS', 'EVO', fallback=True)
# Number of times to run planner and EvoChecker - used to get execution times
NUM_TIMED_RUNS = config.getint('PARAMS', 'NUM_TIMED_RUNS', fallback=1)
VERBOSE = config.getboolean('PARAMS', 'VERBOSE', fallback=True)
POPULATION_SIZE = config.getint('PARAMS', 'POPULATION_SIZE')
MAX_EVALUATIONS = config.getint('PARAMS', 'MAX_EVALUATIONS')

# ---- EvoChecker location ----
# Name of the environment variable that sets the folder where EvoChecker is installed
EVOCHECKER_DIR_ENV_VAR: str = "ARCH_EVOCHECKER_DIR"


def get_evochecker_dir() -> str:
    """Return the folder where EvoChecker is installed.

    The folder is taken from the environment variable ARCH_EVOCHECKER_DIR if it is set.
    Otherwise it defaults to apps/EvoChecker at the root of the project, where run.sh
    downloads EvoChecker (two levels above the arch_plan package: <root>/src/arch_plan).

    Returns:
        Absolute path of the EvoChecker folder. The folder is not checked to exist,
        see check_evochecker_installed.
    """
    default_dir: str = os.path.join(PACKAGE_DIR, "..", "..", "apps", "EvoChecker")
    return os.path.abspath(os.environ.get(EVOCHECKER_DIR_ENV_VAR) or default_dir)


EVOCHECKER_DIR: str = get_evochecker_dir()
JAR_FILE: str = os.path.join(EVOCHECKER_DIR, "EvoChecker-1.1.0.jar")
LIBS_PATH: str = os.path.join(EVOCHECKER_DIR, "libs")


def check_evochecker_installed(jar_file: str = JAR_FILE) -> None:
    """Check that the EvoChecker jar file exists.

    Args:
        jar_file: Path of the EvoChecker jar file. Defaults to JAR_FILE.

    Returns:
        None.

    Raises:
        FileNotFoundError: If the jar file does not exist, explaining how to install
            EvoChecker or how to point ARCH to an existing installation.
    """
    if not os.path.isfile(jar_file):
        raise FileNotFoundError(
            f"EvoChecker not found: {jar_file} does not exist. "
            f"Install it by running run.sh from the root of the project, or set the "
            f"environment variable {EVOCHECKER_DIR_ENV_VAR} to the folder that contains "
            f"{os.path.basename(jar_file)} and its libs folder."
        )


# ---- Set EvoChecker environment var ----
# for linux or windows
EVO_LIBRARY_PATH = f"{LIBS_PATH}/runtime"
LD_LIBRARY_PATH_OR_DYLD_LIBRARY_PATH = "LD_LIBRARY_PATH"
# for mac
if platform == "darwin":
    EVO_LIBRARY_PATH = f"{LIBS_PATH}/runtime-amd64"
    LD_LIBRARY_PATH_OR_DYLD_LIBRARY_PATH = "DYLD_LIBRARY_PATH"
    print("[Config] Running on macOS")
    print(f"[Config] {EVO_LIBRARY_PATH}")
    print(f"[Config] {LD_LIBRARY_PATH_OR_DYLD_LIBRARY_PATH}")

print(f"[LTA-API] Loaded configuration: EVOCHECKER_DIR={EVOCHECKER_DIR}, NUM_TIMED_RUNS={NUM_TIMED_RUNS}, VERBOSE={VERBOSE}, POPULATION_SIZE={POPULATION_SIZE}, MAX_EVALUATIONS={MAX_EVALUATIONS}")

# ---- MOEA Algorithm ----
# Note: Currently only NSGAII is supported
MOEA = "NSGAII"


#---- Global variables (not in config)-----
# Stores problem ID to output directory path
PROBLEM_OUTPUT_DIR = {str: str} 
PROBLEM_OUTPUT_JSON = {str: str}

# Temporary path for storing problems generated from text (natural language) input
TEMP_PATH = os.path.abspath(os.path.dirname(os.path.abspath(__file__)) + "/../../../temp")

# PDDL file names
FILE_DOMAIN_PDDL = 'cphs_domain.pddl'
FILE_PROBLEM_PDDL = 'cphs_problem.pddl'