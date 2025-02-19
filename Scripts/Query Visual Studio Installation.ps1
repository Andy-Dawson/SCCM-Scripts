###############
#
# Query Visual Studio Installation.ps1
# This script queries the computer for the installed version of Visual Studio, if any.
#
###############

# Look for an insallation of Visual Studio
if (Test-Path -Path "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe" -ErrorAction SilentlyContinue) {
    # We have an instance of devenv.exe in the right place, so Visual Studio should be installed - check the version
    if (Test-Path -Path "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe" -ErrorAction SilentlyContinue) {
        # The line below gets an array of output items from the command line process, but should identify the instance of VS Community
        $VSInstance = & "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe" -products Microsoft.VisualStudio.Product.Community
        if ($VSInstance.Count -gt 3) {
            $VSInstanceID = ($VSInstance | where-object {$_ -match 'instanceID: '} | foreach-object {$_ -replace 'instanceID: ',''})
            # Check that the state.json file exists for the above instance
            if (Test-Path -Path "C:\ProgramData\Microsoft\VisualStudio\Packages\_Instances\$VSInstanceID\state.json" -ErrorAction SilentlyContinue) {
                # the state.json file exists, so pull the version from it
                $state = Get-Content "C:\ProgramData\Microsoft\VisualStudio\Packages\_Instances\$VSInstanceID\state.json" | out-String | ConvertFrom-Json
                $InstalledVersion = [System.Version]$state.catalogInfo.productDisplayVersion
                Write-Host "Installed VS version: $($InstalledVersion.ToString())"
            } else {
                # Could not locate the state.json file, so there's something wrong with the installation
                Write-Host "Could not locate state.json file for the installed instance of VS 2022 Community"
            }
        } else {
            # No instances of VS detected by Get-CinInstance method
            Write-Host "No instances of VS 2022 Community detected by VSWhere.exe (but devenv.exe IS present) - This may indicate an (un)installation failure"
        }
    } else {
        # VSWhere.exe not available
        Write-Host "No instance of VSWhere.exe located (but devenv.exe IS present) - This may indicate an (un)installation failure"
    }
} else {
    # Visual Studio 2022 Community is NOT installed and we can go ahead and install it
    Write-Host "It appears that VS 2022 Community is NOT installed..."
}

# Final checks to ensure that the software is installed correctly (or as correctly as we can tell, anyway...)
# Check for well known files to be present
# devenv.exe
Write-Host "Checking for presence of devenv.exe"
if (!(Test-Path -Path "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe" -ErrorAction SilentlyContinue)) {
    # We don't have devenv.exe
    Write-Host "  o devenv.exe NOT found"
    $ThrowException = $true
}
# vswhere.exe
Write-Host "Checking for presence of vswhere.exe"
if (!(Test-Path -Path "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe" -ErrorAction SilentlyContinue)) {
    # We don't have vswhere.exe
    Write-Host "  o vswhere.exe NOT found"
    $ThrowException = $true
}
# VS setup.exe program
Write-Host "Checking for presence of setup.exe"
if (!(Test-Path -Path "C:\Program Files (x86)\Microsoft Visual Studio\Installer\setup.exe" -ErrorAction SilentlyContinue)) {
    # We don't have setup.exe
    Write-Host "  o setup.exe NOT found"
    $ThrowException = $true
}
# devenv.isolation.ini (this appears to be the last file written by the installer)
Write-Host "Checking for presence of devenv.isolation.ini"
if (!(Test-Path -Path "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.isolation.ini" -ErrorAction SilentlyContinue)) {
    # We don't have devenv.isolation.ini
    Write-Host "  o devenv.isolation.ini NOT found"
    $ThrowException = $true
}
# Now check whether we think we have an issue...
if ($ThrowException) {
    # Houston we have a problem
    # Throw an exception to stop the script completing successfully
    Write-Host "Visual Studio not installed successfully (some well-known files are missing)"
} else {
    # We seem to have al well-known files is the correct locations
    Write-Host "  o All well-known files searched for were present"
}
