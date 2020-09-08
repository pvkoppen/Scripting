<#
.SYNOPSIS
    Capture command output.
.DESCRIPTION
    The Start-VMwareUMDSDownload cmdlet starts the VMware-UMDS -D process.
.PARAMETER
    No Parameters
.INPUTS
    No Input
.OUTPUTS
    Creates a log file.
.NOTES
    Version:        1.0
    Author:         Peter van Koppen
    Change Date:    6 May 2020
    Purpose/Change: Wrap logging around teh vmware-umds download process.
.EXAMPLE 1
    Start-VMwareUMDSDownload

    This command:
    1: Starts the VMware-UMDS -D process and captures the output in a log file.
#>

$KeepDays   = 8
$DaysAgo    = (Get-Date).AddDays(-$KeepDays)
$FileFilter = "*.log"
$ScriptPath = Split-Path -Path $script:MyInvocation.InvocationName -Parent
$ScriptShortName = [System.IO.Path]::GetFileNameWithoutExtension($script:MyInvocation.InvocationName)
Start-Transcript -Path "$(Join-Path -Path $ScriptPath -ChildPath $ScriptShortName)-$(Get-Date -Format "dd").log" -Append

#Actions
. 'D:\Services\VMware\Infrastructure\Update Manager\vmware-umds.exe' -G
. 'D:\Services\VMware\Infrastructure\Update Manager\vmware-umds.exe' -D

Write-Host "[INFO ] Remove Transcript Logs: [$FileFilter] older then: '$DaysAgo' from folder: '$ScriptPath'."
Get-ChildItem -Path $ScriptPath -Force -File -Filter $FileFilter | 
    Where-Object { !$_.PSIsContainer -and $_.LastWriteTime -lt $DaysAgo } | Remove-Item -Force -Verbose
Stop-Transcript
