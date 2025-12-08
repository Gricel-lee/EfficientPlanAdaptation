import matplotlib.pyplot as plt
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

def plot_pareto_comparison(points, policies, plot=False):
    '''Plot EvoChecker Pareto points and PRISM Pareto points'''
    # Generate plot for EvoChecker points
    plt = plot_EvoChecker_pareto_front(points,only_pareto=False)
    # Plotting PRISM Pareto (policies) as red diamonds
    int =1;
    for policy in policies:
        if int==1:
            plt.scatter(policy["x"], policy["y"], color='red', marker='D', s=20, label="Pareto optimal solution")
            int=0
        else:
            plt.scatter(policy["x"], policy["y"], color='red', marker='D', s=20)

    # To avoid duplicate labels in the legend
    handles, labels = plt.gca().get_legend_handles_labels()
    unique_labels = []
    unique_handles = []
    for i, label in enumerate(labels):
        if label not in unique_labels:
            unique_labels.append(label)
            unique_handles.append(handles[i])
    plt.legend(unique_handles, unique_labels)

    # Display the plot
    if plot: # False to be able to save files
        plt.show()

def plot_fullMDP_vs_hybrid(filename, file_plot, policiesMDP1):
    points = read_points_from_Evofile(filename)
    plot_pareto_comparison(points, policiesMDP1)
    make_dir(file_plot)
    plt.savefig(file_plot, bbox_inches='tight')
    print("Saved plot:"+file_plot)


def save_plot(file_plot):
    plt.savefig(file_plot, bbox_inches='tight')
    print("Saved plot:"+file_plot)

def make_dir(file_savePlot):
    directory = os.path.dirname(file_savePlot)
    if not os.path.exists(directory):
        os.makedirs(directory)
        


if __name__ == "__main__":
    
    # >>>>>>>>>> Set paths <<<<<<<<<<<
    files_path = "/Users/grisv/GitHub/EfficientPlanAdaptation/RQ1-3/RQ1/EvoChecker"
    output_path = '/Users/grisv/GitHub/EfficientPlanAdaptation/RQ1-3/RQ1/plots/'

    
    # ----- Run for: save plot with Hybrid Planner vs full MDP data Pareto front policies-----
    # Plot model 1
    # Params:
    plot_name = output_path + 'plot.png'
    filename = files_path + "/FullMDP-1/FullMDP-simos-1-1/NSGAII/FULLMDP-SIMOS-1-1_NSGAII_121224_20064114423504342703360884_Front"
    policiesMDP1 = [{"name": "Policy 1", "x": 0.0, "y": 4.063123524275327},
                    {"name": "Policy 2", "x": 0.9999729999730006, "y": 4.063123524275327},
                    {"name": "Policy 3", "x": 0.9999729999730007, "y": 5.30349103355269}]
    # Plot
    plot_fullMDP_vs_hybrid(filename,plot_name,policiesMDP1)
    
    # Plot model 2
    # Params:
    plot_name = output_path + 'plot2.png'
    filename = files_path + "/FullMDP-2/FullMDP-simos-2-29/NSGAII/FULLMDP-SIMOS-2-29_NSGAII_121224_20080612137407610201725746_Front"
    # points = [(0.9703, 18.9492)]
    policiesMDP2 = [{"name": "Policy 1", "x": 0.0, "y": 8.6523697237},
                    {"name": "Policy 2", "x": 0.9694180872999999, "y": 8.6523697237},
                    {"name": "Policy 3", "x": 0.9694180873000001, "y": 17.0761187437}]
    # Plot
    plot_fullMDP_vs_hybrid(filename,plot_name,policiesMDP2)
    
    # ----- Run for: save plot with Hybrid Planner Pareto front-----
    # Plot model 3
    # Params:
    filename = files_path + "/FullMDP-3/FullMDP-simos-3-8/NSGAII/FULLMDP-SIMOS-3-8_NSGAII_121224_20072512341156506045581567_Front"
    # Save plot:
    plot_EvoChecker_pareto_front(read_points_from_Evofile(filename))
    plt.savefig(output_path + 'plot3.png', bbox_inches='tight')
    save_plot(output_path + 'plot3.png')

    # Plot model 4
    # Params:
    filename = files_path + "/FullMDP-4/FullMDP-simos-4-3/NSGAII/FULLMDP-SIMOS-4-3_NSGAII_121224_2007549945594415998598576_Front"
    # Save plot:
    plot_EvoChecker_pareto_front(points = read_points_from_Evofile(filename))
    save_plot(output_path + 'plot4.png')
    



    # # ----- Run for: Check all Pareto front files in a folder
    # folder_path = files_path + "/FullMDP-4"
    # files = get_all_files_in_subfolders(folder_path)
    # for file_path in files:
    #     if file_path[-4:] == "ront":
    #         print(file_path)
    #         # Data for the points (Policy 1, Policy 2, Policy 3)
    #         points = read_points_from_Evofile(file_path)
    #         # # Call the function to plot the data points
    #         plot_EvoChecker_pareto_front(points, plot=True)
    #         # plot_pareto_comparison(points, policies,plot=true)


    # # ----- Run for: Check all Pareto Front files in directory
    # folder_path = '/Users/grisv/GitHub/EfficientPlanAdaptation/RQ1-3/RQ1/EvoChecker/FullMDP-4'  # Replace with the path to your folder
    # files = get_all_files_in_subfolders(folder_path)
    # for file_path in files:
    #     if file_path[-5:] == "Front":
    #         print(file_path)