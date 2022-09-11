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
#  Set-Variable -Name ConfirmPreference -value "High"
#  $minJobRunTime = 80
#  $minMargin     = 5
  $secSleepTime  = 30
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
# ---- Here It Starts --------------------------------------


# Check for DataSources that are Inconsistent:
  Write-Host "# Check DataSources for being Inconsistent" -foregroundcolor $colorHeader
  $pgAll = Get-ProtectionGroup -DPMServerName $DPMServerName
  foreach ($pgIndex in $pgAll) {
    $dsAll = Get-Datasource -ProtectionGroup $pgIndex
    $dsSelected = $dsAll | ? {$_.Protected} 
    $dsSelected | format-List ProtectionGroupName,MountPoints,Name,Protected,State,Activity,Alert
    if ($dsSelected) {
        $dsSelected | Start-DatasourceConsistencyCheck
      }
    }
#    foreach ($dsIndex in $dsInvalid) {
#      Start-DatasourceConsistencyCheck -DataSource $dsIndex -HeavyWeight
#    }
