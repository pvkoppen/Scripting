param([string] $DPMServerName, [string] $RemoveOption)

function Usage()
{
	write-host
    	write-host "Usage::"
	write-host "Remove-InactiveDatasource.ps1 -DPMServerName [DPMServername] -RemoveOption [Remove Options]"
	write-host
	write-host "Run 'Remove-InactiveDatasource.ps1 -detailed' for detailed help"
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
	write-host "Detailed Help :  Use this script to remove inactive datasources on disk or tape or both"
	write-host "Valid inputs of RemoveOption"
	write-host "OnDisk	: Removes all inactive datasources on Disk only"
	write-host "OnTape	: Removes all inactive datasources on Tape only"
	write-host "OnBoth	: Removes all inactive datasources on both Disk and Tape"
	write-host
	write-host
	exit 0
}

if(!$DPMServerName)
{
     $DPMServerName = read-host "DPMServerName:"
}
$dpmServer = Connect-DPMServer $DPMServerName
if (!$dpmServer)
{
    write-Error "Failed To Connect To DPM Server::$DPMServerName"
    exit 1
}

$dsList = get-datasource $dpmservername
if (!$dsList -or ($dsList.Count -eq 0) )
{
    write-verbose   "No Datasources found"
    disconnect-dpmserver $dpmservername
    exit 2
}


if(!$RemoveOption)
{
	$RemoveOption = read-host "RemoveOption:"
}
if($RemoveOption)
{
	if ("ONDISK" -eq $RemoveOption)
	{
		$RemoveOption = "OnDisk"
	}
	elseIf ("ONTAPE" -eq $RemoveOption)
	{
		$RemoveOption = "OnTape"
	}
	elseIf("ONBOTH" -eq $RemoveOption)
	{
		$RemoveOption = "OnBoth"
	}
	else
	{
		write-Error "Invalid Value::$RemoveOption For Parameter -RemoveOption[OnDisk/OnTape/OnBoth]"
		Disconnect-dpmserver
		exit 1
	}
}
else
{
	Usage
	Disconnect-dpmserver
	exit 1
}

foreach($ds in $dsList)
{
	if($RemoveOption -eq "OnDisk" -and 
            ($ds.InactiveProtectionStatus -eq [Microsoft.Internal.EnterpriseStorage.Dls.UI.ObjectModel.OMCommon.InactiveProtection]::Disk -or
             $ds.InactiveProtectionStatus -eq [Microsoft.Internal.EnterpriseStorage.Dls.UI.ObjectModel.OMCommon.InactiveProtection]::DiskAndTape)
   	  )
	{
		write-host "Removing inactive Disk protection of " $ds.Name
		$confirm = read-host "Confirm(y/n):"
		if($confirm -eq "y")
		{
			Remove-DatasourceReplica -Datasource $ds -Disk
			write-host "Inactive disk protection for " $ds.Name " removed"	
		}
	}

	if($RemoveOption -eq "OnTape" -and 
            ($ds.InactiveProtectionStatus -eq [Microsoft.Internal.EnterpriseStorage.Dls.UI.ObjectModel.OMCommon.InactiveProtection]::Tape -or
             $ds.InactiveProtectionStatus -eq [Microsoft.Internal.EnterpriseStorage.Dls.UI.ObjectModel.OMCommon.InactiveProtection]::DiskAndTape)
   	  )
	{
		write-host "Removing inactive Tape protection of " $ds.Name
		$confirm = read-host "Confirm(y/n):"
		if($confirm -eq "y")
		{
			Remove-DatasourceReplica -Datasource $ds -Tape
			write-host "Inactive tape protection for " $ds.Name " removed"	
		}		
	}

	if($RemoveOption -eq "OnBoth" -and 
          $ds.InactiveProtectionStatus -ne [Microsoft.Internal.EnterpriseStorage.Dls.UI.ObjectModel.OMCommon.InactiveProtection]::None)
	{
		write-host "Removing inactive Disk and Tape protection of " $ds.Name
		$confirm = read-host "Confirm(y/n):"
		if($confirm -eq "y")
		{
			if($ds.InactiveProtectionStatus -eq [Microsoft.Internal.EnterpriseStorage.Dls.UI.ObjectModel.OMCommon.InactiveProtection]::Disk)	
			{
				Remove-DatasourceReplica -Datasource $ds -Disk
			}
			elseif($ds.InactiveProtectionStatus -eq [Microsoft.Internal.EnterpriseStorage.Dls.UI.ObjectModel.OMCommon.InactiveProtection]::Tape)
			{
				Remove-DatasourceReplica -Datasource $ds -Tape
			}
			else
			{
				Remove-DatasourceReplica -Datasource $ds -Disk
				Remove-DatasourceReplica -Datasource $ds -Tape
			}
			write-host "Inactive protection for " $ds.Name " removed"	
		}		
	}
}

Disconnect-dpmserver