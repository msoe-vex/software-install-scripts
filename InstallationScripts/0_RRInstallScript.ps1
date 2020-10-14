# --- Program Parameters --- #

param (
    [String][ValidateSet('y','n')]$Web = 'n', 
    [String][ValidateSet('y','n')]$Embedded = 'n', 
    [String][ValidateSet('y','n')]$DataScience = 'n',
    [String][ValidateSet('y','n')]$InstallWSL2 = 'n',
    [String][ValidateSet('y','n')]$Debug = 'n',
    [String]$ExcludeScripts = $null
)
# ------ #

# --- Imports --- #

$ParentDir = (Get-Item $PSScriptRoot).Parent.FullName

$InstallConstants = Get-ChildItem -Path "$ParentDir\*" -Include "*Constants*" | Select-Object -First 1
. $InstallConstants # Import the constant variables (needs to be in parent directory, name containing "Constants")

$InstallFunctions = Get-ChildItem -Path "$ParentDir\*" -Include "*Functions*" | Select-Object -First 1
. $InstallFunctions # Import the function scripts (needs to be in parent directory, name containing "Functions")

# ------ #

### Start Script Here

# --- Removing any old runtime tasks for this file --- #

If (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue) {
    # Destroy any tasks that caused this script to run (prevents unwanted execution in the future)
    Get-ScheduledTask -TaskName $TaskName | Unregister-ScheduledTask -Confirm:$false
}

# ------ #

# --- Creating RaiderRobotics Directory for Installs --- #

Write-Host "Checking for default install directory..."
If (!(Test-Path $RaiderRoboticsDirectory)) {
    Write-Host "Default directory not found. Creating $RaiderRoboticsDirectory..." -BackgroundColor DarkGreen
    New-Item -Path "$MainDirectory\" -Name $MainSubdirectory -ItemType "directory"
    New-Item -Path "$RaiderRoboticsDirectory\" -Name $MainInstallSubdirectory -ItemType "directory"
} Else {
    Write-Host "$RaiderRoboticsDirectory found. Checking for temp..." -BackgroundColor DarkGreen
    If (Test-Path $RaiderRoboticsInstallDirectory) {
        Write-Host "Previous installs found. Removing $RaiderRoboticsInstallDirectory..." -BackgroundColor DarkGreen
        Get-ChildItem $RaiderRoboticsInstallDirectory -Recurse | Remove-Item
    } Else {
        Write-Host "No install directory found. Creating $RaiderRoboticsInstallDirectory..." -BackgroundColor DarkGreen
        New-Item -Path "$RaiderRoboticsDirectory\$MainInstallSubdirectory"
    }
}

# ------ #

# --- Installing Chocolatey --- #

Set-ExecutionPolicy Bypass -Scope Process

Install-CommandIfNotInstalled -PackageName "Chocolatey" -CheckCommand "choco" -InstallCommand { Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString("https://chocolatey.org/install.ps1")) }

# Load choco into powershell environment
$env:ChocolateyInstall = Convert-Path "$((Get-Command choco).Path)\..\.."   
Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"

# ------ #

Update-SessionEnvironment # alias to refreshenv
Write-Host "Refreshing PATH environment, please wait..." -BackgroundColor Blue

# --- Installing Packages --- #

# Basic Software Development Tools #
Install-CommandIfNotInstalled -PackageName "Git" -CheckCommand "git" -InstallCommand { choco install "git" -y }
Install-CommandIfNotInstalled -PackageName "VSCode" -CheckCommand "code" -InstallCommand { choco install "vscode" -y }
Install-CommandIfNotInstalled -PackageName "PROS" -CheckCommand "prosv5" -InstallCommand { Install-ExternalExecutable -URI $ProsURI -FileName $ProsFile }
# # #

# Web Team Tools #
If ($Web -eq "y") {
    Install-CommandIfNotInstalled -PackageName "Node Version Manager" -CheckCommand "nvm" -InstallCommand { choco install "nvm" -y }
}
# # #

# Embedded Team Tools #
If ($Embedded -eq "y") {

}
# # #

# Data Science Tools #
If ($DataScience -eq "y") {
    Install-CommandIfNotInstalled -PackageName "Anaconda" -CheckCommand "_conda" -InstallCommand { choco install "anaconda3" -y --params '"/AddToPath"' }
}
# # #

# ------ #

Update-SessionEnvironment # alias to refreshenv
Write-Host "Refreshing PATH environment, please wait..." -BackgroundColor Blue

# --- Configuring Installations --- #

# Web Team #
If ($Web -eq "y") {
    Write-Host "Configuring Node through Node Version Manager..."
    nvm install $NodeVersion
    nvm use $NodeVersion
}
# # #

# Embedded Team #
If ($Embedded -eq "y") {

}
# # #

# Data Science Team #
If ($DataScience -eq "y") {

}
# # #

# ------ #

Update-SessionEnvironment # alias to refreshenv
Write-Host "Refreshing PATH environment, please wait..." -BackgroundColor Blue

# --- Installing Packages with Previous Dependencies --- #

Write-Host "Installing Packages with Previous Dependencies..." -BackgroundColor DarkGreen

# Web Team Tools #
If ($Web -eq "y") {
    Install-CommandIfNotInstalled -PackageName "Yarn" -CheckCommand "yarn" -InstallCommand { choco install "yarn" -y }
    code --install-extension "ms-vscode.powershell"
}
# # #

# Embedded Team Tools #  
If ($Embedded -eq "y") {
    code --install-extension "ms-vscode.cpptools"
    code --install-extension "ms-vscode-remote.remote-containers"
    code --install-extension "ms-azuretools.vscode-docker"
    code --install-extension "ms-vscode-remote.remote-wsl"
    code --install-extension "visualstudioexptteam.vscodeintellicode"
}              
# # #

# Data Science Tools #
If ($DataScience -eq "y") {
    pip install -U numpy
    pip install -U scipy
    pip install -U pandas
    pip install -U matplotlib
    pip install -U tensorflow
    pip install -U scikit-learn
    code --install-extension "ms-python.python"
}
# # #

# ------ #

Update-SessionEnvironment # alias to refreshenv
Write-Host "Refreshing PATH environment, please wait..." -BackgroundColor Blue

# Write-Host "Generating SSH Key for Github..." -BackgroundColor DarkGreen
# Write-Host "Press [ENTER] on the first prompt, and optionally add a password for the key..." -BackgroundColor DarkGreen
# Write-Host "If this does NOT work, open up Git Bash and type in 'ssh-keygen'" -BackgroundColor Yellow
# ssh-keygen

Write-Host "Installation Complete!" -BackgroundColor DarkGreen

# --- Installing and Enabling WSL : REQUIRES RESTART --- #\

# $CurrentFile = split-path $PSCommandPath -Leaf
# Install-CommandIfNotInstalled -PackageName "Windows Subsystem for Linux (WSL)" -CheckCommand "wslREMOVE" -InstallCommand { Install-WSLLatest -Web $Web -Embedded $Embedded -DataScience $DataScience -InstallWSL2 $InstallWSL2 -Debug $Debug -PSParams $PSParams -PSLoc $PSLoc -TaskName $TaskName -CurrentFile $CurrentFile -InstallationScriptSubdirectory $InstallationScriptSubdirectory -ExcludeScripts $ExcludeScripts }

# ------ #