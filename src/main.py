#---------------- Routing Logic for the Hybrid Task Planner API ----------------

# REST API: to manage the list of problems (create, read, update, delete)

# Necessary libraries
#    FastAPI: The web framework
#    BaseModel: From Pydantic, for data validation and modeling
#    datetime: To get the current timestamp for 'date_creation'
#    uuid: To generate a unique ID for each problem
#    List: To type-hint the response for getting all problems

# To run this application:
# 1. Create a 'config.ini' file in the same directory as this script with all variables.
# 2. Make sure you have FastAPI and Uvicorn installed:
#    source prj-venv/bin/activate
# 3. Run the server from your terminal:
#    uvicorn main:app --reload
# 4. Open your browser and go to http://127.0.0.1:8000/docs to see the interactive API documentation.


import uuid
from datetime import datetime
from typing import Dict, List, Literal
from fastapi import FastAPI, HTTPException, status, BackgroundTasks
from restapi.aux import run_hybrid_planner

# --------------------------
# 1. Import the Pydantic models
from restapi.model import Problem, Problem2Create, Problem

# --------------------------
# 2. Initialize in-memory database, key is problem ID, value is Problem object (can be extended to a real database, e.g., SQLite, PostgreSQL)
PROBLEM_DATABASE: Dict[str, Problem] = {}

# --------------------------
# 3. Initialize the FastAPI application
app = FastAPI(
    title="Problem Management API",
    description="A simple API to create and manage problems.",
    version="1.0.0"
)

# --------------------------
# 4. REST API endpoints/methods
# 4.1 Add and execute a new planning problem
@app.post("/problems/", response_model=Problem, status_code=status.HTTP_201_CREATED, tags=["HybridPlanning"])
async def add_problem(problem_in: Problem2Create, background_tasks: BackgroundTasks):
    """
    Create a new problem and add it to the database.
    """
    # Generate a new unique ID
    problem_id = uuid.uuid4().hex

    # Create a new Problem instance
    new_problem = Problem(
        id=problem_id,
        description=problem_in.description,
        json_file=problem_in.json_file,
        date_creation=datetime.now(),
        status="created"
    )
    
    PROBLEM_DATABASE[problem_id] = new_problem
    
    # Start the background task to process the planning problem
    background_tasks.add_task(run_hybrid_planner, new_problem, PROBLEM_DATABASE)
    
    return new_problem

# 4.2 Get all problems
@app.get("/problems/", response_model=List[Problem], tags=["HybridPlanning"])
def get_all_planning_problems():
    """
    Retrieve a list of all problems in the database.
    """
    # The values() method of a dictionary returns a view of the values.
    # We convert it to a list to ensure proper JSON serialization.
    return list(PROBLEM_DATABASE.values())


# 4.3 Get a problem by ID
@app.get("/problems/{problem_id}", response_model=Problem, tags=["HybridPlanning"])
def get_problem_by_id(problem_id: str):
    """
    Retrieve a single problem by its unique ID.

    If a problem with the given ID is not found, it returns an
    HTTP 404 Not Found error.
    """
    problem = PROBLEM_DATABASE.get(problem_id)
    if not problem:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Problem with ID '{problem_id}' not found."
        )
    return problem





# # Add the code to run the FastAPI app directly using uvicorn
# if __name__ == "__main__":
#     uvicorn.run(app, host="127.0.0.1", port=8000)