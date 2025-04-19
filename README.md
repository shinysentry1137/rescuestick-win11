# Rescue Stick for Windows 11

**Overview**

A modular toolkit for technicians to recover, repair, and assist users with broken, corrupted, or lost data. Completely offline and open source.

**Please read the disclaimer file (DISCLAIMER.txt) before utilizing this project.**

--------------------

**Notable Features**
- 100% offline, portable, and native (needs no connections or dependencies)
- Every tool is written using mostly human-readable scripts
- All parts can be opened, inspected, or modified before use

--------------------

**How to Use**
1. Get a USB stick (8 GB or larger) and format it as NTFS (best format for Windows, preferred here for long paths and permission flexibility). Name the volume clearly as RESCUE.
2. Download this project and unzip the package. Put all contents on the USB stick.
3. Go to your stick in File Explorer, and right-click launcher.bat, selecting Run as Administrator. Should open to a menu allowing tools to be selected by numbers.
You can also open a command prompt or PowerShell window and cd into the stick.

--------------------

**Tools Included in Package**

Launcher (launcher.bat)
Launches a menu which you can select each tool by number.

1. File Recovery Log Scanner (recover_scan.bat)
Finds potentially recoverable deleted files via filesystem metadata. You can surface deleted files that still exist in temp, shadow, or bin.

2. Drive Health Snapshot (drive_health.ps1)
Reports basic disk health and config info using built-in tools. Fast triage. Shows if you have a healthy disk or failing hardware.

3. CHKDSK Runner (chkdsk_runner.bat)
Runs CHKDSK with logging. Easy way to fix filesystem errors and log them for accountability.

4. System Snapshot Generator (system_snapshot.ps1)
Captures critical system info. Knowing much of it can guide your fixes and give audit trails.

5. Volume Shadow Copy Recovery Helper (vss_recovery_helper.bat)
Lists VSS snapshots, mounts them for manual recovery. Can recover earlier versions of files even after deletion.

6. Startup Inspection Tool (startup_inspector.ps1)
Finds  startup programs, Run keys, services. Detects issues with slow boot, malware leftovers, broken boot configs.

7. Drive Cloner (Local File-Based) (drive_cloner.bat)
Clones a drive sector-by-sector using Windows native tools. Before touching a drive, clone it.

8. Simple File Hasher (file_hasher.ps1)
Creates SHA256/MD5 for any file or directory tree. Verifies file integrity, compare backups, detect corruption.

9. Partition Table Viewer (partition_viewer.ps1)
Shows disk layout, partitions, types. Understand what’s missing, what’s hidden, or what’s wrong before starting recovery processes.

10. Basic Secure Eraser (secure_eraser.bat)
Wipes a file, folder, or otherwise compatible space using native overwrites. Provides erasure methods for broken or unsalvageable drives.

11. File System Analyzer (fs_analyzer.ps1)
Walks NTFS/other volumes and builds a report of filetypes, sizes, and last modified dates. Helps spot user data and surface what's recoverable.

--------------------

This project will be expanded to include more repair tools and useful scripts in the future.
