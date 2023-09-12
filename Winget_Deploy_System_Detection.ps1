<#
.SYNOPSIS
Custom app detection script.

.DESCRIPTION
Deploy apps using Winget (Windows package manager) in System Context.

.EXAMPLE
Run detection.ps1. Change the variables AppName and AppId accordingly. 
if app is detected then return code will be "0" else return code will be "1".

.COPYRIGHT
Arghya Biswas. Email:arghyabiswas988@gmail.com

#>

$AppName = "7-zip"

$AppId = "7zip.7zip"

$InstalledApps = Get-Package -Name "*$AppName*" -ErrorAction SilentlyContinue

if ($InstalledApps.Version -ge '23.1.0.0') {
    Write-Host "$($AppName) is installed." -ForegroundColor Green
    Exit 0
    }
else {
    Write-Host "$($AppName) not detected." -ForegroundColor Red
    exit 1
    }