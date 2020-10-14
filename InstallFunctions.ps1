# Raider Robotics Software Install Functions #
# ========================================== #
#
# This script is used to contain all common
# functions used across the install scripts.
#
# ========================================== #

function Invoke-RestartAndRun {
    param (
        [String][ValidateSet('y','n')]$Web = 'n', 
        [String][ValidateSet('y','n')]$Embedded = 'n', 
        [String][ValidateSet('y','n')]$DataScience = 'n',
        [String][ValidateSet('y','n')]$InstallWSL2 = 'n',
        [String][ValidateSet('y','n')]$Debug = 'n',
        [String][Parameter(Mandatory=$true)]$PSParams,
        [String][Parameter(Mandatory=$true)]$PSLoc,
        [String][Parameter(Mandatory=$true)]$TaskName,
        [String][Parameter(Mandatory=$true)]$CurrentFile,
        [String]$InstallationScriptSubdirectory = $null,
        [String]$ExcludeScripts = $null
    )

    $NextScript = $null
    $SearchPath = "$PSScriptRoot\*"

    # Exclude any previously run scripts
    If ($null -ne $InstallationScriptSubdirectory) {
        $SearchPath = "$PSScriptRoot\$InstallationScriptSubdirectory\*"
    }

    If ($null -eq $ExcludeScripts) { # No scripts have been run previously
        $ExcludeScripts = "*$CurrentFile" # Use the asterisk to make this command path-agnostic
    } Else {
        $ExcludeScripts = $ExcludeScripts, "*$CurrentFile" # Add the current file to the list of files
    }

    $ExcludeScripts = $ExcludeScripts.Trim() # Creation and appending above adds an extra space on the beginning, making it not work properly

    $NextScript = Get-ChildItem -Path "$SearchPath" -Include "*.ps1" -Exclude $ExcludeScripts | Sort-Object | Select-Object -First 1

    If ($null -ne $NextScript) { # Another script needs to run, need to start it as a task on logon
        $PSParams = $PSParams + "& { $NextScript -Web $Web -Embedded $Embedded -DataScience $DataScience -InstallWSL2 $InstallWSL2 -ExcludeScripts $ExcludeScripts }" # Add script name to params

        $RunNextScriptTask = New-ScheduledTaskAction -Execute $PSLoc -Argument $PSParams 

        $TaskTrigger = New-ScheduledTaskTrigger -AtLogOn

        Register-ScheduledTask -TaskName $TaskName -Action $RunNextScriptTask -Trigger $TaskTrigger -RunLevel Highest 

        If ($Debug -eq 'y') {
            Write-Host "[DEBUG] Exclusions:$ExcludeScripts" -BackgroundColor Blue
            Write-Host "[DEBUG] Next Script:$NextScript" -BackgroundColor Blue
            Write-Host "[DEBUG] PSLoc:$PSLoc" -BackgroundColor Blue
            Write-Host "[DEBUG] PSParams:$PSParams" -BackgroundColor Blue
        }

        Wait-ConfirmRestart

        Restart-Computer
    }
}

function Install-CommandIfNotInstalled {
    param (
        [String][ValidateSet('y','n')]$WaitForInstall = 'n',
        $PackageName,
        $CheckCommand,
        $InstallCommand
    )

    If (Get-Command $CheckCommand -ErrorAction SilentlyContinue) {
        Write-Host "$PackageName Already Installed. Proceeding..." -BackgroundColor DarkGreen
    } Else {
        Write-Host "$PackageName Not Found. Installing..." -BackgroundColor DarkGreen
        & $InstallCommand
    }

    If ($WaitForInstall -eq 'y') {
        Wait-KeyPress
    }
}

function Install-ExternalExecutable {
    param (
        $URI,
        $FileName
    )

    Invoke-WebRequest -Uri $URI -OutFile "$RaiderRoboticsInstallDirectory\$FileName"
    Start-Process -FilePath "$RaiderRoboticsInstallDirectory\$FileName"
    Wait-KeyPress
}

