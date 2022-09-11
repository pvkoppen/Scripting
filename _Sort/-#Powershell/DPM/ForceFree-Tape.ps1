
param ([string] $DPMServerName, [string] $LibraryName, [string[]] $TapeLocationList)

if(("-?","-help") -contains $args[0])
{
    Write-Host "Usage: ForceFree-Tape.ps1 [[-DPMServerName] <Name of the DPM server>] [-LibraryName] <Name of the library> [-TapeLocationList] <Array of tape locations>"
    Write-Host "Example: Force-FreeTape.ps1 -LibraryName "My library" -TapeLocationList Slot-1, Slot-7"
    exit 0
}

if (!$DPMServerName)
{
    $DPMServerName = Read-Host "DPM server name: "

    if (!$DPMServerName)
    {
        Write-Error "Dpm server name not specified."
        exit 1
    }
}

if (!$LibraryName)
{
    $LibraryName = Read-Host "Library name: "

    if (!$LibraryName)
    {
        Write-Error "Library name not specified."
        exit 1
    }
}

if (!$TapeLocationList)
{
    $TapeLocationList = Read-Host "Tape location: "

    if (!$TapeLocationList)
    {
        Write-Error "Tape location not specified."
        exit 1
    }
}

if (!(Connect-DPMServer $DPMServerName))
{
    Write-Error "Failed to connect To DPM server $DPMServerName"
    exit 1
}

$library = Get-DPMLibrary $DPMServerName | where {$_.UserFriendlyName -eq $LibraryName}

if (!$library)
{
    Write-Error "Failed to find library with user friendly name $LibraryName"
    exit 1
}

foreach ($media in @(Get-Tape -DPMLibrary $library))
{
    if ($TapeLocationList -contains $media.Location)
    {
        if ($media -is [Microsoft.Internal.EnterpriseStorage.Dls.UI.ObjectModel.LibraryManagement.ArchiveMedia])   
        {
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


