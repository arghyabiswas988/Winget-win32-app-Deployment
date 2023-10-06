<#
.SYNOPSIS
Custom app detection script.

.DESCRIPTION
Deploy apps using Winget (Windows package manager) in System Context.

.EXAMPLE
Run detection.ps1. Change the variables AppName and AppId accordingly. 
if app is detected then return code will be "0" else return code will be "1".

.AUTHER
Arghya Biswas. Email:arghyabiswas988@gmail.com

#>

$AppName = "Chrome"

$AppId = "Google.Chrome"

$ARPAppName = "Google Chrome"

$ArpVersion = '117.0.5938.134' #'117.0.5938.134'

$InstalledApps = Get-Package -Name "*$AppName*" -ErrorAction SilentlyContinue

if ($InstalledApps.Version -ge "$ArpVersion") {
    Write-Host "$($AppName) v$($InstalledApps.Version) is installed." -ForegroundColor Green
    Exit 0
    }
else {
    Write-Host "$($AppName) v$($ArpVersion) not detected." -ForegroundColor Red
    exit 1
    }
