import os
import re
import sys
from typing import List
import traceback
from unified_planning.engines.results import PlanGenerationResult
import unified_planning.plans.plan as Plan

from arch.config.config import EVO_LIBRARY_PATH

from arch.planningProblem.planningProblem import planning_problem, get_agent_task_entries, get_agent_travel_durations



#   (The previous UP-object-based get_agents_in_plan/get_tasks_allocated_per_agent/
#   get_actions_per_agent/parsePlan helpers were removed - format_plan_with_timestamps now
#   gets everything it needs from _schedule_plan_actions below, which walks plan.plan.actions
#   directly in their original global order, rather than pre-splitting per agent.)


def _get_prob(data):
    '''Get probability of success for agent and task. Works for either JSON schema (PDDL
    type/instances, or Google OR-Tools flat tasks) via get_agent_task_entries().'''
    prob_agent_dic = dict()
    for agent_id, task_instance_id, agent_task in get_agent_task_entries(data):
        prob_agent_dic[(agent_id, task_instance_id)] = agent_task['probability_of_success']
    return prob_agent_dic

def _get_retries(data):
    '''Get num of retries for agent and task. Works for either JSON schema via
    get_agent_task_entries().'''
    retry_agent_dic = dict()
    for agent_id, task_instance_id, agent_task in get_agent_task_entries(data):
        retry_agent_dic[(agent_id, task_instance_id)] = agent_task['number_of_retries']
    return retry_agent_dic


def _get_task_duration(data):
    '''Get per-agent task duration (mirrors _get_prob/_get_retries/_get_cost). Works for either
    JSON schema via get_agent_task_entries().'''
    duration_agent_dic = dict()
    for agent_id, task_instance_id, agent_task in get_agent_task_entries(data):
        duration_agent_dic[(agent_id, task_instance_id)] = agent_task['duration']
    return duration_agent_dic


def _get_path_durations(data):
    '''Per-agent, bidirectional map of direct-path travel durations: {agent_id: {(from, to):
    duration}}. Works for either JSON schema via get_agent_travel_durations() - PDDL's shared
    paths[].distance (same for every agent) or Google OR-Tools' per-agent agents[].travel[].
    "move" actions only ever happen between directly-connected locations (the PDDL domain's
    precondition requires a "path" fact, and Google OR-Tools' plan.txt already resolved any
    multi-hop travel into direct hops when it was generated), so no shortest-path search is
    needed here.'''
    return get_agent_travel_durations(data)


def _schedule_plan_actions(plan: PlanGenerationResult, task_duration_dic: dict, path_duration_dic: dict) -> dict:
    '''
    Walks the plan's actions in their ORIGINAL (global, interleaved) order - the order ENHSP/
    TEMPest found valid - and assigns each one real [start, end] times, respecting:
      - each agent's own clock (can't start its next action before finishing its last one);
      - location occupancy for "move": the PDDL domain requires a location to be `empty`
        before an agent can move into it (and frees the one it leaves), so the classical plan
        is already conflict-free in DISCRETE step order - whoever vacates a location always
        appears earlier in the sequence than whoever moves into it next. But converting that
        to REAL time per-agent independently can violate it: agent B's real-time departure from
        a location can land later than agent A would otherwise be ready to arrive there, even
        though B's departure is earlier in the plan's step order. Agent A still departs and
        travels on its own schedule (its move's own [start, end] always spans exactly its real
        travel time); if it then arrives before the location is actually free, it waits there
        - an idle gap AFTER that move, before its next line - until it's allowed in. If the
        travel alone takes long enough to cover the remaining occupancy, there's no wait at
        all: e.g. a robot travelling as long as another one's task takes simply arrives to
        find the location already free.
      - "dotask" never needs this: once an agent is at a location (via its own earlier move),
        doing a task there doesn't claim or release occupancy of anywhere else.

    @return {agent_id: [scheduled_action, ...]}, each a dict with keys action_type, task_id
        (None for "move"), from_loc, to_loc, start, end - in that agent's own chronological
        order (which is automatically preserved, as a subsequence of the global order walked).
        A "move"'s [start, end] is always exactly its real travel time; any wait for the
        destination to free up shows up as a gap before the agent's NEXT line, not inside it.
    '''
    agent_clock: dict = {}          # {agent_id: time its last action ended}
    location_freed_at: dict = {}    # {location_id: time it was last vacated (defaults to 0:
                                     # free since the start, matching the PDDL init's "empty")}
    scheduled_per_agent: dict = {}

    for action in plan.plan.actions:
        action: Plan.ActionInstance
        action_name = action._action.name
        if action_name == "move":
            agent_id, from_loc, to_loc = (str(p) for p in action.actual_parameters)
            dur = int(path_duration_dic[agent_id][(from_loc, to_loc)])

            # Depart immediately (no waiting before departure) and travel for the real
            # duration - the move's own bar is exactly this, [start, travel_end], regardless
            # of whether the destination is free yet.
            start = agent_clock.get(agent_id, 0)
            travel_end = start + dur

            # The agent vacates `from_loc` the moment it departs: it's in transit from then
            # on, so another agent can move into `from_loc` starting from that point.
            location_freed_at[from_loc] = start

            scheduled_per_agent.setdefault(agent_id, []).append({
                "action_type": "move", "task_id": None,
                "from_loc": from_loc, "to_loc": to_loc, "start": start, "end": travel_end,
            })

            # The agent isn't actually AT `to_loc` (free to act next) until BOTH travel is
            # done AND whoever was there before has vacated it in real time - which can be
            # later than `travel_end`, even though the classical plan's step order already
            # puts that departure earlier (see docstring). If travel alone takes long enough
            # to cover the remaining occupancy, there's no extra wait at all - e.g. a robot
            # travelling as long as another one's task takes arrives to find the location
            # already free. Any wait needed happens AFTER the travel bar, not before it: the
            # move's own [start, end] above still only spans the real travel, so a leftover
            # wait shows up as a gap between this line and the agent's next one, not as a
            # stretched-out bar.
            agent_clock[agent_id] = max(travel_end, location_freed_at.get(to_loc, 0))

        elif action_name == "dotask":
            agent_id, task_id, loc = (str(p) for p in action.actual_parameters)
            dur = int(task_duration_dic[(agent_id, task_id)])

            start = agent_clock.get(agent_id, 0)
            end = start + dur

            scheduled_per_agent.setdefault(agent_id, []).append({
                "action_type": "dotask", "task_id": task_id,
                "from_loc": loc, "to_loc": loc, "start": start, "end": end,
            })
            agent_clock[agent_id] = end

    return scheduled_per_agent


