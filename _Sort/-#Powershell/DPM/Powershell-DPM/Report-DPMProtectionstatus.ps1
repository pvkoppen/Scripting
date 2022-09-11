#FindRecoveryPoints.ps1
 #This script finds the newest and oldest recovery points from
 #your dpm server and writes them to an html table
 # Put all your dpm server names in the array. If there is only 1, that is fine.
 $dpmservers = @("<your server name here!","Another server name if you have another")
 
Function InitializeDatasourceProperties ($datasources)
 {
 $Eventcount = 0
 For($i = 0;$i -lt $datasources.count;$i++)
 {
 [void](Register-ObjectEvent $datasources[$i] -EventName DataSourceChangedEvent -SourceIdentifier "DPMExtractEvent$i" -Action{$Eventcount++})
 }
 $datasources | select LatestRecoveryPoint > $null
 $begin = get-date
 While (((Get-Date).subtract($begin).seconds -lt 10) -and ($Eventcount -lt $datasources.count) ) {sleep -Milliseconds 250}
 Unregister-Event -SourceIdentifier DPMExtractEvent* -Confirm:$false
 }
 
#Writes name and recovery point info for current iteration of $ds into HTML table. Newest recovery points not in the last 36 hours are red.
 #If there are no recovery points(1/1/0001), the table reads "Never" in red.
 Function WriteTableRowToFile($ThisDatasource, $dpmserver)
 {
 $rpLatest = $ThisDatasource.LatestRecoveryPoint
 $rpOldest = $ThisDatasource.OldestRecoveryPoint
 
"<tr><td>" | Out-File $filename -Append -Confirm:$false
 $ThisDatasource.ProductionServerName | Out-File $filename -Append -Confirm:$false
 "</td><td>" | Out-File $filename -Append -Confirm:$false
 $ThisDatasource.Name | Out-File $filename -Append -Confirm:$false
 If($rpLatest -lt $date.AddHours(-36)){
 If($rpLatest.ToShortDateString() -eq "1/1/0001"){
 "</td><td><b><font style=`"color: #FF0000;`">Never</font></b>" | Out-File $filename -Append -Confirm:$false
 }
 Else{
 "</td><td><b><font style=`"color: #FF0000;`">" | Out-File $filename -Append -Confirm:$false
 $rpLatest.ToShortDateString() | Out-File $filename -Append -Confirm:$false
 "</font></b>" | Out-File $filename -Append -Confirm:$false
 }
 }
 If($rpLatest -ge $date.AddHours(-36)){
 "</td><td>" | Out-File $filename -Append -Confirm:$false
 $rpLatest.ToShortDateString() | Out-File $filename -Append -Confirm:$false
 "</td>" | Out-File $filename -Append -Confirm:$false
 }
 
If($rpOldest.ToShortDateString() -eq "1/1/0001"){
 "<td><b><font style=`"color: #FF0000;`">Never</font></b></td><td>" | Out-File $filename -Append -Confirm:$false
 }
 Else{
 "<td>" | Out-File $filename -Append -Confirm:$false
 $rpOldest.ToShortDateString()| Out-File $filename -Append -Confirm:$false
 "</td><td>" | Out-File $filename -Append -Confirm:$false
 }
 ($rpLatest - $rpOldest).Days | Out-File $filename -Append -Confirm:$false
 "</td><td>" | Out-File $filename -Append -Confirm:$false
 
$dpmServer | out-file $filename -append -confirm:$false
 "</td></tr>" | Out-File $filename -Append -Confirm:$false
 }
 
##Main## The date is used to find recovery points that are too old, and to generate a file #name.
 $date = get-date
 $filedate = get-date -uformat '%m-%d-%Y-%H%M%S'
 $filename = "C:\DPMRecoveryPoints"+ $filedate + ".htm"
 
## HTML table created
 "<html><caption><font style=`"color: #FF0000;`"><b>Red</b></font> = not backed up in the last 36 hours, or has <font style=`"color: #FF0000;`">
 <b>Never</b></font> been backed up</caption><table border =`"1`" style=`"text-align:center`" cellpadding=`"5`"><th style=`"color:#6698FF`">
 <big>DPM Backups</big></th><body><tr><th>Protection Member</th><th>Datasource</th><th>Newest Backup</th><th>Oldest Backup</th><th># of Days</th>
 <th>DPM Server</th></tr>" | Out-File $filename -Confirm:$false
 
Write-Host "Generating Protection Group Report"
 #Disconnect-DPMserver = clear cache, this makes sure that selecting LatestRecoveryPoint in the InitializeDataSourceProperties is an event,
 #thus confirming that all the recovery points are retrieved before the script moves any further
 Disconnect-DPMserver
 #Find all datasources within each protection group
 Write-Host "Locating Datasources"
 foreach ($dpmserver in $dpmservers){
 $dsarray = @(Get-ProtectionGroup -DPMServer $dpmserver | foreach {Get-Datasource $_}) | Sort-Object ProtectionGroup, ProductionServerName
 Write-Host " Complete" -ForegroundColor Green
 Write-Host "Finding Recovery Points"
 InitializeDatasourceProperties $dsarray
 Write-Host " Complete" -ForegroundColor Green
 Write-Host "Writing to File"
 For($i = 0;$i -lt $dsarray.count;$i++)
 {
 WriteTableRowToFile $dsarray[$i] $dpmserver
 }
 Disconnect-DPMserver
 }
 Write-Host " Complete" -ForegroundColor Green
 Write-Host "The report has been saved to"$filename
 "</body></html>" | Out-File $filename -Append -Confirm:$false