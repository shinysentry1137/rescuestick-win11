# ============================
# File System Analyzer
# ============================

$ToolDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$LogDir = Join-Path $ToolDir "logs"
If (!(Test-Path $LogDir)) { New-Item -ItemType Directory -Path $LogDir | Out-Null }

$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$LogFile = Join-Path $LogDir "fs_analysis_$timestamp.txt"

function Log ($msg) {
    $entry = "[{0}] {1}" -f (Get-Date -Format "HH:mm:ss"), $msg
    $entry | Tee-Object -FilePath $LogFile -Append
}

Write-Host "`n==========================="
Write-Host " FILE SYSTEM ANALYZER"
Write-Host "==========================="
$target = Read-Host "Enter FULL path of folder or drive to analyze"

if (!(Test-Path $target)) {
    Log "Invalid path: $target"
    Write-Host "Invalid path. Exiting."
    exit
}

Log "Analyzing path: $target"

# Collect files
$files = Get-ChildItem -Path $target -Recurse -File -ErrorAction SilentlyContinue

if ($files.Count -eq 0) {
    Log "No files found at $target"
    Write-Host "No files found. Exiting."
    exit
}

# File extension stats
Log "`n--- File Extension Breakdown ---"
$files | Group-Object Extension | Sort-Object Count -Descending | ForEach-Object {
    $ext = if ($_.Name) { $_.Name } else { "[no extension]" }
    $count = $_.Count
    $totalSize = ($_.Group | Measure-Object Length -Sum).Sum
    Log ("{0,-10} {1,6} files - {2,10:N0} bytes" -f $ext, $count, $totalSize)
}

# Oldest files
Log "`n--- 10 Oldest Files ---"
$files | Sort-Object LastWriteTime | Select-Object -First 10 | ForEach-Object {
    Log ("{0} | {1}" -f $_.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss"), $_.FullName)
}

# Newest files
Log "`n--- 10 Newest Files ---"
$files | Sort-Object LastWriteTime -Descending | Select-Object -First 10 | ForEach-Object {
    Log ("{0} | {1}" -f $_.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss"), $_.FullName)
}

# Largest files
Log "`n--- 10 Largest Files ---"
$files | Sort-Object Length -Descending | Select-Object -First 10 | ForEach-Object {
    Log ("{0,12:N0} bytes | {1}" -f $_.Length, $_.FullName)
}

Log "`nAnalysis complete."
Pause
