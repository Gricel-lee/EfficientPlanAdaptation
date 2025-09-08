import json
import re
from pprint import pprint

def parse_plan(plan_file: str):
    """
    Parses the plan file to extract a list of actions.
    
    Args:
        plan_file (str): Path to the plan.txt file.
    
    Returns:
        list: A list of action dictionaries, e.g., 
        [{'name': 'move', 'agent': 'worker2', 'params': ['l1', 'l4']}].
    """
    actions = []
    # Regex to capture action_name(agent, param1, param2, ...)
    action_regex = re.compile(r"(\w+)\(([\w\s,]+)\)")
    
    with open(plan_file, 'r') as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("SequentialPlan:"):
                continue
            
            match = action_regex.match(line)
            if match:
                action_name = match.group(1)
                # Split params and strip whitespace
                params = [p.strip() for p in match.group(2).split(',')]
                agent = params.pop(0) # The first parameter is always the agent
                
                actions.append({
                    "name": action_name,
                    "agent": agent,
                    "params": params
                })
    return actions

def load_world_data(input_json_file: str):
    """
    Loads the JSON file and processes its contents into easily searchable maps.
    
    Args:
        input_json_file (str): Path to the input JSON file.
    
    Returns:
        dict: A dictionary containing maps for paths, task instances, and agent-specific task details.
    """
    with open(input_json_file, 'r') as f:
        data = json.load(f)
        
    # Create a map for path distances for quick lookup.
    paths_map = {frozenset((p['start_location'], p['end_location'])): p['distance'] for p in data['paths']}
    
    # Create a map from task instance ID to the main task's properties
    task_instances_map = {}
    for task_type in data['tasks']:
        for instance in task_type['instances']:
            task_instances_map[instance['id']] = {'type': task_type['id']}
            
    # Create a map for agent-specific task durations: {'agent_id': {'task_type': duration}}
    agent_task_durations = {}
    for agent in data['agents']:
        agent_id = agent['id']
        agent_task_durations[agent_id] = {task['type']: task['duration'] for task in agent['tasks']}
            
    return {"paths": paths_map, "tasks": task_instances_map, "agent_tasks": agent_task_durations}

def assemble_timeline(plan_file: str, input_json_file: str):
    """
    Assembles a timeline from a plan file and a world data file.
    
    Calculates the duration of each action based on the JSON data and keeps
    track of each agent's individual timeline.
    
    Args:
        plan_file (str): Path to the plan.txt file.
        input_json_file (str): Path to the input JSON file.
    
    Returns:
        list: A sorted list of timeline event dictionaries.
    """
    actions = parse_plan(plan_file)
    world_data = load_world_data(input_json_file)
    
    timeline = []
    agent_clocks = {}  # Tracks the current time for each agent independently

    for action in actions:
        agent = action["agent"]
        
        if agent not in agent_clocks:
            agent_clocks[agent] = 0
            
        start_time = agent_clocks[agent]
        duration = 1  # Default duration
        details = {}

        if action["name"] == "move":
            start_loc, end_loc = action["params"]
            duration = world_data["paths"].get(frozenset((start_loc, end_loc)), 1)
            details = {"from": start_loc, "to": end_loc}
        
        elif action["name"] == "dotask":
            task_instance_id = action["params"][0]
            task_info = world_data["tasks"].get(task_instance_id)
            
            if task_info:
                task_type = task_info['type']
                # Get agent-specific duration from the new map
                duration = world_data["agent_tasks"].get(agent, {}).get(task_type, 1)
            
            details = {"task_id": task_instance_id, "location": action["params"][1]}

        end_time = start_time + duration
        agent_clocks[agent] = end_time
        
        event = {
            "action": action["name"],
            "agent": agent,
            "start_time": start_time,
            "end_time": end_time,
            "duration": duration,
            "details": details
        }
        timeline.append(event)
        
    timeline.sort(key=lambda x: x['start_time'])
    
    return timeline

def get_timeline_for_problem():
    """Wrapper function."""
    plan_file = "assets/planningProblem/output_example_a954f30fb3ba4ae6ab0cc9b713628f22/plan.txt"
    input_json_file = "assets/planningProblem/example.json"
    timeline = assemble_timeline(plan_file, input_json_file)
    return timeline

if __name__ == "__main__":
    ''' For testing purposes only '''
    print("Assembling timeline from plan.txt and example.json...")
    final_timeline = get_timeline_for_problem()
    
    print("\n--- Generated Timeline ---")
    pprint(final_timeline)
    print("--- End of Timeline ---\n")



