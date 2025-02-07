# UninstDellOptimizer.ps1
# By pkspsne

# Getting processes matching wildcard 'Dell*Optimizer*'
$procs = Get-Process | Where-Object Name -like "Dell*Optimizer*"

# If processes found, kills them each in turn
If ($procs) {
    ForEach ($proc in $procs) {
        $thisID = $proc.Id
        $thisName = $proc.ProcessName
        Stop-Process -Id $thisId -Force -ErrorAction SilentlyContinue
        Write-Host "Killing $thisID`: $thisName" -ErrorAction SilentlyContinue
    }
}

# Pause for 3 seconds to let processes die
Start-Sleep -Seconds 3

# Detects if DellInc.DellOptimizer (Appx Package) is present 
# and uninstalls it if found
If (Get-AppxPackage -Name "DellInc.DellOptimizer") {
	$packageFullName = (Get-AppxPackage -Name "DellInc.DellOptimizer").PackageFullName
	Remove-AppxPackage -Package $packageFullName -AllUsers
}

# Detects if DellOptimizerUI (64-bit) is present 
# and uninstalls it if found
$64BitUI = (Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" | Where-Object { $_.DisplayName -match "DellOptimizerUI"}).UninstallString
If ($64BitUI) {

    $parts = $64BitUI -split " "
	$parts = $parts[1] -split "/I"
	$appID = $parts[1]
	
	Start-Process "C:\Windows\System32\msiexec.exe" -ArgumentList "/x $appID /qn" -Wait
}

# Detects if DellOptimizerUI (64-bit) is present 
# and uninstalls it if found
$64BitApp = (Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" | Where-Object { $_.DisplayName -match "Dell Optimizer"}).UninstallString
If ($64BitApp) {
	
	$parts = $64BitApp -split " "
	$parts = $parts[1] -split "/I"
	$appID = $parts[1]
	
	Start-Process "C:\Windows\System32\msiexec.exe" -ArgumentList "/x $appID /qn" -Wait
}

# Detects if Dell Optimizer Core (32-bit) is present 
# and uninstalls it if found
$core = (Get-ItemProperty "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*" | Where-Object { $_.DisplayName -match "Dell Optimizer Core"}).UninstallString
If ($core) {

	cmd /c $core -silent
}
