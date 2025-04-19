# ================================
# Basic Secure Eraser
# ================================

$ToolDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$LogDir = Join-Path $ToolDir "logs"
If (!(Test-Path $LogDir)) { New-Item -ItemType Directory -Path $LogDir | Out-Null }

$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$LogFile = Join-Path $LogDir "secure_erase_$timestamp.txt"

function Log ($msg) {
    $entry = "[{0}] {1}" -f (Get-Date -Format "HH:mm:ss"), $msg
    $entry | Tee-Object -FilePath $LogFile -Append
}

# Prevent wiping system-critical or active directories
function IsSystemPath($path) {
    $protected = @(
        "$env:WINDIR", "C:\Windows", "C:\Program Files", "C:\Program Files (x86)",
        "$ToolDir", "$env:SystemDrive\Users", "$env:SystemDrive\ProgramData"
    )
    foreach ($p in $protected) {
        if ($path -like "$p*") { return $true }
    }
    return $false
}

# File wipe with three passes (zeros, ones, random)
function Wipe-File {
    param ($file)

    try {
        $size = (Get-Item $file).Length
        $fs = [System.IO.File]::Open($file, 'Open', 'Write')
        $bytes = New-Object Byte[] $size

        # Pass 1: 0x00
        [byte]0x00 | ForEach-Object { [void]$bytes.SetValue($_, ($_..($size - 1))) }
        $fs.Write($bytes, 0, $size)
        $fs.Flush()
        $fs.Position = 0

        # Pass 2: 0xFF
        [byte]0xFF | ForEach-Object { [void]$bytes.SetValue($_, ($_..($size - 1))) }
        $fs.Write($bytes, 0, $size)
        $fs.Flush()
        $fs.Position = 0

        # Pass 3: Random
        (New-Object System.Random).NextBytes($bytes)
        $fs.Write($bytes, 0, $size)
        $fs.Close()

        Remove-Item $file -Force
        Log "WIPED: $file"
    } catch {
        Log "ERROR wiping $file - $_"
    }
}

# Recursive folder wipe
function Wipe-Folder {
    param($path)
    Get-ChildItem -Path $path -Recurse -File | ForEach-Object {
        Wipe-File -file $_.FullName
    }
    Remove-Item -Path $path -Recurse -Force
    Log "REMOVED folder: $path"
}

# Free space wipe using built-in cipher
function Wipe-FreeSpace {
    param($drive)
    Log "Free space wipe on $drive..."
    cipher /w:$drive | Out-String | Out-File -FilePath $LogFile -Append
}

# Menu
Write-Host "`n========================"
Write-Host "   BASIC SECURE ERASER"
Write-Host "========================"
Write-Host "1. Wipe a File"
Write-Host "2. Wipe a Folder"
Write-Host "3. Wipe Free Space on Drive"
Write-Host "4. Exit"
$choice = Read-Host "Select option (1-4)"

switch ($choice) {
    "1" {
        $target = Read-Host "Enter FULL path to file"
        if (!(Test-Path $target -PathType Leaf)) {
            Log "Invalid file path: $target"
        } elseif (IsSystemPath $target)) {
            Log "Blocked system file wipe: $target"
        } else {
            Wipe-File -file $target
        }
    }

    "2" {
        $target = Read-Host "Enter FULL path to folder"
        if (!(Test-Path $target -PathType Container)) {
            Log "Invalid folder path: $target"
        } elseif (IsSystemPath $target)) {
            Log "Blocked system folder wipe: $target"
        } else {
            Wipe-Folder -path $target
        }
    }

    "3" {
        $drive = Read-Host "Enter DRIVE LETTER (example: D)"
        $driveLetter = "$drive`:\"
        if ($drive -match "^[A-Z]$" -and (Test-Path $driveLetter)) {
            Wipe-FreeSpace -drive $driveLetter
        } else {
            Log "Invalid drive selection: $driveLetter"
        }
    }

    default {
        Log "No action selected."
    }
}

Log "Secure erase complete."
Pause
