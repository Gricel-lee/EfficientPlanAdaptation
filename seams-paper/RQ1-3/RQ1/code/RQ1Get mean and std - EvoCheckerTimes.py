import re
import statistics

# Function to extract execution times from the text and compute statistics
def process_execution_times(file_path):
    execution_times = []

    # Open and read the file
    with open(file_path, 'r') as file:
        # Read the file content
        content = file.read()

        # Find all execution times using regex (captures numbers after "Execution Time: ")
        times = re.findall(r'Execution Time: (\d+\.\d+) seconds', content)

        # Convert the found times to float and store them in the list
        execution_times = [float(time) for time in times]

    # Calculate mean and standard deviation
    mean_time = statistics.mean(execution_times)
    stdev_time = statistics.stdev(execution_times)

    return mean_time, stdev_time


def process_execution_times_NumericalP(file_path):
    data = open(file_path).read()
    # Use regular expressions to extract the times
    times = [float(match.group(1)) for match in re.finditer(r"Run \d+: (\d+\.\d+) seconds", data)]

    # Calculate mean and standard deviation
    mean_time = statistics.mean(times)
    stdev_time = statistics.stdev(times)
    return mean_time, stdev_time

def print_mean_std(mean_time, stdev_time):
    # print(f"Mean time: {mean_time:.2f} seconds")
    # print(f"Standard deviation: {stdev_time:.2f} seconds")
    return

# Replace 'your_file.txt' with the actual file path
print("Times in seconds: average (std)\n")
for i in range(1, 4+1):
    print("problem",i)
    # Run for Heuristic Search times:
    f = "time-problem"+str(i)+".json.txt"
    file_path = "/home/gnvf500/Gricel-Documents/GithubGris/Playing-with-multirobot-systems/RQ1-3/RQ1/RQ1-HybridTimes/RQ1-TimesNumericalPlanner/"+f
    mean_time, stdev_time = process_execution_times_NumericalP(file_path)
    #print(mean_time, stdev_time)
    
    # round to two decimal places print
    mean_time = round(mean_time, 3)
    stdev_time = round(stdev_time, 3)
    print("Heuristic planner:",mean_time, stdev_time)
    
    # Run for EvoChecker times:
    f = str(i)+"configFullMDP.properties_time.txt"
    file_path = "/home/gnvf500/Gricel-Documents/GithubGris/Playing-with-multirobot-systems/RQ1-3/RQ1/RQ1-HybridTimes/RQ1-EvocheckerTimes/"+f
    mean_time, stdev_time = process_execution_times(file_path)
    
    # round to two decimal places print
    mean_time = round(mean_time, 3)
    stdev_time = round(stdev_time, 3)
    print("EvoChecker: ",mean_time*60, stdev_time*60,"\n")
    
    
    

# Results per model M1-M4
# Heur planner 0.298 0.025
# Evo:  105.72 5.94 

# Heur planner 0.333 0.025
# Evo:  104.22 1.8599999999999999 

# Heur planner 0.331 0.025
# Evo:  884.22 138.06 

# Heur planner 2.028 0.082
# Evo:  128.16 10.319999999999999 