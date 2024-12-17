# Data Fix Script

This repository contains an improved version of the batch script (`data_fix.bat`) designed to manage and restore MySQL data directories. This project is an improvement of [XAMPP-MySQL-Auto-Fix](https://github.com/DanielHadianto456/XAMPP-MySQL-Auto-Fix) by [DanielHadianto456](https://github.com/DanielHadianto456).

## Prerequisites

- Ensure that this batch file is placed inside the MySQL directory.

## Usage

1. Place the `data_fix.bat` or `data_fix.exe` file inside the MySQL directory.
2. Run the script by double-clicking it or executing it from the command line.

## Script Steps

1. **Menu**: The script displays a menu with options to Check, Run, and Exit.
2. **Directory Check**: Ensures the script is being run from the MySQL directory by checking for the existence of the `data` directory.
3. **Check Option**: Verifies the presence of the `data`, `backup`, and `ibdata1` files and directories.
4. **Run Option**: 
   - **Rename Data Directory**: Finds the next available `data_old` directory name with an incrementing number and renames the `data` directory to this new name.
   - **Copy Backup**: Copies the contents of the `backup` directory to a new `data` directory.
   - **Copy Databases**: Copies all database folders from the renamed `data_old` directory to the new `data` directory, excluding `mysql`, `performance_schema`, and `phpmyadmin` folders.
   - **Copy `ibdata1` File**: Copies the `ibdata1` file from the renamed `data_old` directory to the new `data` directory if it exists.
   - **Completion**: Moves the temporary data folder to the final location and cleans up the temporary directory.
5. **Error Handling**: If any errors occur, the script reverts the changes and logs the error.

## How the Code Works

1. **Menu Display**: The script starts by displaying a menu with three options: Check, Run, and Exit.
2. **User Input**: It waits for the user to enter their choice (1, 2, or 3).
3. **Check Option**: If the user selects option 1, the script verifies the presence of the `data`, `backup`, and `ibdata1` files and directories.
4. **Run Option**: If the user selects option 2, the script performs the following steps:
   - Ensures the script is being run from the MySQL directory.
   - Renames the `data` directory to the next available `data_old` directory name.
   - Copies the contents of the `backup` directory to a new `data` directory.
   - Copies all database folders from the renamed `data_old` directory to the new `data` directory, excluding `mysql`, `performance_schema`, and `phpmyadmin` folders.
   - Copies the `ibdata1` file from the renamed `data_old` directory to the new `data` directory if it exists.
   - Moves the temporary data folder to the final location and cleans up the temporary directory.
5. **Exit Option**: If the user selects option 3, the script exits.
6. **Error Handling**: If any errors occur during the `run` option, the script reverts the changes and logs the error.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.