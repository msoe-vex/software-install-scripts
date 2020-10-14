$PSParams = '-WindowStyle Normal -NoLogo -NoExit -Command '
$PSLoc =  "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
$TaskName = "RaiderRoboticsInstallScript"

$MainDirectory = "C:"
$MainSubdirectory = "RaiderRobotics"
$MainInstallSubdirectory = "temp"
$InstallationScriptSubdirectory = "InstallationScripts"

$RaiderRoboticsDirectory = "$MainDirectory\$MainSubdirectory"
$RaiderRoboticsInstallDirectory = "$RaiderRoboticsDirectory\$MainInstallSubdirectory"

$NodeVersion = "14.13.0"

$ProsFile = "pros-windows-3.1.4.0-64bit.exe"
$ProsURI = "https://github.com/purduesigbots/pros-cli/releases/download/3.1.4/$ProsFile"

$WSL2UpdateFile = "wsl_update_x64.msi"
$WSL2UpdateURI = "https://wslstorestorage.blob.core.windows.net/wslblob/$WSL2UpdateFile"