param ([string] $DPMServerName)

Write-Host "[INFO ] Set Variable values."
if (!$DPMServerName) { $DPMServerName = 'TOLBU01' }

$dtStart = Get-Date
Write-Host "[INFO ] DPMServer: '$DPMServerName', at: $dtStart"
$minMaxRuntime = 1
$secSleepTime  = 30
Write-Host "[INFO ] MaxRuntime: $minMaxRuntime minute(s), SleepTime: $secSleepTime second(s)."
$minJobRunTime = 80
$minMargin     = 5
Write-Host "[INFO ] JobRunTime: $minJobRunTime minute(s), MarginForError: $minMargin minute(s)."
Write-Host "[INFO ] ---------------------------------------------------------------"

Function WaitForJobsToFinish {
  Write-Host "[INFO ] If any jobs where started wait for them to finish" 
  $completedJobsCount = 0
  while (($completedJobsCount -ne $jobList.Length) -and ($($dtStart.AddMinutes($minMaxRunTime)) -gt $(Get-Date))) {
    $completedJobsCount = 0
    Write-Host "[INFO ] Wait for $secSleepTime second before checking. (Runtime: $(new-timespan -Start $dtStart -End $(Get-Date))" 
    sleep $secSleepTime
    foreach ($jobItem in $jobList) {
      if ($jobItem.Job.JobID) {
        if ($($jobItem.Job.HasCompleted)) {
          Write-Host "[INFO ] Job has $($jobItem.Job.Status): $($jobItem.Job.JobType)."
          $completedJobsCount += 1
        } else {
          Write-Host "[INFO ] Job still running: $($jobItem.Job.JobType)."
        }
      } else {
        if ($($jobItem.Job.Success)) {
          Write-Host "[INFO ] Job has Success: $($jobItem.Job.Message)."
          $completedJobsCount += 1
        } else {
          Write-Host "[INFO ] Job still running: $($jobItem.Job.Message)."
        }
      }
    }
  }
  Write-Host "[INFO ] All Jobs 'Finished/Wait Time Expired'."
}

function x {
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
}

Write-Host "[INFO ] Create a Joblist to check in the end."
$jobList = @()

Write-Host "[INFO ] Checking for the DPM Snapin."
if (!(Get-PSSnapin microsoft.dataprotectionmanager.powershell)) {
  Write-Host "[INFO ] Adding PS Snapin for DPM." -Fore Green
  add-PSSnapin Microsoft.DataProtectionManager.PowerShell
} else {
  Write-Host "[INFO ] PS Snapin for DPM already loaded." -Fore Green
}

#Help
if (("-?","-help") -contains $args[0]) {
  Write-Host "[INFO ] Usage: CheckSync-DPMScheduleFailedSync.ps1 [[-DPMServerName] <Name of the DPM server>]"
  Write-Host "[INFO ] Example: CheckSync-DPMScheduleFailedSync.ps1 -DPMServerName ""DPM01"" "
  exit 0
}

if (!$DPMServerName) {
  $DPMServerName = Read-Host "ReadValue: DPMServerName"
  if (!$DPMServerName) {
    Write-Error "[INFO ] DPMServerName not specified."
    exit 1
  }
} else {
  Write-Host "[INFO ] Using DPMServerName: '$DPMServerName'"
}

if (!(Connect-DPMServer $DPMServerName)) {
  Write-Error "[ERROR] Failed to connect to DPMServerName: '$DPMServerName'"
  exit 1
}

