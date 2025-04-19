@echo off
setlocal

:: Set up log directory
set LOGDIR=%~dp0logs
if not exist "%LOGDIR%" mkdir "%LOGDIR%"

:: Get the current date and time for the log file
set TIMESTAMP=%DATE:~-4%%DATE:~4,2%%DATE:~7,2%_%TIME:~0,2%%TIME:~3,2%
set LOGFILE=%LOGDIR%\vss_recovery_log_%TIMESTAMP%.txt

:: Start logging
echo ========================================== >> "%LOGFILE%"
echo VSS RECOVERY LOG - %TIMESTAMP% >> "%LOGFILE%"
echo ========================================== >> "%LOGFILE%"

:: List all available shadow copies
echo Listing available VSS snapshots...
echo.
vssadmin list shadows >> "%LOGFILE%"
echo.
echo VSS snapshots listed successfully. See log file for details.

:: Ask the user to input the shadow copy ID to mount
echo.
echo Available snapshots (ID):
findstr "Shadow Copy" "%LOGFILE%"

:: Ask the user to input the shadow copy ID
set /p SHADOW_ID=Enter the Shadow Copy ID to mount (e.g., {9a7fb1b2-xxxx-xxxx-xxxx-xxxxxxxxxxxx}):

:: Ask the user for the mount point (folder)
set /p MOUNT_DIR=Enter a directory to mount the shadow copy to (e.g., D:\recovery\):

:: Create the mount point folder
if not exist "%MOUNT_DIR%" mkdir "%MOUNT_DIR%"

:: Use mklink to mount the shadow copy
echo Creating symbolic link...
mklink /D "%MOUNT_DIR%" "\\?\GLOBALROOT\Device\HarddiskVolumeShadowCopy%SHADOW_ID%" >> "%LOGFILE%"

:: Finish logging
echo.
echo Symbolic link created successfully. Recovery mount point is at: %MOUNT_DIR% >> "%LOGFILE%"
echo Recovery process complete. >> "%LOGFILE%"
echo ========================================== >> "%LOGFILE%"
echo Log saved to %LOGFILE%
pause

exit
