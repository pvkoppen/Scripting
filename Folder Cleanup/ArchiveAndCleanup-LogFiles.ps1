Param(  
[Parameter(Mandatory=$true)]  
[string]$logFolder,  
[Parameter(Mandatory=$true)]  
[int]$fileAge,  
[Parameter(Mandatory=$true)]  
[int]$archiveAge  
)  


#Write-Output $psversiontable

$logFolder = "C:\temp\log"  
$fileAge = 7  
$archiveAge = 30  
  
$logFiles = Get-ChildItem $logFolder -Filter *.log | Where LastWriteTime -lt  (Get-Date).AddDays(-1 * $fileAge)  
$destinationPath = $logFolder   (Get-Date -format "yyyyMMddHHmmss")   ".zip"  
  
$logFilePaths = @()  
  
foreach($logFile in $logFiles){  
    $logFilePaths  = $logFile.FullName  
    }  
  
Compress-Archive -Path $logFilePaths -DestinationPath $destinationPath -CompressionLevel Optimal  
Remove-Item –path $logFilePaths  
  
$archiveFiles = Get-ChildItem $logFolder -Filter *.zip | Where LastWriteTime -lt  (Get-Date).AddDays(-1 * $archiveAge)  
  
foreach($archiveFile in $archiveFiles){  
    Remove-Item –path $archiveFile.FullName  
}  
 
 
-------------------------------------------------------

# PowerShell Script to delete files and or folders older than X days.
# Created by: Magnus Andersson - Sr Staff Solutions Architect @Nutanix
# Version 1.0
#
# ---------------------
# User input section starts here
#
# Define scfript log file
$logfile="D:\scripts\deletefiles_folders.log"
#
# Define direcroty where the vCenter Server and NSX Manager backups are located
$dir1="D:\backups"
#
# Define how old backups you want to remove by typing a number which corresponds to days
$deletefilesolderthan="7"
#
# User input section end here - Do not change anything below this line
# --------------------------------------------------------------------
#
# Delete logfile
Remove-Item $logfile
# Start delete files and or folders script
$d1=date
echo "----------------------------------------" >> $logfile
echo "Start deleting old backups at:" $d1 >> $logfile
Get-ChildItem -Path "$dir1" -Recurse | Where CreationTime -lt (Get-Date).AddDays(-$deletefilesolderthan) | Remove-Item -Force -Recurse *>&1 >> $logfile
$d2=date
echo "Finished deleting old files and or folders at:" $d2 >> $logfile

-------------------------------------------------- --

$LogPath = "C:\inetpub\logs" 
$maxDaystoKeep = -30 
$outputPath = "c:\CleanupTask\Cleanup_Old_logs.log" 
  
$itemsToDelete = dir $LogPath -Recurse -File *.log | Where LastWriteTime -lt ((get-date).AddDays($maxDaystoKeep)) 
  
if ($itemsToDelete.Count -gt 0){ 
    ForEach ($item in $itemsToDelete){ 
        "$($item.BaseName) is older than $((get-date).AddDays($maxDaystoKeep)) and will be deleted" | Add-Content $outputPath 
        Get-item $item | Remove-Item -Verbose 
    } 
} 
ELSE{ 
    "No items to be deleted today $($(Get-Date).DateTime)"  | Add-Content $outputPath 
    } 
   
Write-Output "Cleanup of log files older than $((get-date).AddDays($maxDaystoKeep)) completed..." 
start-sleep -Seconds 10

