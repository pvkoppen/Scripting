param ([string] $DPMServerName, [string] $LibraryName, [string[]] $TapeLocationList)

#TOL Presets
if (!$DPMServerName) { $DPMServerName = 'TOLSS02' }
if (!$LibraryName)   { $LibraryName   = "Hewlett Packard 1x8 autoloader  (x86 based XP/2003)" }

# Make sure the DPM snap-in is loaded.

if (!(Get-PSSnapin microsoft.dataprotectionmanager.powershell)){
  write-host "Adding PS Snapin for DPM." -Fore Green
  add-PSSnapin Microsoft.DataProtectionManager.PowerShell
}else{
  write-host "PS Snapin for DPM already loaded." -Fore Green
}

if(("-?","-help") -contains $args[0])
{
    Write-Host "Usage: ForceFree-Tape.ps1 [[-DPMServerName] <Name of the DPM server>] [-LibraryName] <Name of the library> [-TapeLocationList] <Array of tape locations>"
    Write-Host "Example: Force-FreeTape.ps1 -LibraryName "My library" -TapeLocationList Slot-1, Slot-7"
    exit 0
}

if (!$DPMServerName)
{
    $DPMServerName = Read-Host "DPM server name"

    if (!$DPMServerName)
    {
        Write-Error "DPM server name not specified."
        exit 1
    }
}

if (!(Connect-DPMServer $DPMServerName))
{
    Write-Error "Failed to connect To DPM server $DPMServerName"
    exit 1
}

if (!$LibraryName)
{
    Write-Host "Select the library where the tape is located:"
    Get-DPMLibrary $DPMServerName | Where-Object -FilterScript {$_.IsOffline -eq 0} | Format-Table "UserFriendlyName"
    $LibraryName = Read-Host "Library name"

    if (!$LibraryName)
    {
        Write-Error "Library name not specified."
        exit 1
    }
}

$library = Get-DPMLibrary $DPMServerName | where {$_.UserFriendlyName -eq $LibraryName}

if (!$library)
{
    Write-Error "Failed to find library with user friendly name $LibraryName"
    exit 1
}

if (!$TapeLocationList)
{
    Write-Host "Select the tape location:"
    Write-Host "[Tape Location]    ([Tape Label])"
    foreach ($media in @(Get-Tape -DPMLibrary $library))
    {
        Write-Host "[$($media.Location)]    (Label:$($media.Label))"
    }
    $TapeLocationList = Read-Host "Tape location"

    if (!$TapeLocationList)
    {
        Write-Error "Tape location not specified."
        exit 1
    }
}


foreach ($media in @(Get-Tape -DPMLibrary $library))
{
    if ($TapeLocationList -contains $media.Location)
    {
        if ($media -is [Microsoft.Internal.EnterpriseStorage.Dls.UI.ObjectModel.LibraryManagement.ArchiveMedia])   
        {
            Write-Host "Removing recovery point(s) for tape in $($media.Location)."
            foreach ($rp in @(Get-RecoveryPoint -Tape $media))
            {
                Get-RecoveryPoint -Datasource $rp.Datasource | Out-Null

                Write-Verbose "Removing recovery point created at $($rp.RepresentedPointInTime) for tape in $($media.Location)."
                Remove-RecoveryPoint -RecoveryPoint $rp -ForceDeletion -Confirm:$false
            }

            Write-Verbose "Setting tape in $($media.Location) as free."
            Set-Tape -Tape $media -Free
        }
        else
        {
            Write-Error "The tape in $($media.Location) is a cleaner tape."
        }
    }
}
