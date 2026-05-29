# Efficient task planning adaptation under uncertainty

## Abstract

A hybrid approach that effectively solves the task planning problem by decomposing it into two intertwined parts, starting with the identification of a feasible plan and followed by its uncertainty augmentation and verification yielding a set of Pareto optimal plans. To enhance its robustness, adaptation tactics are devised for the evolving system requirements and agent’s capabilities. We demonstrate our approach through an industrial case study involving workers and robots undertaking activities within a vineyard, showcasing the benefits of our hybrid approach both in the generation of feasible solutions and scalability compared to native planners.

![image](https://github.com/user-attachments/assets/a1ac9011-b261-4b4b-8350-0241fd0ffc89)

## Install and Run ARCH hybrid planner

**Modify** ```config.ini``` file path

```
HP_PATH = /home/{your_path}/EfficientPlanAdaptation/src
```

Install and run ARCH Docker or locally.


### Using Docker 

Refer to [README-Docker](README-Docker.md) for instructions to create and run ARCH as a Docker container. Skip the next steps until ARCH UI. 


### Local installation

#### Install and run ARCH locally

Jump to 4) to run ARCH. To install:

1) **Download** [EvoChecker](https://github.com/gerasimou/EvoChecker/tree/evoCheckerJar) inside [src/arch/apps/EvoChecker](https://github.com/Gricel-lee/EfficientPlanAdaptation/tree/main/src/arch/apps). The new folder must contain the following files:
![image](https://github.com/Gricel-lee/EfficientPlanAdaptation/blob/multiplePlans/assets/images/dirFiles.png)

2) Create a **python environment** from src/arch/requirements.txt file:
```
cd src/arch
python3 -m venv prj-venv
```
(or python)

```
source prj-venv/bin/activate
pip install -r requirements.txt
deactivate
cd ../..
```
(or pip3). For reference: https://www.dataquest.io/blog/a-complete-guide-to-python-virtual-environments/


3) Make run_task.sh executable by running ```chmod +x run.sh```. 


4) Run ARCH locally

**Run** from terminal.
```
./run.sh
```
This will automatically activate the Python environment, Rest API, and the web app.


## ARCH UI

The API and **web app** will be running locally at **```http://localhost:8001```** (port 8001 defined in run.sh).

Note: To test and submit a planning problem directly through the API try ```http://localhost:8001/docs``` instead. For documentation on how FastAPI works, go to [FastAPI](https://fastapi.tiangolo.com/tutorial/first-steps/#interactive-api-docs).

## Interacting with web app

The web app allows you to submit planning problems (a description and the path to the JSON file with the planning problem). 
<img width="585" height="413" alt="image" src="https://github.com/Gricel-lee/EfficientPlanAdaptation/blob/multiplePlans/assets/images/dashboard.png"/>

Check the Pareto front results when a planning problem is completed.

<img width="585" height="413" alt="image" src="https://github.com/Gricel-lee/EfficientPlanAdaptation/blob/multiplePlans/assets/images/dashboard-completed.png"/>

Check failure messages:

<img width="585" height="413" alt="image" src="https://github.com/Gricel-lee/EfficientPlanAdaptation/blob/multiplePlans/assets/images/dashboard-failed.png"/>

And delete a planning problem:

<img width="585" height="413" alt="image" src="https://github.com/Gricel-lee/EfficientPlanAdaptation/blob/multiplePlans/assets/images/dashboard-delete.png"/>


Note: When a new planning problem is added, the Hybrid planner is started under-the-hood using our API. For example, the status of all jobs are available at ```http://127.0.0.1:8001/api/problems/```.

#### Generated files

At completion, the hybrid planner generates data in the following locations depending on the input:

- From JSON: creates a folder at the same path as the input .JSON file ```output_{name_of_JSON_file}_{problem_random_id}```
- From natural language: creates a folder at ```/output/temp/output_generated_problem_{json_random_id}{problem_random_id}```

The data contains:
- Data from numerical planner: PDDL files, plan, EvoChecker files, execution times per run
- Data from uncertainty augmentation: Pareto front and set obtained per run, execution times per run



**Enjoy!**

# Configuration

## Configuring EvoChecker

1) **Modify** ```config.ini``` file with EvoChecker parameters. 
Do not modify Python path, except if running local Python instead of venv.





# Additional notes

## Full-MDP
To create a full-MDP PRISM file from a JSON file, go to:
```src/aux/fullMDP```


## Git commit note (for devs)
To submit changes, add .gitignore to avoid committing large files, python environment, etc. Optionally, avoid large files by:
```
git add .
git reset src/prj-venv src/apps/EvoChecker/
git commit -m "."
git push
```

If hard reset is required due to trying to commit a large file (an error will appear), make a copy of the folder, then go back n commits, e.g., 1 commit behind:
```
git reset --hard HEAD~1
```
Go back to the last commit that was able to push without large files.

## Architecture notes

ARCH uses REST API. The src/restapi/ folder contains the API logic (routes, models, services). By default, FastAPI handles the HTTP server.



# Q&A

### Error when installing the python environment.
If the python environment initialisation fails, try replacing ```src/requirements.txt``` content for:
```
fastapi==0.116.1
fastapi-cli==0.0.8
fastapi-cloud-cli==0.1.5
unified-planning==1.2.0
up-aries==0.4.0
up-enhsp==0.0.27
up-fmap==0.0.13
up-pyperplan==1.1.0
up-symk==1.3.1
#up-tamer==1.1.4
#up_fast_downward==0.5.0
#up_lpg==0.1.2
matplotlib==3.7.3
```

### When creating the virtual environment, ERROR: pip's dependencies
This error can be ignored:
```
ERROR: pip's dependency resolver does not currently take into account all the packages that are installed. This behaviour is the source of the following dependency conflicts.
generate-parameter-library-py 0.4.0 requires jinja2, which is not installed.
generate-parameter-library-py 0.4.0 requires typeguard, which is not installed.
```



### Error: ModuleNotFoundError: No module named 'tempest' (detailed)

The TempEST solver library has not been installed (or the python environment has not been configured properly). To install the TempEST solver library, first activate the python environment:
```
source src/arch/prj-venv/bin/activate
```
TemPEST relies on [PySMT](https://github.com/pysmt/pysmt) to interface with SMT/OMT solvers. You must install PySMT and at least one solver (e.g., Z3):
```
pip3 install --pre pysmt
pysmt-install --z3
```
Then install TemPEST from the following directory:
```
cd src/arch/apps/tempest/
pip install .
```
Finally, deactivate the python env: 
```
deactivate
```
and try running ARCH again.