from typing import List
from unified_planning.engines.results import PlanGenerationResult
import unified_planning.plans as plans
import unified_planning.plans as sequential_plan
import unified_planning.plans.sequential_plan as SequentialPlan
import unified_planning.plans.plan as Plan
import os
import sys

def get_agents_in_plan(plan:PlanGenerationResult):
    '''Get agents in plan'''
    actions: List["plans.plan.ActionInstance"] = plan.plan.actions
    plan_agents_set = set()
    for action in actions:
        action: Plan.ActionInstance
        plan_agents_set.add(action.actual_parameters[0])
    return plan_agents_set


def get_tasks_allocated_per_agent(plan:PlanGenerationResult):
    '''Get tasks allocated per agent'''
    actions: List["plans.plan.ActionInstance"] = plan.plan.actions
    # intialise dictionary
    plan_task_per_agent = dict()
    plan_agents_set = get_agents_in_plan(plan)
    for agent in plan_agents_set:
        plan_task_per_agent[agent] = []
    # add tasks to dictionary
    for action in actions:
        action: Plan.ActionInstance
        agent = action.actual_parameters[0]
        action_name = action._action.name
        if action_name == "dotask":
            task = action.actual_parameters[1]
            plan_task_per_agent[agent].append(task)
    return plan_task_per_agent

def get_actions_per_agent(plan:PlanGenerationResult):
    '''Get actions per agent'''
    actions: List["plans.plan.ActionInstance"] = plan.plan.actions
    # intialise dictionary
    plan_actions_per_agent = dict()
    plan_agents_set = get_agents_in_plan(plan)
    for agent in plan_agents_set:
        plan_actions_per_agent[agent] = []
    # add tasks to dictionary
    for action in actions:
        action: Plan.ActionInstance
        agent = action.actual_parameters[0]
        plan_actions_per_agent[agent].append(action)
    return plan_actions_per_agent


def parsePlan(plan:PlanGenerationResult):
    # Get plan data
    sequentialPlan:SequentialPlan = plan.plan
    actions: List["plans.plan.ActionInstance"] = plan.plan.actions
    environment = sequentialPlan.environment
    
    plan_agents_set = get_agents_in_plan(plan)
    plan_task_per_agent = get_tasks_allocated_per_agent(plan)
    plan_actions_per_agent = get_actions_per_agent(plan)
    
    return [plan_agents_set, plan_task_per_agent, plan_actions_per_agent]


def _get_prob(data):
    '''Get probability of success for agent and task'''
    # Add task probabilities
    prob_agent_dic = dict()
    for agent in data['agents']:
        # for each existing task
        for t in data['tasks']:
            # if agent has the task
            types = [task['type'] for task in agent['tasks']]
            if t['id'] in types:
                task = [task for task in agent['tasks'] if task['type'] == t['id']][0]
                for instance in t['instances']:
                    prob_agent_dic[(agent['id'],instance['id'])] = task['probability_of_success']
    return prob_agent_dic

def _get_retries(data):
    '''Get num of retries for agent and task'''
    # Add retries
    retry_agent_dic = dict()
    for agent in data['agents']:
        # for each existing task
        for t in data['tasks']:
            # if agent has the task
            types = [task['type'] for task in agent['tasks']]
            if t['id'] in types:
                task = [task for task in agent['tasks'] if task['type'] == t['id']][0]
                for instance in t['instances']:
                    retry_agent_dic[(agent['id'],instance['id'])] = task['number_of_retries']
    return retry_agent_dic


def _get_cost(data):
    '''Get cost for agent and task'''
    # Add cost
    cost_agent_dic = dict()
    for agent in data['agents']:
        # for each existing task
        for t in data['tasks']:
            # if agent has the task
            types = [task['type'] for task in agent['tasks']]
            if t['id'] in types:
                task = [task for task in agent['tasks'] if task['type'] == t['id']][0]
                for instance in t['instances']:
                    cost_agent_dic[(agent['id'],instance['id'])] = task['cost']
    return cost_agent_dic


def _extract_uncertainty_data(data):
    '''Extract uncertainty data from json'''
    prob_agent_dic = _get_prob(data)
    retry_agent_dic = _get_retries(data)
    cost_agent_dic = _get_cost(data)
    p_min = data['constraints']['mission_probability_of_success']
    return prob_agent_dic, retry_agent_dic, cost_agent_dic, p_min



