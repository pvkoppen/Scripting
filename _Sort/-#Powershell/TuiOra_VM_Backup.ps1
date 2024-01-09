param ([string] $OnlyHyperVGuest='')

<# 
 # 21/08/2014 Version 0.3 Hadyn Thomas (Spark Digital)
 #  Tui Ora Hyper-V Export to backup script 
 #  Script exports virtual machines from the Hyper-V cluster to a local path and then moves them
 #  to the Synology NAS. This two step approuch is used as the PowerShell Export-VM function in 
 #  PowerShell runs as a local computer account which errors when trying to directly save to the 
 #  Synlogy NAS.
 #  The exported virtual machine is compressed. The amount of threads used during compression is
 #  configurable but ensure that not all resources are used by the system. Compression results in
 #  a three quater savings in storage used.
 #>
 
<#
 # 10/10/2014 v1.3 Peter van Koppen (Tui Ora)
 #  Updated the script to work in a more general way. User variables set at the front. Include 
 #  a reporting function.
 # 10/10/2014 v1.4 Peter van Koppen (Tui Ora)
 #  Some Small Tweaks on reporting.
 # 10/10/2014 v1.5 Peter van Koppen (Tui Ora)
 #  If Temp folder exists do not remove and create.
 # 10/10/2014 v1.6 Peter van Koppen (Tui Ora)
 #  Tidied up Reporting.
 # 17/10/2014 v1.7 Peter van Koppen (Tui Ora)
 #  Moved Backup to TOLMM02.
 # 07/11/2014 v1.8 Peter van Koppen (Tui Ora)
 #  Reduced Retention to 20 days, Added parameter to backup one server only, Added Loggin of Errorlevels on DOS Commands.
 # 10/11/2014 v1.9 Peter van Koppen (Tui Ora)
 #  Change Save Path: <Root>\HyperVBackup\<Hyper-V Guest Name>\<Hyper-V Guest Name>_Date_Time_<Hyper-V Server Name>.
 #  Activated Delete File
 #  Change Routine: 
 #  1. Create Temp folders; 
 #  2. Get VM's (If parameter is set limit to one VM);
 #  3. Per VM do: 3a. Create Target folder, 3b. Cleanup Target folder, 3c. Export VM, 3d. Compress VM, 3e. Move VM;
 #  4. Cleanup Temp Folders.
 #  5. Email results
 # 12/11/2014, v1.10, Peter van Koppen, Tui Ora
 #  Clear Message log after email.
 # 20/11/2014, v1.11, Peter van Koppen, Tui Ora
 #  When the 7-zip failed the file copy using Robocopy created a wrong folder name.
 # 23/07/2015, v1.12, PvK, TuiOra
 #  Updated logging and result email.
 # 03/08/2015, v1.13, PvK, TuiOra
 #  Changed fResultMail to fResult.
 #>

# ------------------------------------------------------------------
# -- Load Required Modules
# ------------------------------------------------------------------
#Required -version 3.0
#Required -module Hyper-V
#Optional -program 7-Zip

# ------------------------------------------------------------------
# -- User Set Variables
# ------------------------------------------------------------------
# -- FolderPath
  $strTempPath       = "C:\Temp\"
  $strTargetPath     = "\\TOLMM02\Backup$\"
# -- Retention (in Days)
  $intRetentionDays  = "20"

# ------------------------------------------------------------------
# -- Global Variables
# ------------------------------------------------------------------
# -- Process: Hostname
  $strHostname       = $env:COMPUTERNAME
  $strFQDN           = [System.Net.Dns]::GetHostByName($strHostname).hostname
  $strScriptPath     = split-path -parent $global:MyInvocation.MyCommand.Definition
  $strScriptName     = [System.IO.Path]::GetFileNameWithoutExtension($global:MyInvocation.MyCommand.Definition)
  $strLogPath        = join-path -path $(join-path -path $strScriptPath -ChildPath "..") -ChildPath "LogFiles"
  $strLogName        = join-path -path $strLogPath -ChildPath "$strScriptName.log"
# -- Process: Alert Email
  $global:strMessage = "";
  $strSMTPServer     = "smtp.tol.local"
  $strEmailFrom      = "$strHostname@tuiora.co.nz"
  $strEmailTo        = "it.services@tuiora.co.nz"
  $global:boolSuccessResult = $True;
# -- Process: Dates
  $dtNow             = Get-Date
  $strDateTime       = "{0}{1:D2}{2:D2}-{3:D2}{4:D2}" -f $dtNow.year,$dtNow.month,$dtNow.day,$dtNow.hour,$dtNow.minute
  $dtRetainFrom      = $dtNow.AddDays(-$intRetentionDays)
# -- Process: Folders
  $strBackupType     = "HyperVBackup"
  $strTempPath       = Join-Path -Path $strTempPath   -ChildPath "$strBackupType"
  $strTargetPath     = Join-Path -Path $strTargetPath -ChildPath "$strBackupType"
  $strFullTempPath   = Join-Path -Path $strTempPath   -ChildPath "$strDateTime"


