import numpy as np
import os

def get_all_files_in_subfolders(folder_path):
    '''Get all files in subfolders'''
    file_paths = []
    for root, dirs, files in os.walk(folder_path):
        for file in files:
            file_path = os.path.join(root, file)
            file_paths.append(file_path)
    return file_paths

def read_points_from_Evofile(filename):
    '''Read Pareto front points'''
    points = []
    # Open the file and read the data
    with open(filename, 'r') as file:
        count = []
        for line in file:
            if line!="\n":
                count.append(line)
    count = count[2:]
    print(count)
    return count



# 1) Run for: Check mean number of solutions and std
folder_path = '/Users/grisv/GitHub/EfficientPlanAdaptation/RQ1-3/RQ1/EvoChecker/FullMDP-4'  # Replace with the path to your folder
files = get_all_files_in_subfolders(folder_path)
front_or_set = "s" # f or s

n_sol = []
n_sum = 0
fs = {"f":"ront","s":"_Set"}
for file_path in files:
    if file_path[-4:] == fs[front_or_set]:
        print(file_path)
        
        n_sol.append( len(set(read_points_from_Evofile(file_path))) )
        n_sum+= n_sol[-1]
print(n_sol)
print(fs[front_or_set])
print("Avg num of sol:" , (n_sum/len(n_sol)))
print(np.average(n_sol),np.std(n_sol))


# Results (per model in RQ1):

# M1
# 4.0 0.0
# 4.0 0.0

# M2
# 1.0 0.0
# 1.0 0.0

# M3
# Avg num of sol: 27.774193548387096
# 27.774193548387096 1.4747263807306399

# M4
# Avg num of sol: 22.258064516129032
# 22.258064516129032 2.094042886079675