
$MyDir = [System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition)
$scriptPath = $PSScriptRoot
$ServiceUIPath = Join-Path $scriptPath "ServiceUI.exe"
$PowershellPath = Join-Path $env:SystemRoot "system32\WindowsPowerShell\v1.0\powershell.exe"
$NotificationScriptPath = Join-Path $scriptPath "User_Notification_v22.12.5622_Only_Install.ps1"

$command = "$ServiceUIPath -Process:explorer.exe ""$PowershellPath"" -NoProfile -Nologo -WindowStyle Hidden -ExecutionPolicy Bypass -file ""$NotificationScriptPath"""

$FE22EXE = Join-Path $scriptPath "FORCEPOINT-ONE-ENDPOINT-x64.exe"

$logpath = "C:\Temp\Forcepoint-upgrade-logs"

If (!(test-path $logpath)){
New-Item -ItemType Directory -Path $logpath
}
$logfile = 'Forcepoint_v22.12.5622_Install-' + (Get-Date -Format 'dd-MM-yyyy-hh-mm-ss') + '.log'
Start-Transcript -Path "$logpath\$logfile" -IncludeInvocationHeader
Write-Host "Started logging for Forcepoint-upgrade"


$FEO = Get-Package -Name "FORCEPOINT ONE ENDPOINT" -ErrorAction SilentlyContinue
#write-host $FEO.Version

$FEC = Get-Package -Name "Endpoint Classifier" -ErrorAction SilentlyContinue

if (($FEO.Version -eq "20.2.4499") -or ($FEC.Version -eq "8.7.1.379")){ Write-HOST "FORCEPOINT ONE ENDPOINT v20.2.4499 already installed"; EXIT 1033}


Write-Host Displaying popup...
Invoke-Expression -Command $command


Write-Host "Installing FORCEPOINT ONE ENDPOINT v22.12.5622..."
Start-Process -FilePath $FE22EXE -ArgumentList "/v'REBOOT=ReallySuppress /qn'" -Wait
Write-Host Waiting for reboot...
Start-Process -FilePath "C:\Windows\system32\shutdown.exe" -ArgumentList "-r -y -t 240"
EXIT 3010

Stop-Transcript -Verbose
