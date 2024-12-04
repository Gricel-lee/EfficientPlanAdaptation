# From tutorial:
# https://colab.research.google.com/github/aiplan4eu/unified-planning/blob/master/docs/notebooks/io/01-pddl-usage-example.ipynb#scrollTo=1xp1How6aClP

import os
from unified_planning.shortcuts import *
from unified_planning.engines import PlanGenerationResultStatus 
from unified_planning.io import PDDLReader #PDDLReader class to read PDDL files
from unified_planning.engines.results import PlanGenerationResult

def importPDDLproblem(path, fdomain, fproblem):  
    path = path + "data/"  
    # Initialize the PDDLReader
    reader = PDDLReader()
    # Get domain and problem
    problem = reader.parse_problem(path+fdomain, path+fproblem)
    return problem

def printImportedPDDLproblem(problem):
    print(problem)

def runPlanner(problem,path,print=True):
    path = path + "data/"
    # Get fluent from problem (for optimisation objective)       (https://unified-planning.readthedocs.io/en/stable/notebooks/io/01-pddl-usage-example.html)
    travel_dist = problem.fluent("travel_dist")    

    # Set metric to minimising travel distance
    problem.clear_quality_metrics()  # remove previous opt. metric
    problem.add_quality_metric(MinimizeExpressionOnFinalState(travel_dist())) # +++
    
    # Solve the problem optimally
    with OneshotPlanner(
        problem_kind=problem.kind,
        optimality_guarantee=PlanGenerationResultStatus.SOLVED_OPTIMALLY #(quality metric already set to minimize cost)
    ) as planner:
        plan:PlanGenerationResult = planner.solve(problem)
    
    # Print and save the plan
    if print:
        printPlan(plan)
    savePlan(path, plan)
    
    return plan


def printPlan(result):
    print(result.plan)
    
def savePlan(path, result):
    # save plan to txt file
    with open(path+'plan.txt', 'w') as f:
        f.write(str(result.plan))
    print(f"Plan saved to file {path}")
