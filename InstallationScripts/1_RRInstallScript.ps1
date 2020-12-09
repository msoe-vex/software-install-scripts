# --- Program Parameters --- #

param (
    [String][ValidateSet('y','n')]$Web = 'n', 
    [String][ValidateSet('y','n')]$Embedded = 'n', 
    [String][ValidateSet('y','n')]$DataScience = 'n',
    [String][ValidateSet('y','n')]$InstallWSL2 = 'n',
    [String][ValidateSet('y','n')]$LocalDebug = 'n',
    [String]$ExcludeScripts = $null
)

# ------ #

Set-Location -Path "C:\RaiderRobotics\software-install-scripts\InstallationScripts"

# --- Imports --- #

$ParentDir = (Get-Item $PSScriptRoot).Parent.FullName

$InstallConstants = Get-ChildItem -Path "$ParentDir\*" -Include "*Constants*" | Select-Object -First 1

. $InstallConstants # Import the constant variables (needs to be in parent directory, name containing "Constants")

$InstallFunctions = Get-ChildItem -Path "$ParentDir\*" -Include "*Functions*" | Select-Object -First 1
. $InstallFunctions # Import the function scripts (needs to be in parent directory, name containing "Functions")

# ------ #

# --- Removing any old runtime tasks for this file --- #

If (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue) {
    # Destroy any tasks that caused this script to run (prevents unwanted execution in the future)
    Get-ScheduledTask -TaskName $TaskName | Unregister-ScheduledTask -Confirm:$false
}

# ------ #

# --- Finish Installing WSL2 --- #


If ($InstallWSL2 -eq 'y') {
    Install-ExternalExecutable -InstallDir $RaiderRoboticsInstallDirectory -URI $WSL2UpdateURI -FileName $WSL2UpdateFile
}

Update-SessionEnvironment

# ------ #

# Web Team Tools #
If ($Web -eq "y") {

}
# # #

# Embedded Team Tools #
If ($Embedded -eq "y") {
    # No good way to check if Ubuntu 20.04 is currently installed
    choco install wsl-ubuntu-2004 --params "/InstallRoot:true"

    
}
# # #

# Data Science Tools #
If ($DataScience -eq "y") {

}
# # #





# ------ #