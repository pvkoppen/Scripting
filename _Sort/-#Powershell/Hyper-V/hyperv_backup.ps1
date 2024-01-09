﻿#requires -version 3.0
#requires -module Hyper-V

<#
This script will export virtual machines from the Hyper-V cluster to a target destination. In this case we are storing the backups
on the Synology NAS. 
By default the script will create folder(s) using the format:

VMNAME_DAY_MONTH_YEAR

The script will delete the oldest folder once it reaches the retain limit that has been set.

Because the export process can be time consuming, you can use the -AsJob parameter which will be passed to Export-VM. You will then get 
PowerShell background jobs which you can manage with the standard job cmdlets.

This script must be run as an administrator in an elevated session.

.PARAMETER VM
A comma separated list of virtual machines. You can also pipe Get-VM into this command. This parameter has an alias of Name.
.PARAMETER Path
The path to the top level backup or export folder.
.PARAMETER Monthly
Run the script in Monthly mode
.PARAMETER AsJob
Export virtual machines using background jobs
.EXAMPLE
PS C:\> get-vm toldc01,toldc02 | c:\scripts\ScheduledExport.ps1 -path e:\export

Get the virtual machines, TOLDC01 and TOLDC02 and pipe them to the script which will
export them to the given folder.

.EXAMPLE
PS C:\> c:\scripts\ScheduledExport.ps1 "TOLDC01","TOLFP01" -path E:\Export -asjob

Export virtual machines CHI-DC01 and CHI-FP01 to a weekly folder under E:\Export.

.EXAMPLE
PS C:\> get-content c:\work\vms.txt | c:\scripts\ScheduledExport.ps1 -asjob -monthly

Read the text file, vms.txt, and pass each virtual machine name to the script. This will
use the Monthly backup folders. Exports will be done as jobs.

  ****************************************************************
  * DO NOT USE THIS SCRIPT UNLESS YOU HAVE FULLY TESTED IT IN AN *
  * ENVIRONMENT WHERE NOTHING WILL BREAK 
  ****************************************************************
#>

[cmdletbinding(SupportsShouldProcess=$True)]

Param(
[Parameter(Position=0,Mandatory=$True,
HelpMessage="Enter the virtual machine name or names",
ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
[ValidateNotNullorEmpty()]
[Alias("name")]
[string[]]$VM,

[Parameter(Position=1)]
[ValidateNotNullorEmpty()]
[string]$Path = "C:\work\export",

[Parameter(Position=2)]
[switch]$Monthly,

[Parameter(Position=3)]
[switch]$AsJob
)

Begin {

#define some variables if we are doing weekly or monthly backups, change values as needed
if ($monthly) {
  $type = "Monthly"
  $retain = 2
}
else {
   $type = "Weekly"
   $retain = 2
}

Write-Verbose "Processing $type backups. Retaining last $retain."

#get backup directory list
Try {
 Write-Verbose "Checking $path for subfolders"
 
 #get only directories under the path that start with Weekly or Monthly
 $subFolders =  dir -Path $path\$type* -Directory -ErrorAction Stop
}
Catch {
    Write-Warning "Failed to enumerate folders from $path"
    #bail out of the script
    return
}

#check if any backup folders
if ($subFolders) {
    #if found, get count
    Write-Verbose "Found $($subfolders.count) folder(s)"
    
    #if more than the value of $retain, delete oldest one
    if ($subFolders.count -ge $retain ) {
       #get oldest folder based on its CreationTime property
       $oldest = $subFolders | sort CreationTime | Select -first 1 
       Write-Verbose "Deleting oldest folder $($oldest.fullname)"
       #delete it
       $oldest | Remove-Item -Recurse -Force
    }
      
 } #if $subfolders
else {
    #if none found, create first one
    Write-Verbose "No matching folders found. Creating the first folder"    
}

#create the folder
#get the current date
$now = Get-Date

#name format is Type_Year_Month_Day_HourMinute
$childPath = "{0}_{1}_{2:D2}_{3:D2}_{4:D2}{5:D2}" -f $type,$now.year,$now.month,$now.day,$now.hour,$now.minute

#create a variable that represents the new folder path
$new = Join-Path -Path $path -ChildPath $childPath

Try {
    Write-Verbose "Creating $new"
    #Create the new backup folder
    $BackupFolder = New-Item -Path $new -ItemType directory -ErrorAction Stop 
}
Catch {
  Write-Warning "Failed to create folder $new. $($_.exception.message)"
  #failed to create folder so bail out of the script
  Return
}
} #end begin

Process {

#only process if a backup folder was created
if ($BackupFolder) {
    #export VMs
    #define a hashtable of parameters to splat to Export-VM
    $exportParam = @{
     Path = $new
     Name=$Null
     ErrorAction="Stop"
    }
    if ($asjob) {
      Write-Verbose "Exporting as background job"
      $exportParam.Add("AsJob",$True)
    }

    Write-Verbose "Exporting virtual machines"
    <#
     Go through each virtual machine name, and export it using Export-VM
    #>
    foreach ($name in $VM) {
        $exportParam.Name=$name
        #if the user did not include -WhatIf then the machine will be exported
        #otherwise they will get a WhatIf message
        if ($PSCmdlet.shouldProcess($name)) {
           Try {
                Export-VM @exportParam
           }
           Catch {
            Write-Warning "Failed to export virtual machine(s). $($_.Exception.Message)"
           }
        } #whatif
    } #close foreach
} #if backup folder exists 
} #Process
End {
    Write-Host "Export script finished." -ForegroundColor Green
}
<#
Sample Code to create PowerShell scheduled job

$trigger = New-JobTrigger -Weekly -DaysOfWeek Friday -At 12:00
$options = New-ScheduledJobOption -RunElevated
$VMs = "test vm*","demo rig"

#specify script parameter values in order
Register-ScheduledJob -Name "Weekly VM Export" -FilePath c:\scripts\jpb.ps1 -Trigger $trigger -ScheduledJobOption $options -ArgumentList $VMs,"c:\work\export",$False,$False

$trigger = New-JobTrigger -Weekly -DaysOfWeek Friday -WeeksInterval 4 -At 12:00AM
#reuse options and vms
Register-ScheduledJob -Name "Monthly VM Export" -FilePath c:\scripts\BackupVMScripts.ps1 -Trigger $trigger -ScheduledJobOption $options -ArgumentList $VMs,"c:\work\export",$True,$False

#>
