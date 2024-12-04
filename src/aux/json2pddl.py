'''
Gricel Vazquez
Last reviewed: Dec 2, 2024
Read the json file containing the problem specification.
'''

import json
import os


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


def createFolder(fpath):
    # Create empty directory or delete files if they exist
    if not os.path.exists(fpath):
        os.makedirs(fpath)
    else:
        #delete all files in the directory
        files = os.listdir(fpath)
        for f in files:
            os.remove(fpath+f)
            

def main(fpath ="./src/",
    fdomain = 'mrmh_planning_domain.pddl',
    fproblem = 'mrmh_planning_problem.pddl'):
    ''' Generate PDDL domain and problem files from the JSON data.'''
    fout = fpath+"data/"
    # Load the JSON data
    with open(fpath+'input-json/problem.json', 'r') as f:
        data = json.load(f)
    # Generate PDDL domain and problem files
    domain_content = generate_pddl_domain(data)
    problem_content = generate_pddl_problem(data)
    # Create folder
    createFolder(fout)
    # Save the files
    with open(fout+fdomain, 'w') as f:
        f.write(domain_content)
    with open(fout+fproblem, 'w') as f:
        f.write(problem_content)
    print("PDDL files generated: mrmh_planning_domain.pddl and mrmh_planning_problem.pddl")
    return data

if __name__ == "__main__":
    fpath ="./src/"
    fdomain = 'mrmh_planning_domain.pddl'
    fproblem = 'mrmh_planning_problem.pddl'
    main(fpath, fdomain, fproblem)
