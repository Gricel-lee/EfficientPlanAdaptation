import os

import shutil

def createFolder(fpath):
    '''Delete all files in the directory and create a new folder.
    Even when subfolders are present, they are deleted.'''
    # Create empty directory or delete files if they exist
    if not os.path.exists(fpath):
        os.makedirs(fpath)  # create the folder if it doesn't exist
    else:
        # Delete all files and folders in the directory
        #print(f"Directory exists, removing current files and folders: {fpath}")
        for f in os.listdir(fpath):
            item_path = os.path.join(fpath, f)
            if os.path.isdir(item_path):
                # If it's a directory, remove it and its contents
                shutil.rmtree(item_path)
                #print(f"Directory removed: {item_path}")
            elif os.path.isfile(item_path):
                # If it's a file, remove it
                os.remove(item_path)
                #print(f"File removed: {item_path}")
                

# def createFolder(fpath):
#     '''Delete all files in the directory and create a new folder.'''
#     # Create empty directory or delete files if they exist
#     #print(f"Checking if directory exists: {fpath}")
#     if not os.path.exists(fpath):
#         os.makedirs(fpath)  # created folder
#         #print(f"Directory created at: {fpath}")
#     else:
#         # Delete all files in the directory
#         print(f"Directory exists, removing current files: {fpath}")
#         for f in os.listdir(fpath):
#             os.remove(os.path.join(fpath, f))
            
            
def createFile(fpath):
    os.makedirs(os.path.dirname(fpath), exist_ok=True)
    