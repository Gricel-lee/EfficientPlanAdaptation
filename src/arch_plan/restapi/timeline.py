import re
from pprint import pprint

# Matches one action line in a plan.txt file. Google OR-Tools and PDDL/TEMPest plans now
# share this exact text format:
#     move(agent, from_loc, to_loc) [start, end]
#     dotask(agent, task_id, from_loc, to_loc) [start, end]
_ACTION_RE = re.compile(r"^\s*(\w+)\(([^)]*)\)\s*\[\s*(\d+)\s*,\s*(\d+)\s*\]\s*$")


def parse_plan(plan_file: str):
    """
    Parses the plan file to extract a list of actions, including the [start, end]
    timestamps already embedded in it by whichever planner wrote it.

    Args:
        plan_file (str): Path to the plan.txt file.

    Returns:
        list: A list of action dictionaries, e.g.,
        [{'name': 'move', 'agent': 'worker2', 'params': ['l1', 'l4'], 'start': 0, 'end': 5}].
    """
    actions = []
    with open(plan_file, 'r') as f:
        for line_no, raw_line in enumerate(f, start=1):
            line = raw_line.strip()
            if not line or line.startswith("SequentialPlan:"):
                continue

            match = _ACTION_RE.match(line)
            if not match:
                raise ValueError(f"[timeline] Could not parse plan line {line_no} in {plan_file}: {raw_line!r}")

            action_name, args_str, start, end = match.groups()
            # Split params and strip whitespace
            params = [p.strip() for p in args_str.split(',')]
            agent = params.pop(0)  # The first parameter is always the agent

            actions.append({
                "name": action_name,
                "agent": agent,
                "params": params,
                "start": int(start),
                "end": int(end),
            })
    return actions


def assemble_timeline(plan_file: str):
    """
    Assembles a timeline from a plan file.

    Start/end times and durations are read directly from the file - both planners (Google
    OR-Tools and PDDL/TEMPest) embed them when writing plan.txt - so no separate problem
    JSON is needed here any more.

    Args:
        plan_file (str): Path to the plan.txt file.

    Returns:
        list: A sorted list of timeline event dictionaries.
    """
    actions = parse_plan(plan_file)

    timeline = []
    for action in actions:
        start_time, end_time = action["start"], action["end"]
        duration = end_time - start_time

        if action["name"] == "move":
            from_loc, to_loc = action["params"]
            details = {"from": from_loc, "to": to_loc}
        elif action["name"] == "dotask":
            # dotask(agent, task_id, from_loc, to_loc). from_loc == to_loc for a PDDL task
            # (it doesn't move the agent), but they may differ for a Google OR-Tools task.
            task_id, from_loc, to_loc = action["params"]
            details = {"task_id": task_id, "from": from_loc, "to": to_loc, "location": from_loc}
        else:
            details = {}

        event = {
            "action": action["name"],
            "agent": action["agent"],
            "start_time": start_time,
            "end_time": end_time,
            "duration": duration,
            "details": details,
        }
        timeline.append(event)

    timeline.sort(key=lambda x: x['start_time'])

    return timeline


if __name__ == "__main__":
    ''' For testing purposes only '''
    import sys
    plan_file = sys.argv[1] if len(sys.argv) > 1 else "assets/planningProblem/output_example_a954f30fb3ba4ae6ab0cc9b713628f22/plan.txt"
    print(f"Assembling timeline from {plan_file}...")
    final_timeline = assemble_timeline(plan_file)

    print("\n--- Generated Timeline ---")
    pprint(final_timeline)
    print("--- End of Timeline ---\n")
