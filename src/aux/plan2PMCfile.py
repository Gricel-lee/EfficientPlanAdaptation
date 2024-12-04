from typing import List
from unified_planning.engines.results import PlanGenerationResult
import unified_planning.plans as plans
import unified_planning.plans as sequential_plan
import unified_planning.plans.sequential_plan as SequentialPlan
import unified_planning.plans.plan as Plan

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
    
    # print("actions:")
    # for action in actions:
    #     action: Plan.ActionInstance
    #     print(action)
    #     print(action._action.name)   # action name
    #     print(action.actual_parameters) # grounded parameters of an action on a plan
    #     for param in action.actual_parameters:
    #         print(param)
        
        
    # for act in resplan.plan.actions:
    #     act: plans.ActionInstance
    #     print(type(act))
    #     print(act._action)
    #     print(act._action.parameters)
    #     print(act.)
        
    #     # plan[i] = plan[i].replace('(','')
    #     # plan[i] = plan[i].replace(')','')
    #     # plan[i] = plan[i].replace(' ','')


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



def createPRISMfile(fpath, plan, data, args, evoChecker=False):
    '''Generate PRISM or Evochecker files'''
    # Info from plan
    plan_agents_set = args[0]
    plan_task_per_agent = args[1]
    plan_actions_per_agent = args[2]
    # Info from json data (uncertainty relevant)
    prob_agent_dic, retry_agent_dic, cost_agent_dic, p_min = _extract_uncertainty_data(data)
    #file output
    fout = fpath+"data/"
    
    s_evoProps = "" # evochecker properties
    s = '''dtmc\n'''
    
    if not evoChecker:    
        #- Formula success (completed with success)
        s += '''label \"success\" = '''
        for agent in plan_agents_set:
            s+=f"{agent}={agent}Final & "
        s = s[:-2]; s+=";\n"
        #- Formula done (completed with success or failure)
        s += '''label \"done\" = ('''
        for agent in plan_agents_set:
            s+=f"({agent}={agent}Final | {agent}={agent}Fail) & "
        s = s[:-3]; s+=");\n\n"
    else:
        #- Formula success (completed with success)
        s_evoProps += '''label \"success\" = '''
        for agent in plan_agents_set:
            s_evoProps+=f"{agent}={agent}Final & "
        s_evoProps = s_evoProps[:-2]; s_evoProps+=";\n"
        #- Formula done (completed with success or failure)
        s_evoProps += '''label \"done\" = ('''
        for agent in plan_agents_set:
            s_evoProps+=f"({agent}={agent}Final | {agent}={agent}Fail) & "
        s_evoProps = s_evoProps[:-3]; s_evoProps+=");\n\n"
        
        
    # - Max retries for each agent, for each task allocated
    for agent in plan_task_per_agent.keys():
        for task in plan_task_per_agent[agent]:
            if evoChecker:
                retries = retry_agent_dic[(str(agent),str(task))]
                s += f"evolve int {agent}_maxRetry_{task} [1..{retries}];\n"
            else:
                s += f"const {agent}_maxRetry_{task};\n"
    s += "\n"
    # - Agent probabilities
    for agent in plan_task_per_agent.keys():
        for task in plan_task_per_agent[agent]:
            prob = prob_agent_dic[(str(agent),str(task))]
            s += f"const double p_{agent}_{task}={prob};\n"
    # - Final states
    for agent in plan_agents_set:
        n_agent_state = len(plan_actions_per_agent[agent])+1
        s += f"const int {agent}Final = {n_agent_state-1};\n"
        s += f"const int {agent}Fail = {n_agent_state};\n"
        
    s += "\n"
    # - Agent modules
    for agent in plan_agents_set:
        s += f"module _{agent}\n"
        # - State variables
        # state variable tracking the current action
        s += f"  {agent} : [0..{len(plan_actions_per_agent[agent])+2}];\n"
        # state variable for track retries
        for task in plan_task_per_agent[agent]:
            # retry = retry_agent_dic[(str(agent),str(task))]
            s += f"  {agent}retry_{task} : [0..{agent}_maxRetry_{task}] init 0;\n"
        s += "\n"
        # - Transitions
        n_trans = 0 # current transition
        loc = ""
        for action in plan_actions_per_agent[agent]:
            # if action is move
            if action._action.name == "move":
                loc = str(action.actual_parameters[2])
                s += f"  [{agent}move{loc}] {agent}={n_trans}-> 1:({agent}'={n_trans}+1);\n"
            # if action is dotask
            if action._action.name == "dotask":
                task = str(action.actual_parameters[1])
                retry = retry_agent_dic[(str(agent),task)]
                # if retries allowed (>0)
                if retry > 0:           # loc saved from move action if needed
                    # [w2dot1l4Retry] w2=1 & w2retry_t1l4<w2_maxRetry_t1l4 -> p_w2_do:(w2'=w2+1) + (1-p_w2_do):(w2'=w2)&(w2retry_t1l4'=w2retry_t1l4+1);
                    # [w2dot1l4] w2=1 & w2retry_t1l4>=w2_maxRetry_t1l4 -> 1:(w2'=w2Fail);
                    s += f"  [{agent}do{task}Retry] {agent}={n_trans} & {agent}retry_{task} < {agent}_maxRetry_{task} -> p_{agent}_{task} : ({agent}'={agent}+1) + (1-p_{agent}_{task}) : ({agent}'={agent}) & ( {agent}retry_{task}' = {agent}retry_{task}+1);\n"
                    s += f"  [{agent}do{task}] {agent}={n_trans} & {agent}retry_{task} >= {agent}_maxRetry_{task} -> 1:({agent}'={agent}Fail);\n"
                # if no retries allowed
                else:
                    s += f"  [{agent}do{task}] {agent}={n_trans} -> p_{agent}_{task} : ({agent}'={agent}+1) + (1-p_{agent}_{task}) : ({agent}'={agent}Fail);\n"
            # increase step
            n_trans += 1
        s += "endmodule\n\n"
    # - Rewards
    s += "rewards \"cost\"\n"
    for agent in plan_agents_set:
        for action in plan_actions_per_agent[agent]:
            # if action is move
            if action._action.name == "move":
                loc = str(action.actual_parameters[2])
                cost=1 # Cost set to 1
                s += f"  [{agent}move{loc}] true:{cost};\n"
            # if action is dotask
            if action._action.name == "dotask":
                task = str(action.actual_parameters[1])
                cost = cost_agent_dic[(str(agent),task)]
                s += f"  [{agent}do{task}] true:{cost};\n"
                # if retries allowed (>0)
                retry = retry_agent_dic[(str(agent),task)]
                if retry > 0:
                    s += f"  [{agent}do{task}Retry] true:{cost};\n"
    s += "endrewards"
    
    #complete evochecker properties file
    if evoChecker:
        s_evoProps += "//objective, max\nP=? [ F \"success\" ]\n\n"
        
        s_evoProps += "//objective, min\nR=? [ F \"done\" ]\n\n"
        
        s_evoProps += f"//constraint, max, {p_min}\nR=? [ F \"success\" ]\n\n"
        
    
    
    if evoChecker:
        _save_file(s, fout, 'modelEvo.pm')
        _save_file(s_evoProps, fout, 'modelEvo.props')
        print("EvoChecker file saved.")
    else:
        _save_file(s, fout, 'modelPrism.pm')
        print("Prism file saved.")
    


def _save_file(s, fout, fname):
    # Save file
    with open(fout+fname, 'w') as f:
        f.write(s)
    