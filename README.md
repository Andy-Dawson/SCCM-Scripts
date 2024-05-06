# SCCM-Scripts
PowerShell scripts for use within SCCM/SCEM to achieve specific tasks.

## Introdcution
This respository contains scripts used within SCCM/SCEM to achieve single tasks against one or more client computers.

Scripts include:

* Remove Old PaperCut Versions From Cache Folder.ps1 - This script checks the 'C:\Cache' folder created on client computers by the PaperCut client application and removes all but the most recent version. This has been useful for clearing out old versions which contain vulnerabilities.

