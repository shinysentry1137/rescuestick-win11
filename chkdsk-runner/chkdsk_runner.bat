@echo off
setlocal

:: Set up the folder path for logs
set LOGDIR=%~dp0logs
if not exist "%LOGDIR%" mkdir "%LOGDIR%"

:: Get the current date and time for the log file
set TIMESTAMP=%DATE:~-4%%DATE:~4,2%%DATE:~7,2%_%TIME:~0,2%%TIME:~3,2%
set LOGFILE=%LOGDIR%\chkdsk_log_%TIMESTAMP%.txt

:: Ask the user to input the drive letter to check
echo ========================================
echo CHKDSK Runner - Select Drive to Check
echo ========================================
echo.
echo Available drives:
wmic logicaldisk get name
echo.
set /p DRIVE=Enter the drive letter (e.g., C:): 

:: Confirm the selected drive
echo You selected %DRIVE%. Running CHKDSK on this drive...
echo.

:: Run CHKDSK and output the results to the log file
echo Running CHKDSK on %DRIVE%... >> "%LOGFILE%"
chkdsk %DRIVE% >> "%LOGFILE%" 2>&1

:: Display the output location
echo.
echo ========================================
echo CHKDSK COMPLETE. Output saved to:
echo %LOGFILE%
echo ========================================
pause

exit
