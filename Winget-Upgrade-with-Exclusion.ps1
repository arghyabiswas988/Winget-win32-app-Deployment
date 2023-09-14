<#
.SYNOPSIS
Upgrade all installed app via winget with exclution list.

.DESCRIPTION
This script will Upgrade all installed app via winget with exclution list.

.EXAMPLE
Run the script. Change the variables AppName. All app will be upgraded excludung apps listed in exclusion list.

.COPYRIGHT
Arghya Biswas. Email:arghyabiswas988@gmail.com

#>

class Software {
    [string]$Name
    [string]$Id
    [string]$Version
    [string]$AvailableVersion
}

$upgradeResult = winget upgrade | Out-String

$lines = $upgradeResult.Split([Environment]::NewLine)


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
$upgradeList = @()
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

        $upgradeList += $software
    }
}


$upgradeList | Format-Table

$toSkip = @(
'Tonec.InternetDownloadManager')

foreach ($package in $upgradeList)
{
    if (-not ($toSkip -contains $package.Id))
    {
        Write-Host "Going to upgrade package $($package.id)"
        & winget upgrade $package.id --silent
    }
    else
    {
        Write-Host "Skipped upgrade to package $($software.Name)"
    }
}