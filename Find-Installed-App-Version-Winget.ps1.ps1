<#
.SYNOPSIS
Custom app version detectin script using winget.

.DESCRIPTION
This script will look for the app in installed app list using winget.

.EXAMPLE
Run the script. Change the variables AppName. will get the version of the app

.COPYRIGHT
Arghya Biswas. Email:arghyabiswas988@gmail.com

#>

$AppName = 'ocenaudio'

class Software {
    [string]$Name
    [string]$Id
    [string]$Version
    [string]$AvailableVersion
}

$ListResult = winget list | Out-String

$lines = $ListResult.Split([Environment]::NewLine)


# Find the line that starts with Name, it contains the header
$fl = 0
while (-not $lines[$fl].StartsWith("Name"))
{
    $fl++
}

# Line $i has the header, we can find char where we find ID and Version
$idStart = $lines[$fl].IndexOf("Id")
$versionStart = $lines[$fl].IndexOf("Version")
$availableStart = $lines[$fl].IndexOf("Available")
$sourceStart = $lines[$fl].IndexOf("Source")

# Now cycle in real package and split accordingly
$List = @()
For ($i = $fl + 1; $i -le $lines.Length; $i++)
{
    $line = $lines[$i]
    if ($line.Length -gt ($availableStart + 1) -and -not $line.StartsWith('-'))
    {
        $name = $line.Substring(0, $idStart).TrimEnd()
        $id = $line.Substring($idStart, $versionStart - $idStart).TrimEnd()
        $version = $line.Substring($versionStart, $availableStart - $versionStart).TrimEnd()
        $available = $line.Substring($availableStart, $sourceStart - $availableStart).TrimEnd()
        $software = [Software]::new()
        $software.Name = $name;
        $software.Id = $id;
        $software.Version = $version
        $software.AvailableVersion = $available;

        $List += $software
    }
}

#$List | Format-Table

#$List | Where-Object Name -Like 'ocenaudio'

$InstalledApps = $List | Where-Object Name -Like "$AppName"

Write-Output $InstalledApps.Version
