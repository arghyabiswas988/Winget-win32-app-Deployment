# Install latest app using WinGet
Param(
[parameter(Mandatory = $true, HelpMessage = "Enter application ID, example PuTTY.PuTTY Case sensitive")]$AppID,
[Parameter(Mandatory = $False)] [Switch] $Uninstall,
[parameter(Mandatory = $False, HelpMessage = "Additional install options. 'Example --version 1.1' or '--architecture X64'")]$Options
)

$LogPath = "C:\logs\winget\$AppID.txt"

Start-Transcript -Path $LogPath -Force -ErrorAction SilentlyContinue

Try {

    # Resolve correct path for multiple installed versions

    $ResolveWingetPath = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe" -Verbose

    $WingetPath = $ResolveWingetPath[-1].Path

    $WingetPath = "$WingetPath\winget.exe"

    # Define agreements from Params
    If ($Uninstall) { 
        $WingetArgs = "Uninstall --exact --id $AppID --silent --accept-source-agreements" -split " "
    }
        
    Else { 
        $WingetArgs = "Install --exact --id $AppID --silent $Options --accept-package-agreements --accept-source-agreements" -split " "
    }

    # Run Winget
    & $WingetPath $WingetArgs
    
    if(($LASTEXITCODE -ne 0)){
    
        Write-Output "$AppID failed - $LASTEXITCODE"exit $LASTEXITCODE
        }
}

Catch {

    $errMsg = $_.Exception.Message
    Write-Error $errMsg
    exit 1

    }
