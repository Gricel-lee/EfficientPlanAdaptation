# Run

## Create python environment

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

2) Download [EvoChecker](https://github.com/gerasimou/EvoChecker/tree/evoCheckerJar) inside src/apps. The new folder must contain the following files:
![image](https://github.com/user-attachments/assets/752140ef-b815-4eed-854f-06414dee453d)


3) Modify ```run.sh``` file with your installation paths:


4) Run the hybrid planner in the terminal as:
```
./run.sh
```
This should create a folder with the name of each of your .json files, with:
- Data from numerical planner: PDDL files, plan, EvoChecker files, execution times per run
- Data from uncertainty augmentation: Pareto front and set obtained per run, execution times per run

**Enjoy!**

## Full-MDP
To create a full-MDP PRISM file from a JSON file, go to:
```src/aux/fullMDP```


## Git note
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
