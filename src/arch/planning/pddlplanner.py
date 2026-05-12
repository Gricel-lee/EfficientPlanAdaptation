# Authors: Gricel Vazquez

import os
from unified_planning.shortcuts import *
from unified_planning.engines import PlanGenerationResultStatus 
from unified_planning.io import PDDLReader  # PDDLReader class to read PDDL files
from unified_planning.engines.results import PlanGenerationResult

from unified_planning.shortcuts import get_environment, AnytimePlanner
from arch.config.config import PROBLEM_OUTPUT_DIR, POPULATION_SIZE, MAX_EVALUATIONS, JAR_FILE, NUM_TIMED_RUNS
import arch.planning.plan2PMCfile as plan2PMCfile
from arch.planningProblem.planningProblem import planning_problem


def importPDDLproblem(data_output_dir, f_domain, f_problem):  
    print(f"[pddlplanner] Processing PDDL problem: {f_domain} and {f_problem}")  # Debugging line to show file names
    data_output_dir# = os.path.join(data_output_dir, "data")  # Correct path concatenation
    
    # Debugging print to check the final path
    print(f"[pddlplanner] Final path for reading PDDL files: {data_output_dir}")
    
    # Initialise the PDDLReader
    reader = PDDLReader()

    # Debugging: Check the paths used for parsing
    print(f"[pddlplanner] Reading domain file: {os.path.join(data_output_dir, f_domain)}")
    print(f"[pddlplanner] Reading problem file: {os.path.join(data_output_dir, f_problem)}")
    
    # Get domain and problem
    problem = reader.parse_problem(os.path.join(data_output_dir, f_domain), os.path.join(data_output_dir, f_problem))
    
    # Debugging: Check if problem is parsed correctly
    print(f"[pddlplanner] PDDL problem successfully parsed")
    return problem

def printImportedPDDLproblem(problem:PDDLReader):
    print(f"[pddlplanner] Imported PDDL problem")
    # Print problem details
    print("Problem Name:", problem.name)
    print("Objects:", problem.all_objects)
    print("Goals:", problem.goals)
    print("Actions:", problem.actions)
    # print("\nInitial Values:", problem.initial_value)
    

# ----- Generating one or multiple plans ------
def runPlanner(f_domain, f_problem, output_directory, jsondata, timeout, headless=True):
    plans_found = set()
    plans_obj_found = []
    
    # Set Unified Planning params
    env = get_environment()
    env.factory.add_engine("tempest", "tempest.engine", "TempestEngine")
    env.credits_stream = None
    
    # Read PDDL problem saved
    pddl_reader = PDDLReader()
    problem = pddl_reader.parse_problem(os.path.join(output_directory, f_domain),
                                os.path.join(output_directory, f_problem))
    problem.clear_quality_metrics()
    
    # ---- First, run ENHSP ----
    k = 1
    print(f"[pddlplanner] Running ENHSP as first solver...")
    plan = runENHSP(problem, output_directory)

    if plan.plan is None:
        print(f"[pddlplanner] ERROR: ENHSP found no plan (status: {plan.status}). Aborting.")
        return plans_obj_found

    if headless:
        # Save PRISM/Evochecker files
        savePRISMEvochekerFiles(planning_problem.json_data, planning_problem.output_dir_name, k, plan, headless=True)
        # save time
        planning_problem.save_timer(label="ENHSP Planning Time Plan1")
    else:
        # Save PRISM/Evochecker files
        savePRISMEvochekerFiles(jsondata, output_directory, k, plan, headless=False)

     #TODO: replace plan.txt with plan_<k>.txt in UI code if needed to support multiple plans, for now keep plan.txt for compatibility
    # save plan.txt for UI compatibility (first plan from ENHSP)
    with open(f"{output_directory}/plan.txt", "w") as f:
        f.write(str(plan.plan))

    # Save the plan
    plans_found.add(plan.plan)
    plans_obj_found.append(plan)

    # ----- Then, run TEMPest to generate multiple plans ------
    print(f"[pddlplanner] Running TEMPest to generate multiple plans...")
    # 'incremental': True is faster but may generate more similar plans
    with AnytimePlanner(name="tempest", params={'incremental': False}) as p:
        for i, res in enumerate(p.get_solutions(problem, timeout=timeout)):
            if res.plan and res.plan not in plans_found:
                plans_found.add(res.plan)
                plans_obj_found.append(res)
                print(res.plan)
                k = i + 2
                if k>20:
                    break
                with open(f"{output_directory}/plan_{k}.txt", "w") as f:
                    print(f"[pddlplanner] Saving TEMPest plan {k} to file: {output_directory}/plan_{k}.txt")
                    f.write(str(res.plan))
                # Save PRISM/Evochecker files
                if headless:
                    savePRISMEvochekerFiles(planning_problem.json_data, planning_problem.output_dir_name, k, res, headless=True)
                    # save time
                    planning_problem.save_timer(label=f"TEMPest Planning Time for Plan{k}")
                else:
                    savePRISMEvochekerFiles(jsondata, output_directory, k, res, headless=False)
    return plans_obj_found



