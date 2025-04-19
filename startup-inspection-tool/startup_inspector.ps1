# ===============================
# Startup Inspection Tool
# ===============================

$ToolRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
$LogDir = Join-Path $ToolRoot "logs"
If (!(Test-Path $LogDir)) { New-Item -ItemType Directory -Path $LogDir | Out-Null }

$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$logfile = Join-Path $LogDir "startup_inspection_$timestamp.txt"

"==========================================" | Out-File $logfile
" STARTUP INSPECTION TOOL - $timestamp"     | Out-File $logfile -Append
"==========================================" | Out-File $logfile -Append

# --- RUN KEYS: HKLM ---
"`n[*] HKLM Run Keys:" | Out-File $logfile -Append
Try {
    Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run" | Out-File $logfile -Append
} Catch {
    "Error reading HKLM Run keys: $_" | Out-File $logfile -Append
}

# --- RUN KEYS: HKCU ---
"`n[*] HKCU Run Keys:" | Out-File $logfile -Append
Try {
    Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" | Out-File $logfile -Append
} Catch {
    "Error reading HKCU Run keys: $_" | Out-File $logfile -Append
}

# --- STARTUP FOLDERS ---
"`n[*] Startup Folder (All Users):" | Out-File $logfile -Append
$allUsersStartup = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"
Get-ChildItem -Path $allUsersStartup -Force | Out-File $logfile -Append

"`n[*] Startup Folder (Current User):" | Out-File $logfile -Append
$currentUserStartup = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
Get-ChildItem -Path $currentUserStartup -Force | Out-File $logfile -Append

# --- SCHEDULED TASKS THAT RUN AT LOGIN ---
"`n[*] Scheduled Tasks at Logon:" | Out-File $logfile -Append
Get-ScheduledTask | Where-Object { $_.Triggers | Where-Object { $_.AtLogOn -eq $true } } | Format-Table TaskName, TaskPath, State | Out-File $logfile -Append

# --- AUTO-START SERVICES ---
"`n[*] Services Set to Auto Start:" | Out-File $logfile -Append
Get-Service | Where-Object { $_.StartType -eq 'Automatic' } | Format-Table Name, DisplayName, Status | Out-File $logfile -Append

"`nDone. Output saved to $logfile"
Pause
