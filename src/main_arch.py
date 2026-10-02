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
# 6. Mount Static Files Directories
#    These must come AFTER all your API routes are included. "/assets" (the repo-root
#    assets/ folder, a sibling of src/ - outside src/static/) is mounted BEFORE the
#    catch-all "/" mount below, since Starlette tries mounts in registration order and
#    "/" would otherwise swallow every "/assets/..." request first. It's what lets the
#    Visual Problem Editor's background-image paths like "../assets/background/qdc.jpg"
#    actually resolve in the browser - without this mount, assets/ was never reachable
#    over HTTP at all, regardless of what any JSON's "background.path" said.
# --------------------------
app.mount("/assets", StaticFiles(directory="../assets"), name="assets")
app.mount("/", StaticFiles(directory="static", html=True), name="static")