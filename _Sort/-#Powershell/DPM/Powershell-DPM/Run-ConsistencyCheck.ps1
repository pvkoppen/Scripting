param([string] $DPMServerName, [string] $ProtectionGroupName, [string] $DatasourceName)

function Usage()
{
	write-host
    	write-host "Usage::"
	write-host "Run-ConsistencyCheck.ps1 -DPMServerName [DPMServername] -ProtectionGroupName [ProtectionGroupName] -DatasourceName [DatasourceName]"
	write-host
	write-host "Run 'Run-ConsistencyCheck.ps1 -detailed' for detailed help"
	write-host
	write-host
}

if(("-?","-help") -contains $args[0])
{
	Usage
	exit 0
}

if(("-detailed") -contains $args[0])
{
	write-host
	write-host "Detailed Help :  Use this script to run consistency check until it succeeds on a given datasource"
	write-host
	write-host
	exit 0
}

if(!$DPMServerName)
{
     $DPMServerName = read-host "DPMServerName:"
}
if(!$ProtectionGroupName)
{
     $ProtectionGroupName = read-host "ProtectionGroupName:"
}
if(!$DatasourceName)
{
     $DatasourceName = read-host "DatasourceName:"
}

$dpmServer = Connect-DPMServer $DPMServerName
if (!$dpmServer)
{
    write-Error "Failed To Connect To DPM Server::$DPMServerName"
    exit 1
}

write-host "Start consistency check on $DatasourceName " 

write-host "Getting protection group $ProtectionGroupName in $DPMServerName..." 
$ProtectionGroup = Get-ProtectionGroup $DPMServerName | where { $_.FriendlyName -eq $ProtectionGroupName} 
if (!$ProtectionGroup)
{
    write-Error "Failed To get protection group::$ProtectionGroupName"
    exit 1
}

write-host "Getting $DatasourceName from PG $ProtectionGroupName..." 
$ds = Get-Datasource $protectionGroup | where { $_.Name -eq $DatasourceName } 
if (!$ds)
{
    write-Error "Failed To get datasource::$DatasourceName"
    exit 1
}

write-host "Starting consistency check..." 
$jobSucceeded = $false
while ($jobSucceeded -eq $false)
{
	$job = Start-DatasourceConsistencyCheck -Datasource $ds 
	while (! $job.hascompleted )
	{ 
		$jobtype = $j.jobtype 
		write-host "Waiting for $jobtype job to complete..."; 
		start-sleep 5
    	} 
	if($job.Status -ne "Succeeded") 
        {
		write-host "Job $jobtype failed... triggering again" 
        } 
	else
	{
	   	Write-host "$jobtype job completed... Successfully" 
		$jobSucceeded = $true
	}
}

Disconnect-dpmserver
