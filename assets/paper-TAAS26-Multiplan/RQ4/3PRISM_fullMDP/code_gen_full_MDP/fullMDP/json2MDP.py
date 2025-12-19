'''
Gricel Vazquez
Last reviewed: Dec 5, 2024
Read the json file containing the problem specification.
'''

import json
import os
import re


def _get_all_instanceTasks(data):
    ''' Get the instance tasks from the JSON data.'''
    instanceTasks = []
    for task in data['tasks']:
        for instance in task['instances']:
            instanceTasks.append(instance['id'])
    return instanceTasks


def _get_data_agents_info(data, verbose=False):
    '''Get the task instances per agent from the JSON data.'''
    instanceAgents = dict()
    instanceAgentsRetries = dict()
    instanceAgentsProb = dict()
    instanceAgentsCost = dict()
    for agent in data['agents']:
        instanceAgents[agent['id']] = []
        # for each existing task
        for t in data['tasks']:
            # if agent has the task
            types = [task['type'] for task in agent['tasks']]
            if t['id'] in types:
                task = [task for task in agent['tasks'] if task['type'] == t['id']][0]
                for instance in t['instances']:
                    instanceAgents[agent['id']].append(instance['id'])
                    instanceAgentsRetries[(agent['id'],instance['id'])] = task['number_of_retries']
                    instanceAgentsProb[(agent['id'],instance['id'])] = task['probability_of_success']
                    instanceAgentsCost[(agent['id'],instance['id'])] = task['cost']
    if verbose:
        print("Task instances that agents can do: ", instanceAgents)
        print("Task instance and agent to Retries: ", instanceAgentsRetries)
        print("Task instance and agent to Prob: ", instanceAgentsProb)
        print("Task instance and agent to Cost: ", instanceAgentsCost)
    return instanceAgents, instanceAgentsRetries, instanceAgentsProb, instanceAgentsCost




