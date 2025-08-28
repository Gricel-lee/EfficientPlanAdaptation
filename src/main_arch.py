#---------------- Hybrid Task Planner Main Application ----------------
# REST API: to manage the list of planning problems (add, fetch, delete)

# To run this application:
# 1. Ensure your follow the GitHub README installation instructions.
# 2. Run the API and application from your terminal, all by running:
#    ./run.sh
# 3. Open your browser and go to http://127.0.0.1:8001/ to see the UI.

# Optionally, use cmd to interact with the API endpoints directly. See
# http://127.0.0.1:8001/docs for more information. Example, to add a new planning problem:
# curl -X 'POST' \
#   'http://127.0.0.1:8001/api/problems/' \
#   -H 'accept: application/json' \
#   -H 'Content-Type: application/json' \
#   -d '{
#   "description": "My Planning Problem",
#   "json_file": "../assets/planningProblem/example.json"
# }'


# Import APIRouter
from fastapi import FastAPI, HTTPException, status, BackgroundTasks, APIRouter
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware


# --------------------------
# 2. Import the api router
from restapi.router import api_router

# --------------------------
# 3. Initialize the FastAPI application
app = FastAPI(
    title="Hybrid Planner Main App",
    description="Serves the frontend application and the backend API.",
    version="1.2.0"
)

# --------------------------
# 4. Add CORS Middleware to the main app
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins for development
    allow_credentials=True,
    allow_methods=["*"],  # Allows all HTTP methods
    allow_headers=["*"],  # Allows all headers
)

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





# @api_router.get("/problems/{problem_id}/results", tags=["HybridPlanning"])
# def get_problem_results(problem_id: str):
#     """
#     Reads and returns the JSON results file for a completed problem.
#     """
#     # Construct the path to the results file, assuming a name like 'results.json'
#     # This path must match where your 'run_hybrid_planner' saves its output.
    
#     # @deprecated
#     # problem = PROBLEM_DATABASE[problem_id]
#     # problem_dir = os.path.dirname(problem.json_file)
#     # results_dir = os.path.join(problem_dir, f"data_{problem.description}", "dataevochecker_run1/NSGAII/")
#     # TODO: TEST config.PROBLEM_OUTPUT_DIR[problem_id] is set correctly
#     output_dir = config.PROBLEM_OUTPUT_DIR[problem_id]
#     run = 1 # get only first run, more than one run might exist
#     results_dir = os.path.join(output_dir, "dataevochecker_run" + str(run) + "/"+config.MOEA+"/")

#     print(f"[HybridPlanner] Looking for results in: {results_dir}")
    
#     # Check if the results directory exists
#     if not os.path.exists(results_dir):
#         PROBLEM_DATABASE[problem_id].status = "failed"
#         PROBLEM_DATABASE[problem_id].error_message = f"Results directory {results_dir} not found."
#         raise HTTPException(
#             status_code=status.HTTP_404_NOT_FOUND,
#             detail= PROBLEM_DATABASE[problem_id].error_message
#         )
        

#     #search for first file that ends in _FRONT
#     for file in os.listdir(results_dir):
#         if file.endswith("_Front"):
#             results_path = os.path.join(results_dir, file)
#             break

#     if not os.path.exists(results_path):
#         PROBLEM_DATABASE[problem_id].status = "failed"
#         PROBLEM_DATABASE[problem_id].error_message = "Results file not found. The process may not be complete or it may have failed."
#         raise HTTPException(
#             status_code=status.HTTP_404_NOT_FOUND,
#             detail=PROBLEM_DATABASE[problem_id].error_message
#         )
    
#     x_values = []
#     y_values = []
    
#     try:
#         with open(results_path, 'r') as f:
#             lines = f.readlines()
#             if not lines:
#                 raise ValueError("Results file is empty.")

#             # Parse the header line
#             header_line = lines[0].strip()
#             # Split by tabs
#             header_parts = header_line.split("\t",1)
#             if len(header_parts) == 2:
#                 x_label, y_label = header_parts

#             # Parse the data lines
#             for line in lines[1:]:
#                 line = line.strip()
#                 if not line:
#                     continue
                
#                 parts = line.split()
#                 if len(parts) == 2:
#                     x_values.append(float(parts[0]))
#                     y_values.append(float(parts[1]))

#         return {
#             "x_label": x_label,
#             "y_label": y_label,
#             "x_values": x_values,
#             "y_values": y_values
#         }

#     except Exception as e:
#         raise HTTPException(
#             status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
#             detail=f"Failed to read or parse results file: {e}"
#         )
        


