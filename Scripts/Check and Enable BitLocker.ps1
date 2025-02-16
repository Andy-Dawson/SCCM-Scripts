##########
#
# Script to check and enable BitLocker
#
##########

"Checking existing BitLocker status..." | Out-File -FilePath C:\Support\BLandTPMCheck.txt
$bls = Get-BitLockerVolume | Where {$_.MountPoint -eq "C:"}
if ($($bls.ProtectionStatus) -eq "On") {
    "Current BitLocker Status: $($bls.ProtectionStatus)" | Out-File -FilePath C:\Support\BLandTPMCheck.txt -Append
} else {
    "Current BitLocker Status: $($bls.ProtectionStatus)" | Out-File -FilePath C:\Support\BLandTPMCheck.txt -Append
    $tpm = Get-Tpm
    "Checking TPM..." | Out-File -FilePath C:\Support\BLandTPMCheck.txt -Append
    if ($($tpm.TpmPresent) -eq $true) {
        "TPM.TpmPresent: $($tpm.TpmPresent)" | Out-File -FilePath C:\Support\BLandTPMCheck.txt -Append
	    if ($($tpm.TpmEnabled) -eq $true) {
            "TPM.TpmEnabled: $($tpm.TpmEnabled)" | Out-File -FilePath C:\Support\BLandTPMCheck.txt -Append
            if ($($tpm.TpmActivated) -eq $true) {
                "TPM.TpmActivated: $($tpm.TpmActivated)" | Out-File -FilePath C:\Support\BLandTPMCheck.txt -Append
                if ($($tpm.TpmReady) -eq $true) {
                    "TPM.TpmReady: $($tpm.TpmReady)" | Out-File -FilePath C:\Support\BLandTPMCheck.txt -Append
                    "Enabling BitLocker..." | Out-File -FilePath C:\Support\BLandTPMCheck.txt -Append                
                    Enable-BitLocker -MountPoint "C:" -RecoveryPasswordProtector
                } else {"TPM.TpmReady: $($tpm.TpmReady) - Should be False" | Out-File -FilePath C:\Support\BLandTPMCheck.txt -Append}
            } else {"TPM.TpmActivated: $($tpm.TpmActivated) - Should be False" | Out-File -FilePath C:\Support\BLandTPMCheck.txt -Append}
        } else {"TPM.TpmEnabled: $($tpm.TpmEnabled) - Should be False" | Out-File -FilePath C:\Support\BLandTPMCheck.txt -Append}
    } else {"TPM.TpmPresent: $($tpm.TpmPresent) - Should be False" | Out-File -FilePath C:\Support\BLandTPMCheck.txt -Append}
    "TPM check complete" | Out-File -FilePath C:\Support\BLandTPMCheck.txt -Append
}
