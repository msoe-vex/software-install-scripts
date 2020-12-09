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

Write-Host "Checking for default directory..."
If (!(Test-Path $RaiderRoboticsDirectory)) {
    Write-Host "Default directory not found. Creating $RaiderRoboticsDirectory..." -BackgroundColor DarkGreen
    New-Item -Path "$MainDirectory\" -Name $MainSubdirectory -ItemType "directory"
    New-Item -Path "$RaiderRoboticsDirectory\" -Name $MainInstallSubdirectory -ItemType "directory"
} 

Write-Host "Checking for install directory..." -BackgroundColor DarkGreen
If (Test-Path $RaiderRoboticsInstallDirectory) {
    Write-Host "Previous installs found. Removing $RaiderRoboticsInstallDirectory..." -BackgroundColor DarkGreen
    Get-ChildItem $RaiderRoboticsInstallDirectory -Recurse | Remove-Item
} Else {
    Write-Host "No install directory found. Creating $RaiderRoboticsInstallDirectory..." -BackgroundColor DarkGreen
    New-Item -Path "$RaiderRoboticsDirectory\$MainInstallSubdirectory"
}

Write-Host "Checking for script directory..." -BackgroundColor DarkGreen
If (Test-Path $RaiderRoboticsInstallDirectory) {
    Write-Host "Previous scripts found. Removing $RaiderRoboticsInstallScriptGitDirectory..." -BackgroundColor DarkGreen
    Get-ChildItem $RaiderRoboticsInstallScriptGitDirectory -Recurse | Remove-Item
} Else {
    Write-Host "No install directory found. Creating $RaiderRoboticsInstallScriptGitDirectory..." -BackgroundColor DarkGreen
    New-Item -Path "$RaiderRoboticsDirectory\$MainInstallScriptGitSubdirectory"
}

# ------ #

# --- Copying all install folders to Raider Robotics directory --- #

$ParentDir = (Get-Item $PSScriptRoot).Parent.FullName
Copy-Item -Path "$ParentDir\*" -Destination "$RaiderRoboticsInstallScriptGitDirectory"

# ------ #

# --- Installing Chocolatey --- #

Set-ExecutionPolicy Bypass -Scope Process

Install-CommandIfNotInstalled -InstallDir $RaiderRoboticsInstallDirectory -PackageName "Chocolatey" -CheckCommand "choco" -InstallCommand { Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')) }

# Load choco into powershell environment
$env:ChocolateyInstall = Convert-Path "$((Get-Command choco).Path)\..\.."   
Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"

# ------ #

Update-SessionEnvironment # alias to refreshenv
Write-Host "Refreshing PATH environment, please wait..." -BackgroundColor Blue

# --- Installing Packages --- #

# Basic Software Development Tools #
Install-CommandIfNotInstalled -InstallDir $RaiderRoboticsInstallDirectory -PackageName "Git" -CheckCommand "git" -InstallCommand { choco install "git" -y }
Install-CommandIfNotInstalled -InstallDir $RaiderRoboticsInstallDirectory -PackageName "VSCode" -CheckCommand "code" -InstallCommand { choco install "vscode" -y }
Install-CommandIfNotInstalled -InstallDir $RaiderRoboticsInstallDirectory -PackageName "Python" -CheckCommand "pip" -InstallCommand { choco install "python" -y }

Update-SessionEnvironment

# Phasing out from Atom IDE in favor of VSCode
# Install-CommandIfNotInstalled -PackageName "PROS" -CheckCommand "prosv5" -InstallCommand { Install-ExternalExecutable -InstallDir $RaiderRoboticsInstallDirectory -URI $ProsURI -FileName $ProsFile }

Install-CommandIfNotInstalled -InstallDir $RaiderRoboticsInstallDirectory -PackageName "PROS" -CheckCommand "pros" -InstallCommand { pip install "pros-cli"; Install-ExternalExecutable -InstallDir $RaiderRoboticsInstallDirectory -URI $ARMGCCURI -FileName $ARMGCCFile }
# # #

# Web Team Tools #
If ($Web -eq "y") {
    Install-CommandIfNotInstalled -InstallDir $RaiderRoboticsInstallDirectory -PackageName "Node Version Manager" -CheckCommand "nvm" -InstallCommand { choco install "nvm" -y }

    Install-ProgramIfNotPresentAtDirectory -InstallDir $RaiderRoboticsInstallDirectory -CheckDirectory $VS2019Directory -InstallCommand { choco install visualstudio2019community }
}
# # #

# Embedded Team Tools #
If ($Embedded -eq "y") {

}
# # #

# Data Science Tools #
If ($DataScience -eq "y") {
    Install-CommandIfNotInstalled -InstallDir $RaiderRoboticsInstallDirectory -PackageName "Anaconda" -CheckCommand "_conda" -InstallCommand { choco install "anaconda3" -y --params '"/AddToPath"' }
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
    Install-CommandIfNotInstalled -InstallDir $RaiderRoboticsInstallDirectory -PackageName "Yarn" -CheckCommand "yarn" -InstallCommand { choco install "yarn" -y }
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

# --- Installing and Enabling WSL : REQUIRES RESTART --- #

$CurrentFile = split-path $PSCommandPath -Leaf

Install-CommandIfNotInstalled -InstallDir $RaiderRoboticsInstallDirectory -PackageName "Windows Subsystem for Linux (WSL)" -CheckCommand "wslREMOVE" -InstallCommand { Install-WSLLatest -Web $Web -Embedded $Embedded -DataScience $DataScience -InstallWSL2 $InstallWSL2 -LocalDebug $LocalDebug -PSParams $PSParams -PSLoc $PSLoc -TaskName $TaskName -CurrentFile $CurrentFile -InstallationScriptSubdirectory $InstallationScriptSubdirectory -ExcludeScripts $ExcludeScripts }

# ------ #