# ------------------------------------------------------------------
# -- Define FUNCTIONS
# ------------------------------------------------------------------

Function fMailer ([string]$EmailSubject) { 
  $smtp=new-object Net.Mail.SmtpClient($strSMTPServer)
  $msg  = new-object Net.Mail.MailMessage
  $msg.From = $strEmailFrom
  $msg.to.add($strEmailTo)
  $msg.subject = "$EmailSubject"
  $msg.body = $global:strMessage
  Try {
    $smtp.Send($msg)
  } catch {
    $smtp.Send($strEmailFrom, $strEmailTo, "$EmailSubject", $global:strMessage)
  }
}

Function fRecord ([string]$MessageLevel, [string]$Message) {
  If ($MessageLevel -eq "SILENT") { 
    $RecordMessage = "$Message"
  } Else {
    $RecordMessage = "[$MessageLevel] $($(new-timespan -Start $dtNow -End $(Get-Date)).TotalMinutes.ToString("#0.00")) $Message"
  }
  if ([string]::IsNullOrEmpty($global:strMessage)) {
    $global:strMessage = $RecordMessage
    Add-Content $strLogName ""
  } else {
    $global:strMessage = $global:strMessage+"`r`n"+$RecordMessage
  }
  If ($MessageLevel -eq "INFO") { Write-Host $RecordMessage -ForegroundColor Green }
  ElseIf ($MessageLevel -eq "WARN") { Write-Host $RecordMessage -ForegroundColor Yellow }
  ElseIf ($MessageLevel -eq "ERROR") { 
    Write-Host $RecordMessage -ForegroundColor Red 
    $global:boolSuccessResult = $FALSE
  } Else { Write-Host $RecordMessage }
  Add-Content $strLogName $RecordMessage
}

Function fResult ($Success) {
  # -- Set Subject name
  if ($Success) {
    $strMailSubject = "$strScriptName - Completed Successfully."
    fRecord "INFO" "-- $strMailSubject"
  } else {
    $strMailSubject = "$strScriptName - Completed with Errors."
    fRecord "ERROR" "-- $strMailSubject"
  }
  # -- Send Email
  fMailer $strMailSubject
  $global:strMessage = ""
}


# ------------------------------------------------------------------
# -- START
# ------------------------------------------------------------------

fRecord "INFO" "Process Started: '$strScriptName' at $strDateTime "
fRecord "INFO" "User Set Variables: `$strTempPath = '$strTempPath'."
fRecord "INFO" "User Set Variables: `$strTargetPath = '$strTargetPath'."
fRecord "INFO" "User Set Variables: `$intRetentionDays  = '$intRetentionDays'."
fRecord "INFO" "User Set Variables: `$strSMTPServer = '$strSMTPServer'."
fRecord "INFO" "User Set Variables: `$strEmailFrom = '$strEmailFrom'."
fRecord "INFO" "User Set Variables: `$strEmailTo = '$strEmailTo'."

if ($OnlyHyperVGuest -ne '') {
  fRecord "INFO" "Parameter Set Variables: `$OnlyHyperVGuest = '$OnlyHyperVGuest'."
}

fRecord "INFO" "Prep Local Temp-Folder: '$strTempPath'."
if (!(Test-Path -Path $strTempPath )) {
  fRecord "INFO" "Temp-Folder does not exist: Create."
  New-Item -ItemType directory -Path $strTempPath
} else {
  fRecord "INFO" "Temp-Folder exists."
}

fRecord "INFO" "Prep Timed Temp-Folder: '$strFullTempPath'."
Try {
  $objTempFolder = New-Item -Path $strFullTempPath -ItemType directory -ErrorAction Stop 
  fRecord "INFO" "Timed Temp-Folder created."
} Catch {
  fRecord "ERROR" "Timed Temp-Folder creation failed: $($_.exception.message) "
  fResult $FALSE
  Return
}

fRecord "INFO" "Get VirtualMachines."
$ArrVirtualMachines = Get-VM 
if ($OnlyHyperVGuest -ne '') {
  $ArrVirtualMachines = Get-VM | where {$_.Name -eq $OnlyHyperVGuest}
}

