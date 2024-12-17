import os
import shutil
import time
from tqdm import tqdm

def check():
    print("Checking if everything is in place...")

    # Check if the batch file is inside the mysql directory
    if not os.path.exists("data"):
        print("This script must be placed inside the mysql directory.")
        print("Exiting...")
        return False

    # Check if the data folder exists
    if os.path.exists("data"):
        print("has data folder - PASSED")
    else:
        print("has data folder - FAILED - Reason: data folder not found")
        print("Exiting...")
        return False

    # Check if the backup folder exists
    if os.path.exists("backup"):
        print("has backup folder - PASSED")
    else:
        print("has backup folder - FAILED - Reason: backup folder not found")
        print("Exiting...")
        return False

    # Check if the ibdata1 file exists in the data folder
    if os.path.exists("data/ibdata1"):
        print("has ibdata1 file in data folder - PASSED")
    else:
        print("has ibdata1 file in data folder - FAILED - Reason: ibdata1 file not found")
        print("Exiting...")
        return False

    print("All checks passed!")
    return True

def run():
    print("Running the script...")

    try:
        # Ensure the script is being run from the mysql directory
        if not os.path.exists("data"):
            raise Exception("This script must be placed inside the mysql directory.")

        # Check if the data folder exists
        if not os.path.exists("data"):
            raise Exception("has data folder - FAILED - Reason: data folder not found")

        # Check if the backup folder exists
        if not os.path.exists("backup"):
            raise Exception("has backup folder - FAILED - Reason: backup folder not found")

        # Check if the ibdata1 file exists in the data folder
        if not os.path.exists("data/ibdata1"):
            raise Exception("has ibdata1 file in data folder - FAILED - Reason: ibdata1 file not found")

        # Create a temporary folder for operations
        temp_dir = os.path.join(os.getcwd(), "temp")
        os.makedirs(temp_dir, exist_ok=True)

        # Step 1: Find the next available data_old directory name with an incrementing number
        count = 1
        while os.path.exists(f"data_old{count}"):
            count += 1

        new_data_old_dir = f"data_old{count}"
        print(f"Renaming data to {new_data_old_dir}...")
        os.rename("data", new_data_old_dir)

        # Initialize progress bar
        total_steps = 5  # Total number of steps
        progress_bar = tqdm(total=total_steps, desc="Progress", ncols=100, ascii=True)

        # Step 2: Make a copy of mysql/backup folder and name it as mysql/data
        print("Copying backup to data...")
        shutil.copytree("backup", os.path.join(temp_dir, "data"))
        progress_bar.update(1)

        # Step 3: Copy all database folders from new_data_old_dir to data (excluding mysql, performance_schema, and phpmyadmin folders)
        print(f"Copying databases from {new_data_old_dir} to data (excluding mysql, performance_schema, and phpmyadmin)...")
        for item in os.listdir(new_data_old_dir):
            src = os.path.join(new_data_old_dir, item)
            dst = os.path.join(temp_dir, "data", item)
            if item.lower() not in ["mysql", "performance_schema", "phpmyadmin"]:
                if os.path.isdir(src):
                    if not os.path.exists(dst):
                        print(f"Copying folder {item}...")
                        shutil.copytree(src, dst)
                    else:
                        print(f"Skipping folder {item} as it already exists.")
                else:
                    if not os.path.exists(dst):
                        print(f"Copying file {item}...")
                        shutil.copy2(src, dst)
                    else:
                        print(f"Skipping file {item} as it already exists.")
                progress_bar.update(1)

        # Step 4: Copy ibdata1 file from new_data_old_dir to data
        if os.path.exists(os.path.join(new_data_old_dir, "ibdata1")):
            print(f"Copying ibdata1 from {new_data_old_dir} to data...")
            shutil.copy(os.path.join(new_data_old_dir, "ibdata1"), os.path.join(temp_dir, "data", "ibdata1"))
        else:
            print(f"Warning: ibdata1 file not found in {new_data_old_dir}.")
        progress_bar.update(1)

        # Step 5: Move the temporary data folder to the final location
        shutil.move(os.path.join(temp_dir, "data"), "data")
        progress_bar.update(1)

        # Step 6: Clean up the temporary folder
        shutil.rmtree(temp_dir)
        progress_bar.update(1)

        progress_bar.close()
        print("All done!")
        input("Press Enter to continue...")

    except Exception as e:
        print(f"Error: {e}")
        # Revert changes
        if os.path.exists(new_data_old_dir) and not os.path.exists("data"):
            os.rename(new_data_old_dir, "data")
        if os.path.exists(temp_dir):
            shutil.rmtree(temp_dir)
        print("Reverted changes due to error.")
        input("Press Enter to continue...")

def main():
    # Set console window size to be resizable
    os.system('mode con: cols=120 lines=40')

    while True:
        print("==========================================")
        print("Please select an option:")
        print("[1] Check")
        print("[2] Run")
        print("[3] Exit")
        print("==========================================")
        choice = input("Enter your choice (1, 2, or 3): ")

        if choice == "1":
            if not check():
                break
        elif choice == "2":
            run()
            break
        elif choice == "3":
            break
        else:
            print("Invalid choice. Please try again.")
            input("Press Enter to continue...")

if __name__ == "__main__":
    main()