def format_plan_with_timestamps(plan: PlanGenerationResult, json_data) -> str:
    '''
    Render a PDDL SequentialPlan as text in the same format used for Google OR-Tools plans:
    "move" and "dotask" lines are annotated with "[start, end]", and "dotask" repeats its
    location as both start and end locations (a PDDL task doesn't change the agent's location,
    unlike a Google OR-Tools task). Times are computed by _schedule_plan_actions() - each
    agent's own clock PLUS cross-agent location-occupancy waits (see its docstring) - so an
    agent waiting for a location to free up shows up as a gap between two of its lines, with
    no line of its own (the UI's Gantt chart renders this as empty space for that agent).

    @param plan: PlanGenerationResult (e.g. the result of runENHSP, or one TEMPest solution)
    @param json_data: the parsed problem JSON (same input used to generate the PDDL files)
    @return: the formatted plan text, e.g.:
        SequentialPlan:
            move(worker2, l1, l4) [00, 05]
            dotask(worker2, t1l4, l4, l4) [05, 10]
    '''
    task_duration_dic = _get_task_duration(json_data)
    path_duration_dic = _get_path_durations(json_data)
    scheduled_per_agent = _schedule_plan_actions(plan, task_duration_dic, path_duration_dic)

    lines = ["SequentialPlan:"]
    for agent_id, actions in scheduled_per_agent.items():
        for a in actions:
            start, end = a["start"], a["end"]
            if a["action_type"] == "move":
                lines.append(f"    move({agent_id}, {a['from_loc']}, {a['to_loc']}) [{start:02d}, {end:02d}]")
            else:
                lines.append(f"    dotask({agent_id}, {a['task_id']}, {a['from_loc']}, {a['to_loc']}) [{start:02d}, {end:02d}]")
    return "\n".join(lines) + "\n"


def _get_cost(data):
    '''Get cost ("fatigue" in the JSON - both schemas use that field name) for agent and task.
    Works for either JSON schema via get_agent_task_entries().'''
    cost_agent_dic = dict()
    for agent_id, task_instance_id, agent_task in get_agent_task_entries(data):
        cost_agent_dic[(agent_id, task_instance_id)] = agent_task['fatigue']
    return cost_agent_dic


def _extract_uncertainty_data(data):
    '''Extract uncertainty data from json'''
    prob_agent_dic = _get_prob(data)
    retry_agent_dic = _get_retries(data)
    cost_agent_dic = _get_cost(data)
    p_min = data['constraints']['mission_probability_of_success']
    return prob_agent_dic, retry_agent_dic, cost_agent_dic, p_min



