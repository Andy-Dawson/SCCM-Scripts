##########
#
# Script to delete old user profiles to attempt to reclaim disk space
#
##########

# How much disk space do we need to attempt to end up with free?
$DiskSpaceRequired = 30 # in GB

# The list of accounts we need to be sure to keep
$AccountsToKeep = @('administrator','Public','default','administrator.DomainNetBIOS')

# Get the disk information for Drive C
$Disk = get-psdrive C
$DiskFreeSpace = $Disk.Free/1GB
$DiskFreeSpaceString = "{0:N2} GB" -f $DiskFreeSpace

# Check how much free disk space there is
if (!($DiskFreeSpace -ge $DiskSpaceRequired)) {
    # We do not have at least the requested disk space free
    Write-Host "Free disk space is not at least $($DiskSpaceRequired) GB, clearing old profiles..."
    Write-Host "Free disk space: $($DiskFreeSpaceString)"

    # Get the currently logged on user (if there is one)
    $SystemUsers = &query user | Select-Object -Skip 1
    foreach ($User in $SystemUsers) {
        if ($User.Split(" ")[0] -like ">*") {
            # This is the currently logged on user
            $LoggedOnUser = $User.split(" ")[0].ToString().Replace(">","")
            Write-Host "Logged on user: $($LoggedOnUser)"
        }
    }
    #$LoggedOnUser = Get-WmiObject Win32_LoggedOnUser | Select Antecedent -Unique | Where-Object { $_.Antecedent.ToString().Split('"')[1] -ne $env:COMPUTERNAME -and $_.Antecedent.ToString().Split('"')[1] -ne "Window Manager" -and $_.Antecedent.ToString().Split('"')[3] -notmatch $env:COMPUTERNAME } | %{"{0}\{1}" -f $_.Antecedent.ToString().Split('"')[1],$_.Antecedent.ToString().Split('"')[3]}
    if ($LoggedOnUser) {
        # We have a currently logged on user on the system, so do not want to attempt to delete their profile
        # The list of accounts for which we do not want to delete the profile
        $AccountsToKeep += $LoggedOnUser
    }
    # Now get the list of profiles in the C:\Users folder that are also not in the list of those to keep - sort by last use time (oldest to newest)
    $UserProfilestoRemove = Get-CimInstance -Class Win32_UserProfile |  Where-Object {$_.LocalPath -like "C:\Users\*" -and $_.LocalPath.split('\')[-1] -notin $AccountsToKeep} | Sort-Object LastUseTime
    if ($UserProfilestoRemove) {
        # We hae profiles that we can remove to regain some disk space
        foreach ($Profile in $UserProfilestoRemove) {
            Write-Host "Removing profile at $($Profile.LocalPath)"
            $Profile | Remove-CimInstance

            # Now get the free disk space to see whether we have enough and can stop deleting profiles
            $Disk = get-psdrive C
            $DiskFreeSpace = $Disk.Free/1GB
            $DiskFreeSpaceString = "{0:N2} GB" -f $DiskFreeSpace

            Write-Host "Free disk space is now $($DiskFreeSpaceString)"
            If ($DiskFreeSpace -ge $DiskSpaceRequired) {
                # We now have enough free disk space and can stop here
                Write-Host "Free disk space is now sufficient"
                Break
            }
        }
        # We have now removed as many profiles as we can, get the free disk space to see whether we have enough
        $Disk = get-psdrive C
        $DiskFreeSpace = $Disk.Free/1GB
        $DiskFreeSpaceString = "{0:N2} GB" -f $DiskFreeSpace
        # Let the user know if we still do not have the required disk space free
        If (!($DiskFreeSpace -ge $DiskSpaceRequired)) {
            # We still do not have enough disk space
            Write-Host "IMPORTANT - It appears that there are no further profiles that we can remove to increase disk space."
            Write-Host "Manual intervention will be required."
        }
    } else {
        # There are no profiles that can be removed, and therefore nothing we can do
        Write-Host "IMPORTANT - It appears that there are no profiles that we can remove to increase disk space."
        Write-Host "Manual intervention will be required."
    }
} else {
    # We have enough disk space, nothing to do
    Write-Host "Free disk space is sufficient, nothing to do..."
}

Write-Host "Script complete"