def createPRISMfile(output_dir, name_file, plan, json_data, libs_dir, evoChecker=False, population=10, max_evals=100):
    '''
    Create EvoChecker or PRISM file from PDDL plan
        @param output_dir: output directory
        @param plan: PDDL plan generated
        @param json_data: json parsed data
        @param evoChecker: if True, create EvoChecker files
        @return: path to config.props file (only needed for EvoChecker)
    
    
    '''
    try:
        '''Generate PRISM or Evochecker files'''
        # Info from plan
        args = parsePlan(plan) # get plan data
        plan_agents_set = args[0]
        plan_task_per_agent = args[1]
        plan_actions_per_agent = args[2]
        
        # Info from json data (uncertainty relevant)
        prob_agent_dic, retry_agent_dic, cost_agent_dic, p_min = _extract_uncertainty_data(json_data)
        
        # Check the folder exists, create it if necessary
        if not os.path.exists(output_dir):
            os.makedirs(output_dir)
            print(f"[createPRISMfile] Folder '{output_dir}' created.")
        
        s_evoProps = ""  # Evochecker properties
        s = '''dtmc\n'''
        
        if not evoChecker:    
            # Formula success (completed with success)
            s += '''label "success" = '''
            for agent in plan_agents_set:
                s += f"{agent}={agent}Final & "
            s = s[:-2]; s += ";\n"
            # Formula done (completed with success or failure)
            s += '''label "done" = ('''
            for agent in plan_agents_set:
                s += f"({agent}={agent}Final | {agent}={agent}Fail) & "
            s = s[:-3]; s += ");\n\n"
        else:
            # Formula success (completed with success)
            s_evoProps += '''label "success" = '''
            for agent in plan_agents_set:
                s_evoProps += f"{agent}={agent}Final & "
            s_evoProps = s_evoProps[:-2]; s_evoProps += ";\n"
            # Formula done (completed with success or failure)
            s_evoProps += '''label "done" = ('''
            for agent in plan_agents_set:
                s_evoProps += f"({agent}={agent}Final | {agent}={agent}Fail) & "
            s_evoProps = s_evoProps[:-3]; s_evoProps += ");\n\n"
        
        # Max retries for each agent, for each task allocated
        for agent in plan_task_per_agent.keys():
            for task in plan_task_per_agent[agent]:
                if evoChecker:
                    retries = retry_agent_dic[(str(agent), str(task))]
                    s += f"evolve int {agent}_maxRetry_{task} [1..{retries}];\n"
                else:
                    s += f"const {agent}_maxRetry_{task};\n"
        s += "\n"

        # Agent probabilities
        for agent in plan_task_per_agent.keys():
            for task in plan_task_per_agent[agent]:
                prob = prob_agent_dic[(str(agent), str(task))]
                s += f"const double p_{agent}_{task}={prob};\n"
        
        # Final states
        for agent in plan_agents_set:
            n_agent_state = len(plan_actions_per_agent[agent]) + 1
            s += f"const int {agent}Final = {n_agent_state-1};\n"
            s += f"const int {agent}Fail = {n_agent_state};\n"
            
        s += "\n"

        # Agent modules
        for agent in plan_agents_set:
            s += f"module _{agent}\n"
            # State variables
            s += f"  {agent} : [0..{len(plan_actions_per_agent[agent]) + 2}];\n"
            # State variable for tracking retries
            for task in plan_task_per_agent[agent]:
                s += f"  {agent}retry_{task} : [0..{agent}_maxRetry_{task}] init 0;\n"
            s += "\n"
            
            # Transitions
            n_trans = 0
            for action in plan_actions_per_agent[agent]:
                if action._action.name == "move":
                    loc = str(action.actual_parameters[2])
                    s += f"  [{agent}move{loc}] {agent}={n_trans}-> 1:({agent}'={n_trans}+1);\n"
                if action._action.name == "dotask":
                    task = str(action.actual_parameters[1])
                    retry = retry_agent_dic[(str(agent), task)]
                    if retry > 0:
                        s += f"  [{agent}do{task}Retry] {agent}={n_trans} & {agent}retry_{task} < {agent}_maxRetry_{task} -> p_{agent}_{task} : ({agent}'={agent}+1) + (1-p_{agent}_{task}) : ({agent}'={agent}) & ({agent}retry_{task}' = {agent}retry_{task}+1);\n"
                        s += f"  [{agent}do{task}] {agent}={n_trans} & {agent}retry_{task} >= {agent}_maxRetry_{task} -> 1:({agent}'={agent}Fail);\n"
                    else:
                        s += f"  [{agent}do{task}] {agent}={n_trans} -> p_{agent}_{task} : ({agent}'={agent}+1) + (1-p_{agent}_{task}) : ({agent}'={agent}Fail);\n"
                n_trans += 1
            s += "endmodule\n\n"
        
        # Rewards
        s += "rewards \"cost\"\n"
        for agent in plan_agents_set:
            for action in plan_actions_per_agent[agent]:
                if action._action.name == "move":
                    loc = str(action.actual_parameters[2])
                    cost = 1  # Cost set to 1
                    s += f"  [{agent}move{loc}] true:{cost};\n"
                if action._action.name == "dotask":
                    task = str(action.actual_parameters[1])
                    cost = cost_agent_dic[(str(agent), task)]
                    s += f"  [{agent}do{task}] true:{cost};\n"
                    retry = retry_agent_dic[(str(agent), task)]
                    if retry > 0:
                        s += f"  [{agent}do{task}Retry] true:{cost};\n"
        s += "endrewards"
        
        # Complete evochecker properties file
        if evoChecker:
            s_evoProps += "//objective, max\nP=? [ F \"success\" ]\n\n"
            s_evoProps += "//objective, min\nR=? [ F \"done\" ]\n\n"
            s_evoProps += f"////constraint, min, {p_min}\n//P=? [ F \"success\" ]\n\n"
        
        # Save .pm and .props files
        _save_file(s, output_dir, f'datamodelEvo.pm')
        _save_file(s_evoProps, output_dir, f'datamodelEvo.props')
        print(f"Files saved as datamodelEvo.pm and datamodelEvo.props")
        
        # Get and save evochecker config.properties file
        if evoChecker:
            s_configProps = _get_evochecker_config_file(output_dir,libs_dir,name_file,population,max_evals)
            _save_file(s_configProps, output_dir, f'evo_config.properties')
            
            
    except Exception as e:
        print(f"Error creating PRISM file: {e}")
        sys.exit(1)
    
    # Return path to config.props file (only needed for EvoChecker)
    return os.path.join(output_dir, f'evo_config.properties') 
    

