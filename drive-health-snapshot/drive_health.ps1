# ===============================
# Drive Health Snapshot Tool
# ===============================

$ToolRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
$LogDir = Join-Path $ToolRoot "logs"
If (!(Test-Path $LogDir)) { New-Item -ItemType Directory -Path $LogDir | Out-Null }

$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$logfile = Join-Path $LogDir "drive_health_$timestamp.txt"

"==========================================" | Out-File $logfile
" DRIVE HEALTH SNAPSHOT - $timestamp"        | Out-File $logfile -Append
"==========================================" | Out-File $logfile -Append

# --- PHYSICAL DISK STATUS ---
"`n[*] Physical Disks:" | Out-File $logfile -Append
Get-PhysicalDisk | Format-List FriendlyName, MediaType, Size, HealthStatus, OperationalStatus | Out-File $logfile -Append

# --- DISK DETAILS ---
"`n[*] Disk Info (Get-Disk):" | Out-File $logfile -Append
Get-Disk | Format-List Number, FriendlyName, SerialNumber, Size, PartitionStyle, OperationalStatus | Out-File $logfile -Append

# --- WMIC DISKDRIVE STATUS (legacy but still helpful) ---
"`n[*] WMIC DiskDrive Status:" | Out-File $logfile -Append
wmic diskdrive get status, caption, size, serialnumber /format:list | Out-File $logfile -Append

# --- VOLUME LAYOUT ---
"`n[*] Volume Info (Get-Volume):" | Out-File $logfile -Append
Get-Volume | Format-List DriveLetter, FileSystemLabel, FileSystem, SizeRemaining, Size, HealthStatus | Out-File $logfile -Append

"`nDone. Output saved to $logfile"
Pause
