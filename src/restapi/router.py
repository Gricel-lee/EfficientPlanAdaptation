# api/router.py
from arch.config.config import PROBLEM_OUTPUT_JSON
from fastapi import APIRouter, HTTPException, status, BackgroundTasks
from typing import List
from restapi.models import Problem, Problem2Create
from restapi import planner_service
from typing import Dict


# --------------------------
# Initialize in-memory database   #@TODO: from db.memory_db import PROBLEM_DATABASE # Needed for background task
PROBLEM_DATABASE: Dict[str, Problem] = {}


# --------------------------
# 1.Create a separate router for the API with prefix
api_router = APIRouter(prefix="/api", tags=["HybridPlanning"])

# --------------------------
# 2. Define the API endpoints on the new router api_router
#    Note: All decorators are now @api_router instead of @app
# --------------------------
@api_router.post("/problems/", response_model=Problem, status_code=status.HTTP_201_CREATED)
async def add_n_run_problem(problem_in: Problem2Create, background_tasks: BackgroundTasks) -> Problem:
    # Call the service to create the problem
    new_problem = planner_service.create_and_start_problem(problem_in)
    # Run problem object as a background task
    background_tasks.add_task(planner_service.run_hybrid_planner, new_problem, PROBLEM_DATABASE)
    return new_problem

@api_router.get("/problems/", response_model=List[Problem])
def get_all_planning_problems():
    print("[Router] Retrieving all problems.")
    return planner_service.get_all_problems()

@api_router.get("/problems/{problem_id}", response_model=Problem)
def get_problem(problem_id: str):
    problem = planner_service.get_problem_by_id(problem_id)
    if not problem:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Problem with ID '{problem_id}' not found.")
    return problem

@api_router.get("/problems/{problem_id}/output_json")
def get_problem_output_json(problem_id: str):
    output_json = PROBLEM_OUTPUT_JSON.get(problem_id)
    if not output_json:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Output JSON for problem ID '{problem_id}' not found.")
    # read the content of the file and return it as a string
    with open(output_json, 'r') as f:
        return f.read()

@api_router.get("/problems/{problem_id}/results")
def get_problem_results(problem_id: str):
    results = planner_service.get_results_for_problem(problem_id)
    if not results:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=PROBLEM_DATABASE[problem_id].error_message)
    return results

@api_router.delete("/problems/{problem_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_problem(problem_id: str):
    success = planner_service.delete_problem_by_id(problem_id)
    if not success:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Problem with ID '{problem_id}' not found.")
    return

@api_router.get("/problems/{problem_id}/timeline")
def get_problem_timeline(problem_id: str):
    timeline = planner_service.get_timeline_for_problem(problem_id)
    if timeline is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Timeline for problem ID '{problem_id}' not found.")
    return timeline
