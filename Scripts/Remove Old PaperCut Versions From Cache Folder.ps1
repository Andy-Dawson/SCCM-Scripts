##########
#
# Script to remove old copies of the PaperCut client application from the C:\Cache folder
#
##########

if (Test-Path -Path "C:\Cache" -PathType Container) {
	# We have a C:\Cache path to check, now get the list of folders in the C:\Cache folder
	$cachefolders = Get-ChildItem -Path C:\Cache -Depth 0 | Where-Object {$_.LastWriteTime} | Sort-Object LastWriteTime -Descending
	# Check whether we have any folders in the C:\Cache folder
	$numfolders = $cachefolders.count
	if ($numfolders -gt 0) {
		# We have at least one folder in the C:\Cache folder, proceed...
		if ($numfolders -gt 1) {
			# Remove all except the latest
			For ($i=1; $i -le $numfolders-1; $i++) {
				write-host "Removing item $($cachefolders[$i].FullName)"
				Remove-Item -Path $cachefolders[$i].FullName -Recurse
			}
		} else {
			# The C:\Cache folder only contains 1 folder
			Write-Host "C:\Cache contains only a single folder; nothing to be done..."
		}
	} else {
		# C:\Cache folder exists, but has not subn-folders
		Write-Host "C:\Cache folder found, BUT is empty..."
	}
} else {
	# No C:\Cache folder found
	Write-Host "C:\Cache folder NOT found..."
}
