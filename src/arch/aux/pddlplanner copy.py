import os
from unified_planning.shortcuts import *
from unified_planning.engines import PlanGenerationResultStatus 
from unified_planning.io import PDDLReader  # PDDLReader class to read PDDL files
from unified_planning.engines.results import PlanGenerationResult

def importPDDLproblem(data_output_dir, f_domain, f_problem):  
    print(f"[pddlplanner] Processing PDDL problem: {f_domain} and {f_problem}")  # Debugging line to show file names
    data_output_dir# = os.path.join(data_output_dir, "data")  # Correct path concatenation
    
    print(data_output_dir+"<=")
    
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

def printImportedPDDLproblem(problem):
    print(f"[pddlplanner] Imported PDDL problem")




def selectPlanner(problem, data_output_dir):
    '''
    Select the planner based on the problem kind.
    '''
    # print(f"[pddlplanner] Selecting planner for problem kind: {problem.kind}")
    
    # if problem.kind == ProblemKind.OPTIMIZATION:
    #     print(f"[pddlplanner] Using OneshotPlanner for optimization problem.")
    #     return OneshotPlanner(problem_kind=problem.kind, optimality_guarantee=PlanGenerationResultStatus.SOLVED_OPTIMALLY)
    # else:
    #     print(f"[pddlplanner] Using OneshotPlanner for non-optimization problem.")
    #     return OneshotPlanner(problem_kind=problem.kind)
    
    # Solve the problem optimally
    
    planners = ["enhsp", "enhsp-optimal", "tamer"]
    planner2use = "optimal"
    
    # Documentation: https://unified-planning.readthedocs.io/en/latest/operation_modes.html
    # Future work. See section: PortfolioSelector
    #------
    print(f"[pddlplanner] Solving the problem enhsp...")
    with OneshotPlanner(
        problem_kind=problem.kind,
        optimality_guarantee=PlanGenerationResultStatus.SOLVED_OPTIMALLY  # quality metric already set to minimize cost
    ) as planner:
        plan: PlanGenerationResult = planner.solve(problem)
    savePlan(data_output_dir, plan, file_name='plan_enhsp.txt')
    
    
    #-----
    with OneshotPlanner(
        names=["tamer"],#["tamer", "pyperplan"],
        params=[{"heuristic": "hadd", "weight": 0.8}, {}],
    ) as planner:
        result = planner.solve(problem)
        print(result)
        
    
    #------
    print(f"[pddlplanner] Solving the problem enhsp optimally...")
    with OneshotPlanner(
        problem_kind=problem.kind,
    ) as planner:
        plan: PlanGenerationResult = planner.solve(problem)
    savePlan(data_output_dir, plan, file_name='plan_enhsp_opt.txt')
    
    #------
    print(f"[pddlplanner] Solving the problem using anytime planner...")
    with AnytimePlanner(
        problem_kind=problem.kind, anytime_guarantee="INCREASING_QUALITY"
    ) as planner:
        for i, p in enumerate(planner.get_solutions(problem)):
            plan = p.plan
            savePlan(data_output_dir, plan, file_name=f"plan_anytimeplanner_{i}.txt")
            # print(f"{i+1}) {p.plan.actions}")
            # if len(p.plan.actions) <= 4:
            #     print("Done!")
            #     break
    
    
    #elif planner2use == "tamer":
    print(f"[pddlplanner] Solving the problem using tamer...")
    
    
    return plan



def runPlanner(problem, data_output_dir):
    '''
    Run the planner with the given PDDL problem and save the plan to a file.
    '''
    print(f"[pddlplanner] Running planner with problem at: {data_output_dir}")  # Debugging line to show the problem being passed
    
    # Get fluent from problem (for optimisation objective)
    travel_dist = problem.fluent("travel_dist")    
    print(f"[pddlplanner] Found fluent 'travel_dist'")
    
    # Set metric to minimizing travel distance
    problem.clear_quality_metrics()  # remove previous optimization metric
    problem.add_quality_metric(MinimizeExpressionOnFinalState(travel_dist()))  # +++
    print(f"[pddlplanner] Quality metric set to minimize travel distance.")

    # Solve and save planning problem
    plan = selectPlanner(problem, data_output_dir)
    
    # Print
    print(f"[pddlplanner] Plans generated successfully.")
    
    return plan


def savePlan(path, result, file_name='plan.txt'):

    # Debugging: Check the path used for saving
    print(f"[pddlplanner] Saving plan to file: {os.path.join(path, file_name)}")
    
    # Save plan to txt file
    with open(os.path.join(path, 'plan.txt'), 'w') as f:
        f.write(str(result.plan))
    
    print(f"[pddlplanner] Plan saved to file {path}")