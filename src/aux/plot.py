import matplotlib.pyplot as plt
import os 

def get_first_file_with_suffix(directory, suffix="_Front"):
    # List all files in the directory
    for filename in os.listdir(directory):
        # Check if the file ends with the specified suffix
        if filename.endswith(suffix):
            return os.path.join(directory, filename)  # Return the full path of the first file found
    return None  # Return None if no matching file is found


def read_points_from_Evofile(filename):
    '''Read Pareto front points'''
    points = []
    # Open the file and read the data
    with open(filename, 'r') as file:
        for line in file:
            # Skip lines that do not contain numeric data
            if line.startswith("P=?") or line.startswith("R=?"):
                continue
            # Split the line into two values (x, y)
            try:
                x, y = map(float, line.split())
                points.append((x, y))
            except ValueError:
                # Handle any lines that don't have valid floating point values
                print(f"Skipping invalid line: {line.strip()}")
    return points

def plot_EvoChecker_pareto_front(points,only_pareto=True, plot=False):
    # Create the plot
    plt.figure(figsize=(4, 3))
    plt.rcParams.update({'font.size': 11}) # global font size
    # Adding labels and title
    plt.xlabel('Probability of Success')
    plt.xlabel('Pmax=?[F "success"]')
    plt.ylabel('Cummulative cost')
    plt.ylabel('Rmin=?[C<=20]')
    #plt.title('---')

    # Unzip points x and y coordinate lists
    x, y = zip(*points)
    
    # Plot EvoChecker data points in blue
    plt.scatter(x, y, color='blue', marker='o', s=15, label="Hybrid approach solutions")
    
    # Required add unique label
    if only_pareto:
        # To avoid duplicate labels in the legend
        handles, labels = plt.gca().get_legend_handles_labels()
        unique_labels = []
        unique_handles = []
        for i, label in enumerate(labels):
            if label not in unique_labels:
                unique_labels.append(label)
                unique_handles.append(handles[i])
        plt.legend(unique_handles, unique_labels)
    
    # Display plot 
    if plot:  # False to be able to save files
        plt.show()
    return(plt)


def save_plot(file_plot):
    plt.savefig(file_plot, bbox_inches='tight')
    print("Saved plot:"+file_plot)
    

def make_dir(file_savePlot):
    directory = os.path.dirname(file_savePlot)
    if not os.path.exists(directory):
        os.makedirs(directory)  

if __name__ == "__main__":
    # >>>>>>>>>> Set paths <<<<<<<<<<<
    filename = get_first_file_with_suffix("/home/gnvf500/Gricel-Documents/GithubGris/Playing-with-multirobot-systems/src/Problems/Agricultural/data_agricultural/dataevochecker_run1/NSGAII/")
    output_dir = '/home/gnvf500/Gricel-Documents/GithubGris/Playing-with-multirobot-systems/src/Problems/Agricultural/data_agricultural/'
    
    
    # ----- Run for: save plot of Pareto front-----
    plot_EvoChecker_pareto_front(points = read_points_from_Evofile(filename))
    make_dir(output_dir)
    save_plot(output_dir + 'plot.png')