def savePRISMEvochekerFiles(jsondata, output_dir_param, k, plan, headless=True):
    ''' Save PRISM and EvoChecker files for each plan found
    tempestEngineTimeout: timeout for the planner
    if 0, only one plan is generated.
    '''
    if headless:
        # Use planning_problem attributes (headless mode)
        output_dir = planning_problem.output_dir
        output_dir_name = planning_problem.output_dir_name
    else:
        # Use passed parameters (non-headless mode)
        output_dir = output_dir_param
        output_dir_name = os.path.basename(output_dir_param)
        # Initialize planning_problem with jsondata for createPRISMfile to use
        planning_problem.set_from_data(jsondata, output_dir)

    print(f"[pddlplanner] Generating PRISM/Evochecker files for plan {k}:\n{plan}")

    output_plan_dir = os.path.join(output_dir, f"output_plan_{k}")

    print(f"[pddlplanner] Output plan dir: {output_plan_dir}")
    print(f"[pddlplanner] Key: {output_dir_name+str(k)}")
    # Add output folder
    PROBLEM_OUTPUT_DIR[output_dir_name+str(k)] = output_plan_dir

    print(f"[pddlplanner] Creating PRISM file...")
    name_file = f"plan_{k}"
    plan2PMCfile.createPRISMfile(PROBLEM_OUTPUT_DIR[output_dir_name+str(k)], name_file, plan, jsondata, planNumber=f"_{k}", population=POPULATION_SIZE, max_evals=MAX_EVALUATIONS)
    plan2PMCfile.createPRISMfile(PROBLEM_OUTPUT_DIR[output_dir_name+str(k)], name_file, plan, jsondata, evoChecker=True, planNumber=f"_{k}", population=POPULATION_SIZE, max_evals=MAX_EVALUATIONS)
    









def runENHSP(problem, data_output_dir):
    '''
    Run the ENHSP planner as first solver (TAMPER as second).
    '''
    print(f"[pddlplanner] Running planner with problem at: {data_output_dir}")  # Debugging line
    
    # Get fluent from problem (for optimisation objective)
    travel_dist = problem.fluent("travel_dist")    
    print(f"[pddlplanner] Found fluent in the problem: {travel_dist}")  # Debugging line to check if fluent is found

    # Set metric to minimizing travel distance
    problem.clear_quality_metrics()  # remove previous optimization metric
    problem.add_quality_metric(MinimizeExpressionOnFinalState(travel_dist()))  # +++
    print(f"[pddlplanner] Quality metric set to minimize travel distance.")  # Debugging line for quality metric
    
    # Solve suboptimally
    # with OneshotPlanner(problem_kind=problem.kind) as planner:
    #     plan: PlanGenerationResult = planner.solve(problem)
    # file_name = 'plan_suboptimal.txt'
    # savePlan(data_output_dir, plan, file_name)
    # print(f"[pddlplanner] Plan generated successfully. Saved in {file_name}")

    
    # Solve the problem optimally
    print(f"[pddlplanner] Solving the problem optimally...")
    with OneshotPlanner(
        problem_kind=problem.kind,
        optimality_guarantee=PlanGenerationResultStatus.SOLVED_OPTIMALLY  # quality metric already set to minimize cost
    ) as planner:
        plan: PlanGenerationResult = planner.solve(problem)
    
    # Print plan and status for debugging
    print(f"[pddlplanner] Plan generation status: {plan.status}")

    #TODO: if plan.status is PlanGenerationResultStatus.INTERNAL_ERROR
    # Add error handling for the case when ENHSP fails to find a plan
    # then set error message in the UI and skip to running TEMPest to find plans (if ENHSP fails, we can still find plans with TEMPest, but we won't have the optimal plan from ENHSP)
    if plan.status != PlanGenerationResultStatus.SOLVED_OPTIMALLY:
        print(f"[pddlplanner] ERROR: ENHSP failed to find an optimal plan (status: {plan.status}). Proceeding to run TEMPest for plan generation.")
        return plan

    print(f"[pddlplanner] Plan found: {plan.plan}")

    # TODO: if plan.plan is None, it means that ENHSP failed to find a plan, so we should handle this case (e.g., by logging an error message and returning an empty plan or a specific error object)
    # Add error handling for the case when ENHSP fails to find a plan

    # Save
    file_name = 'plan_1.txt'
    savePlan(data_output_dir, plan, file_name)
    
    # Print
    print(f"[pddlplanner] Plan generated successfully. Saved in {file_name}")
    
    return plan


def savePlan(path, result, file_name):

    # Debugging: Check the path used for saving
    print(f"[pddlplanner] Saving plan to file: {os.path.join(path, file_name)}")
    
    # Save plan to txt file
    with open(os.path.join(path, file_name), 'w') as f:
        f.write(str(result.plan))
    
    print(f"[pddlplanner] Plan saved to file {path}")


    