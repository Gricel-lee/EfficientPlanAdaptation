import json
import re

def parse_pareto_front(filepath):
    """
    Parses the pareto front file to extract QoS data (cost and probability).
    
    Args:
        filepath (str): The path to the paretofront.txt file.

    Returns:
        list: A list of dictionaries, each containing 'cost' and 'probabilitySucc'.
    """
    qos_data = []
    with open(filepath, 'r') as f:
        lines = f.readlines()
        # Skip header and process data lines
        for line in lines[1:]:
            if line.strip():
                parts = line.split()
                qos_data.append({
                    "probabilitySucc": float(parts[0]),
                    "cost": float(parts[1])
                })
    return qos_data

def parse_pareto_set(filepath):
    """
    Parses the pareto set file to extract task retry configurations.
    
    Args:
        filepath (str): The path to the paretoset.txt file.

    Returns:
        list: A list of lists, where each inner list contains dictionaries 
              representing a task's retry info ('maxRetry', 'agent', 'task').
    """
    all_tasks_retries = []
    with open(filepath, 'r') as f:
        lines = f.readlines()
        
        # Parse the header to get agent and task names
        header_parts = lines[0].strip().split()
        parsed_headers = []
        for part in header_parts:
            # e.g., 'worker2_maxRetry_t1l4' -> ('worker2', 't1l4')
            split_part = part.split('_')
            agent = split_part[0]
            task = split_part[-1]
            parsed_headers.append({"agent": agent, "task": task})
            
        # Process the data rows
        for line in lines[1:]:
            if line.strip():
                retries = [int(r) for r in line.split()]
                
                # Combine headers with the retry counts for this specific solution
                tasks_retries_for_solution = []
                for i, header_info in enumerate(parsed_headers):
                    tasks_retries_for_solution.append({
                        "maxRetry": retries[i],
                        "agent": header_info["agent"],
                        "task": header_info["task"]
                    })
                all_tasks_retries.append(tasks_retries_for_solution)

    return all_tasks_retries

def parse_plan(filepath):
    """
    Reads a sequential plan from a text file and returns it as a list of actions.

    Args:
        filepath (str): The path to the input text file (e.g., 'plan.txt').
    
    Returns:
        list: A list of action dictionaries.
    """
    plan_actions = []
    
    # Regular expressions to parse the two types of actions
    move_pattern = re.compile(r"^\s*move\(([^,]+),\s*([^,]+),\s*([^)]+)\)")
    dotask_pattern = re.compile(r"^\s*dotask\(([^,]+),\s*([^,]+),\s*([^)]+)\)")

    with open(filepath, 'r') as f:
        for line in f:
            # Attempt to match 'move' action
            move_match = move_pattern.match(line)
            if move_match:
                agent, initial_loc, end_loc = move_match.groups()
                action = {
                    "name": "move",
                    "agent": agent.strip(),
                    "initialLocation": initial_loc.strip(),
                    "endLocation": end_loc.strip(),
                    "taskId": None
                }
                plan_actions.append(action)
                continue # Move to the next line

            # Attempt to match 'dotask' action
            dotask_match = dotask_pattern.match(line)
            if dotask_match:
                agent, task_id, location = dotask_match.groups()
                action = {
                    "name": "dotask",
                    "agent": agent.strip(),
                    "initialLocation": location.strip(),
                    "endLocation": None,
                    "taskId": task_id.strip()
                }
                plan_actions.append(action)
    return plan_actions


def generate_combined_json(plan_file, front_file, set_file, output_file):
    """
    Reads plan, pareto front, and set files, combines them, and generates a single JSON file.
    
    Args:
        plan_file (str): Path to the plan.txt file.
        front_file (str): Path to the paretofront.txt file.
        set_file (str): Path to the paretoset.txt file.
        output_file (str): Path for the output JSON file.
    """
    try:
        # 1. Parse all data from files into memory
        plan_data = parse_plan(plan_file)
        qos_data = parse_pareto_front(front_file)
        tasks_retries_data = parse_pareto_set(set_file)

        if len(qos_data) != len(tasks_retries_data):
            print("Warning: Row count mismatch between paretofront and paretoset files.")

        # 2. Combine pareto data into a list of solutions
        pareto_solutions = []
        num_solutions = min(len(qos_data), len(tasks_retries_data))

        for i in range(num_solutions):
            solution = {
                "paretoSolutionId": i + 1,
                "QoS": qos_data[i],
                "tasksRetries": tasks_retries_data[i]
            }
            pareto_solutions.append(solution)

        # 3. Create the final, single JSON object with a root key for each data type
        final_json = {
            "plan": plan_data,
            "pareto": pareto_solutions
        }

        # 4. Write the combined object to the output file (in write 'w' mode)
        with open(output_file, 'w') as f:
            json.dump(final_json, f, indent=4)
        
        print(f"Successfully generated combined JSON in '{output_file}'.")

    except FileNotFoundError as e:
        print(f"Error: Could not find the file {e.filename}.")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")

# --- Main execution ---
if __name__ == "__main__":
    frontFile = "assets/planningProblem/output_example_0b98603ccfdc4d4992778baa57bdf5cc/dataevochecker_run1/NSGAII/CPHS-EXAMPLE-EVOCHECKER-OUTPUT_NSGAII_101226_280825_Front"
    setFile = "assets/planningProblem/output_example_0b98603ccfdc4d4992778baa57bdf5cc/dataevochecker_run1/NSGAII/CPHS-EXAMPLE-EVOCHECKER-OUTPUT_NSGAII_101226_280825_Set"
    jsonFile = "assets/planningProblem/output_example_0b98603ccfdc4d4992778baa57bdf5cc/json_output.json"
    planFile = "assets/planningProblem/output_example_0b98603ccfdc4d4992778baa57bdf5cc/plan.txt"
    
    generate_combined_json(planFile, frontFile, setFile, jsonFile)