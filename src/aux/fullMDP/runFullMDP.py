''' Generate the MDP Prism file content from the JSON data.\n
NOTE: REQUIRES ID OF LOCATIONS TO BE \"l+XX+optional letter\", where XX is 1,2,3... up to the number of locations, and optional letter is a letter to differentiate locations with the same number. \n
e.g. (l1, l2)
NOTE: REQUIRES tasks ID's to have location at the end: \"l+XX+optional letter\", where XX is 1,2,3... up to the number of locations, and optional letter is a letter to differentiate locations with the same number. \n
(e.g. t1l1, t1l1a, t3l29)
'''

import json2MDP as json2MDP
import json2MDPwRetries as json2MDPwRetries
import os

def main():
    # ----Set JSON path----
    input_dir ="src/Problems/fullmdp/"
    
    for json_file in os.listdir(input_dir):
        if json_file.endswith(".json"):
            mdpFile = json_file.replace(".json",".mdp").replace("/","_")
            
            # Get file name without extension
            name_file = os.path.splitext(json_file)[0]
                
            # Get full path
            json_file_path = os.path.join(input_dir, json_file);
            
            # Get output folder
            output_dir = os.path.join(os.path.dirname(json_file_path), f"data_fullMDP_{name_file}")
            print(f"[runfullMDP] Processing: {output_dir}")
            
            # Create PRISM fullMDP files (with and without retries as actions)
            json2MDP.main(json_file_path, mdpFile, output_dir)
            json2MDPwRetries.main(json_file_path, mdpFile, output_dir)
            
    
    print("[runfullMDP] Done.")

if __name__ == "__main__":
    main()