$ExcludeScripts = $null
$CurrentFile = split-path $PSCommandPath -Leaf
$SearchPath = "$PSScriptRoot\*"

If ($null -eq $ExcludeScripts) { # No scripts have been run previously
    $ExcludeScripts = "*0_RRInstallScript.ps1" # Use the asterisk to make this command path-agnostic
} Else {
    $ExcludeScripts = $ExcludeScripts, "*$CurrentFile" # Add the current file to the list of files
}

$NextScript = Get-ChildItem -Path "$SearchPath" -Include "*.ps1" -Exclude $ExcludeScripts | Sort-Object | Select-Object -First 1
Write-Host $NextScript