param ([string] $DPMServerName, [string] $LibraryName, [string[]] $TapeLocationList)

Write-Host "[INFO ] Set Variable values."
if (!$DPMServerName) { $DPMServerName = 'TOLBU01' }
if (!$LibraryName)   { $LibraryName   = "Hewlett Packard 1x8 G2 autoloader  (x64 based)" }

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
  Write-Host "[INFO ] Usage: Catalog-DPMTape.ps1 [[-DPMServerName] <Name of the DPM server>] [-LibraryName] <Name of the library> [-TapeLocationList] <Array of tape locations>"
  Write-Host "[INFO ] Example: Catalog-DPMTape.ps1 -LibraryName ""My library"" -TapeLocationList Slot-1, Slot-7"
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

if (!$LibraryName) {
  Write-Host "[INFO ] Select the library where the tape is located:"
  Get-DPMLibrary $DPMServerName | Where-Object -FilterScript {$_.IsOffline -eq 0} | Format-Table "UserFriendlyName"
  $LibraryName = Read-Host "ReadValue: LibraryName"
  if (!$LibraryName) {
    Write-Error "[ERROR] LibraryName not specified."
    exit 1
  }
} else {
  Write-Host "[INFO ] Using LibraryName: '$LibraryName'"
}

$library = Get-DPMLibrary $DPMServerName | where {$_.UserFriendlyName -eq $LibraryName}

if (!$library) {
  Write-Error "[ERROR] Failed to find library with user friendly LibraryName: '$LibraryName'"
  exit 1
}

if (!$TapeLocationList) {
  Write-Host "[INFO ] Select the tape location:"
  Write-Host "Location    Protection Group    Tape Label"
  foreach ($media in @(Get-Tape -DPMLibrary $library)) {
    if ($($media.Label)) {
      Write-Host "$($media.Location)      $($media.ProtectionGroupName)       $($media.Label)"
    } else {
      Write-Host "$($media.Location)      -- Free --          -- Free --"
    }
  }
  $TapeLocationList = Read-Host "ReadValue: TapeLocationList"
  if (!$TapeLocationList) {
    Write-Error "[ERROR] TapeLocationList not specified."
    sleep $secSleepTime
    exit 1
  } else {
    Write-Host "[INFO ] Using TapeLocationList: '$TapeLocationList'"
    $TapeLocationList
  }
} else {
  Write-Host "[INFO ] Using TapeLocationList: '$TapeLocationList'"
}

foreach ($media in @(Get-Tape -DPMLibrary $library)) {
  Write-Host "[INFO ] Check: '$($media.Location)' in TapeLocationList: '$TapeLocationList'."
  if ($TapeLocationList -contains $media.Location) {
    Write-Host "[INFO ] Location in list: '$($media.Location)'"
    if ($media -is [Microsoft.Internal.EnterpriseStorage.Dls.UI.ObjectModel.LibraryManagement.ArchiveMedia]) {
      Write-Host "[INFO ] Mark tape as not free: '$($media.Location)'."
      Set-Tape -NotFree -Tape $media
      Write-Host "[INFO ] Wait (seconds): $secSleepTime."
      sleep $secSleepTime
      Write-Host "[INFO ] Recatalog '$($media.Location)'."
      $jobList += @{ Job= Start-TapeRecatalog -Tape $media }
    } else {
      Write-Error "[ERROR] The tape in '$($media.Location)' is a cleaner tape."
    }
  } # Media in TapeLocationList
} # ForEach Media

WaitForJobsToFinish

Disconnect-DPMServer
Write-Host "[INFO ] Waiting for $secSleepTime Second before closing."
sleep $secSleepTime
Write-Host "[INFO ] The end. (Runtime: $(new-timespan -Start $dtStart -End $(Get-Date))"

