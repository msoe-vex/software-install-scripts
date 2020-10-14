# --- Program Parameters --- #

param (
    [String][ValidateSet('y','n')]$Web = 'n', 
    [String][ValidateSet('y','n')]$Embedded = 'n', 
    [String][ValidateSet('y','n')]$DataScience = 'n',
    [String][ValidateSet('y','n')]$InstallWSL2 = 'n',
    [String]$ExcludeScripts = $null
)

# ------ #

# --- Imports --- #

$ParentDir = (Get-Item $PSScriptRoot).Parent.FullName

$InstallFunctions = Get-ChildItem -Path "$ParentDir\*" -Include "*Functions*" | Select-Object -First 1
. $InstallFunctions # Import the function scripts (needs to be in parent directory, name containing "Functions")

$InstallConstants = Get-ChildItem -Path "$ParentDir\*" -Include "*Constants*" | Select-Object -First 1
. $InstallConstants # Import the constant variables (needs to be in parent directory, name containing "Constants")

# ------ #

# --- Removing any old runtime tasks for this file --- #

If (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue) {
    # Destroy any tasks that caused this script to run (prevents unwanted execution in the future)
    Get-ScheduledTask -TaskName $TaskName | Unregister-ScheduledTask -Confirm:$false
}

# ------ #

# --- Finish Installing WSL2 --- #

If ($InstallWSL2 -eq 'y') {
    Install-ExternalExecutable -URI $WSL2UpdateURI -FileName $WSL2UpdateFile
}

# ------ #