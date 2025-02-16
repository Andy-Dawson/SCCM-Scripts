####################
#
# Script to remove old version(s) of Unity Editor
#
####################

# Get the folders that contain 'Unity', other than 'Unity Hub' and the most recent version
# Start by getting any folders that contain 'Unity *' and that are not 'Unity Hub'
$vers = Get-ChildItem -Directory -Depth 0 -Filter "Unity *" -Path 'C:\Program Files\' | Where {$_.Name -ne "Unity Hub"} | Sort-Object -Property Creationtime -Descending
# Now check how many we have - if only 1, we should not need to do anything
if ($vers.count -gt 1) {
	# We need to remove at least 1 previous instance of Unity Editor
	$NumInstances = $vers.count
	For ($i = 1; $i -le ($NumInstances - 1); $i++) {
		# Assemble the path to the exe to call
		$ExePath = $vers[$i].FullName + "\Editor\Uninstall.exe"
		Write-Host "Running uninstaller at $($ExePath)"
		Start-Process -Wait $ExePath -argumentlist "/S"
	}
} elseif ($vers.count -eq 1) {
	# Only 1 instance
	Write-Host "Only a single instance of Unity is installed - $($vers[0].FullName)"
} else {
	# No instances
	Write-Host "No instances of Unity found"
}
