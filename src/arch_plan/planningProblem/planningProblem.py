import json
import time
from typing import Dict, Tuple, Optional
import os


# ── Schema-agnostic problem parsing ────────────────────────────────────────────
# Two JSON problem schemas exist, kept deliberately separate on disk - PDDL problems use a
# shared paths[].distance and group agent tasks by task TYPE (with data['tasks'][*]['instances']
# as the type's instances); Google OR-Tools problems use per-agent agents[].travel[] (no shared
# path distance) and flat task ids directly (no type/instances split; task_graph is also
# Google-OR-only, and is deliberately what check_json_file_4type() uses to pick the planner -
# don't add it to a PDDL problem, it would get routed to the wrong solver).
# The functions below parse either schema into the SAME shape, so downstream code (steepness,
# probability/retries/fatigue lookups, travel durations for plan timestamps) never needs to
# know or care which schema the JSON it was given uses.

def get_agent_task_entries(data: dict):
    '''
    Yields (agent_id, task_instance_id, agent_task_dict) for every agent/task-instance pairing,
    regardless of schema:
      - PDDL (type/instances): agent_task_dict has 'type' (a task TYPE id); data['tasks'] maps
        that type to its list of instances, each sharing agent_task_dict's parameters (duration,
        fatigue, probability_of_success, number_of_retries, steepness).
      - Google OR-Tools (flat): agent_task_dict has 'id' directly - it already IS the (flat)
        task instance, no type indirection.
    '''
    # type -> [instance_id, ...], for the PDDL-style schema only (empty for Google OR-Tools,
    # whose data['tasks'] entries have no 'instances')
    task_instances = {
        task["id"]: [inst["id"] for inst in task.get("instances", [])]
        for task in data.get("tasks", [])
    }
    for agent in data.get("agents", []):
        agent_id = agent["id"]
        for agent_task in agent.get("tasks", []):
            if "type" in agent_task:
                # PDDL-style: one agent_task entry covers every instance of that type
                for instance_id in task_instances.get(agent_task["type"], []):
                    yield agent_id, instance_id, agent_task
            else:
                # Google OR-Tools-style: agent_task IS the (flat) task instance already
                yield agent_id, agent_task["id"], agent_task


def get_agent_travel_durations(data: dict) -> Dict[str, Dict[Tuple[str, str], float]]:
    '''
    Returns {agent_id: {(from_loc, to_loc): duration}}, bidirectional, regardless of schema:
      - PDDL: paths[] carry a shared 'distance' - the same default for every agent.
      - Google OR-Tools: paths[] carry an 'id' (no shared distance); each agent overrides/
        defines its own travel durations via agents[].travel[] = [{id: path_id, duration}].
    An agent's own travel[] entry always takes precedence over the shared default, for any path
    it mentions (lets a schema mix both, though in practice each problem uses only one style).
    '''
    # Shared default, from paths[].distance (PDDL-style; empty dict if paths have no 'distance')
    base: Dict[Tuple[str, str], float] = {}
    for p in data.get("paths", []):
        if "distance" in p:
            a, b, dur = p["start_location"], p["end_location"], p["distance"]
            base[(a, b)] = dur
            base[(b, a)] = dur

    # path id -> (from, to), for cross-referencing agents[].travel[] (Google OR-Tools-style;
    # empty dict if paths have no 'id')
    path_endpoints = {
        p["id"]: (p["start_location"], p["end_location"])
        for p in data.get("paths", []) if "id" in p
    }

    agent_travel: Dict[str, Dict[Tuple[str, str], float]] = {}
    for agent in data.get("agents", []):
        per_agent = dict(base)
        for tr in agent.get("travel", []):
            path_id, dur = tr["id"], int(tr["duration"])
            # On a duplicate travel[] entry for the same path, keep the smaller duration
            # (matches the original build_agent_graph()'s behavior in gen_google_problem.py).
            if path_id in path_endpoints:
                a, b = path_endpoints[path_id]
                if (a, b) in per_agent and dur >= per_agent[(a, b)]:
                    continue
                per_agent[(a, b)] = dur
                per_agent[(b, a)] = dur
        agent_travel[agent["id"]] = per_agent

    return agent_travel


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
    # Other methods to set and get problem specifications, steepness, etc.
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
        key = (agent_id, task_instance_id)
        steepness = self.steepness_map.get(key)
        # print(f"[PlanningProblem] agent: {agent_id}, task: {task_instance_id}, steepness: {steepness}")
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
        Works for either JSON schema (PDDL type/instances, or Google OR-Tools flat tasks) via
        get_agent_task_entries(); 'steepness' isn't a Google OR-Tools field, so it always
        defaults to 1.0 there (same default as when a PDDL task simply omits it).
        """
        steepness_map = {}
        for agent_id, task_instance_id, agent_task in get_agent_task_entries(json_data):
            agent_id = str(agent_id).strip()
            task_instance_id = str(task_instance_id).strip()
            steepness_map[(agent_id, task_instance_id)] = agent_task.get("steepness", 1.0)
            # print(f"[===PlanningProblem] Loaded steepness for agent {agent_id}, task instance {task_instance_id}: {steepness_map[(agent_id, task_instance_id)]}")
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