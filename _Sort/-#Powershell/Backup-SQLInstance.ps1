$ServerName = "TOLDB04"
$BackupDirectory = "C:\Backups\"
$BackupDate = get-date -format yyyyMMdd_HHmmss 

[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") | out-null
$ServerSMO = new-object ("Microsoft.SqlServer.Management.Smo.Server") $ServerName 
$DatabaseList = $ServerSMO.Databases


foreach ($Database in $DatabaseList) {
  if($Database.Name -ne "tempdb") {
    $DatabaseName = $Database.Name
    $DatabaseBackup = new-object ("Microsoft.SqlServer.Management.Smo.Backup")
    $DatabaseBackup.Action = "Database"
    $DatabaseBackup.Database = $DatabaseName
    $DatabaseBackup.Devices.AddDevice($BackupDirectory + "\" + $DatabaseName + "_" + $BackupDate + ".BAK", "File")
    $DatabaseBackup.SqlBackup($ServerSMO)
  }
}