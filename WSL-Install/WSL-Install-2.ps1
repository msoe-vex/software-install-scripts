Invoke-WebRequest -Uri "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi" -OutFile "wsl_update_x64.msi"
Start-Process -FilePath "wsl_update_x64.msi"

Write-Host "Please restart your computer to complete the install!"