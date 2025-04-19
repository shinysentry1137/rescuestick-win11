@echo off
setlocal
set LOGFILE=%~dp0logs\recover_scan_%date:/=-%_%time::=-%.log
mkdir "%~dp0logs" >nul 2>&1

echo ============================================= >> "%LOGFILE%"
echo  FILE RECOVERY SCAN STARTED - %DATE% %TIME%   >> "%LOGFILE%"
echo ============================================= >> "%LOGFILE%"
echo.

REM --- SCAN 1: Recycle Bin ---
echo [*] Scanning Recycle Bin... >> "%LOGFILE%"
dir /s /a "%SystemDrive%\$Recycle.Bin" >> "%LOGFILE%" 2>&1

REM --- SCAN 2: User Temp Files ---
echo [*] Scanning User TEMP folder... >> "%LOGFILE%"
dir /s /a "%TEMP%" >> "%LOGFILE%" 2>&1

REM --- SCAN 3: Windows Temp ---
echo [*] Scanning Windows TEMP folder... >> "%LOGFILE%"
dir /s /a "C:\Windows\Temp" >> "%LOGFILE%" 2>&1

REM --- SCAN 4: Desktop & Downloads ---
echo [*] Scanning Desktop and Downloads... >> "%LOGFILE%"
for /d %%u in ("C:\Users\*") do (
    if exist "%%u\Desktop" dir /s /a "%%u\Desktop" >> "%LOGFILE%" 2>&1
    if exist "%%u\Downloads" dir /s /a "%%u\Downloads" >> "%LOGFILE%" 2>&1
)

echo. >> "%LOGFILE%"
echo ============================================= >> "%LOGFILE%"
echo  SCAN COMPLETE - Output saved to %LOGFILE%
echo =============================================

pause
exit /b
