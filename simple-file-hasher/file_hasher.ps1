# =====================================
# Simple File Hasher - SHA256 & MD5
# =====================================

$ToolDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$LogDir = Join-Path $ToolDir "logs"
If (!(Test-Path $LogDir)) { New-Item -ItemType Directory -Path $LogDir | Out-Null }

$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$LogFile = Join-Path $LogDir "hash_report_$timestamp.txt"

"==========================================" | Out-File $LogFile
" FILE HASHER LOG - $timestamp"             | Out-File $LogFile -Append
"==========================================" | Out-File $LogFile -Append

# Ask user for file or folder input
$target = Read-Host "Enter full path to file or folder"

# Confirm path exists
if (!(Test-Path $target)) {
    "Path does not exist. Exiting..." | Out-File $LogFile -Append
    Write-Host "Invalid path. Exiting."
    exit
}

# Function to get both SHA256 and MD5
function Get-Hashes {
    param($filepath)
    try {
        $sha256 = Get-FileHash -Algorithm SHA256 -Path $filepath
        $md5 = Get-FileHash -Algorithm MD5 -Path $filepath
        return @{
            Path = $filepath
            SHA256 = $sha256.Hash
            MD5 = $md5.Hash
        }
    } catch {
        return @{
            Path = $filepath
            SHA256 = "ERROR"
            MD5 = "ERROR"
        }
    }
}

# Process single file or full folder
if (Test-Path $target -PathType Leaf) {
    # Single file
    $result = Get-Hashes -filepath $target
    "FILE: $($result.Path)" | Out-File $LogFile -Append
    "SHA256: $($result.SHA256)" | Out-File $LogFile -Append
    "MD5:    $($result.MD5)"    | Out-File $LogFile -Append
    "" | Out-File $LogFile -Append
} else {
    # Directory
    Get-ChildItem -Path $target -Recurse -File | ForEach-Object {
        $result = Get-Hashes -filepath $_.FullName
        "FILE: $($result.Path)" | Out-File $LogFile -Append
        "SHA256: $($result.SHA256)" | Out-File $LogFile -Append
        "MD5:    $($result.MD5)"    | Out-File $LogFile -Append
        "" | Out-File $LogFile -Append
    }
}

Write-Host "Hashes written to $LogFile"
Pause
