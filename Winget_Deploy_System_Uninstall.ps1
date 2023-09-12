<#
.SYNOPSIS
Uninstall apps using Winget.

.DESCRIPTION
Deploy apps using Winget (Windows package manager) in System Context.

.EXAMPLE
Run Uninstall.ps1. Change the variable AppName and AppId accordingly.

.COPYRIGHT
Arghya Biswas. Email:arghyabiswas988@gmail.com

#>

$AppName = "7-zip"

$AppId = "7zip.7zip"

$AppInstaller = Get-AppxProvisionedPackage -Online | Where-Object DisplayName -eq Microsoft.DesktopAppInstaller

$LogFolder = Join-Path $env:SystemDrive "Temp\Logs"

if (!(Test-Path $LogFolder)){
New-Item -Path $LogFolder -ItemType Directory -Force
}

$logFile = "$($AppName)_Uninstall_" + (Get-Date -Format "MM-dd-yyyy-HH-mm-ss") + ".log"
#Start Logging
Start-Transcript -Path "$LogFolder\$logFile" -Append

Write-Host "Trying to uninstall $AppName with Winget..."

IF ($AppInstaller.Version -ge "2022.506.16.0"){
    try {
        Write-Host "Uninstalling $($AppName) via Winget" -ForegroundColor Green

        $ResolveWingetPath = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe"
        if ($ResolveWingetPath){
               $WingetPath = $ResolveWingetPath[-1].Path
        }
    
        $config
        cd $wingetpath
        .\winget.exe uninstall --id $AppId --scope machine --silent

        cd "C:\Windows\system32"
        
        }
    Catch {
        Throw "Failed to uninstall App $($AppName)"
    }
}
Else {
    Write-Host "Winget (Windows package manager) not installed." -ForegroundColor Red
    
    Write-Host "Trying to uinstall using Microsoft Package Management..." -ForegroundColor yellow

    Get-Package -Name "*$AppName*" | Uninstall-Package -Force
}



Write-Host "Checking for the app after uninstallation..."

$InstalledApps = Get-Package -Name "*$AppName*" -ErrorAction SilentlyContinue

#Write-Host $InstalledApps

if ($InstalledApps.Version -eq $null) {
    Write-Host "$($AppName) not detected, Uninstalled successfully." -ForegroundColor Green
    }
else {
    Write-Host "$($AppName) detected after Uninstallation. Uninstallation Failed." -ForegroundColor Red
    }

Stop-Transcript