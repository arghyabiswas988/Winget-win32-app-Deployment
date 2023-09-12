<#
.SYNOPSIS
Deploy apps using Winget.

.DESCRIPTION
Deploy apps using Winget (Windows package manager) in System Context.

.EXAMPLE
Run Install.ps1. Change the variable AppName and AppId accordingly.

.COPYRIGHT
Arghya Biswas. Email:arghyabiswas988@gmail.com

#>

$AppName = "7-zip"

$AppId = "7zip.7zip"

#$ARPAppName = "7-Zip 23.01 (x64 edition)"

$AppInstaller = Get-AppxProvisionedPackage -Online | Where-Object DisplayName -eq Microsoft.DesktopAppInstaller

$LogFolder = Join-Path $env:SystemDrive "Temp\Logs"

if (!(Test-Path $LogFolder)){
New-Item -Path $LogFolder -ItemType Directory -Force
}

$logFile = "$($AppName)_Install_" + (Get-Date -Format "MM-dd-yyyy-HH-mm-ss") + ".log"
#Start Logging
Start-Transcript -Path "$LogFolder\$logFile" -Append

If($AppInstaller.Version -lt "2022.506.16.0") {

    Write-Host "Winget is not installed, trying to install latest version from Github" -ForegroundColor Yellow

    Try {
            
        Write-Host "Creating Winget Packages Folder" -ForegroundColor Yellow

        if (!(Test-Path -Path C:\ProgramData\WinGetPackages)) {
            New-Item -Path C:\ProgramData\WinGetPackages -Force -ItemType Directory
        }

        Set-Location C:\ProgramData\WinGetPackages

        #Downloading Packagefiles
        Write-Host "Downloading Microsoft.UI.Xaml.2.7.0..."
        Invoke-WebRequest -Uri "https://www.nuget.org/api/v2/package/Microsoft.UI.Xaml/2.7.0" -OutFile "C:\ProgramData\WinGetPackages\microsoft.ui.xaml.2.7.0.zip"
        Expand-Archive C:\ProgramData\WinGetPackages\microsoft.ui.xaml.2.7.0.zip -Force

        Write-Host "Downloading Microsoft.VCLibs.140.00.UWPDesktop..."
        Invoke-WebRequest -Uri "https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx" -OutFile "C:\ProgramData\WinGetPackages\Microsoft.VCLibs.x64.14.00.Desktop.appx"

        Write-Host "Downloading Winget"
        Invoke-WebRequest -Uri "https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" -OutFile "C:\ProgramData\WinGetPackages\Winget.msixbundle"

        Write-Host "Installing Winget with dependencies."
        Add-ProvisionedAppxPackage -online -PackagePath:.\Winget.msixbundle -DependencyPackagePath .\Microsoft.VCLibs.x64.14.00.Desktop.appx,.\microsoft.ui.xaml.2.7.0\tools\AppX\x64\Release\Microsoft.UI.Xaml.2.7.Appx -SkipLicense

        Write-Host "Awaiting for Winget to initiate" -Foregroundcolor Yellow
        Start-Sleep 5
    }
    Catch {
        Throw "Failed to install Desktop App Installer."
        Break
    }

    }
Else {
    Write-Host "Winget already installed." -ForegroundColor Green
}

Write-Host "Trying to install $AppName with Winget..." -ForegroundColor Yellow

IF ($AppName){
    try {
        Write-Host "Installing $($AppName) via Winget" -ForegroundColor Green

        $ResolveWingetPath = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe"
        if ($ResolveWingetPath){
               $WingetPath = $ResolveWingetPath[-1].Path
        }
    
        $config
        cd $wingetpath
        .\winget.exe install --id $AppId --scope machine --silent --accept-source-agreements --accept-package-agreements

        cd "C:\Windows\system32"
    }
    Catch {
        Throw "Failed to install App $($AppName)"
    }
}
Else {
    Write-Host "App $($AppName) not available" -ForegroundColor Yellow
}
Write-Host "Checking for the app after installation..."

$InstalledApps = Get-Package -Name "*$AppName*" -ErrorAction SilentlyContinue

if ($InstalledApps.Version -ge '23.1.0.0') {
    Write-Host "$($AppName) is installed successfully." -ForegroundColor Green
    }
else {
    Write-Host "$($AppName) not detected after installation. Installation Failed." -ForegroundColor \Red
    }

Stop-Transcript