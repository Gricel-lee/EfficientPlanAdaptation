'''
Gricel Vazquez
Last reviewed: Dec 2, 2024
Read the json file containing the problem specification.
'''

import json
import os
import arch.aux.auxiliary as auxiliary

def generate_pddl_domain(data):
    ''' Generate the PDDL domain file content from the JSON data.'''
    
    # Domain header and requirements
    domain = '''(define (domain mrmh_planning)
    (:requirements :strips :typing :negative-preconditions :numeric-fluents)
    (:types location task agent)
    (:predicates 
    (agent_at ?r - agent ?l - location) 
    (path ?l_from - location ?l_to - location) 
    (empty ?l - location) 
    (task_loc ?t - task ?l - location) 
    (task_done ?t - task))
    (:functions (p_success ?a - agent ?t - task) (travel_dist))'''
    
    # Actions in the domain
    domain += f''' 
    (:action move
        :parameters ( ?r - agent ?l_from - location ?l_to - location)
        :precondition 
            (and (path ?l_from ?l_to) (agent_at ?r ?l_from) (empty ?l_to) )
        :effect 
            (and (not (agent_at ?r ?l_from)) (agent_at ?r ?l_to) (empty ?l_from) (not (empty ?l_to)) 
            (increase (travel_dist) 1)))
    (:action dotask
        :parameters ( ?a - agent ?t - task ?l - location)
        :precondition 
            (and (agent_at ?a ?l) (task_loc ?t ?l) (not (task_done ?t)) 
            (<= {data['constraints']['min_assignment_probability']} (p_success ?a ?t)) )
        :effect 
            (and (task_done ?t)))
    )
    '''
    return domain


def generate_pddl_problem(data):
    ''' Generate the PDDL problem file content from the JSON data.'''
    # Initialise problem header
    problem = '''(define (problem mrmh_planning)
    (:domain mrmh_planning)
    (:objects'''
    for location in data['locations']:
        problem += f" {location['id']} "
    problem+= ''' - location\n    '''
    for agents in data['agents']:
        problem += f" {agents['id']} "
    problem+= ''' - agent\n    '''
    for task in data['tasks']:
        for instance in task['instances']:
            problem += f" {instance['id']} "
    # Initialise travel distance
    problem+= ''' - task)
    (:init
        (= (travel_dist) 0)\n'''
    # Add paths
    for path in data['paths']:
        problem += f"        (path {path['start_location']} {path['end_location']})"
        problem += f" (path {path['end_location']} {path['start_location']})\n"
    problem += "  "
    # Add initial empty locations
    for location in data['locations']:
        #if location not in any of the agents locations
        if location['id'] not in [agent['initial_location'] for agent in data['agents']]:
            problem += f"(empty {location['id']}) "
    
    # Add task locations
    for task in data['tasks']:
        for instance in task['instances']:
            problem += f"  (task_loc {instance['id']} {instance['location']})\n"
    problem += "       "
    # Add agent positions
    for agent in data['agents']:
        problem += f" (agent_at {agent['id']} {agent['initial_location']})"
    problem += "\n"
    # Add task probabilities
    for agent in data['agents']:
        # for each existing task
        for t in data['tasks']:
            # if agent has the task
            types = [task['type'] for task in agent['tasks']]
            if t['id'] in types:
                task = [task for task in agent['tasks'] if task['type'] == t['id']][0]
                for instance in t['instances']:
                    problem += f"  (= (p_success {agent['id']} {instance['id']}) {task['probability_of_success']})\n"
            else:
                for instance in t['instances']:
                    problem += f"  (= (p_success {agent['id']} {instance['id']}) 0)\n"
            
    # Goal conditions
    problem += ''' 
    )
    (:goal (and 
    '''
    for task in data['tasks']:
        for instance in task['instances']:
            problem += f"  (task_done {instance['id']})\n"
    
    problem += '''))
    (:metric minimize (travel_dist))
)'''

    return problem


def main(json_file_path,
        output_dir = '',
        fdomain='mrmh_planning_domain.pddl',
        fproblem='mrmh_planning_problem.pddl',
        ):
    ''' Generate PDDL domain and problem files from the JSON data.'''
    
    # Set output directory
    if output_dir=='':    
        output_dir = os.path.join(os.path.dirname(json_file_path), "data")
    
    # Debug: Check the input JSON file path
    print(f"[JSON2PDDL] Input JSON file path: {json_file_path}")
    
    # Load the JSON data from the provided file path
    try:
        with open(json_file_path, 'r') as f:
            data = json.load(f)
        print("[JSON2PDDL] Successfully loaded JSON data.")
    except FileNotFoundError as e:
        print(f"[JSON2PDDL] Error: {e}")
        return
    
    # Generate PDDL domain and problem
    print("[JSON2PDDL] Generating PDDL domain and problem files...")
    domain_content = generate_pddl_domain(data)
    problem_content = generate_pddl_problem(data)
    
    # # Create folder for output if it doesn't exist
    # print(f"[JSON2PDDL] Creating folder (if needed) at: {output_dir}")
    # auxiliary.createFolder(output_dir)
    
    # Save the files
    print(f"[JSON2PDDL] Saving domain file to: {os.path.join(output_dir, fdomain)}")
    with open(os.path.join(output_dir, fdomain), 'w') as f:
        f.write(domain_content)
    
    print(f"[JSON2PDDL] Saving problem file to: {os.path.join(output_dir, fproblem)}")
    with open(os.path.join(output_dir, fproblem), 'w') as f:
        f.write(problem_content)
    
    print(f"[JSON2PDDL] PDDL files generated for {os.path.basename(json_file_path)}")
    return data


if __name__ == "__main__":
    # Define the directory containing the JSON files
    input_dir = "./src/Problems/AgentVariation"  # Ensure this path exists
    
    # Iterate through all files in the directory
    for filename in os.listdir(input_dir):
        if filename.endswith(".json"):  # Only process .json files
            json_file_path = os.path.join(input_dir, filename)
            print(f"[JSON2PDDL] Processing file: {json_file_path}")
            main(json_file_path)  # Call main with the full path to each JSON file
