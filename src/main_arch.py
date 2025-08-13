#---------------- Routing Logic for the Hybrid Task Planner API ----------------

# REST API: to manage the list of problems (create, read, update, delete)

# To run this application:
# 1. Ensure your project structure is correct (static folder, etc.).
# 2. Make sure you have FastAPI and Uvicorn installed:
#    source prj-venv/bin/activate
# 3. Run the server from your terminal, all by running:
#    ./run.sh
# 4. Open your browser and go to http://127.0.0.1:8001/ to see the UI.

import uuid
from datetime import datetime
from typing import Dict, List
import os
# Import APIRouter
from fastapi import FastAPI, HTTPException, status, BackgroundTasks, APIRouter
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware

# Assuming these are in a 'restapi' subfolder as per your code
from arch.aux.auxiliary_api import run_hybrid_planner 
from restapi.model import Problem, Problem2Create
import arch.config.config as config 

# --------------------------
# 1. Initialize in-memory database
PROBLEM_DATABASE: Dict[str, Problem] = {}

# --------------------------
# 2. Initialize the FastAPI application
app = FastAPI(
    title="Hybrid Planner Main App",
    description="Serves the frontend application and the backend API.",
    version="1.2.0"
)

# Create a separate router for the API with a prefix
api_router = APIRouter(prefix="/api")


# --------------------------
# 3. Add CORS Middleware to the main app
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins for development
    allow_credentials=True,
    allow_methods=["*"],  # Allows all HTTP methods
    allow_headers=["*"],  # Allows all headers
)

# --------------------------
# 4. Define API Endpoints on the new router
#    Note: All decorators are now @api_router instead of @app
# --------------------------

@api_router.post("/problems/", response_model=Problem, status_code=status.HTTP_201_CREATED, tags=["HybridPlanning"])
async def add_problem(problem_in: Problem2Create, background_tasks: BackgroundTasks):
    """
    Create a new problem, add it to the database, and start the
    background processing task.
    """
    problem_id = uuid.uuid4().hex
    print(f"Received {problem_in.description} with ID: {problem_id}")
    new_problem = Problem(
        id=problem_id,
        description=problem_in.description,
        json_file=problem_in.json_file,
        date_creation=datetime.now(),
        status="created"
    )
    print(f"[HybridPlanner] Adding new problem with ID: {problem_id}")
    PROBLEM_DATABASE[problem_id] = new_problem
    background_tasks.add_task(run_hybrid_planner, new_problem, PROBLEM_DATABASE)
    return new_problem

@api_router.get("/problems/", response_model=List[Problem], tags=["HybridPlanning"])
def get_all_planning_problems():
    """
    Retrieve a list of all problems in the database.
    """
    print("[HybridPlanner] Retrieving all problems.")
    return list(PROBLEM_DATABASE.values())

@api_router.get("/problems/{problem_id}", response_model=Problem, tags=["HybridPlanning"])
def get_problem_by_id(problem_id: str):
    """
    Retrieve a single problem by its unique ID.
    """
    problem = PROBLEM_DATABASE.get(problem_id)
    if not problem:
        raise HTTPException(status_code=404, detail=f"Problem with ID '{problem_id}' not found.")
    return problem

# In main.py, add this with your other @api_router functions

import json # Make sure to import the json library at the top of your file

@api_router.get("/problems/{problem_id}/results", tags=["HybridPlanning"])
def get_problem_results(problem_id: str):
    """
    Reads and returns the JSON results file for a completed problem.
    """
    # Construct the path to the results file, assuming a name like 'results.json'
    # This path must match where your 'run_hybrid_planner' saves its output.
    
    # @deprecated
    # problem = PROBLEM_DATABASE[problem_id]
    # problem_dir = os.path.dirname(problem.json_file)
    # results_dir = os.path.join(problem_dir, f"data_{problem.description}", "dataevochecker_run1/NSGAII/")
    # TODO: TEST config.PROBLEM_OUTPUT_DIR[problem_id] is set correctly
    output_dir = config.PROBLEM_OUTPUT_DIR[problem_id]
    run = 1 # get only first run, more than one run might exist
    results_dir = os.path.join(output_dir, "dataevochecker_run" + str(run) + "/"+config.MOEA+"/")

    print(f"[HybridPlanner] Looking for results in: {results_dir}")
    
    # Check if the results directory exists
    if not os.path.exists(results_dir):
        PROBLEM_DATABASE[problem_id].status = "failed"
        PROBLEM_DATABASE[problem_id].error_message = f"Results directory {results_dir} not found."
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail= PROBLEM_DATABASE[problem_id].error_message
        )
        

    #search for first file that ends in _FRONT
    for file in os.listdir(results_dir):
        if file.endswith("_Front"):
            results_path = os.path.join(results_dir, file)
            break

    if not os.path.exists(results_path):
        PROBLEM_DATABASE[problem_id].status = "failed"
        PROBLEM_DATABASE[problem_id].error_message = "Results file not found. The process may not be complete or it may have failed."
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=PROBLEM_DATABASE[problem_id].error_message
        )
    
    x_values = []
    y_values = []
    
    try:
        with open(results_path, 'r') as f:
            lines = f.readlines()
            if not lines:
                raise ValueError("Results file is empty.")

            # Parse the header line
            header_line = lines[0].strip()
            # Split by tabs
            header_parts = header_line.split("\t",1)
            if len(header_parts) == 2:
                x_label, y_label = header_parts

            # Parse the data lines
            for line in lines[1:]:
                line = line.strip()
                if not line:
                    continue
                
                parts = line.split()
                if len(parts) == 2:
                    x_values.append(float(parts[0]))
                    y_values.append(float(parts[1]))

        return {
            "x_label": x_label,
            "y_label": y_label,
            "x_values": x_values,
            "y_values": y_values
        }

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to read or parse results file: {e}"
        )
        
@api_router.delete("/problems/{problem_id}", status_code=status.HTTP_204_NO_CONTENT, tags=["HybridPlanning"])
def delete_problem(problem_id: str):
    """
    Delete a problem from the database by its ID.
    """
    if problem_id not in PROBLEM_DATABASE:
        raise HTTPException(status_code=404, detail=f"Problem with ID '{problem_id}' not found.")
    del PROBLEM_DATABASE[problem_id]
    return

# --------------------------
# 5. Include the API router in the main app
#    This makes all the @api_router endpoints active under the /api prefix.
# --------------------------
app.include_router(api_router)

# --------------------------
# 6. Mount Static Files Directory
#    This must come AFTER all your API routes are included.
# --------------------------
app.mount("/", StaticFiles(directory="static", html=True), name="static")
