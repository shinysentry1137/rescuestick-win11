@echo off
title Rescue Stick for Windows - Launcher
color 0A

:menu
cls
echo.
echo ==========================================
echo      RESCUE STICK FOR WINDOWS
echo         Offline Recovery Toolkit
echo ==========================================
echo  Select a tool to launch:
echo.
echo  1. File Recovery Log Scanner
echo  2. Drive Health Snapshot
echo  3. CHKDSK Runner
echo  4. System Snapshot Generator
echo  5. Volume Shadow Copy Recovery Helper
echo  6. Startup Inspection Tool
echo  7. Drive Cloner (Local File-Based)
echo  8. Simple File Hasher
echo  9. Partition Table Viewer
echo 10. Basic Secure Eraser
echo 11. File System Analyzer
echo 12. Exit
echo.
echo More tools and functionality will be added in future updates.
echo.
echo ==========================================
echo.

set /p choice=Enter choice (1-12): 

if "%choice%"=="1" start "" ".\file-recovery-log-scanner\recover_scan.bat"
if "%choice%"=="2" powershell -ExecutionPolicy Bypass -File ".\drive-health-snapshot\drive_health.ps1"
if "%choice%"=="3" start "" ".\chkdsk-runner\chkdsk_runner.bat"
if "%choice%"=="4" powershell -ExecutionPolicy Bypass -File ".\system-snapshot-generator\system_snapshot.ps1"
if "%choice%"=="5" start "" ".\volume-shadow-copy-recovery-helper\vss_recovery_helper.bat"
if "%choice%"=="6" start "" ".\startup-inspection-tool\startup_inspector.ps1"
if "%choice%"=="7" start "" ".\drive-cloner-local-file-based\drive_cloner.bat"
if "%choice%"=="8" start "" ".\simple-file-hasher\file_hasher.ps1"
if "%choice%"=="9" start "" ".\partition-table-viewer\partition_viewer.ps1"
if "%choice%"=="10" powershell -ExecutionPolicy Bypass -File ".\basic-secure-eraser\secure_eraser.bat"
if "%choice%"=="11" powershell -ExecutionPolicy Bypass -File ".\file-system-analyzer\fs_analyzer.bat"
if "%choice%"=="12" exit

goto menu
