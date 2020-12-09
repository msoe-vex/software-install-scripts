$PSParams = '-WindowStyle Normal -NoLogo -NoExit -Command '
$PSLoc =  "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
$TaskName = "RaiderRoboticsInstallScript"

$MainDirectory = "C:"
$MainSubdirectory = "RaiderRobotics"
$MainInstallSubdirectory = "Install"
$MainInstallScriptGitSubdirectory = "software-install-scripts"

# Directory inside of the Git directory to look for linked files
$InstallationScriptSubdirectory = "InstallationScripts"

$RaiderRoboticsDirectory = "$MainDirectory\$MainSubdirectory"
$RaiderRoboticsInstallDirectory = "$RaiderRoboticsDirectory\$MainInstallSubdirectory"
$RaiderRoboticsInstallScriptGitDirectory = "$RaiderRoboticsDirectory\$MainInstallScriptGitSubdirectory"

$VS2019Directory = "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community"

$NodeVersion = "14.13.0"

$ProsFile = "pros-windows-3.1.4.0-64bit.exe"
$ProsURI = "https://github.com/purduesigbots/pros-cli/releases/download/3.1.4/$ProsFile"

$ARMGCCFile = "gcc-arm-compiler.exe"
$ARMGCCURI = "https://developer.arm.com/-/media/Files/downloads/gnu-rm/9-2020q2/gcc-arm-none-eabi-9-2020-q2-update-win32.exe?revision=50c95fb2-67ca-4df7-929b-55396266b4a1&la=en&hash=DE1CD6E7A15046FD1ADAF828EA4FA82228E682E2"

$WSL2UpdateFile = "wsl_update_x64.msi"
$WSL2UpdateURI = "https://wslstorestorage.blob.core.windows.net/wslblob/$WSL2UpdateFile"

