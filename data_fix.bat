@echo off
setlocal enabledelayedexpansion

REM Log function
:log
echo %~1
echo %~1 >> "%CD%\data_fix.log"
goto :eof

REM Ensure the batch file is being run from the mysql directory
if not exist "%CD%\data" (
    call :log "This batch file must be placed inside the mysql directory."
    call :log "Exiting..."
    pause
    exit /b
)

REM Step 1: Find the next available data_old directory name with an incrementing number
set count=1
:checkdir
if exist "%CD%\data_old!count!" (
    set /a count+=1
    goto checkdir
)

set newDataOldDir=data_old!count!
call :log "Renaming data to %newDataOldDir%..."
ren "%CD%\data" "%newDataOldDir%"
if errorlevel 1 (
    call :log "Error renaming data directory."
    exit /b
)

REM Step 2: Make a copy of mysql/backup folder and name it as mysql/data
call :log "Copying backup to data..."
xcopy /E /I /Y "%CD%\backup" "%CD%\data" >nul
if errorlevel 1 (
    call :log "Error copying backup to data."
    exit /b
)

REM Step 3: Copy all database folders from %newDataOldDir% to data (excluding mysql, performance_schema, and phpmyadmin folders)
call :log "Copying databases from %newDataOldDir% to data (excluding mysql, performance_schema, and phpmyadmin)..."
for /d %%G in ("%CD%\%newDataOldDir%\*") do (
    if /I not "%%~nxG"=="mysql" if /I not "%%~nxG"=="performance_schema" if /I not "%%~nxG"=="phpmyadmin" (
        call :log "Copying folder %%~nxG..."
        xcopy /E /I /Y "%%G" "%CD%\data\%%~nxG" >nul
        if errorlevel 1 (
            call :log "Error copying folder %%~nxG."
        )
    )
)

REM Step 4: Copy ibdata1 file from %newDataOldDir% to data
if exist "%CD%\%newDataOldDir%\ibdata1" (
    call :log "Copying ibdata1 from %newDataOldDir% to data..."
    copy /Y "%CD%\%newDataOldDir%\ibdata1" "%CD%\data\ibdata1" >nul
    if errorlevel 1 (
        call :log "Error copying ibdata1 file."
    )
) else (
    call :log "Warning: ibdata1 file not found in %newDataOldDir%."
)

call :log "All done!"
pause