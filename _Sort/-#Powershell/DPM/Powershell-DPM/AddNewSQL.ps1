param([string] $ProductionServer, [string] $PGName)
if(!$ProductionServer)
{
	$ProductionServer = read-host "Enter the production server name : "
}
if(!$PGName)
{
	$PGName = read-host "Enter the name of your existing SQL protection group name : "
}

$dpmservername = &"hostname"
connect-dpmserver $dpmservername
$dpmservername

$PGList = @(Get-ProtectionGroup $dpmservername)

foreach ($PG in $PGList)
{
	if($PG.FriendlyName -eq $PGName)
	{
		write-host "Found PG $PGName"
		$MPG = Get-ModifiableProtectionGroup $PG
		$PGFound=$true
	}
}

if(!$PGfound)
{
	write-host "Protection Group $PGName does not exist"
	exit 1
}


$PSList=@(Get-ProductionServer $dpmservername)
$DsList = @()

foreach ($PS in $PSList)
{
	if($PS.NetBiosName -eq $ProductionServer)
	{
		write-host "Running Inquiry on" $PS.NetbiosName
		$DSlist += Get-Datasource -ProductionServer $PS -Inquire
		$PSFound=$true
	}
}

if(!$PSfound)
{
	"Production Server $PS does not exist"
	exit 1
}


$protectedDsList = @()
foreach ($ds in $dslist)
{
	if($ds.ToString("T", $null) -match "SQL" -and !$ds.Protected)
	{
		write-host "Adding to your SQL protection PG" $ds.Name
		$protectedDsList += $ds
		Add-ChildDatasource -ProtectionGroup $MPG -ChildDatasource $ds
	}
}

foreach ($ds in $protectedDsList)
{
		$x=Get-DatasourceDiskAllocation -Datasource $ds
		Set-DatasourceDiskAllocation -Datasource $x -ProtectionGroup $MPG

}

Set-ReplicaCreationMethod -ProtectionGroup $MPG -Now

if($protectedDsList.Length)
{
	write-host "Adding new SQL DBs to" $MPG.FriendlyName
	Set-protectiongroup $MPG
}

disconnect-dpmserver $dpmservername
"Exiting from script"