# ── Plan-file (plan.txt) parsing ──────────────────────────────────────────────
# Google OR-Tools and PDDL/TEMPest both now write the same plan.txt text format:
#     SequentialPlan:
#         move(agent, from_loc, to_loc) [start, end]
#         dotask(agent, task_id, from_loc, to_loc) [start, end]
# createPRISMfile() below is driven entirely off this text file, not off a live
# unified_planning plan object (that object only exists for the PDDL/ENHSP/TEMPest
# path; the Google OR-Tools path never has one, since its solver runs as generated,
# standalone Python code). The UP-object-based helpers above (get_agents_in_plan,
# get_tasks_allocated_per_agent, get_actions_per_agent, parsePlan, used by
# format_plan_with_timestamps) are kept as-is: they're still needed to WRITE
# plan.txt in the first place, from the PDDL side's live plan object.

_PLAN_LINE_RE = re.compile(
    r'^\s*(?P<name>\w+)\((?P<args>[^)]*)\)\s*\[\s*(?P<start>\d+)\s*,\s*(?P<end>\d+)\s*\]\s*$'
)


def parse_plan_file(plan_file_path: str) -> List[dict]:
    '''
    Parse a plan.txt file into an ordered list of action dicts, each with keys:
    agent, action_type ("move"|"dotask"), task_id (None for "move"), from_loc, to_loc, start, end.
    '''
    actions = []
    with open(plan_file_path) as f:
        for line_no, raw_line in enumerate(f, start=1):
            line = raw_line.strip()
            if not line or line.startswith("SequentialPlan"):
                continue
            match = _PLAN_LINE_RE.match(line)
            if not match:
                raise ValueError(f"[plan2PMCfile] Could not parse plan line {line_no} in {plan_file_path}: {raw_line!r}")
            name = match.group("name")
            args = [a.strip() for a in match.group("args").split(",")]
            start, end = int(match.group("start")), int(match.group("end"))
            if name == "move":
                if len(args) != 3:
                    raise ValueError(f"[plan2PMCfile] Expected 3 args for 'move', got {args} on line {line_no}: {raw_line!r}")
                agent, from_loc, to_loc = args
                task_id = None
            elif name == "dotask":
                if len(args) != 4:
                    raise ValueError(f"[plan2PMCfile] Expected 4 args for 'dotask', got {args} on line {line_no}: {raw_line!r}")
                agent, task_id, from_loc, to_loc = args
            else:
                raise ValueError(f"[plan2PMCfile] Unknown action type '{name}' on line {line_no}: {raw_line!r}")
            actions.append({
                "agent": agent,
                "action_type": name,
                "task_id": task_id,
                "from_loc": from_loc,
                "to_loc": to_loc,
                "start": start,
                "end": end,
            })
    return actions


def parsePlanFile(plan_file_path: str) -> list:
    '''
    File-based counterpart of parsePlan(): parses plan_file_path (a plan.txt, from either
    planner) and returns [plan_agents_set, plan_task_per_agent, plan_actions_per_agent],
    same shape as parsePlan(), but each "action" is a dict (see parse_plan_file) instead
    of a unified_planning ActionInstance.
    '''
    actions = parse_plan_file(plan_file_path)
    plan_agents_set = {a["agent"] for a in actions}
    plan_task_per_agent = {agent: [] for agent in plan_agents_set}
    plan_actions_per_agent = {agent: [] for agent in plan_agents_set}
    for a in actions:
        plan_actions_per_agent[a["agent"]].append(a)
        if a["action_type"] == "dotask":
            plan_task_per_agent[a["agent"]].append(a["task_id"])
    return [plan_agents_set, plan_task_per_agent, plan_actions_per_agent]


