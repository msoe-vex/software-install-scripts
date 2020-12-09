dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# Checking if WSL 2 can be installed

$MajorVersion = [System.Environment]::OSVersion.Version.Major
$BuildVersion = [System.Environment]::OSVersion.Version.Build
$RevisionVersion = [System.Environment]::OSVersion.Version.Revision

If ($MajorVersion -ge 10 -and $BuildVersion -eq 18362 -and $RevisionVersion -eq 1049) {
    Write-Host "This machine is compatible with WSL 2. Installing..." -BackgroundColor DarkGreen
    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
} ElseIf ($MajorVersion -ge 10 -and $BuildVersion -eq 18363 -and $RevisionVersion -eq 1049) {
    Write-Host "This machine is compatible with WSL 2. Installing..." -BackgroundColor DarkGreen
    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
} ElseIf ($MajorVersion -ge 10 -and $BuildVersion -gt 18363) {
    Write-Host "This machine is compatible with WSL 2. Installing..." -BackgroundColor DarkGreen
    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
} Else {
    Write-Host "This machine is not compatible with WSL 2. Installing WSL 1..." -BackgroundColor Yellow
}

Write-Host "Please restart your machine now, and run WSL-Install-2.ps1"