Write-Host "[INFO ] Check for Datasources that failed Synchronisation."
$pgAll = Get-ProtectionGroup -DPMServerName $DPMServerName
If ($pgAll) {
  foreach ($pgIndex in $pgAll) {
    Write-Host "[INFO ] Get-PolicySchedules for: '$($pgIndex.FriendlyName)'" 
    $psAll = Get-PolicySchedule -ProtectionGroup $pgIndex -ShortTerm
    foreach ($psIndex in $psAll) {
#      Write-Host "[INFO ] Get-PolicySchedules: '$psIndex'"
      if ($($psIndex.JobType) -eq "FullReplicationForApplication") {
        foreach ($dtIndex in $psIndex.TimesOfDay) {
          Write-Host "[INFO ] If a Policy Schedule is later today, check yesterday's instead."
          if ($dtIndex -gt $dtStart) { $dtIndex = $($dtIndex.AddDays(-1)) }
          if ($($dtIndex.AddMinutes($minJobRunTime)) -lt $dtStart) {
            Write-Host "[INFO ] Get-PolicySchedules: '$($psIndex.JobType)' ($($dtIndex.AddDays(-1)))"
            $dsAll = Get-Datasource -ProtectionGroup $pgIndex
            $dsSelected = $dsAll | ? {$_.Activity -eq "Idle"} 
            foreach ($dsIndex in $dsSelected) {
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
                    #Write-Host "[INFO ] '$dsIndex' is protected ($($rpIndex.RepresentedPointInTime))"
                  } else {
                    Write-Host "[INFO ] '$dsIndex' is NOT protected. (Schedule Protection)"
                    # TODO
                    $jobList += @{
                      Job = New-RecoveryPoint -DataSource $dsIndex -Disk -DiskRecoveryPointOption WithSynchronize
                      DataSource = $dsIndex
                    }
                  }
                } # It is an ApplicationComponent
              } # Find out if DataSource is an ApplicationComponent
            } # Check all the (Idle) DataSources in the ProtectionGroup
          } else {
            Write-Host "[INFO ] Get-PolicySchedules: '$($psIndex.JobType)' ($dtIndex): Within RunTime..."
          } # After JobRunTime
        } # ForEach ScheduleTime
      } elseif ($($psIndex.JobType) -eq "Replication") {
        Write-Host "[INFO ] Get-PolicySchedules: '$($psIndex.JobType)'= Ignored"
      } elseif ($($psIndex.JobType) -eq "ShadowCopy") {
        foreach ($dtIndex in $psIndex.TimesOfDay) {
          # If a Policy Schedule is later today, check yesterday's instead.
          if ($dtIndex -gt $dtStart) { $dtIndex = $($dtIndex.AddDays(-1)) }
          if ($($dtIndex.AddMinutes($minJobRunTime)) -lt $dtStart) {
            Write-Host "[INFO ] Get-PolicySchedules: '$($psIndex.JobType)' ($dtIndex)"
            $dsAll = Get-Datasource -ProtectionGroup $pgIndex
            $dsSelected = $dsAll | ? {$_.Activity -eq "Idle"} 
            foreach ($dsIndex in $dsSelected) {
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
                    # Write-Host "[INFO ] '$dsIndex' is protected ($($rpIndex.RepresentedPointInTime))"
                  } else {
                    Write-Host "[INFO ] '$dsIndex' is NOT protected. (Schedule Protection)"
                    # TODO
                    $jobList += @{
                      Job = New-RecoveryPoint -DataSource $dsIndex -Disk -DiskRecoveryPointOption WithSynchronize
                      DataSource = $dsIndex
                    }
                  }
                } # It is a Volume
              } # Find out if DataSource is a Volume
            } # Check all the (Idle) DataSources in the ProtectionGroup
          } else {
            Write-Host "[INFO ] Get-PolicySchedules: '$($psIndex.JobType)' ($dtIndex): Within RunTime..."
          } # After JobRunTime
        } # ForEach ScheduleTime
      } else {
        Write-Host "[INFO ] Get-PolicySchedules: '$($psIndex.JobType)'= Unknown Type"
      } # If $($psIndex.JobType)
    } # ForEach $psIndex
  } # ForEach $pgIndex
} # If $pgAll

WaitForJobsToFinish

Disconnect-DPMServer
Write-Host "[INFO ] Waiting for $secSleepTime Second before closing."
sleep $secSleepTime
Write-Host "[INFO ] The end. (Runtime: $(new-timespan -Start $dtStart -End $(Get-Date))"

