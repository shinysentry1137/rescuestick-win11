# ===============================
# System Snapshot Generator
# ===============================

$ToolRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
$LogDir = Join-Path $ToolRoot "logs"
If (!(Test-Path $LogDir)) { New-Item -ItemType Directory -Path $LogDir | Out-Null }

$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$logfile = Join-Path $LogDir "system_snapshot_$timestamp.txt"

"==========================================" | Out-File $logfile
" SYSTEM SNAPSHOT - $timestamp"             | Out-File $logfile -Append
"==========================================" | Out-File $logfile -Append

# --- OS INFORMATION ---
"`n[*] Operating System Info:" | Out-File $logfile -Append
Get-WmiObject -Class Win32_OperatingSystem | Format-List Caption, Version, OSArchitecture, Manufacturer, BuildNumber, InstallDate | Out-File $logfile -Append

# --- SYSTEM HARDWARE INFO ---
"`n[*] System Hardware Info:" | Out-File $logfile -Append
Get-WmiObject -Class Win32_ComputerSystem | Format-List Manufacturer, Model, TotalPhysicalMemory, NumberOfProcessors, Processor | Out-File $logfile -Append

# --- CPU INFO ---
"`n[*] CPU Info:" | Out-File $logfile -Append
Get-WmiObject -Class Win32_Processor | Format-List Name, Manufacturer, NumberOfCores, NumberOfLogicalProcessors, MaxClockSpeed | Out-File $logfile -Append

# --- MEMORY INFO ---
"`n[*] Memory Info:" | Out-File $logfile -Append
Get-WmiObject -Class Win32_PhysicalMemory | Format-List Capacity, Speed, Manufacturer, PartNumber | Out-File $logfile -Append

# --- DISK INFO ---
"`n[*] Disk Info:" | Out-File $logfile -Append
Get-WmiObject -Class Win32_DiskDrive | Format-List DeviceID, Model, Size, MediaType, SerialNumber | Out-File $logfile -Append

# --- NETWORK INFO ---
"`n[*] Network Info:" | Out-File $logfile -Append
Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled -eq $true} | Format-List Description, MACAddress, IPAddress | Out-File $logfile -Append

# --- INSTALLED SOFTWARE ---
"`n[*] Installed Software:" | Out-File $logfile -Append
Get-WmiObject -Class Win32_Product | Format-Table Name, Version | Out-File $logfile -Append

# --- SYSTEM ENVIRONMENT VARIABLES ---
"`n[*] Environment Variables:" | Out-File $logfile -Append
Get-ChildItem -Path Env: | Format-Table Name, Value | Out-File $logfile -Append

"`nDone. Output saved to $logfile"
Pause
