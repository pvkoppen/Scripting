$limit = (Get-Date).AddMonths(-3)
$path = "D:\SERVICES\Syslogd\Dated logs\Filtered\SONUS"

function Delete-OldFilesFromFolder {
  param ([int]$KeepMonths, [string]$FolderPath)

  $limit = (Get-Date).AddMonths(-$KeepMonths)
  $path = $FolderPath
  Write-Host "-- KeepMonths: $KeepMonths; Process folder: $FolderPath"

  if ($KeepMonths -and $FolderPath -and (Test-Path -path $FolderPath)) {
    # Delete files older than the $limit.
    $ToBeDeleted = Get-ChildItem -Path $path -Recurse -Force | 
      Where-Object { !$_.PSIsContainer -and $_.LastWriteTime -lt $limit }
    $ToBeDeleted
    $ToBeDeleted | Remove-Item -Force

    # Delete any empty directories left behind after deleting the old files.
    $ToBeDeleted = Get-ChildItem -Path $path -Recurse -Force | 
      Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | 
      Where-Object { !$_.PSIsContainer }) -eq $null }
    $ToBeDeleted
    $ToBeDeleted | Remove-Item -Force -Recurse
  } else { Write-Output "Parameter missing or Folder does not exist" }
}

Delete-OldFilesFromFolder -KeepMonths 3 -FolderPath "D:\SERVICES\Syslogd\Dated logs\Filtered\SONUS"
Delete-OldFilesFromFolder -KeepMonths 12 -FolderPath "D:\DATA\SERVICES\sFTP\UCS"
Delete-OldFilesFromFolder -KeepMonths 12 -FolderPath "D:\DATA\SERVICES\sFTP\CUC"
Delete-OldFilesFromFolder -KeepMonths 12 -FolderPath "D:\DATA\SERVICES\sFTP\CUCM"
