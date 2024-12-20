﻿<#
# Author  : PvKoppen - TussockLine
# Date    : 10/05/2021
# Modified: 06/09/2021
# Version : 1.0b
#>

#StartTranscript
Write-Host "[INFO] $ScriptShortName: Start Transcript Logs"
$KeepDays        = 21
$DaysAgo         = (Get-Date).AddDays(-$KeepDays)
if ($script:MyInvocation.InvocationName) {
    $ScriptPath      = Split-Path -Path $script:MyInvocation.InvocationName -Parent
    $ScriptShortName = [System.IO.Path]::GetFileNameWithoutExtension($script:MyInvocation.InvocationName)
} else {
    $ScriptPath      = $env:TEMP
    $ScriptShortName = "$($env:Username)"
}
$FileFilter      = "$ScriptShortName#*.log"
Start-Transcript -Path "$(Join-Path -Path $ScriptPath -ChildPath $ScriptShortName)#$(Get-Date -Format "yyyyMMdd").log" -Append

#Variables

#CalculatedValues

#Create Folders

#Functions

#Actions

#Report

#Cleanup
Write-Host "[INFO] $ScriptShortName: Remove Transcript Logs: [$FileFilter] older then: '$DaysAgo' from folder: '$ScriptPath'"
Get-ChildItem -Path $ScriptPath -Force -File -Filter $FileFilter | 
    Where-Object { !$_.PSIsContainer -and $_.LastWriteTime -lt $DaysAgo } | Remove-Item -Force -Verbose
Stop-Transcript
