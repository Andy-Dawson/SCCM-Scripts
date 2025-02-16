##########
#
# Script to setup BIOS password, auto-wake times, WoL config etc. within the BIOS of Dell computers
#
##########

$BIOSPass = "MySuperSecretPassword"
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
    $minutes = Get-Random -Minimum -0 -Maximum 30 #Reduces issue of circuit trips
    Set-Item -Path DellSMBIOS:\PowerManagement\DeepSleepCtrl Disabled -Password $BIOSPass
    Set-Item -Path DellSMBIOS:\PowerManagement\AutoOnHr 8 -Password $BIOSPass
    Set-Item -Path DellSMBIOS:\PowerManagement\AutoOnMn $minutes -Password $BIOSPass
    Set-Item -Path DellSMBIOS:\PowerManagement\AutoOn SelectDays -Password $BIOSPass
    Set-Item -Path DellSMBIOS:\PowerManagement\AutoOnSun Disabled -Password $BIOSPass
    Set-Item -Path DellSMBIOS:\PowerManagement\AutoOnMon Enabled -Password $BIOSPass
    Set-Item -Path DellSMBIOS:\PowerManagement\AutoOnTue Enabled -Password $BIOSPass
    Set-Item -Path DellSMBIOS:\PowerManagement\AutoOnWed Enabled -Password $BIOSPass
    Set-Item -Path DellSMBIOS:\PowerManagement\AutoOnThur Enabled -Password $BIOSPass
    Set-Item -Path DellSMBIOS:\PowerManagement\AutoOnFri Enabled -Password $BIOSPass
    Set-Item -Path DellSMBIOS:\PowerManagement\AutoOnSat Disabled -Password $BIOSPass
    Set-Item -Path DellSMBIOS:\PowerManagement\WakeOnLan LanOnly -Password $BIOSPass
    Set-Item -Path DellSmbios:\Wireless\WirelessLan Disabled -Password $BIOSPass
}