foreach ($VirtualMachine in $ArrVirtualMachines) {

  fRecord "INFO" "-- Processing Virtual Machine: '$($VirtualMachine.Name)' (Runtime: $($(new-timespan -Start $dtNow -End $(Get-Date)).TotalMinutes.ToString("#0.00")) Min)."
  $strVMTempPath     = Join-Path -Path $strFullTempPath -ChildPath $VirtualMachine.Name
  $strVMTargetPath   = Join-Path -Path $strTargetPath   -ChildPath $VirtualMachine.Name
  $strVMTemp7zip     = "$strVMTempPath-$strDateTime-$strHostname.7z"
  $strFullTargetPath = Join-Path -Path $strVMTargetPath -ChildPath "$strDateTime-$strHostname"

  if (!(Test-Path -Path $strVMTargetPath )) {
    fRecord "INFO" "VM-Target-Folder does not exist: Create."
    Try {
      $objTargetFolder = New-Item -Path $strVMTargetPath -ItemType directory -ErrorAction Stop 
      fRecord "INFO" "VM-Target-Folder created."
    }
    Catch {
      fRecord "ERROR" "VM-Target-Folder creation failed: $($_.exception.message) "
      fResult $FALSE
      Return
    }
  } else {
    fRecord "INFO" "VM-Target-Folder exists."
  }

  fRecord "INFO" "Clean up VM-Target-Folder with Retention period: '$intRetentionDays' days."
  If (Test-Path -Path $strVMTargetPath ) {
    fRecord "INFO" "VM-Target-Folder Exist: Perform Clean up."
    $arrFiles = get-childitem $strVMTargetPath -include *.* -recurse | Where {$_.LastWriteTime -le "$dtRetainFrom"} 
    fRecord "INFO" "Number of files to process: $($arrFiles.Count)."
    foreach ($File in $arrFiles) {
      fRecord "INFO" "Processing file: '$File'."
      If ($File.LastWriteTime -lt ($(Get-Date).AddDays(-14))) { 
        Remove-Item $File
        fRecord "INFO" "File deleted."
      } else {
        fRecord "WARN" "File ignored. (Minimum retention 14 days!)"
      }
    }
  } else {
    fRecord "ERROR" "VM-Target-Folder does not Exist: Exit!"
    fResult $FALSE
    Return
  }

  fRecord "INFO" "Exporting VirtualMachine." 		 
  Try {
    Export-VM -name $VirtualMachine.Name -path $strFullTempPath 
    fRecord "INFO" "VirtualMachine export successfully."
  } Catch {
    fRecord "ERROR" "VirtualMachine export failed: $($_.Exception.Message) "
  }

  fRecord "INFO" "Compress the exported VirtualMachine using 7-Zip."
  Try{
    # 7Zip here is using LZMA2 which is a modified version of LZMA providing better 
    # multi-threading support and less expansion of incompressible data
    & 'C:\Program Files\7-Zip\7z.exe' a -m0=lzma2 -mmt=8 "$strVMTemp7zip" $strVMTempPath
	$cmdResult = $LASTEXITCODE
	if ($cmdResult -eq 0) {
	  fRecord "INFO" "Compression completed. ($cmdResult)"
	} else {
	  fRecord "WARN" "Compression Failed (Nothing to compress?) ($cmdResult)"
	}
  } Catch {
    fRecord "WARN" "Compression failed: $($_.Exception.Message) ($cmdResult)"
  }

  fRecord "INFO" "Move Virtual Machine from Temp folder to Target Folder."
  Try{
    if (Test-Path -Path "$strVMTemp7zip" ) {
      Robocopy "$strFullTempPath" "$strVMTargetPath" "*.7z" /MOVE /r:1 /w:1
	  $cmdResult = $LASTEXITCODE
      fRecord "INFO" "Compressed VirtualMachine move successful. ($cmdResult)"
    } else {
      fRecord "INFO" "VirtualMachine Compressed File unavailable - Create Full-Target-Folder and move Full VirtualMachine. ($LASTEXITCODE)"
	  Try {
        $objTargetFolder = New-Item -Path $strFullTargetPath -ItemType directory -ErrorAction Stop 
        fRecord "INFO" "Full-Target-Folder created."
      }
      Catch {
        fRecord "ERROR" "Full-Target-Folder creation failed: $($_.exception.message) "
        fResult $FALSE
        Return
      }
	  Robocopy "$strFullTempPath" "$strFullTargetPath" "*.*" /E /MOVE /r:1 /w:1
	  $cmdResult = $LASTEXITCODE
      fRecord "INFO" "VirtualMachine move successful. ($cmdResult)"
    }
  } Catch {
    fRecord "ERROR" "VitualMachine move failed: $($VirtualMachine.Name) backup to the NAS. $($_.Exception.Message) ($LASTEXITCODE)"
  }

  fRecord "INFO" "Clean up Temp-Folder Location: '$strFullTempPath'."
  Try{
    Get-ChildItem $strFullTempPath | Remove-Item -Force -Recurse
    fRecord "INFO" "Temp-Folder clean up successful. "
  } Catch {
    fRecord "WARN" "Temp-Folder clean up failed: $($_.Exception.Message) "
  } 
}
 fRecord "INFO" "Virtual Machine(s) Processing Completed. (Runtime: $($(new-timespan -Start $dtNow -End $(Get-Date)).TotalMinutes.ToString("#0.00")) Min)."

fRecord "INFO" "Clean up Temp Folder Location: '$strTempPath'."
Try{
  Get-ChildItem $strTempPath | Remove-Item -Force -Recurse
  fRecord "INFO" "Temp-Folder Clean up successful. "
} Catch {
  fRecord "WARN" "Temp-Folder clean up failed: $($_.Exception.Message) "
} 

fResult $global:boolSuccessResult

