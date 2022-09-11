# Set Variable values
  $colorHeader = "Yellow"
  $colorInfo = "White"
  $colorGood = "Green"
  $colorBad = "Red"
  Write-Host "# Set Variables." -foregroundcolor $colorHeader
  Write-Host "  # ---------------------------------------------------------------"
  Write-Host "  # Colors: " -NoNewLine -ForegroundColor $colorInfo
  Write-Host "Plain, "  -NoNewLine
  Write-Host "Header, " -NoNewLine -ForegroundColor $colorHeader
  Write-Host "Info, "   -NoNewLine -ForegroundColor $colorInfo
  Write-Host "Good, "   -NoNewLine -ForegroundColor $colorGood
  Write-Host "Bad."     -ForegroundColor $colorBad
  $DPMServerName = "TOLBU01"
  $dtStart = Get-Date
  Write-Host "  # DPMServer: $DPMServerName, at: $dtStart" -foregroundcolor $colorInfo
  $minJobRunTime = 80
  $minMargin     = 5
  $secSleepTime  = 60
  Write-Host "  # JobRunTime: $minJobRunTime minutes, MarginForError: $minMargin minutes, SleepTime: $secSleepTime secondes." -foregroundcolor $colorInfo
  Write-Host "  # ---------------------------------------------------------------"


# Start of Script: Check for the DPM Snapin
  Write-Host "# Checking for DPM Snapin." -ForegroundColor $colorHeader
  if (!(Get-PSSnapin microsoft.dataprotectionmanager.powershell)) {
    write-host "  # Adding PS Snapin for DPM." -ForegroundColor $colorGood
    add-PSSnapin Microsoft.DataProtectionManager.PowerShell
  } else {
    write-host "  # PS Snapin for DPM already loaded." -ForegroundColor $colorGood
  }


# Create a Joblist to check in the end
  $jobList = @()



# Check for DataSources that need to grow:
  mkdir .\LogFiles
  Write-Host "# Check DataSources for growth needs (needs work)" -foregroundcolor $colorHeader
  Write-Host "" > ..\LogFiles\Report-DiskSpace-All.html
  Write-Host "" > ..\LogFiles\Report-DiskSpace-SpaceRequired.html
  Write-Host "" > ..\LogFiles\Report-DiskSpace-OverAllocated.html
  $pgAll = Get-ProtectionGroup -DPMServerName $DPMServerName
  foreach ($pgIndex in $pgAll) {
    $pgName = $pgIndex.FriendlyName
    $dsAll = Get-Datasource -ProtectionGroup $pgIndex 
    $dsAll | convertto-html ProductionServerName,LogicalPath,ReplicaSize,RequiredReplicaSize,ReplicaUsedSpace,ShadowCopyAreaSize,RequiredShadowCopyAreaSize,ShadowCopyUsedSpace,ReplicaGrowRequired >> ..\LogFiles\Report-DiskSpace-$pgName-All.html #ProtectableObjectLoadPath
    $dsGrowRequired = $dsAll | ? {($_.ReplicaGrowRequired) -or (($_.ReplicaSize*0.75) -le $_.ReplicaUsedSpace)} 
    if ($dsGrowRequired) { 
      $dsGrowRequired | convertto-html ProductionServerName,LogicalPath,ReplicaSize,RequiredReplicaSize,ReplicaUsedSpace,ShadowCopyAreaSize,RequiredShadowCopyAreaSize,ShadowCopyUsedSpace,ReplicaGrowRequired >> ..\LogFiles\Report-DiskSpace-$pgName-SpaceRequired.html #ProtectableObjectLoadPath
    }
    $dsNotGrowRequired = $dsAll | ? {!($_.ReplicaGrowRequired) -and (($_.ReplicaSize*0.4) -ge $_.ReplicaUsedSpace)} 
    if ($dsNotGrowRequired) { 
      $dsNotGrowRequired | convertto-html ProductionServerName,LogicalPath,ReplicaSize,RequiredReplicaSize,ReplicaUsedSpace,ShadowCopyAreaSize,RequiredShadowCopyAreaSize,ShadowCopyUsedSpace,ReplicaGrowRequired >> ..\LogFiles\Report-DiskSpace-$pgName-OverAllocated.html #ProtectableObjectLoadPath
    }
  }


# Walk thru JobList waiting for Completion
  Write-Host "# If any jobs where started wait for them to finish" -ForegroundColor $colorHeader
  $completedJobsCount = 0
  while (($completedJobsCount -ne $jobList.Length) -and ($($dtStart.AddMinutes($minJobRunTime).AddMinutes($minMagin)) -gt $(Get-Date))) {
    $completedJobsCount = 0
    Write-Host "  # Wait for $secSleepTime Second before checking (Again)" -ForegroundColor $colorInfo
    sleep $secSleepTime
    foreach ($jobItem in $jobList) {
      if ($($jobItem.Job.HasCompleted)) {
        Write-Host "    # Job has $($jobItem.Job.Status): $($jobItem.DataSource)."  -ForegroundColor $colorGood
        $completedJobsCount += 1
      } else {
        Write-Host "    # Job still running: $($jobItem.DataSource)." -ForegroundColor $colorInfo
      }
    }
  }
  Write-Host "  # All Jobs 'Finished/Wait Time Expired', waiting for $secSleepTime Second before closing" -ForegroundColor $colorInfo
  sleep $secSleepTime
  Write-Host "# The end." -ForegroundColor $colorHeader

