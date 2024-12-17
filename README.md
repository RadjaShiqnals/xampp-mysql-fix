# Data Fix Script

This repository contains a batch script (`data_fix.bat`) designed to manage and restore MySQL data directories.

## Prerequisites

- Ensure that this batch file is placed inside the MySQL directory.

## Usage

1. Place the `data_fix.bat` file inside the MySQL directory.
2. Run the script by double-clicking it or executing it from the command line.

## Script Steps

1. **Log Function**: The script includes a logging function that writes messages to `data_fix.log`.
2. **Directory Check**: Ensures the script is being run from the MySQL directory by checking for the existence of the `data` directory.
3. **Rename Data Directory**: Finds the next available `data_old` directory name with an incrementing number and renames the `data` directory to this new name.
4. **Copy Backup**: Copies the contents of the `backup` directory to a new `data` directory.
5. **Copy Databases**: Copies all database folders from the renamed `data_old` directory to the new `data` directory, excluding `mysql`, `performance_schema`, and `phpmyadmin` folders.
6. **Copy `ibdata1` File**: Copies the `ibdata1` file from the renamed `data_old` directory to the new `data` directory if it exists.
7. **Completion**: Logs a completion message and pauses the script.

## Error Handling

- The script logs errors encountered during the renaming, copying of the backup, copying of database folders, and copying of the `ibdata1` file.
- If any errors occur, the script logs the error and exits.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.