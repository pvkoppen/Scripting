param ([string] $DPMServerName)

Write-Host "[INFO ] Set Variable values."
if (!$DPMServerName) { $DPMServerName = 'TOLBU01' }

$dtStart = Get-Date
Write-Host "[INFO ] DPMServer: '$DPMServerName', at: $dtStart"
$minMaxRuntime = 1
$secSleepTime  = 30
Write-Host "[INFO ] MaxRuntime: $minMaxRuntime minutes, SleepTime: $secSleepTime seconds."
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
  Write-Host "[INFO ] Usage: CheckConsistency-DPMAllProctectedDatasources.ps1 [[-DPMServerName] <Name of the DPM server>]"
  Write-Host "[INFO ] Example: CheckConsistency-DPMAllProctectedDatasources.ps1 -DPMServerName ""DPM01"" "
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

Write-Host "[INFO ] Check DataSources for being Inconsistent."
$pgAll = Get-ProtectionGroup -DPMServerName $DPMServerName
If ($pgAll) {
  foreach ($pgIndex in $pgAll) {
    Write-Host "[INFO ] Checking DataSources for ProtectionGroup: '$($pgIndex.FriendlyName)'."
    $dsAll = Get-Datasource -ProtectionGroup $pgIndex
    $dsSelected = $dsAll | ? {$_.Protected -and $_.Activity -eq "Idle"} 
#    $dsSelected | format-List ProtectionGroupName,MountPoints,Name,Protected,State,Activity,Alert
    if ($dsSelected) {
      foreach ($dsIndex in $dsSelected) {
        Write-Host "[INFO ] DatasourceConsistencyCheck started for: '$dsIndex'"
        $jobList += @{ Job= $dsIndex | Start-DatasourceConsistencyCheck }
      } # Foreach $dsIndex
    } else {
      Write-Host "[INFO ] No Inconsistent DataSource(s)."
    }
  } #ForEach $pgIndex
} else {
  Write-Host "[WARN ] No ProtectionGroup(s)."
}

WaitForJobsToFinish

Disconnect-DPMServer
Write-Host "[INFO ] Waiting for $secSleepTime Second before closing."
sleep $secSleepTime
Write-Host "[INFO ] The end. (Runtime: $(new-timespan -Start $dtStart -End $(Get-Date))"

