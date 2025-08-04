# Efficient task planning adaptation under uncertainty

## Abstract

A hybrid approach that effectively solves the task planning problem by decomposing it into two intertwined parts, starting with the identification of a feasible plan and followed by its uncertainty augmentation and verification yielding a set of Pareto optimal plans. To enhance its robustness, adaptation tactics are devised for the evolving system requirements and agent’s capabilities. We demonstrate our approach through an industrial case study involving workers and robots undertaking activities within a vineyard, showcasing the benefits of our hybrid approach both in the generation of feasible solutions and scalability compared to native planners.

![image](https://github.com/user-attachments/assets/a1ac9011-b261-4b4b-8350-0241fd0ffc89)



## Running hybrid planner

1) Download [EvoChecker](https://github.com/gerasimou/EvoChecker/tree/evoCheckerJar) inside [src/apps](https://github.com/Gricel-lee/EfficientPlanAdaptation/tree/main/src/apps). The new folder must contain the following files:
![image](https://github.com/user-attachments/assets/752140ef-b815-4eed-854f-06414dee453d)

2) Modify ```run.sh``` and ```config.ini``` file with your installation paths.

3) Run the hybrid planner in the terminal as:
```
./run.sh
```
4) After running this script, the FastAPI server will be running.

For documentation and to check how it works, go to http://localhost:8001/docs

Here, you can interact with the server to submit a planning problem (for more documentation visit [FastAPI](https://fastapi.tiangolo.com/tutorial/first-steps/#interactive-api-docs) )
For example, in @post/problems/Add Problem, set a submit a new planning problem by providing the Json file and a description of the problem.

![alt text](image.png)

After executing this, the Hybrid planner is started under-the-hood. See the status and all jobs in @post/problems/Get All Planning Problems
 At completion, it should create a folder in the .json file folder, with:
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
