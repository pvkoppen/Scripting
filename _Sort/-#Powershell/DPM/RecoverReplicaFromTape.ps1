# This script initializes replica from tape recovery point. The parameters have to be initialized first as given below.  Please give the values of parameters as appropriate for your environment.  You can customize this easily as per your needs. Save the attached file as a .ps1 file and invoke through the DPM Management Shell.


$DPMServerName = "DPM server name"
$pgName = "PG Name"
$dsName = "K:\"

$pg = Get-ProtectionGroup $DPMServerName | where { $_.FriendlyName -eq $pgName }
if(!$pg)
{
	Write-Host "Protection group " $pgName " not found"
	exit 1
}
$ds = Get-Datasource $pg | where { $_.logicalpath -eq $dsName } 
if(!$ds)
{
	Write-Host "Datasource " $dsName " not found"
	exit 1
}
$rpList = Get-RecoveryPoint -Datasource $ds
if(!$rpList -or $rpList.Count -eq 0)
{
	Write-Host "No recovery points exists"
	exit 1
}
if($rpList.Count -gt 1)
{
	# Initialize $rp appropriately here
	$rp = $rpList[0]	
}
else 
{
	$rp = $rpList
}

if($rp.DataLocation -eq 0)
{
	Write-Host "Selected Recovery Point does not exist on Tape"
	exit 1
}
$lib = Get-DPMLibrary -DPMServerName $DPMServerName
if(!$lib)
{
	Write-Host "No libraries detected"
	exit 1
}
$rop = New-RecoveryOption -RecoverToReplicaFromTape 1 -RecoveryLocation DPMReplicaVolume -FileSystem -TargetServer $DPMServerName -OverwriteType Overwrite -RecoveryType Recover -DpmLibrary $lib
Recover-RecoverableItem -RecoverableItem $rp -RecoveryOption $rop
