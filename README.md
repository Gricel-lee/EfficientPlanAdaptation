# Efficient task planning adaptation under uncertainty

## Abstract

A hybrid approach that effectively solves the task planning problem by decomposing it into two intertwined parts, starting with the identification of a feasible plan and followed by its uncertainty augmentation and verification yielding a set of Pareto optimal plans. To enhance its robustness, adaptation tactics are devised for the evolving system requirements and agent’s capabilities. We demonstrate our approach through an industrial case study involving workers and robots undertaking activities within a vineyard, showcasing the benefits of our hybrid approach both in the generation of feasible solutions and scalability compared to native planners.

![image](https://github.com/user-attachments/assets/a1ac9011-b261-4b4b-8350-0241fd0ffc89)



## Running hybrid planner

1) Download [EvoChecker](https://github.com/gerasimou/EvoChecker/tree/evoCheckerJar) inside [src/apps](https://github.com/Gricel-lee/EfficientPlanAdaptation/tree/main/src/apps). The new folder must contain the following files:
![image](https://github.com/Gricel-lee/EfficientPlanAdaptation/blob/multiplePlans/assets/images/dirFiles.png)

2) Modify ```run.sh``` and ```config.ini``` file with your installation paths.

3) Run the hybrid planner in the terminal as
```
./run.sh
```
This will automatically activate the Python environment, FastAPI, and the web app.

4) After running this script, the API and **web app** will be running locally at **```http://localhost:8001```** (port defined in run.sh).

Note: To test and submit a planning problem directly throught the API try ```http://localhost:8001/docs``` instead. For documentation on how FastAPI works, go to [FastAPI](https://fastapi.tiangolo.com/tutorial/first-steps/#interactive-api-docs).


The web app allows you to submit planning problems (a description and the path to the JSON path with the planning problem). 
<img width="585" height="413" alt="image" src="https://github.com/Gricel-lee/EfficientPlanAdaptation/blob/multiplePlans/assets/images/dashboard.png"/>

Check the Pareto front results when a planning problem is completed.

<img width="585" height="413" alt="image" src="https://github.com/Gricel-lee/EfficientPlanAdaptation/blob/multiplePlans/assets/images/dashboard-completed.png"/>

Check failure messages:

<img width="585" height="413" alt="image" src="https://github.com/Gricel-lee/EfficientPlanAdaptation/blob/multiplePlans/assets/images/dashboard-failed.png"/>

And delete planning problem:

<img width="585" height="413" alt="image" src="https://github.com/Gricel-lee/EfficientPlanAdaptation/blob/multiplePlans/assets/images/dashboard-delete.png"/>


Note: When a new planning problem is added, the Hybrid planner is started under-the-hood using our API. For example, the status of all jobs are avaialble at ```http://127.0.0.1:8001/api/problems/```.
 At completion, the hybrid planner should create a folder in the input .JSON file directory, with the generated data:
- Data from numerical planner: PDDL files, plan, EvoChecker files, execution times per run
- Data from uncertainty augmentation: Pareto front and set obtained per run, execution times per run


**Enjoy!**


## Full-MDP
To create a full-MDP PRISM file from a JSON file, go to:
```src/aux/fullMDP```


## Git commit note (for devs)
To submit changes, avoid large files by:
```
git add .
git reset src/prj-venv src/apps/EvoChecker/
git commit -m "."
git push
```

If requires hard reset, make copy of folder, then go back n commits, e.g., 1 commit behind:
```
git reset --hard HEAD~1
```
Go back to the last commit that was able to push
