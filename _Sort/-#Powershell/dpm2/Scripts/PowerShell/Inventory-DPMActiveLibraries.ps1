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
  IF (!$DPMServerName)  { $DPMServerName = "TOLSS02" }
  $dtStart = Get-Date
  Write-Host "  # DPMServer: $DPMServerName, at: $dtStart" -foregroundcolor $colorInfo
#  Set-Variable -Name ConfirmPreference -value "High"
#  $minJobRunTime = 80
#  $minMargin     = 5
  $secSleepTime  = 20
#  Write-Host "  # JobRunTime: $minJobRunTime minutes, MarginForError: $minMargin minutes, SleepTime: $secSleepTime secondes." -foregroundcolor $colorInfo
  Write-Host "  # SleepTime: $secSleepTime secondes." -foregroundcolor $colorInfo
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


#Write-Host "# List all Libraries..." -foregroundcolor $colorHeader
#  $DPMLibraries = Get-DPMLibrary -DPMServerName $DPMServerName
#  $DPMLibraries | ft UserFriendlyName,Type
#  $DPMAutoLoaderLibrary = $DPMLibraries | Where-Object -FilterScript {$_.Type -eq "TapeLibrary"} 
#  $DPMLibrariesActive   = $DPMLibraries | Where-Object -FilterScript {$_.IsOffline -eq 0} 


Write-Host "# List all Active Libraries." -foregroundcolor $colorHeader
  $DPMLibrariesActive = Get-DPMLibrary -DPMServerName $DPMServerName | Where-Object -FilterScript {$_.IsOffline -eq 0}
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

