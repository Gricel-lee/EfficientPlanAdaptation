import aux.json2pddl as json2pddl
import aux.pddlplanner as pddlplanner
import aux.plan2PMCfile as plan2PMCfile
import os

def main():
    # Set variables
    fpath ="./src/"
    fdomain = 'mrmh_planning_domain.pddl'
    fproblem = 'mrmh_planning_problem.pddl'
    
    # Generate PDDL files
    jsondata = json2pddl.main(fpath)
    
    # Import PDDL problem
    problem = pddlplanner.importPDDLproblem(fpath, fdomain, fproblem)
    #pddlplanner.printImportedPDDLproblem(problem)
    
    # Run PDDL planner
    plan = pddlplanner.runPlanner(problem, fpath,print=False)
    
    # Generate PRISM/Evochecker file from PDDL plan
    args = plan2PMCfile.parsePlan(plan)
    plan2PMCfile.createPRISMfile(fpath, plan, jsondata, args)
    plan2PMCfile.createPRISMfile(fpath, plan, jsondata, args, evoChecker=True)
    
    
    # Get the current working directory to get path
    current_directory = os.getcwd()
    print("Current working directory:", current_directory)

if __name__ == "__main__":
    main()