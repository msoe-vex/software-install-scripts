# Raider Robotics - Software Installation Scripts
This repository holds all of the scripts and setup required to program for the Raider Robotics VEX U Team. This setup guide will walk through the basics of installation and setup required.

Starting out, we need to open powershell as an administrator to check some settings. To do this, press the folloing keys:

    Windows Key + R

This will open the run menu. From here, type in:

    powershell.exe

To open this as an administrator, make sure to press the following keys:

    Control + Shift + Enter

You should see the title of the window as *Administrator: Windows Powershell*. If so, you have done this correctly.

***
### Configuring Permissions
<br>
In the administrator powershell window, type the following command:

    Get-ExecutionPolicy

This will return the policy for running scripts. For our script to work correctly, the value returned should be **Unrestricted**. If yours didn't return unrestricted, run the following command:

    Set-ExecutionPolicy Unrestricted

This will prompt you to accept your changes, and to this press **Y** or **A**. (You can run the same command later with *Bypass* or *Restricted* later if you want to be extra safe).

Now, we need to download the repository. 

*** 
### Downloading and Running the Scripts
<br>
In the repository on GitHub, hit the green "Code" button and select the *Download ZIP* option. (Or, [download here](https://github.com/msoe-vex/software-install-scripts/archive/main.zip))

Once these download, unzip them and navigate to the *software-install-scripts* folder. You should see three files and a folder:
- InstallConstants.ps1
- InstallFunctions.ps1
- RaiderRoboticsInstall.ps1
- InstallationScripts

While viewing these in File Explorer, select:

*File > Open Windows Powershell > Open Windows Powershell as administrator*. 

This will run powershell in this location, allowing you to run these scripts. Next, you can start the installation.

**NOTE:** In the command below, replace *'n'* with *'y'* if you want to install any of the other packages. By default, we have chosen *'y'* for the Embedded Team package. Once you select your packages, run the following command.

    .\RaiderRoboticsInstall.ps1 -Web n -Embedded y -DataScience n

Let this program run as needed, and complete any user installations required during the process. If the installation fails or freezes for more than 10 minutes while running, exit the script and re-run the script. **It will automatically recognize current installations, so do not uninstall anything previously done**.



