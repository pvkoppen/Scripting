--------------------------------- Start of script ------------------------------------- 

#This DPM powershell script helps automate the growing of replica and shadow copy volumes which need to be grown.
#You can edit the below constants which can help you configure how much you want to grow the volumes by each time

$ReplicaThreshold = 500MB
$SCThreshold = 1GB
$ReplicaGrowBy = 5GB
$SCGrowBy = 5GB

#End of Constants

$dpmservername = &"hostname"

# The cmdlet below is called Connect-Serverin the DPM v2 Beta2 build
$dpmserver=Connect-DPMServer $dpmservername

if(!$dpmserver)
{
 write-error "Unable to connect to $dpmservername"
 exit 1
}

$PGList = @(Get-ProtectionGroup $dpmservername)

foreach($PG in $PGList)
{

 # The cmdlet below is called Modify-ProtectionGroup in the DPM v2 Beta2 build
 $MPG = Get-ModifiableProtectionGroup $PG

 $dslist=@(get-datasource $MPG)
 foreach ($ds in $dslist)
 {
  if(($ds.ReplicaSize - $ds.ReplicaUsedSpace) -lt $ReplicaThreshold)
  {
   "Need to grow replica for $($ds.Name) on $($ds.ProductionServerName)"
   $NewReplicaSize = $ds.ReplicaSize + $ReplicaGrowBy
    Set-DatasourceDiskAllocation -Manual -Datasource $ds -ProtectionGroup $MPG -ReplicaArea 

$NewReplicaSize
  }
  else
  {
   $ReplicaFreeSpace = $ds.ReplicaSize - $ds.ReplicaUsedSpace
   $ReplicaFreeSpace /= 1MB
   "Replica for $($ds.Name) on $($ds.ProductionServerName) does not need to grow and has 

$ReplicaFreeSpace MB free"
  }
  if($ds.ShadowCopyAreaSize - $ds.ShadowCopyUsedSpace -lt $SCThreshold)
  {
   "Need to grow recovery point volume for $($ds.Name) on $($ds.ProductionServerName)"
   $NewSCSize = $ds.ShadowCopyAreaSize + $SCGrowBy
    Set-DatasourceDiskAllocation -Manual -Datasource $ds -ProtectionGroup $MPG -ShadowCopyArea 

$NewSCSize
  }
  else
  {
   $SCFreeSpace = $ds.ShadowCopyAreaSize - $ds.ShadowCopyUsedSpace
   $SCFreeSpace /= 1MB
   "Recovery Point volume for $($ds.Name) on $($ds.ProductionServerName) does not need to grow and has 

$SCFreeSpace MB free"
  }
 }
 
 # The cmdlet below is called Save-ProtectionGroup in the DPM v2 Beta2 build
 Set-ProtectionGroup $MPG

}

# The cmdlet below is called Disconnect-Server in the DPM v2 Beta2 build
Disconnect-DPMServer $dpmservername

"Exiting from script"
--------------------------------- End of script ---------------------------------------

