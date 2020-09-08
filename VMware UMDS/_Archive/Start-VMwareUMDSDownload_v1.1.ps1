<#
.SYNOPSIS
    Capture command output.
.DESCRIPTION
    The Start-VMwareUMDSDownload cmdlet starts the VMware-UMDS -D process.
.PARAMETER
    No Parameters
.INPUTS
    No Input
.OUTPUTS
    Creates a log file.
.NOTES
    Version:        1.1
    Author:         Peter van Koppen
    Change Date:    8 Sep 2020
    Purpose/Change: Wrap logging around the vmware-umds download process.
.EXAMPLE 1
    Start-VMwareUMDSDownload

    This command:
    1: Starts the VMware-UMDS -D process and captures the output in a log file.
#>

$KeepDays   = 21
$DaysAgo    = (Get-Date).AddDays(-$KeepDays)
$FileFilter = "*.log"
$ScriptPath = Split-Path -Path $script:MyInvocation.InvocationName -Parent
$ScriptShortName = [System.IO.Path]::GetFileNameWithoutExtension($script:MyInvocation.InvocationName)
Start-Transcript -Path "$(Join-Path -Path $ScriptPath -ChildPath $ScriptShortName)-$(Get-Date -Format "dd").log" -Append

#Config
<#
. 'D:\Services\VMware\Infrastructure\Update Manager\vmware-umds.exe' -S --disable-host
. 'D:\Services\VMware\Infrastructure\Update Manager\vmware-umds.exe' -S -e embeddedEsx-6.5.0
. 'D:\Services\VMware\Infrastructure\Update Manager\vmware-umds.exe' -S -e embeddedEsx-6.7.0
#. 'D:\Services\VMware\Infrastructure\Update Manager\vmware-umds.exe' -S -e embeddedEsx-7.0.0
#>

#Actions
. 'D:\Services\VMware\Infrastructure\Update Manager\vmware-umds.exe' -G
. 'D:\Services\VMware\Infrastructure\Update Manager\vmware-umds.exe' -D 2>&1

Write-Host "[INFO ] Remove Transcript Logs: [$FileFilter] older then: '$DaysAgo' from folder: '$ScriptPath'."
Get-ChildItem -Path $ScriptPath -Force -File -Filter $FileFilter | 
    Where-Object { !$_.PSIsContainer -and $_.LastWriteTime -lt $DaysAgo } | Remove-Item -Force -Verbose
Stop-Transcript

<#
PS C:\Windows\system32> . "D:\Services\VMware\Infrastructure\Update Manager\vmware-umds.exe"
Allowed Options:

Basic Commands:
  -h [ --help ]                       Show this message
  -D [ --download ]                   Download updates based on the current 
                                      configuration
  -E [ --export ]                     Export all updates that have been 
                                      downloaded.
  -R [ --re-download ]                Re-download existing updates that may be 
                                      corrupted and download new updates. Use 
                                      this command only if you suspect UMDS 
                                      patch store is corrupted.
  -S [ --set-config ]                 Setup UMDS configuration
  -G [ --get-config ]                 Print current UMDS configuration
  -v [ --version ]                    Print UMDS version
  -i [ --info-level ] arg             The level of information shown on the 
                                      console: <verbose|info>. Use this along 
                                      with download, export or re-download 
                                      operation only
  -L [ --list-host-platforms ]        List all suppported ESX platforms for 
                                      download

Optional argument for export:
  -x [ --export-store ] arg           Destination directory for export 
                                      operation (Overrides setting from 
                                      configuration)

Arguments for set-config:
  -u [ --add-url ] arg                Add a URL to the configuration for 
                                      downloading updates. Requires url-type
  -r [ --url-type ] arg               Type of URL: <HOST>, HOST for ESX 6.x 
                                      (HOST is the only supported type 
                                      currently). Use with add-url
  -l [ --remove-url ] arg             Remove URL from the configuration
  -P [ --patch-store ] arg            Configure location for storing updates 
                                      after download
  -o [ --default-export-store ] arg   Configure location for exporting updates
  -p [ --proxy ] arg                  Configure proxy server settings. Format 
                                      is host:port. Use --proxy "" to disable 
                                      proxy
  -Y [ --enable-host ]                Enable ESX host update downloads for all 
                                      platforms
  -N [ --disable-host ]               Disable ESX host update downloads for all
                                      platforms
  -e [ --enable-host-platform ] arg   Enable ESX host update downloads for 
                                      specified platforms. Specify multiple 
                                      platforms separated by whitespace
  -d [ --disable-host-platform ] arg  Disable ESX host update downloads for 
                                      specified platforms. Specify multiple 
                                      platforms separated by whitespace


  Examples:

	To add a new ESX host patch depot URL
		vmware-umds -S --add-url https://hostname/index.xml --url-type HOST

	To remove a URL
		vmware-umds -S --remove-url https://hostname/index.xml

	To list all supported platforms for downloading ESX host updates
		vmware-umds --list-host-platforms

	To enable downloading of ESX host updates
		vmware-umds -S --enable-host

	To enable downloading of only ESXi 6.0.0 host updates
		vmware-umds -S --enable-host
		vmware-umds -S -e embeddedEsx-6.0.0

	To disable downloading of only ESXi 6.0.0 host updates
		vmware-umds -S --disable-host
		vmware-umds -S -d embeddedEsx-6.0.0

	To download updates based on the current configuration
		vmware-umds -D

	To export all downloaded updates to F:\UMDS-store
		vmware-umds -S --default-export-store F:\UMDS-store
		vmware-umds -E
	OR
		vmware-umds -E --export-store F:\UMDS-store


PS C:\Windows\system32> 
#>