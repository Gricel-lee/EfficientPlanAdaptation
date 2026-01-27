import os
import numpy as np


def get_all_exp_time_files(var, exps, dir_gen_plans):
    files = []
    # get N experiments
    for exp in exps:    
        # get time file
        time_file =f"exp{exp}_output_data_{var.replace('.json', '')}/timer_log.txt"
        full_times_file = os.path.join(dir_gen_plans, time_file)
        files.append(full_times_file)
    return files

def read_all_files_get_times(files):
    all_times = []
    for full_times_file in files:
        with open(full_times_file, "r") as f:
            lines = f.readlines()
            all_times.append(lines)
    return all_times

def get_times_with(row_str, all_times):
    times = []
    for lines in all_times:
        for line in lines:
            if row_str in line:
                # extract time
                times.append(line.split("Elapsed time:")[1].strip().split(" ")[0])
    return times




# ============== Get data =============
# Get saved files
dirr = "/home/gnvf500/Gricel-Documents/GithubGris/EfficientPlanAdaptation/assets/paper-TAAS26-Multiplan/RQ4/1Non-probab-Multi-plan/JSONs_input"
dir_gen_plans = "/home/gnvf500/Gricel-Documents/GithubGris/EfficientPlanAdaptation/assets/paper-TAAS26-Multiplan/RQ4/1Non-probab-Multi-plan/data_gen"
dir_get_times = "Non-probab-Multi-plan/data_times"

exps = [1,2,3,4,5,6,7,8,9,10]
# get list files end with .json in dirr
json_files = [f for f in os.listdir(dirr) if f.endswith(".json")]

times_dic_mean = {}
times_dic_std = {}
# for each variant
for var in json_files:
    print(f"Variant: {var}")
    
    files = get_all_exp_time_files(var, exps, dir_gen_plans)
    all_times = read_all_files_get_times(files)
    
    # Get times for n_plans
    for n_plans in [1, 5, 10, 15, 20]:
        row_str = f"Plan{n_plans}:" #[TIMER] ENHSP Planning Time Plan1: Elapsed time: 147.6297 seconds
        times = get_times_with(row_str, all_times)
        get_mean = np.mean([float(t) for t in times])
        get_std = np.std([float(t) for t in times])
        # print mean and std 4 decimal places
        print(f"{get_mean:.4f} $\pm$ {get_std:.4f} & %{n_plans}plan")