function Install-WSLLatest {
    param (
        [String][ValidateSet('y','n')]$Web = 'n', 
        [String][ValidateSet('y','n')]$Embedded = 'n', 
        [String][ValidateSet('y','n')]$DataScience = 'n',
        [String][ValidateSet('y','n')]$InstallWSL2 = 'n',
        [String][ValidateSet('y','n')]$Debug = 'n',
        [String][Parameter(Mandatory=$true)]$PSParams,
        [String][Parameter(Mandatory=$true)]$PSLoc,
        [String][Parameter(Mandatory=$true)]$TaskName,
        [String][Parameter(Mandatory=$true)]$CurrentFile,
        [String]$InstallationScriptSubdirectory = $null,
        [String]$ExcludeScripts = $null
    )

    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

    # Checking if WSL 2 can be installed

    $MajorVersion = [System.Environment]::OSVersion.Version.Major
    $BuildVersion = [System.Environment]::OSVersion.Version.Build
    $RevisionVersion = [System.Environment]::OSVersion.Version.Revision

    If ($MajorVersion -ge 10 -and $BuildVersion -eq 18362 -and $RevisionVersion -eq 1049) {
        Write-Host "This machine is compatible with WSL 2. Installing..." -BackgroundColor DarkGreen
        Install-WSL2 -Web $Web -Embedded $Embedded -DataScience $DataScience -InstallWSL2 $InstallWSL2 -Debug $Debug -PSParams $PSParams -PSLoc $PSLoc -TaskName $TaskName -CurrentFile $CurrentFile -InstallationScriptSubdirectory $InstallationScriptSubdirectory -ExcludeScripts $ExcludeScripts
    } ElseIf ($MajorVersion -ge 10 -and $BuildVersion -eq 18363 -and $RevisionVersion -eq 1049) {
        Write-Host "This machine is compatible with WSL 2. Installing..." -BackgroundColor DarkGreen
        Install-WSL2 -Web $Web -Embedded $Embedded -DataScience $DataScience -InstallWSL2 $InstallWSL2 -Debug $Debug -PSParams $PSParams -PSLoc $PSLoc -TaskName $TaskName -CurrentFile $CurrentFile -InstallationScriptSubdirectory $InstallationScriptSubdirectory -ExcludeScripts $ExcludeScripts
    } ElseIf ($MajorVersion -ge 10 -and $BuildVersion -gt 18363) {
        Write-Host "This machine is compatible with WSL 2. Installing..." -BackgroundColor DarkGreen
        Install-WSL2 -Web $Web -Embedded $Embedded -DataScience $DataScience -InstallWSL2 $InstallWSL2 -Debug $Debug -PSParams $PSParams -PSLoc $PSLoc -TaskName $TaskName -CurrentFile $CurrentFile -InstallationScriptSubdirectory $InstallationScriptSubdirectory -ExcludeScripts $ExcludeScripts
    } Else {
        Write-Host "This machine is not compatible with WSL 2. Installing WSL 1..." -BackgroundColor Yellow
        Invoke-RestartAndRun -Web $Web -Embedded $Embedded -DataScience $DataScience -InstallWSL2 $InstallWSL2 -Debug $Debug -PSParams $PSParams -PSLoc $PSLoc -TaskName $TaskName -CurrentFile $CurrentFile -InstallationScriptSubdirectory $InstallationScriptSubdirectory -ExcludeScripts $ExcludeScripts
    }
}

function Install-WSL2 {
    param (
        [String][ValidateSet('y','n')]$Web = 'n', 
        [String][ValidateSet('y','n')]$Embedded = 'n', 
        [String][ValidateSet('y','n')]$DataScience = 'n',
        [String][ValidateSet('y','n')]$InstallWSL2 = 'n',
        [String][ValidateSet('y','n')]$Debug = 'n',
        [String][Parameter(Mandatory=$true)]$PSParams,
        [String][Parameter(Mandatory=$true)]$PSLoc,
        [String][Parameter(Mandatory=$true)]$TaskName,
        [String][Parameter(Mandatory=$true)]$CurrentFile,
        [String]$InstallationScriptSubdirectory = $null,
        [String]$ExcludeScripts = $null
    )

    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

    $InstallWSL2 = 'y' # Update variable to flag an update to WSL2 needed
    
    Invoke-RestartAndRun -Web $Web -Embedded $Embedded -DataScience $DataScience -InstallWSL2 $InstallWSL2 -Debug $Debug -PSParams $PSParams -PSLoc $PSLoc -TaskName $TaskName -CurrentFile $CurrentFile -InstallationScriptSubdirectory $InstallationScriptSubdirectory -ExcludeScripts $ExcludeScripts
}

function Wait-KeyPress {
    Read-Host "Press [ENTER] once the installation has finished..."
}

function Wait-ConfirmRestart {
    Write-Host "The installation process is paused until the computer restarts" -BackgroundColor Yellow
    Read-Host "Press any key to restart..."
}

function Invoke-PrintTest {
    Write-Host "Function Successfully Ran"
}