def _generate_mdp(data,verbose=False):
    ''' Generate the MDP Prism file content from the JSON data.\n
    NOTE: REQUIRES ID OF LOCATIONS TO BE \"l+XX+optional letter\", where XX is 1,2,3... up to the number of locations, and optional letter is a letter to differentiate locations with the same number. \n
    e.g. (l1, l2)
    NOTE: REQUIRES tasks ID's to have location at the end: \"l+XX+optional letter\", where XX is 1,2,3... up to the number of locations, and optional letter is a letter to differentiate locations with the same number. \n
    (e.g. t1l1, t1l1a, t3l29)
    '''
    instanceAgents, instanceAgentsRetries, instanceAgentsProb, instanceAgentsCost = _get_data_agents_info(data,verbose)
    # Initialise MDP header
    s = '''mdp\n'''
    #- Label success (completed with success)
    s += '''// Labels & formulae \n'''
    s += '''label \"success\" = '''
    for i in _get_all_instanceTasks(data):
        s+=f"{i}=1 & "
    s = s[:-3]; s+=";\n"
    #- Label done (completed with succ or failure)
    s += '''label \"done\" = '''
    for i in _get_all_instanceTasks(data):
        s+=f"!({i}=0) & "
    s = s[:-3]; s+=";\n"
    #- Formula success
    s += '''formula success = '''
    for i in _get_all_instanceTasks(data):
        s+=f"{i}=1 & "
    s = s[:-3]; s+=";\n"
    #-Max retries for each agent, for each task
    s += '''// Retries\n'''
    for a in instanceAgentsRetries.keys():
        agent = a[0]; task = a[1]; retry = instanceAgentsRetries[a]
        s += f"const int {agent}_maxRetry_{task} = {retry};\n"
    #-Cost for each agent, for each task
    s += '''// Cost\n'''
    for a in instanceAgentsCost.keys():
        agent = a[0]; task = a[1]; cost = instanceAgentsCost[a]
        s += f"const int {agent}_cost_{task} = {cost};\n"
    #-Module for all agents
    s += '''\n\n'''
    s += f'''module agents\n'''
    for agent in instanceAgents.keys():
        s += f'''  //  {agent} state vars\n'''
        # Location
        a = [a for a in data['agents'] if a['id']==agent][0] #get agent data
        initLoc = a['initial_location'].replace(" ","")[1:]
        n_loc = len(data['locations'])
        s += f"  {agent}Loc : [0..{n_loc}] init {initLoc}; //location\n"
        # Retries
        for task in instanceAgents[agent]:
            if instanceAgentsRetries[(agent,task)]>0:
                s += f"  {agent}retry_{task} : [0..{agent}_maxRetry_{task}] init 0; //retry\n"
    s += "  // empty locations\n"
    # Empty locations
    for location in data['locations']:
        if location['id'] not in [agent['initial_location'].replace(" ","") for agent in data['agents']]:
            s += f"  empty{location['id']} : bool init true;\n"
        else:
            s += f"  empty{location['id']} : bool init false;\n"
    # Task instances
    s += "  // tasks\n"
    for task in _get_all_instanceTasks(data):
        s += f"  {task} : [0..2] init 0; //1: success, 2: failure\n"
    # Transitions
    s += '''\n\n  // Transitions move\n'''
    # Move
    for agent in instanceAgents.keys():
        s+= f"  // {agent}\n"
        for path in data['paths']:
            locstart = path['start_location']
            locend = path['end_location']
            #--REQUIRES ID OF LOCATIONS TO BE lXX, where XX is 1,2,3... up to the number of locations
            s += f"  [{agent}move{locstart}_{locend}] {agent}Loc={locstart[1:]} & empty{locend} & !success-> 1.0 : (empty{locstart}'=true) & (empty{locend}'=false) & ({agent}Loc'={locend[1:]});\n"
            # add simetric path
            s += f"  [{agent}move{locend}_{locstart}] {agent}Loc={locend[1:]} & empty{locstart} & !success -> 1.0 : (empty{locend}'=true) & (empty{locstart}'=false) & ({agent}Loc'={locstart[1:]});\n"

    # Do task
    s += '''\n\n  // Transitions dotask\n'''
    for agent in instanceAgents.keys():
        s+= f"  // {agent}\n"
        for task in instanceAgents[agent]:
            probsuccess = round(instanceAgentsProb[(agent,task)],2)
            retry = instanceAgentsRetries[(agent,task)]
            #--REQUIRES ID OF TASKS TO BE TXXXLXXa, where XX refers to the location lXX, XX= 1,2,3... up to the number of locations, a is a string
            loc = task.split("l")[1]
            loc = re.sub(r'\D', '', loc)
            if retry > 0:
                s += f"  [{agent}dotask_{task}] {task}=0 & {agent}Loc={loc} & {agent}retry_{task}<{agent}_maxRetry_{task} -> {probsuccess} : ({task}'=1) + {round(1-probsuccess,2)} : ({agent}retry_{task}'={agent}retry_{task}+1);\n"
                s += f"  [{agent}dotask_{task}] {task}=0 & {agent}Loc={loc} & {agent}retry_{task}>={agent}_maxRetry_{task} -> 1 : ({task}'=2);\n"
            else:
                s += f"  [{agent}dotask_{task}] {task}=0 & {agent}Loc={loc} -> {probsuccess} : ({task}'=1) + {round(1-probsuccess,2)} : ({task}'=2);\n"
    s += '''endmodule\n'''

    # Cost rewards
    s += '''\n\n// Reward: cost\n'''
    s += '''rewards\n'''
    for agent in instanceAgents.keys():
        s += f"  // {agent} move\n"
        # Move
        for path in data['paths']:
            locstart = path['start_location']
            locend = path['end_location']
            s += f"  [{agent}move{locstart}_{locend}] true : 1;\n"
            s += f"  [{agent}move{locend}_{locstart}] true : 1;\n"
        s += f"  // {agent} dotask\n"  
        # Do task
        for task in instanceAgents[agent]:
            cost = instanceAgentsCost[(agent,task)]
            s += f"  [{agent}dotask_{task}] true : {agent}_cost_{task};\n"

    s += '''endrewards'''
    return s



def createFolder(fpath):
    '''Delete all files in the directory and create a new folder.
    Even when subfolders are present, they are deleted.'''
    # Create empty directory or delete files if they exist
    if not os.path.exists(fpath):
        os.makedirs(fpath)  # create the folder if it doesn't exist
    else:
        # Delete all files and folders in the directory
        #print(f"Directory exists, removing current files and folders: {fpath}")
        for f in os.listdir(fpath):
            item_path = os.path.join(fpath, f)
            if os.path.isdir(item_path):
                # If it's a directory, remove it and its contents
                shutil.rmtree(item_path)
                #print(f"Directory removed: {item_path}")
            elif os.path.isfile(item_path):
                # If it's a file, remove it
                os.remove(item_path)
                #print(f"File removed: {item_path}")
                


def main(json_file_path, mdpFile, output_dir):    
    ''' Generate Full MDP from JSON data.'''
    
    # Load the JSON data
    with open(json_file_path, 'r') as f:
        data = json.load(f)
    # Generate MDP Prism files
    model = _generate_mdp(data)
    
    # Create output directory - indexed by file name
    createFolder(output_dir)
    
    # Save the files
    with open(os.path.join(output_dir,"fullmdp.mdp"), 'w') as f:
        f.write(model)
    