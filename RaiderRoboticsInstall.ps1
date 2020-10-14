# Raider Robotics Software Install Script #
# ======================================= #
#
# This script is used to install git, set 
# up an SSH-Key for the user, pull the
# latest install scripts from our repo, 
# and start the installation.
#
# ======================================= #

param (
    [String][ValidateSet('y','n')]$Web = 'n', 
    [String][ValidateSet('y','n')]$Embedded = 'n', 
    [String][ValidateSet('y','n')]$DataScience = 'n',
    [String][ValidateSet('y','n')]$Debug = 'n'
)

Write-Host "Raider Robotics Software Installation Script"
Write-Host "If installation fails further down the script, do NOT run the internal installation scripts separately."
Write-Host "This script automatically detects previous installations and doesn't re-install software packages."

Write-Host "It is recommended to close all other programs while running the installation script." -BackgroundColor Yellow -ForegroundColor Black
Write-Host "This script will automatically restart your computer one or more times during installation". -BackgroundColor Red -ForegroundColor White
Write-Host "Please type 'y' if you accept this and are ready to start installation."

$key = $host.UI.RawUI.ReadKey()
Write-Host ""
if ($key.Character -ne 'y') {
    Write-Host "ERROR: Script denied. Exiting..." -BackgroundColor Red -ForegroundColor White
    exit
}

Write-Host "This script will install the following software packages:"

Write-Host "Basic Software Pack" -BackgroundColor Blue -ForegroundColor White

If ($Web -eq "y") {
    Write-Host "Web Team Pack" -BackgroundColor Blue -ForegroundColor White
}

If ($Embedded -eq "y") {
    Write-Host "Embedded Team Pack" -BackgroundColor Blue -ForegroundColor White 
}

If ($DataScience -eq "y") { 
    Write-Host "Data Science Pack" -BackgroundColor Blue -ForegroundColor White
}

Start-Sleep -Seconds 5

Write-Host "Starting installation..."

# Default directory inside of $PSScriptRoot to look for installation scripts
$ScriptDirectory = 'InstallationScripts'

# Find the lowest-numbered install script in the folder
$InstallationScript = Get-ChildItem -Path "$PSScriptRoot\$ScriptDirectory\*" -Include "*.ps1" | Sort-Object | Select-Object -First 1

# Run the previously found script
& $InstallationScript -Web $Web -Embedded $Embedded -DataScience $DataScience -Debug $Debug