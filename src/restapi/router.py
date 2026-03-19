# api/router.py
from arch.config.config import PROBLEM_OUTPUT_JSON, TEMP_PATH, ACCEPTANCE_RATES_FILE, COGNITIVE_STATE_FILE
from fastapi import APIRouter, HTTPException, status, BackgroundTasks, Request, UploadFile, File
from typing import List, Dict
from restapi.models import Problem, Problem2Create, ProblemFromTextCreate, SelectedUser
from restapi.services import planner_service, explanation_service
from arch.memory_db.memory_db import PROBLEM_DATABASE
import os, uuid, json


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

@api_router.post("/upload-json")
async def upload_json_file(file: UploadFile = File(...)):
    """Upload a JSON file from the user's local machine and store it in the temp directory."""
    contents = await file.read()
    # Validate it's valid JSON
    try:
        json_data = json.loads(contents)
    except json.JSONDecodeError:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Invalid JSON file.")
    # Save to temp directory
    os.makedirs(TEMP_PATH, exist_ok=True)
    unique_id = uuid.uuid4().hex[:8]
    # Use original filename (without extension) + unique suffix
    original_name = os.path.splitext(file.filename)[0] if file.filename else "uploaded_problem"
    output_path = os.path.join(TEMP_PATH, f"{original_name}_{unique_id}.json")
    with open(output_path, "w", encoding="utf-8") as f:
        json.dump(json_data, f, indent=2)
    print(f"[Router] Saved uploaded JSON to {output_path}")
    return {"json_file_path": output_path}


@api_router.post("/problems/from-text/", response_model=Problem, status_code=status.HTTP_201_CREATED)
async def create_problem_from_text(problem_text: ProblemFromTextCreate, background_tasks: BackgroundTasks):
    # Log problem details for debugging
    print("[Router] Received problem from text input:")
    print(f"  Description: {problem_text.description[:50]}..." if len(problem_text.description) > 50 else f"  Description: {problem_text.description}")
    print(f"  Text length: {len(problem_text.text)} characters")
    print(f"  Text preview: {problem_text.text[:200]}..." if len(problem_text.text) > 200 else f"  Text: {problem_text.text}")
    # Convert text to JSON planning problem
    json_problem = planner_service.convert_text_to_json_problem(problem_text.text)
    if not json_problem:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Failed to convert text to JSON planning problem.")
    # Create Problem2Create object
    problem_in = Problem2Create(description=problem_text.description, json_file=json_problem)
    # Create and start the problem
    new_problem = planner_service.create_and_start_problem(problem_in)
    # Run problem object as a background task
    background_tasks.add_task(planner_service.run_hybrid_planner, new_problem, PROBLEM_DATABASE)
    return new_problem



# ----------- Explanation related endpoints ---------- 

@api_router.post("/problems/{problem_id}/explain-solution")
async def explain_solution(problem_id: str, payload: dict):
    print(f"[Router] Received request to explain solution for problem ID: {problem_id} with payload: {payload}")
    problem = planner_service.get_problem_by_id(problem_id)
    print(f"[Router] Retrieved problem: {problem}")
    if not problem:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Problem with ID '{problem_id}' not found.")
    solution_index = payload.get("solution_index", 0)
    solution_data = payload.get("solution_data", [])
    
    role = payload.get("role", "non-expert")
    format = payload.get("format", "detailed")
    levelDetail = payload.get("levelDetail", "technical")
    tone = payload.get("tone", "formal")

    explanation = planner_service.explain_solution(problem, solution_index, solution_data,
                                                role, format, levelDetail, tone)
    return {"explanation": explanation}



@api_router.get("/acceptance-rates")
def get_acceptance_rates():
    """Returns acceptance/rejection rates per role from the configured JSON file."""
    with open(ACCEPTANCE_RATES_FILE, 'r') as f:
        return json.load(f)


@api_router.put("/acceptance-rates")
def update_acceptance_rates(data: dict):
    """Writes updated acceptance/rejection rates back to the JSON file."""
    with open(ACCEPTANCE_RATES_FILE, 'w') as f:
        json.dump(data, f, indent=4)
    return data


@api_router.get("/cognitive-state")
def get_cognitive_state():
    """Returns cognitive attention/understanding state from the configured JSON file."""
    with open(COGNITIVE_STATE_FILE, 'r') as f:
        return json.load(f)


@api_router.put("/cognitive-state")
def update_cognitive_state(data: dict):
    """Writes updated cognitive state back to the JSON file."""
    with open(COGNITIVE_STATE_FILE, 'w') as f:
        json.dump(data, f, indent=4)
    return data


@api_router.post("/problems/{problem_id}/explanation-params")
def get_explanation_params(problem_id: str, user: SelectedUser):
    print(f"[Router] Obtaining prompt filling values (level of detail, tone and format) for problem ID: {problem_id} for user role: {user.role}")
    explanation_vars = explanation_service.get_explan_params_POMDP_policy(problem_id, user.role)
    return explanation_vars