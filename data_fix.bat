@echo off
setlocal enabledelayedexpansion

:menu
cls
echo ==========================================
echo Please select an option:
echo [1] Check
echo [2] Run
echo [3] Exit
echo ==========================================
set /p choice=Enter your choice (1, 2, or 3): 

if "%choice%"=="1" goto check
if "%choice%"=="2" goto run
if "%choice%"=="3" exit /b
echo Invalid choice. Please try again.
pause
goto menu

:check
echo Checking if everything is in place...

REM Check if the batch file is inside the mysql directory
if not exist "%CD%\data" (
    echo This batch file must be placed inside the mysql directory.
    echo Exiting...
    pause
    exit /b
)

REM Check if the data folder exists
if exist "%CD%\data" (
    echo has data folder - PASSED
) else (
    echo has data folder - FAILED - Reason: data folder not found
    echo Exiting...
    pause
    exit /b
)

REM Check if the backup folder exists
if exist "%CD%\backup" (
    echo has backup folder - PASSED
) else (
    echo has backup folder - FAILED - Reason: backup folder not found
    echo Exiting...
    pause
    exit /b
)

REM Check if the ibdata1 file exists in the data folder
if exist "%CD%\data\ibdata1" (
    echo has ibdata1 file in data folder - PASSED
) else (
    echo has ibdata1 file in data folder - FAILED - Reason: ibdata1 file not found
    echo Exiting...
    pause
    exit /b
)

echo All checks passed!
pause
goto menu

:run
cls
echo Running the script...

REM Ensure the batch file is being run from the mysql directory
if not exist "%CD%\data" (
    echo This batch file must be placed inside the mysql directory.
    echo Exiting...
    pause
    exit /b
)

REM Check if the data folder exists
if not exist "%CD%\data" (
    echo has data folder - FAILED - Reason: data folder not found
    echo Exiting...
    pause
    exit /b
)

REM Check if the backup folder exists
if not exist "%CD%\backup" (
    echo has backup folder - FAILED - Reason: backup folder not found
    echo Exiting...
    pause
    exit /b
)

REM Check if the ibdata1 file exists in the data folder
if not exist "%CD%\data\ibdata1" (
    echo has ibdata1 file in data folder - FAILED - Reason: ibdata1 file not found
    echo Exiting...
    pause
    exit /b
)

REM Create a temporary folder for operations
set tempDir=%CD%\temp
mkdir "%tempDir%"

REM Step 1: Find the next available data_old directory name with an incrementing number
set count=1
:checkdir
if exist "%CD%\data_old!count!" (
    set /a count+=1
    goto checkdir
)

set newDataOldDir=data_old!count!
echo Renaming data to %newDataOldDir%...
ren "%CD%\data" "%newDataOldDir%"

REM Step 2: Make a copy of mysql/backup folder and name it as mysql/data
echo Copying backup to data...
xcopy /E /I /Y "%CD%\backup" "%tempDir%\data"

REM Step 3: Copy all database folders from %newDataOldDir% to data (excluding mysql, performance_schema, and phpmyadmin folders)
echo Copying databases from %newDataOldDir% to data (excluding mysql, performance_schema, and phpmyadmin)...
for /d %%G in ("%CD%\%newDataOldDir%\*") do (
    if /I not "%%~nxG"=="mysql" if /I not "%%~nxG"=="performance_schema" if /I not "%%~nxG"=="phpmyadmin" (
        echo Copying folder %%~nxG...
        xcopy /E /I /Y "%%G" "%tempDir%\data\%%~nxG"
    )
)

REM Step 4: Copy ibdata1 file from %newDataOldDir% to data
if exist "%CD%\%newDataOldDir%\ibdata1" (
    echo Copying ibdata1 from %newDataOldDir% to data...
    copy /Y "%CD%\%newDataOldDir%\ibdata1" "%tempDir%\data\ibdata1"
) else (
    echo Warning: ibdata1 file not found in %newDataOldDir%.
)

REM Move the temporary data folder to the final location
move "%tempDir%\data" "%CD%\data"

REM Clean up the temporary folder
rmdir /S /Q "%tempDir%"

echo All done!
pause
goto menu

:exit
exit /b