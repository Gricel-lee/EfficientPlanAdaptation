import numpy as np
import matplotlib.pyplot as plt

# ============= Plot Raw Data with Error Bars =============

#----- Raw data -------
# 1.2316 ± 0.0134, 2.2515 ± 0.6645, 2.3373 ± 0.3077, 3.4992 ± 0.6645, 4.3283 ± 0.6645
# 5.5012 ± 0.0134, 11.9495 ± 2.0348, 22.8916 ± 3.4587, 30.9586 ± 5.0241, 38.0720 ± 8.0412
# 7.5731 ± 0.0187, 570.3567 ± 69.2175, 688.1855 ± 74.9238, 844.4668 ± 80.9347, 961.1288 ± 93.2982
# 17.7234 ± 0.0201, 468.4220 ± 56.2084, 534.1415 ± 61.5093, 598.7312 ± 68.0914, 670.3325 ± 79.0528
# 17.2418 ± 0.0198, 749.8326 ± 86.5432, 838.1968 ± 94.3056, 934.3133 ± 103.2476, 1027.7720 ± 112.2890

# Plot raw data means and stddevs
import numpy as np
import matplotlib.pyplot as plt

# Function to parse raw data and plot with error bars
def plot_raw_data():
    # Raw data (mean ± std) for each task
    raw_data = [
        [1.2316, 2.2515, 2.3373, 3.4992, 4.3283],  # 5 tasks, 3 agents
        [5.5012, 11.9495, 22.8916, 30.9586, 38.0720],  # 10 tasks, 3 agents
        [7.5731, 570.3567, 688.1855, 844.4668, 961.1288],  # 15 tasks, 3 agents
        [17.7234, 468.4220, 534.1415, 598.7312, 670.3325],  # 15 tasks, 4 agents
        [17.2418, 749.8326, 838.1968, 934.3133, 1027.7720],  # 15 tasks, 5 agents
    ]

    # Standard deviations for each data set
    std_devs = [
        [0.0134, 0.6645, 0.3077, 0.6645, 0.6645],  # Std for 5 tasks, 3 agents
        [0.0134, 2.0348, 3.4587, 5.0241, 8.0412],  # Std for 10 tasks, 3 agents
        [0.0187, 69.2175, 74.9238, 80.9347, 93.2982],  # Std for 15 tasks, 3 agents
        [0.0201, 56.2084, 61.5093, 68.0914, 79.0528],  # Std for 15 tasks, 4 agents
        [0.0198, 86.5432, 94.3056, 103.2476, 112.2890],  # Std for 15 tasks, 5 agents
    ]
    
    # x-axis values representing the number of plans (1, 5, 10, 15, 20)
    x = np.array([1, 5, 10, 15, 20])
    
    # Calculate means and standard deviations
    means = [np.array(data) for data in raw_data]
    stds = [np.array(std_dev) for std_dev in std_devs]
    
    # Legends for each dataset
    legends = ["5t3a", "10t3a", "15t3a", "15t4a", "15t5a"]
    
    # Plotting the data with error bars
    plt.figure(figsize=(10, 6))
    
    for i in range(5):
        plt.errorbar(x, means[i], yerr=stds[i], fmt='-o', label=legends[i])
    
    # Labels and title
    plt.xlabel("Number of Plans")
    plt.ylabel("Execution Time (s)")
    plt.title("Execution Time vs Number of Plans with Error Bars")
    
    # X-ticks no decimals
    plt.xticks(x)
    
    # Grid and legend
    plt.grid(True)
    plt.legend()
    
    # Show plot
    plt.show()

# Call the function to plot
plot_raw_data()





# ============= Linear Fitting =============
def print_linear_fit(y):
    # Fit a line (linear regression)
    slope, intercept = np.polyfit(x, y, 1)

    # Plot the data and the fitted line
    plt.scatter(x, y, color='red', label='Data Points')
    plt.plot(x, slope * x + intercept, label=f'Fitted Line (Slope = {slope:.4f})', color='blue')

    # Labels and title
    plt.xlabel("Number of Plans")
    plt.ylabel("Execution Time (s)")
    plt.title("Linear Fit for Execution Times")
    plt.legend()

    # Show the plot
    plt.show()

    print(f"Slope of the fitted line: {slope:.4f}")


# --------- Data for different variants ---------
y1 = np.array([1.2316, 2.2515, 2.3373, 3.4992, 4.3283])  # Time values
y2 = np.array([5.5012, 11.9495, 22.8916, 30.9586, 38.0720])
y3 = np.array([7.5731, 570.3567, 688.1855, 844.4668, 961.1288])
y4 = np.array([17.7234, 468.4220, 534.1415, 598.7312, 670.3325])
y5 = np.array([17.2418, 749.8326, 838.1968, 934.3133, 1027.7720])

# Data x points
x = np.array([1, 5, 10, 15, 20])  # Corresponding to number of plans


# Function get slope by performing linear fitting
print_linear_fit(y1)
s