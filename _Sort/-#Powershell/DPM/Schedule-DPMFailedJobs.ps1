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
  $DPMServerName = "TOLSS02"
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


Write-Host "# List all Libraries..." -foregroundcolor $colorHeader
  $DPMLibraries = Get-DPMLibrary -DPMServerName $DPMServerName
  $DPMLibraries 


Write-Host "# List all Active Libraries." -foregroundcolor $colorHeader
  $DPMLibrariesActive = $DPMLibraries | Where-Object -FilterScript {$_.IsOffline -eq 0}
  $DPMLibrariesActive


Write-Host "# Process Active Libraries" -foregroundcolor $colorHeader
  foreach ($DPMLibrary in $DPMLibrariesActive)
  {
    Write-Host "  # Processing Library: $($DPMLibrary.UserFriendlyName)." -foregroundcolor $colorHeader
    if ( $DPMLibrary.Type -eq "TapeLibrary")
    {
      Write-Host "  # Unlock Library Door" -foregroundcolor $colorHeader
      $DPMLibrary | Unlock-DPMLibraryDoor

      Write-Host "    # Wait for process to finish ($secSleepTime sec)." -foregroundcolor $colorHeader
      sleep $secSleepTime

      Write-Host "  # Lock Library Door" -foregroundcolor $colorHeader
      $DPMLibrary | Lock-DPMLibraryDoor

      Write-Host "    # Wait for process to finish ($secSleepTime sec)." -foregroundcolor $colorHeader
      sleep $secSleepTime

      Write-Host "  # Perform Fast Inventory" -foregroundcolor $colorHeader
      $DPMLibrary | Start-DPMLibraryInventory -FastInventory

      Write-Host "    # Wait for process to finish ($secSleepTime sec)." -foregroundcolor $colorHeader
      sleep $secSleepTime
    } else {
      Write-Host "  # This library is a Stand-Alone drive (No Unlock-Door and Lock-Door required)." -foregroundcolor Yellow
    }
    Write-Host "  # Schedule Detailed Inventory." -foregroundcolor $colorHeader
    $DPMLibrary | Start-DPMLibraryInventory -DetailedInventory
  }


# Check for DataSources that need to grow:
  Write-Host "# Check DataSources for growth needs (needs work)" -foregroundcolor $colorHeader
  Write-Host "" > .\Report-DiskSpace-All.html
  Write-Host "" > .\Report-DiskSpace-SpaceRequired.html
  Write-Host "" > .\Report-DiskSpace-OverAllocated.html
  $pgAll = Get-ProtectionGroup -DPMServerName $DPMServerName
  foreach ($pgIndex in $pgAll) {
    $dsAll = Get-Datasource -ProtectionGroup $pgIndex
    $dsAll | convertto-html ProductionServerName,LogicalPath,ReplicaSize,RequiredReplicaSize,ReplicaUsedSpace,ShadowCopyAreaSize,RequiredShadowCopyAreaSize,ShadowCopyUsedSpace,ReplicaGrowRequired >> .\Report-DiskSpace-All.html #ProtectableObjectLoadPath
    $dsGrowRequired = $dsAll | ? {($_.ReplicaGrowRequired) -or (($_.ReplicaSize*0.75) -le $_.ReplicaUsedSpace)} 
    if ($dsGrowRequired) { 
      $dsGrowRequired | convertto-html ProductionServerName,LogicalPath,ReplicaSize,RequiredReplicaSize,ReplicaUsedSpace,ShadowCopyAreaSize,RequiredShadowCopyAreaSize,ShadowCopyUsedSpace,ReplicaGrowRequired >> .\Report-DiskSpace-SpaceRequired.html #ProtectableObjectLoadPath
    }
    $dsNotGrowRequired = $dsAll | ? {!($_.ReplicaGrowRequired) -and (($_.ReplicaSize*0.4) -ge $_.ReplicaUsedSpace)} 
    if ($dsNotGrowRequired) { 
      $dsNotGrowRequired | convertto-html ProductionServerName,LogicalPath,ReplicaSize,RequiredReplicaSize,ReplicaUsedSpace,ShadowCopyAreaSize,RequiredShadowCopyAreaSize,ShadowCopyUsedSpace,ReplicaGrowRequired >> .\Report-DiskSpace-OverAllocated.html #ProtectableObjectLoadPath
    }
  }


# Check for DataSources that are Inconsistent:
  Write-Host "# Check DataSources for being Inconsistent" -foregroundcolor $colorHeader
  $pgAll = Get-ProtectionGroup -DPMServerName $DPMServerName
  foreach ($pgIndex in $pgAll) {
    $dsAll = Get-Datasource -ProtectionGroup $pgIndex
    $dsInvalid = $dsAll | ? {$_.Protected -and $_.State -eq "Invalid"} 
    $dsInvalid | format-List ProtectionGroupName,MountPoints,Name,Protected,State,Activity,Alert
    if ($dsInvalid) {
      $jobList += @{
        Job= $dsInvalid | Start-DatasourceConsistencyCheck
        DataSource= $dsInvalid
      }
    }
#    foreach ($dsIndex in $dsInvalid) {
#      Start-DatasourceConsistencyCheck -DataSource $dsIndex -HeavyWeight
#    }
  }


