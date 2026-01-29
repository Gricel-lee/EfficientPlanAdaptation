import json
import time
from typing import Dict, Tuple, Optional
import os

#TODO: REPLACE data in code to use this class,
#TODO: create classess for other parts (e.g., agents, tasks, planner gen plans, evo, etc)
class PlanningProblem:
    ''' Class to hold the planning problem specification. 
    To use: "from arch.planningProblem.problemSpec import problem"
    To initialize: problem.set() method with the required parameters.
    To generate new instance: problem.reset()  (for testing/run experiments purposes).
    '''
    def __init__(self):
        self.json_file_path = None
        self.output_dir_name = None
        self.output_dir = None
        self.temperstEngineTimeout = None
        self.one_plan_or_multiple = None
        self.data = None
        self.steepness_map = None
        self.json_data = None
        # Timer initialization get init execution time
        self.start_time = self.initialize_timer()
        
    #---------------- TIMER METHODS ----------------
    def initialize_timer(self):
        self.start_time = time.perf_counter()
        return self.start_time
    
    def save_timer(self, label: Optional[str] = None):
        end_time = time.perf_counter()
        elapsed_time = end_time - self.start_time
        file_path = os.path.join(self.output_dir, "timer_log.txt")
        # save in output_dir
        with open(file_path, "a") as f:
            if label:
                f.write(f"[TIMER] {label}: Elapsed time: {elapsed_time:.4f} seconds\n")
            else:
                f.write(f"[TIMER] Elapsed time: {elapsed_time:.4f} seconds\n")
        return elapsed_time

    #-------------------------------------------------------

    def set(self, json_file_path, output_dir_name, temperstEngineTimeout, one_plan_or_multiple):
        self.json_file_path = json_file_path
        self.output_dir_name = output_dir_name
        self.output_dir =  os.path.join(os.path.dirname(json_file_path), output_dir_name)
        self.temperstEngineTimeout = temperstEngineTimeout
        self.one_plan_or_multiple = one_plan_or_multiple

        # set JSON data
        self.data = self._read_json()
        # set steepness map
        self.steepness_map = self._load_steepness_map(self.data)

    def set_from_data(self, json_data: dict, output_dir: str):
        '''Initialize from already-loaded JSON data (for non-headless mode).'''
        self.data = json_data
        self.json_data = json_data
        self.output_dir = output_dir
        self.output_dir_name = os.path.basename(output_dir)
        # set steepness map
        self.steepness_map = self._load_steepness_map(json_data)
        
    def get_steepness(self, agent_id: str, task_instance_id: str):
        ''' Returns steepness for agent and task instance. '''
        agent_id = agent_id.strip()
        task_instance_id = task_instance_id.strip()
        print("HII",agent_id, task_instance_id)
        key = (agent_id, task_instance_id)
        steepness = self.steepness_map.get(key)
        if steepness is None:
            print(f"[WARNING] No steepness found for {key}")
        return steepness

    def _read_json(self):
        ''' Method to read the JSON file and return its content. '''
        with open(self.json_file_path, 'r') as f:
            data = json.load(f)
        return data


    def _load_steepness_map(self, json_data: dict) -> Dict[Tuple[str, str], float]:
        """
        Returns a mapping:
            (agent_id, task_instance_id) -> steepness
        """
        # First, build a lookup: task_id -> list of instance_ids
        task_instances = {
            task["id"]: [inst["id"] for inst in task.get("instances", [])]
            for task in json_data.get("tasks", [])
        }

        steepness_map = {}
        for agent in json_data.get("agents", []):
            agent_id = str(agent["id"]).strip()
            for task in agent.get("tasks", []):
                task_id = str(task["type"]).strip()  # agent's task references the task type
                steepness = task.get("steepness", 1.0)
                # Map (agent_id, each task_instance_id) -> steepness
                for tinstance_id in task_instances.get(task_id, []):
                    steepness_map[(agent_id, tinstance_id)] = steepness
                    # print(f"[===PlanningProblem] Loaded steepness for agent {agent_id}, task instance {tinstance_id}: {steepness}")
        return steepness_map
    
    def reset(self):
        ''' Reset all attributes to None. Useful for testing purposes.'''
        self.json_file_path = None
        self.output_dir_name = None
        self.temperstEngineTimeout = None
        self.one_plan_or_multiple = None
        self.data = None
        self.steepness_map = None
        self.json_data = None
        # Reset timer to inital time
        self.start_time = self.initialize_timer()


# TODO: call this along the code instead of config.py for problem changing specs
planning_problem = PlanningProblem()