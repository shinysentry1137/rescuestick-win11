@echo off
setlocal enabledelayedexpansion

:: ===============================
:: Drive Cloner (File-Level)
:: ===============================

:: Setup folder for logs
set TOOL_DIR=%~dp0
set LOGDIR=%TOOL_DIR%logs
if not exist "%LOGDIR%" mkdir "%LOGDIR%"

:: Generate timestamped log file
for /f "tokens=1-4 delims=/: " %%a in ("%date% %time%") do (
    set timestamp=%%d-%%b-%%a_%%e%%f
)
set LOGFILE=%LOGDIR%\clone_log_%timestamp%.txt

:: Welcome
echo =========================================== >> "%LOGFILE%"
echo DRIVE CLONER TOOL - %timestamp% >> "%LOGFILE%"
echo =========================================== >> "%LOGFILE%"

:: Ask for source and destination
echo Enter full SOURCE path (e.g., D:\ or D:\MyFiles):
set /p SOURCE=
echo SOURCE: %SOURCE% >> "%LOGFILE%"

echo Enter full DESTINATION path (e.g., E:\Backup):
set /p DEST=
echo DESTINATION: %DEST% >> "%LOGFILE%"

:: Run robocopy
echo Starting copy... >> "%LOGFILE%"
robocopy "%SOURCE%" "%DEST%" /MIR /ZB /R:3 /W:5 /V /TEE /LOG+:"%LOGFILE%"

echo Copy complete. Log saved to:
echo %LOGFILE%
pause
exit
