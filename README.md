# SCCM-Scripts
PowerShell scripts for use within SCCM/SCEM to achieve specific tasks.

## Introdcution
This respository contains scripts used within SCCM/SCEM to achieve single tasks against one or more client computers.

[Scripts](https://github.com/Andy-Dawson/SCCM-Scripts/tree/main/Scripts) include:

* [Check and Enable BitLocker.ps1](https://github.com/Andy-Dawson/SCCM-Scripts/blob/main/Scripts/Check%20and%20Enable%20BitLocker.ps1) - Checks BitLocker status and enables it, if possible.

* [Clear Disk Space.ps1](https://github.com/Andy-Dawson/SCCM-Scripts/blob/main/Scripts/Clear%20Disk%20Space.ps1) - Clears disk space on the target computers by removing the oldest user profiles. Expecially useful when SSDs are not large enough!

* [Dell TPM.ps1](https://github.com/Andy-Dawson/SCCM-Scripts/blob/main/Scripts/Dell%20TPM.ps1) - Enables TPM within the BIOS of Dell computers, if possible. Provides feedback if not.

* [Dell WakeUp Configuration.ps1](https://github.com/Andy-Dawson/SCCM-Scripts/blob/main/Scripts/Dell%20WakeUp%20Configuration.ps1) - Configures the auto-wake settings within the BIOS of Dell computers and also configures required settings for wake-on-LAN.

* [Remove Old PaperCut Versions From Cache Folder.ps1](https://github.com/Andy-Dawson/SCCM-Scripts/blob/main/Scripts/Remove%20Old%20PaperCut%20Versions%20From%20Cache%20Folder.ps1) - Checks the 'C:\Cache' folder created on client computers by the PaperCut client application and removes all but the most recent version. This has been useful for clearing out old versions which contain vulnerabilities.

* [Remove Old Unity Instances.ps1](https://github.com/Andy-Dawson/SCCM-Scripts/blob/main/Scripts/Remove%20Old%20Unity%20Instances.ps1) - Looks for, and removes, old instances of Unity.

* [Query Visual Studio Installation.ps1](https://github.com/Andy-Dawson/SCCM-Scripts/blob/main/Scripts/Query%20Visual%20Studio%20Installation.ps1) - Looks for, and reports the version of Visual Studio Community 2022, if one is installed.
