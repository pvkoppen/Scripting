
$KeepDays   = 21
$DaysAgo    = (Get-Date).AddDays(-$KeepDays)
$ScriptPath = Split-Path -Path $script:MyInvocation.InvocationName -Parent
$ScriptShortName = [System.IO.Path]::GetFileNameWithoutExtension($script:MyInvocation.InvocationName)
$FileFilter = "$ScriptShortName#*.log"
Start-Transcript -Path "$(Join-Path -Path $ScriptPath -ChildPath $ScriptShortName)#$(Get-Date -Format "yyyyMMdd").log" -Append

#Variables

#Functions
function Delete-OldFilesFromFolder {
  param ([int]$KeepMonths, [string]$FolderPath)

  if ($KeepMonths -and $FolderPath -and (Test-Path -path $FolderPath)) {
    $limit = (Get-Date).AddMonths(-$KeepMonths)
    $path = $FolderPath
    Write-Host "[INFO ] Months to keep: $KeepMonths; Processing folder: $FolderPath"

    Write-Host "[INFO ] Select files to be deleted."
    $ToBeDeleted = Get-ChildItem -Path $path -Recurse -Force | 
      Where-Object { !$_.PSIsContainer -and $_.LastWriteTime -lt $limit }
    Write-Host "[INFO ] Deleting files: $ToBeDeleted"
    $ToBeDeleted | Remove-Item -Force

    Write-Host "[INFO ] Select empty folder left behind after file delete."
    $ToBeDeleted = Get-ChildItem -Path $path -Recurse -Force | 
      Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | 
      Where-Object { !$_.PSIsContainer }) -eq $null }
    Write-Host "[INFO ] Deleting empty folders: $ToBeDeleted"
    $ToBeDeleted | Remove-Item -Force -Recurse
  } else { Write-Output "[WARN ] Parameter missing or Folder does not exist" }
}

#Actions
Delete-OldFilesFromFolder -KeepMonths 3 -FolderPath "D:\SERVICES\Syslogd\Dated logs\Filtered\SONUS"
Delete-OldFilesFromFolder -KeepMonths 12 -FolderPath "D:\DATA\SERVICES\sFTP\UCS"
Delete-OldFilesFromFolder -KeepMonths 12 -FolderPath "D:\DATA\SERVICES\sFTP\CUC"
Delete-OldFilesFromFolder -KeepMonths 12 -FolderPath "D:\DATA\SERVICES\sFTP\CUCM"
Delete-OldFilesFromFolder -KeepMonths 12 -FolderPath "D:\SERVICES\Syslogd\Dated logs\CatchAll"

Write-Host "[INFO ] Remove Transcript Logs: [$FileFilter] older then: '$DaysAgo' from folder: '$ScriptPath'."
Get-ChildItem -Path $ScriptPath -Force -File -Filter $FileFilter | 
    Where-Object { !$_.PSIsContainer -and $_.LastWriteTime -lt $DaysAgo } | Remove-Item -Force -Verbose
Stop-Transcript