def createPRISMfile(output_dir, name_file, plan_file, json_data, evoChecker=False, population=10, max_evals=100, planNumber=""):
    '''
    Create EvoChecker or PRISM file from a plan.txt file (Google OR-Tools or PDDL/TEMPest format)
        @param output_dir: output directory
        @param plan_file: path to the plan.txt file to read (NOT a unified_planning plan object)
        @param json_data: json parsed data
        @param evoChecker: if True, create EvoChecker files; if False, create PRISM files
        @return: path to config.props file (only needed for EvoChecker)


    '''
    # File names (with plan number if multiple plans)
    fname_model = f'datamodelEvo{planNumber}.pm'
    fname_props = f'datamodelEvo{planNumber}.props'
    fname_config_props = f'evo_config{planNumber}.properties'
    fname_prism = f'datamodelEvo{planNumber}.prism'

    try:
        '''Generate PRISM or Evochecker files'''
        # Info from plan
        args = parsePlanFile(plan_file) # get plan data from plan.txt
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
                s += f"const double p_{agent}_{task}_ORIGINAL={prob};\n"
                
        # e value:
        s += "\nconst double e = 2.718281828459045;\n"
        # OK {worker1, r3} plan_agent_set
        for agent in plan_agents_set:
            print("Agent:", agent)
            for task in plan_task_per_agent[agent]:
                agentID = str(agent) # agent is type: unified_planning.model.fnode.FNode
                taskInstanceID = str(task) # task is type: unified_planning.model.fnode.FNode
                s += f"const double steepness{agentID}_{taskInstanceID} = {planning_problem.get_steepness(agentID, taskInstanceID)};\n"
        s += "\n"
        
        # Agent probability formulas:
        for agent in plan_task_per_agent.keys():
            for task in plan_task_per_agent[agent]:
                prob = prob_agent_dic[(str(agent), str(task))]
                s += f"formula p_{agent}_{task} = 2 * (1 - p_{agent}_{task}_ORIGINAL) * (1 / (1 + 1/pow(e,({agent}retry_{task} * steepness{agent}_{task})))) + (2 * p_{agent}_{task}_ORIGINAL - 1);\n"
        s += "\n"

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
                if action["action_type"] == "move":
                    loc = action["to_loc"]
                    s += f"  [{agent}move{loc}] {agent}={n_trans}-> 1:({agent}'={n_trans}+1);\n"
                if action["action_type"] == "dotask":
                    task = action["task_id"]
                    retry = retry_agent_dic[(str(agent), task)]
                    if retry > 0:
                        s += f"  [{agent}do{task}Retry] {agent}={n_trans} & {agent}retry_{task} < {agent}_maxRetry_{task} -> p_{agent}_{task} : ({agent}'={agent}+1) + (1-p_{agent}_{task}) : ({agent}'={agent}) & ({agent}retry_{task}' = {agent}retry_{task}+1);\n"
                        s += f"  [{agent}do{task}] {agent}={n_trans} & {agent}retry_{task} >= {agent}_maxRetry_{task} -> 1:({agent}'={agent}Fail);\n"
                    else:
                        s += f"  [{agent}do{task}] {agent}={n_trans} -> p_{agent}_{task} : ({agent}'={agent}+1) + (1-p_{agent}_{task}) : ({agent}'={agent}Fail);\n"
                n_trans += 1
            s += "endmodule\n\n"
        
        # Reward vals
        for agent in plan_agents_set:
            for action in plan_actions_per_agent[agent]:
                if action["action_type"] == "dotask":
                    task = action["task_id"]
                    cost = cost_agent_dic[(str(agent), task)]
                    # add cost original
                    s += f"formula r_{agent}_{task}_ORIGINAL = {cost};\n"
                    # add formula (reward varies with retries)
                    s += f"formula r_{agent}_{task} = r_{agent}_{task}_ORIGINAL * ({agent}retry_{task}+1);\n"
                    
        
        # Rewards
        s += "\n\nrewards \"cost\"\n"
        for agent in plan_agents_set:
            for action in plan_actions_per_agent[agent]:
                if action["action_type"] == "move":
                    loc = action["to_loc"]
                    cost = 1  # Cost set to 1
                    s += f"  [{agent}move{loc}] true:{cost};\n"
                if action["action_type"] == "dotask":
                    task = action["task_id"]
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
            s_evoProps += f"//constraint, min, {p_min}\nP=? [ F \"success\" ]\n\n"
        
        # Save .pm and .props files
        if evoChecker:
            # Save .pm and .props files
            _save_file(s, output_dir, fname_model)
            _save_file(s_evoProps, output_dir, fname_props)

            # Get and save evochecker config.properties file
            s_configProps = _get_evochecker_config_file(output_dir,name_file,fname_model,fname_props,population,max_evals)
            _save_file(s_configProps, output_dir, fname_config_props)
        else:
            _save_file(s, output_dir, fname_prism)
            
    except Exception as e:
        print(f"Error creating PRISM file: {e}")
        #print the traceback.print_exc()
        traceback.print_exc()
        import sys # Error if not added here
        sys.exit(1)
    # Return path to config.props file (only needed for EvoChecker)
    return os.path.join(output_dir, fname_config_props)


def _get_evochecker_config_file(output_dir,name_file,fname_model,fname_props,population=100,max_evals=1000):
    '''Get Evochecker config file'''
    
    # Set parameters
    problem = f"CPHS-{name_file}-EvoChecker-output"
    model = os.path.join(output_dir, fname_model) #"/datamodelEvo1.pm"
    properties = os.path.join(output_dir, fname_props) #"/datamodelEvo1.props"
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
    MODEL_CHECKING_ENGINE_LIBS_DIRECTORY = {EVO_LIBRARY_PATH}
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
    
