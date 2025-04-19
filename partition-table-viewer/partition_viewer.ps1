# ===============================
# Partition Table Viewer Tool
# ===============================

$ToolRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
$LogDir = Join-Path $ToolRoot "logs"
If (!(Test-Path $LogDir)) { New-Item -ItemType Directory -Path $LogDir | Out-Null }

$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$LogFile = Join-Path $LogDir "partition_view_$timestamp.txt"

"==========================================" | Out-File $LogFile
" PARTITION TABLE VIEWER - $timestamp"      | Out-File $LogFile -Append
"==========================================" | Out-File $LogFile -Append

# --- DISK INFO ---
"`n[*] Physical Disks:" | Out-File $LogFile -Append
Get-Disk | Format-Table Number, FriendlyName, Size, PartitionStyle, OperationalStatus | Out-String | Out-File $LogFile -Append

# --- PARTITIONS ---
"`n[*] Partitions:" | Out-File $LogFile -Append
Get-Partition | Format-Table DiskNumber, PartitionNumber, DriveLetter, Size, Type | Out-String | Out-File $LogFile -Append

# --- VOLUMES ---
"`n[*] Volumes:" | Out-File $LogFile -Append
Get-Volume | Format-Table DriveLetter, FileSystemLabel, FileSystem, SizeRemaining, Size, HealthStatus | Out-String | Out-File $LogFile -Append

# --- DISKPART OUTPUT (Bonus Raw View) ---
"`n[*] DiskPart Output:" | Out-File $LogFile -Append

$diskpartScript = Join-Path $env:TEMP "diskpart_temp_script.txt"
Set-Content -Path $diskpartScript -Value "list disk`nlist volume`nlist partition"
$diskpartOut = diskpart /s $diskpartScript
$diskpartOut | Out-File $LogFile -Append

Remove-Item $diskpartScript -Force

"`nDone. Output saved to $LogFile"
Pause