# Check for Datasources that failed Synchronisation
  Write-Host "# Get-ProtectionGroups:" -ForegroundColor $colorHeader
  $pgAll = Get-ProtectionGroup -DPMServerName $DPMServerName
  foreach ($pgIndex in $pgAll) {
    Write-Host "  # Get-PolicySchedules for: $($pgIndex.FriendlyName)" -ForegroundColor $colorHeader
    $psAll = Get-PolicySchedule -ProtectionGroup $pgIndex -ShortTerm
    foreach ($psIndex in $psAll) {
#      Write-Host "  # Get-PolicySchedules: $psIndex" -ForegroundColor $colorHeader
      if ($($psIndex.JobType) -eq "FullReplicationForApplication") {
        foreach ($dtIndex in $psIndex.TimesOfDay) {
          # If a Policy Schedule is later today, check yesterday's instead.
          if ($dtIndex -gt $dtStart) { $dtIndex = $($dtIndex.AddDays(-1)) }
          if ($($dtIndex.AddMinutes($minJobRunTime)) -lt $dtStart) {
            Write-Host "    # Get-PolicySchedules: $($psIndex.JobType) ($($dtIndex.AddDays(-1)))" -ForegroundColor $colorHeader
            $dsAll = Get-Datasource -ProtectionGroup $pgIndex
            foreach ($dsIndex in $dsAll) {
              foreach ($valueIndex in $dsIndex.NodeType.JunctionLessPath) {
                if ($valueIndex.Type -eq "ApplicationComponent") {
                  $ProtectionCompleted = $False
                  $rpDisk = $dsIndex | Get-RecoveryPoint | Where-Object {$_.DataLocation -eq "Disk"}
                  foreach ($rpIndex in $rpDisk) {
                    if ($($rpIndex.RepresentedPointInTime.AddMinutes($minMargin)) -ge $dtIndex) {
                     $ProtectionCompleted = $True
                    } # Found a recent RecoveryPoint
                  } # Walk thru RecoveryPoints
                  if ($ProtectionCompleted) {
                    #Write-Host "      # '$dsIndex' is protected ($($rpIndex.RepresentedPointInTime))" -ForegroundColor $colorGood
                  } else {
                    Write-Host "      # '$dsIndex' is NOT protected. (Schedule Protection)" -ForegroundColor $colorBad
                    # TODO
                    $jobList += @{
                      Job = New-RecoveryPoint -DataSource $dsIndex -Disk -DiskRecoveryPointOption WithSynchronize
                      DataSource = $dsIndex
                    }
                  }
                } # It is an ApplicationComponent
              } # Find out if DataSource is an ApplicationComponent
            } # Check all the DataSources in the ProtectionGroup
          } else {
            Write-Host "    # Get-PolicySchedules: $($psIndex.JobType) ($dtIndex): Within RunTime..." -ForegroundColor $colorInfo
          } # After JobRunTime
        } # ForEach ScheduleTime
      } elseif ($($psIndex.JobType) -eq "Replication") {
        Write-Host "    # Get-PolicySchedules: $($psIndex.JobType)= Ignored" -ForegroundColor $colorInfo
      } elseif ($($psIndex.JobType) -eq "ShadowCopy") {
        foreach ($dtIndex in $psIndex.TimesOfDay) {
          # If a Policy Schedule is later today, check yesterday's instead.
          if ($dtIndex -gt $dtStart) { $dtIndex = $($dtIndex.AddDays(-1)) }
          if ($($dtIndex.AddMinutes($minJobRunTime)) -lt $dtStart) {
            Write-Host "    # Get-PolicySchedules: $($psIndex.JobType) ($dtIndex)" -ForegroundColor $colorHeader
            $dsAll = Get-Datasource -ProtectionGroup $pgIndex
            foreach ($dsIndex in $dsAll) {
              foreach ($valueIndex in $dsIndex.NodeType.JunctionLessPath) {
                if ($valueIndex.Type -eq "Volume") {
                  $ProtectionCompleted = $False
                  $rpDisk = $dsIndex | Get-RecoveryPoint | Where-Object {$_.DataLocation -eq "Disk"}
                  foreach ($rpIndex in $rpDisk) {
                    if ($($rpIndex.RepresentedPointInTime.AddMinutes($minMargin)) -ge $dtIndex) {
                     $ProtectionCompleted = $True
                    } # Found a recent RecoveryPoint
                  } # Walk thru RecoveryPoints
                  if ($ProtectionCompleted) {
                    # Write-Host "      # '$dsIndex' is protected ($($rpIndex.RepresentedPointInTime))" -ForegroundColor $colorGood
                  } else {
                    Write-Host "      # '$dsIndex' is NOT protected. (Schedule Protection)" -ForegroundColor $colorBad
                    # TODO
                    $jobList += @{
                      Job = New-RecoveryPoint -DataSource $dsIndex -Disk -DiskRecoveryPointOption WithSynchronize
                      DataSource = $dsIndex
                    }
                  }
                } # It is a Volume
              } # Find out if DataSource is a Volume
            } # Check all the DataSources in the ProtectionGroup
          } else {
            Write-Host "    # Get-PolicySchedules: $($psIndex.JobType) ($dtIndex): Within RunTime..." -ForegroundColor $colorInfo
          } # After JobRunTime
        } # ForEach ScheduleTime
      } else {
        Write-Host "### Get-PolicySchedules: $($psIndex.JobType)= Unknown Type" -ForegroundColor $colorBad
      } # If $($psIndex.JobType)
    } # ForEach $psIndex
  } # ForEach $pgIndex


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

