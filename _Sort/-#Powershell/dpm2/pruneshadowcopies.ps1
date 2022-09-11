
function GetDistinctDays([Microsoft.Internal.EnterpriseStorage.Dls.UI.ObjectModel.OMCommon.ProtectionGroup] $group, 
[Microsoft.Internal.EnterpriseStorage.Dls.UI.ObjectModel.OMCommon.Datasource] $ds)
{    
    if($group.ProtectionType -eq [Microsoft.Internal.EnterpriseStorage.Dls.UI.ObjectModel.OMCommon.ProtectionType]::DiskToTape)
    {
        return 0
    }
    
    $scheduleList = get-policyschedule -ProtectionGroup $group -ShortTerm
    if($ds -is [Microsoft.Internal.EnterpriseStorage.Dls.UI.ObjectModel.FileSystem.FsDataSource])
    {
        $jobType = [Microsoft.Internal.EnterpriseStorage.Dls.Intent.JobTypeType]::ShadowCopy
    }
    else
    {
        $jobType = [Microsoft.Internal.EnterpriseStorage.Dls.Intent.JobTypeType]::FullReplicationForApplication
        if($ds.ProtectionType -eq [Microsoft.Internal.EnterpriseStorage.Dls.Intent.ReplicaProtectionType]::ProtectFromDPM)
        {            
            return 2
        }
    }
    write-verbose   "Look for jobType $jobType"

    foreach($schedule in $scheduleList)
    {
        write-verbose("schedule jobType {0}" -f $schedule.JobType)
        if($schedule.JobType -eq $jobType)
        {
            return [Math]::Ceiling(($schedule.WeekDays.Length * $ds.RecoveryRangeinDays) / 7)
             
        }
    }

    return 0
}

function IsShadowCopyExternal($id)
{
    $result = $false;

    $ctx = New-Object -Typename Microsoft.Internal.EnterpriseStorage.Dls.DB.SqlContext 
    $ctx.Open()

    $cmd = $ctx.CreateCommand()
    $cmd.CommandText = "select COUNT(*) from tbl_RM_ShadowCopy where shadowcopyid = '$id'"   
    write-verbose $cmd.CommandText
    $countObj = $cmd.ExecuteScalar()
    write-verbose $countObj
    if ($countObj -eq 0)
    {
        $result = $true
    }
        
    $cmd.Dispose()
    $ctx.Close()

    return $result
}


function IsShadowCopyInUse($id)
{
    $result = $true;

    $ctx = New-Object -Typename Microsoft.Internal.EnterpriseStorage.Dls.DB.SqlContext 
    $ctx.Open()

    $cmd = $ctx.CreateCommand()
    $cmd.CommandText = "select ArchiveTaskId, RecoveryJobId from tbl_RM_ShadowCopy where ShadowCopyId = '$id'"   
    write-verbose $cmd.CommandText
    $reader = $cmd.ExecuteReader()
    
    while($reader.Read())
    {
        if ($reader.IsDBNull(0) -and $reader.IsDBNull(1))
        {
            $result = $false
        }
    } 
        
    $cmd.Dispose()
    $ctx.Close()

    return $result
}

$dpmservername = &"hostname"

$dpmsrv = connect-dpmserver $dpmservername

if (!$dpmsrv)
{
	write-verbose "Unable to connect to $dpmservername"
	exit 1
}

write-verbose $dpmservername

$pgList = get-protectiongroup $dpmservername
if (!$pgList)
{
    write-verbose   "No PGs found"
    disconnect-dpmserver $dpmservername
    exit 2
}

write-verbose("Number of ProtectionGroups = {0}" -f $pgList.Length)
$replicaList = @{}
$latestScDateList = @{}

foreach($pg in $pgList)
{
    $dslist = get-datasource $pg
    write-verbose("Number of datasources = {0}" -f $dslist.length)
    foreach ($ds in $dslist)
    {        
        $rplist = get-recoverypoint $ds | where { $_.DataLocation -eq 'Disk' }
        write-verbose("Number of recovery points {0}" -f $rplist.length)
        
        $countDistinctDays = GetDistinctDays $pg $ds
        write-verbose("Number of weekdays with fulls = {0}" -f $nDaysOfWeekWithFulls)
        
        if($countDistinctDays -eq 0)
        {
            write-verbose   "D2T PG. No recovery points to delete"
            continue;
        }
        
        $replicaList[$ds.ReplicaPath] = $ds.RecoveryRangeinDays
        $latestScDateList[$ds.ReplicaPath] = new-object DateTime 0,0
        $lastDayOfRetentionRange = ([DateTime]::UtcNow).AddDays($ds.RecoveryRangeinDays * -1);        
        write-verbose("Distinct days to count = {0}. LastDayOfRetentionRange = {1} " -f $countDistinctDays, $lastDayOfRetentionRange)
        
        $distinctDays = 0;
        $lastDistinctDay = (get-Date).Date
        $numberOfRecoveryPointsDeleted = 0

        if ($rplist)
        {
    
            foreach ($rp in ($rplist | sort-object -property UtcRepresentedPointInTime -descending))
            {                        
                if ($rp)
                {                    
                    write-verbose("Recovery point time = {0}" -f $rp.UtcRepresentedPointInTime)
        
                    if ($rp.UtcRepresentedPointInTime.Date -lt $lastDistinctDay)
                    {
                        write-verbose "Incrementing distinct days"
                        $distinctDays += 1
                        $lastDistinctDay = $rp.UtcRepresentedPointInTime.Date
                    }
        
                    if (($distinctDays -gt $countDistinctDays) -and ($rp.UtcRepresentedPointInTime -lt $lastDayOfRetentionRange))
                    {
                        write-verbose "Deleting a recovery point"
			if ($rp.IsIncremental -eq $FALSE)
			{
                        	remove-recoverypoint $rp -ForceDeletion -confirm:$false | out-null
	                        $numberOfRecoveryPointsDeleted += 1
			}
                    }
                    else
                    {
                        write-verbose "Not calling remove-recoverypoint"
                    }
                }
                else
                {
                    write-verbose "Got a NULL rp"
                }	
            }

            write-verbose "Number of SCs deleted $numberOfRecoveryPointsDeleted"                
        }
    }
}

