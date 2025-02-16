##########
#
# Script to enable TPM within the BIOS of Dell computers
#
##########

$BIOSPass = "MySuperSecretPassword"
$RequiresReboot = 0
$System = Get-CimInstance CIM_ComputerSystem -ComputerName $FQCN
if($($System.Manufacturer) -Like "Dell*"){
    $NuGet = Get-PackageProvider NuGet -ForceBootstrap -ErrorAction SilentlyContinue
    $DellBIOS =  Get-Module -ListAvailable DellBIOSProvider
    if([version]$DellBIOS.version -lt [version]"2.7.0"){
        Install-Module DellBIOSProvider -Force -SkipPublisherCheck
        $BIOSProviderPath = (Get-InstalledModule -Name DellBiosProvider -ErrorAction SilentlyContinue).InstalledLocation
        Unblock-File $BIOSProviderPath
    }
    Import-Module DellBIOSProvider
    $ExistPw = Get-Item DellSmbios:\Security\IsAdminPasswordSet
    $AlreadySet = $ExistPw.CurrentValue
    if($AlreadySet -eq $False){
        Set-Item -Path DellSmbios:\Security\AdminPassword $BIOSPass
    }
    $TPMEnabled = (Get-Item DellSmbios:\TPMSecurity\TpmSecurity).CurrentValue
    $TPMActivated = (Get-Item DellSmbios:\TPMSecurity\TpmActivation).CurrentValue
    if($TPMEnabled -eq "Disabled") {
        Set-Item -Path DellSmbios:\TPMSecurity\TpmSecurity Enabled -Password $BIOSPass
        $RequiresReboot = 1
    }
    if($TPMActivated -eq "Disabled") {
	      Set-Item -Path DellSmbios:\TPMSecurity\TpmActivation Enabled -Password $BIOSPass
        $RequiresReboot = 1
    }
    if($RequiresReboot -eq 1) {
        Write-Host "Reboot required to enable/activate TPM"
    }
}
