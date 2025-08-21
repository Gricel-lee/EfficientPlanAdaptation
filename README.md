# Efficient task planning adaptation under uncertainty

## Abstract

A hybrid approach that effectively solves the task planning problem by decomposing it into two intertwined parts, starting with the identification of a feasible plan and followed by its uncertainty augmentation and verification yielding a set of Pareto optimal plans. To enhance its robustness, adaptation tactics are devised for the evolving system requirements and agent’s capabilities. We demonstrate our approach through an industrial case study involving workers and robots undertaking activities within a vineyard, showcasing the benefits of our hybrid approach both in the generation of feasible solutions and scalability compared to native planners.

![image](https://github.com/user-attachments/assets/a1ac9011-b261-4b4b-8350-0241fd0ffc89)



## Running the hybrid planning

Follow the steps to run the hybrid task planner from the terminal! 

1) First, create a python environment:
```
cd src
python3 -m venv prj-venv
```
(or python)

```
source prj-venv/bin/activate
pip install -r requirements.txt
```
(or pip3)

For reference: https://www.dataquest.io/blog/a-complete-guide-to-python-virtual-environments/

2) Download [EvoChecker](https://github.com/gerasimou/EvoChecker/tree/evoCheckerJar) inside [src/apps](https://github.com/Gricel-lee/EfficientPlanAdaptation/tree/main/src/apps). The new folder must contain the following files:
![image](https://github.com/user-attachments/assets/752140ef-b815-4eed-854f-06414dee453d)


3) Modify ```run.sh``` file with your installation paths.


4) Run the hybrid planner in the terminal as:
```
./run.sh
```
This should create a folder with the name of each of your .json files, with:
- Data from numerical planner: PDDL files, plan, EvoChecker files, execution times per run
- Data from uncertainty augmentation: Pareto front and set obtained per run, execution times per run

**Enjoy!**

## Specify a new planning problem

Planning problems are specified using JSON files located in the INPUT_DIR path, as defined in run.sh. These JSON files contain the full description of the task, including agents, locations, paths, and mission constraints. To create a new planning problem, follow the structure of the example file:```src/Problems/Agricultural/agricultural.json```:
Guidelines for Creating JSON Planning Files:
- Do not use underscores (_) in any ID names.
- All IDs must be unique.
- Probabilities must be specified as floating-point numbers between 0.0 and 1.0, with at least one decimal place.
- Task instance IDs must follow the pattern: taskID + locationID + uniqueCharacter (e.g., t2l5a where t2 is the task, l5 is the location, and a differentiates the instance).



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


## Errors

### Error when installing the python environment.
If the python environment initialisation fails, try replace ```src/requirements.txt``` content for:
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