$sclist = Get-WmiObject win32_shadowcopy            
if ($sclist)
{   
    foreach ($sc in $sclist)
    {
        if ($replicaList[$sc.VolumeName] -ne $null -and $sc.Persistent -eq $True)
        {
             $currScDate = $sc.InstallDate
             $scdate = new-object DateTime $currScDate.SubString(0,4), $currScDate.SubString(4,2), $currScDate.SubString(6,2)
             $scdate = $scdate.AddDays($replicaList[$sc.VolumeName])
             $lastValidDate = get-date
             if(test-path "Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Microsoft Data Protection Manager\2.0")
             {
                 $validityPeriod = Get-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Microsoft Data Protection Manager\2.0"
                 if($validityPeriod -and $validityPeriod.ValidityPeriodForExternalSC)
                 {
                     if($validityPeriod.ValidityPeriodForExternalSC -is "System.Int32")
                     {
                         $lastValidDate = $lastValidDate.AddDays(-$validityPeriod.ValidityPeriodForExternalSC)
                     }
                 }
             }             
             if ($scdate.Date -lt $lastValidDate.Date)
             {
                  write-verbose "Deleting a persistent snap older than $recoveryRange and not created by DPM"
                  $nonDPMShadowCopy = @(IsShadowCopyExternal($sc.ID))
                  if ($nonDPMShadowCopy[0] -eq $true)
                  {
                      $sc.Delete()
                  }
              }
         }
    }
}

$inactiveDsList = Get-Datasource -DPMServerName $dpmservername -Inactive | where {$_.InactiveProtectionStatus -ne "Tape"}
foreach ($inactiveDs in $inactiveDsList)
{
    if ($inactiveDs.ReplicaPath)
    {
    	$replicaList[$inactiveDs.ReplicaPath] = $inactiveDs.RecoveryRangeinDays
	$latestScDateList[$inactiveDs.ReplicaPath] = new-object DateTime 0,0
    }
}

$sclist = Get-WmiObject win32_shadowcopy
if ($sclist)
{
    [array]::reverse($sclist)
    $noDismountInterval = new-object TimeSpan 2,0,0,0
    foreach ($sc in $sclist)
    {
        if ($replicaList[$sc.VolumeName] -ne $null -and $sc.Persistent -eq $True)
        {                         
            $currScDate = $sc.InstallDate
            $scdate = new-object DateTime $currScDate.SubString(0,4), $currScDate.SubString(4,2), $currScDate.SubString(6,2)
            write-verbose "Install date for $($sc.ID) is $($scDate) [$($sc.InstallDate)]"
            
            $scdate = $scdate - $noDismountInterval
            if ($scdate -gt $latestScDateList[$sc.VolumeName])
            {
                $nonDPMShadowCopy = @(IsShadowCopyExternal($sc.ID))
                if ($nonDPMShadowCopy[0] -eq $false)
                {
                    $latestScDateList[$sc.VolumeName] = $scdate
                }
            }
        }                   
    }

    foreach ($sc in $sclist)
    {
        if ($replicaList[$sc.VolumeName] -ne $null -and $sc.Persistent -eq $True)
        {                         
            $currScDate = $sc.InstallDate
            $scdate = new-object DateTime $currScDate.SubString(0,4), $currScDate.SubString(4,2), $currScDate.SubString(6,2)
            
            write-verbose "Latest install date for $($sc.ID) created on $($scdate) is $($latestScDateList[$sc.VolumeName])"
            if ($scdate -lt $latestScDateList[$sc.VolumeName])
            {
                $isShadowCopyInUse = @(IsShadowCopyInUse($sc.ID))

                if ($isShadowCopyInUse[0] -eq $false)
                {
                    write-verbose "sending dismount for the snapshot $($sc.ID)"
                    snapdismount.exe $sc.DeviceObject
                }                             
            }
        }                   
    }
}


disconnect-dpmserver $dpmservername
write-verbose "Exiting from script"

exit