def _get_evochecker_config_file(output_dir,libs_dir,name_file,population=100,max_evals=1000):
    '''Get Evochecker config file'''
    
    # Set parameters
    problem = f"CPHS-{name_file}-EvoChecker-output"
    model = os.path.join(output_dir, 'datamodelEvo.pm') #"models/models_n_props/datamodelEvo1.pm"
    properties = os.path.join(output_dir, 'datamodelEvo.props') #"models/models_n_props/datamodelEvo1.props"
    #libs_dir = "libs/runtime"
    python_dir = "/usr/bin/python3"
    
    # Create config.properties file
    s_configProps = ""
    s_configProps += f"""PROBLEM = {problem}
    
    MODEL_TEMPLATE_FILE = {model}
    PROPERTIES_FILE = {properties}

    # Step2 : Set the algorithm (MOGA or Random) to run
    # ALGORITHM = RANDOM
    ALGORITHM = NSGAII
    # ALGORITHM = SPEA2
    # ALGORITHM = MOCELL

    # Step 3: Set the population for the MOGAs
    POPULATION_SIZE = {population}

    # Step 4: Set the maximum number of evaluations
    MAX_EVALUATIONS = {max_evals}

    # Step 5: Set the number of processors (for parallel execution) and initial port
    PROCESSORS = 1
    INIT_PORT = 8860

    # Step 6: Set the directories containing the libraries of the model checker
    MODEL_CHECKING_ENGINE_LIBS_DIRECTORY = {libs_dir}
    # MODEL_CHECKING_ENGINE_LIBS_DIRECTORY = libs/runtime-amd64

    # Step 7: Set plotting settings
    # Note: requires Python3
    PLOT_PARETO_FRONT = FALSE
    PYTHON3_DIRECTORY = {python_dir}
    # /usr/local/bin/python3

    # Step 8: Set additional settings
    VERBOSE = TRUE

    # Which EvoChecker engine should be used: Options: NORMAL, PARAMETRIC
    # If is absent the normal EvoChecker will be used
    EVOCHECKER_TYPE = NORMAL

    # Option: PRISM | STORM (preference: PRISM for NORMAL, STORM for PARAMETRIC)
    EVOCHECKER_ENGINE = PRISM
    # EVOCHECKER_TYPE = PARAMETRIC
    # EVOCHECKER_ENGINE = STORM

    #############################################################
    # Advanced Settings
    # JAVA=/Library/Java/JavaVirtualMachines/openjdk-11.0.2.jdk/Contents/Home/bin/java
    # MODEL_CHECKING_ENGINE = libs/PrismExecutor.jar
    """
    return s_configProps

def _save_file(s, output_folder, file_name):
    # Save file
    with open(os.path.join(output_folder, file_name), 'w') as f:
        f.write(s)
    print(f"File saved to {os.path.join(output_folder, file_name)}")
    
