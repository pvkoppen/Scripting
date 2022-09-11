#param ([string] $Param1='ValueIfNotSet')

<#
 # 14/08/2015, v1.13, PvK, TuiOra
 #  First verion.
 #>

# ------------------------------------------------------------------
# -- Load Required Modules
# ------------------------------------------------------------------

# ------------------------------------------------------------------
# -- User Set Variables
# ------------------------------------------------------------------
# -- Retention (in Days)
  $intStaleHours  = "2"

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
  $strSMTPServer     = "smtp.tuiora.co.nz"
  $strEmailFrom      = "$strHostname@tuiora.co.nz"
  $strEmailTo        = "it.services@tuiora.co.nz"
  $global:boolLogErrorsWithServicedesk = $True # $True or $False
  $strEmailToSD      = "servicedesk@tuiora.co.nz"
  $global:boolSuccessResult = $True # $True or $False
# -- Process: Dates
  $dtNow             = Get-Date
  $strDateTime       = "{0}{1:D2}{2:D2}-{3:D2}{4:D2}" -f $dtNow.year,$dtNow.month,$dtNow.day,$dtNow.hour,$dtNow.minute
  $dtStaleBefore     = $dtNow.AddHours(-$intStaleHours)

# ------------------------------------------------------------------
# -- Define FUNCTIONS
# ------------------------------------------------------------------

Function fMailer ([string]$EmailSubject) { 
  $smtp=new-object Net.Mail.SmtpClient($strSMTPServer)
  $msg  = new-object Net.Mail.MailMessage
  $msg.From = $strEmailFrom
  $msg.to.add($strEmailTo)
  if ($global:boolLogErrorsWithServicedesk -and (-not $global:boolSuccessResult)) { $msg.to.add($strEmailToSD) }
  $msg.subject = "$EmailSubject"
  $msg.body = $global:strMessage
  Try {
    $smtp.Send($msg)
  } catch {
    $smtp.Send($strEmailFrom, $strEmailTo, "$EmailSubject", $global:strMessage)
    if ($global:boolLogErrorsWithServicedesk -and (-not $global:boolSuccessResult)) { $smtp.Send($strEmailFrom, $strEmailToSD, "$EmailSubject", $global:strMessage)}
  }
}

Function fRecord ([string]$MessageLevel, [string]$Message) {
  if (!(Test-Path -Path $strLogPath )) {
    New-Item -ItemType directory -Path $strLogName
  }
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

function Check-StaleLogFile ([string]$strFilePath) {
  if (Test-Path -Path $strFilePath) {
    fRecord "INFO" "File exists: $strFilePath"
    $file = Get-Item -Path $strFilePath
    if ($file.LastWriteTime -lt $dtStaleBefore) {
      fRecord "ERROR" "File is stale: $strFilePath (LastModified: $($file.LastWriteTime))"
    } else {
      fRecord "INFO" "File is active: $strFilePath (LastModified: $($file.LastWriteTime))"
    }
  } else {
    fRecord "ERROR" "File is missing: $strFilePath"
  }
}

function Check-MTInboxErrorInLog ([string]$strMTInboxLog) {
  if (Test-Path -Path $strMTInboxLog) {
    $boolFileRename = $False
    fRecord "INFO" "File exists: $strMTInboxLog"

    fRecord "INFO" "Checking log file for error entries: 'Rejected'."
    $strToRecord = Get-Content $strMTInboxLog | where {$_ -like '*Rejected*'}
    if ($strToRecord) {
      fRecord "ERROR" "Log entries found: $($strToRecord.Count)"
      fRecord "ERROR" $strToRecord
      $boolFileRename = $True
    } else {
      fRecord "INFO" "Log entries found: None"
    }

    fRecord "INFO" "Checking log file for error entries: 'Err'."
    $strToRecord = Get-Content $strMTInboxLog | where {$_ -like '*Err*'} | where {$_ -notlike '*= 0*'} | where {$_ -notlike 'Adv Forms*'} | where {$_ -notlike '* ?RSD?'} | where {$_ -notlike '* ?LAB?'} | where {$_ -notlike '*Referral*'} | where {$_ -notlike 'Out Box for *) on *'}
    if ($strToRecord) {
      fRecord "ERROR" "Log entries found: $($strToRecord.Count)"
      fRecord "ERROR" $strToRecord
      $boolFileRename = $True
    } else {
      fRecord "INFO" "Log entries found: None"
    }

    fRecord "INFO" "Checking log file for error entries: 'Invalid'."
    $strToRecord = Get-Content $strMTInboxLog | where {$_ -like '*Invalid*'} | where {$_ -notlike '*--> PV1*'}
    if ($strToRecord) {
      fRecord "ERROR" "Log entries found: $($strToRecord.Count)"
      fRecord "ERROR" $strToRecord
      $boolFileRename = $True
    } else {
      fRecord "INFO" "Log entries found: None"
    }

    fRecord "INFO" "Checking log file for error entries: 'Un-'."
    $strToRecord = Get-Content $strMTInboxLog | where {$_ -like '*Un-*'} | where {$_ -notlike 'REF_DAT*'}
    if ($strToRecord) {
      fRecord "ERROR" "Log entries found: $($strToRecord.Count)"
      fRecord "ERROR" $strToRecord
      $boolFileRename = $True
    } else {
      fRecord "INFO" "Log entries found: None"
    }

    if ($boolFileRename) {
      fRecord "INFO" "Renaming log: $strMTInboxLog to: $([System.IO.Path]::GetFileNameWithoutExtension($strMTInboxLog))-$strDateTime.log"
      Rename-Item $strMTInboxLog "$([System.IO.Path]::GetFileNameWithoutExtension($strMTInboxLog))-$strDateTime.log"
    }

  } else {
    fRecord "ERROR" "File is missing: $strMTInboxLog"
  }
}

function Check-NIRMsgTransferErrorInLog ([string]$strNIRMsgTransferLog) {
  if (Test-Path -Path $strNIRMsgTransferLog) {
    $boolFileRename = $False
    fRecord "INFO" "File exists: $strNIRMsgTransferLog"

    fRecord "INFO" "Checking log file for error entries: 'missing'."
    $strToRecord = Get-Content $strNIRMsgTransferLog | where {$_ -like '*missing*'} | where {$_ -notlike '*continuing*'}
    if ($strToRecord) {
      fRecord "ERROR" "Log entries found: $($strToRecord.Count)"
      fRecord "ERROR" $strToRecord
      $boolFileRename = $True
    } else {
      fRecord "INFO" "Log entries found: None"
    }

    fRecord "INFO" "Checking log file for error entries: 'failed'."
    $strToRecord = Get-Content $strNIRMsgTransferLog | where {$_ -like '*failed*'}
    if ($strToRecord) {
      fRecord "ERROR" "Log entries found: $($strToRecord.Count)"
      fRecord "ERROR" $strToRecord
      $boolFileRename = $True
    } else {
      fRecord "INFO" "Log entries found: None"
    }

    if ($boolFileRename) {
      fRecord "INFO" "Renaming log: $strNIRMsgTransferLog to: $([System.IO.Path]::GetFileNameWithoutExtension($strNIRMsgTransferLog))-$strDateTime.log"
      Rename-Item $strNIRMsgTransferLog "$([System.IO.Path]::GetFileNameWithoutExtension($strNIRMsgTransferLog))-$strDateTime.log"
    }

  } else {
    fRecord "ERROR" "File is missing: $strNIRMsgTransferLog"
  }
}

function Check-HealthLinkErrorInLog ([string]$strHLError, [string]$strHLEvent) {
  if (Test-Path -Path $strHLError) {
    fRecord "INFO" "File exists: $strHLError"
    $file = Get-Item -Path $strHLError
    if ($file.LastWriteTime -gt $dtStaleBefore) {
      fRecord "ERROR" "File is active: $strHLError (LastModified: $($file.LastWriteTime))"
      $strToRecord = Get-Content $strHLError | select -first 10
      fRecord "ERROR" $strToRecord
    } else {
      fRecord "INFO" "File is stale: $strHLError (LastModified: $($file.LastWriteTime))"
    }
  } else {
    fRecord "ERROR" "File is missing: $strHLError"
  }
  if (Test-Path -Path $strHLEvent) {
    $boolFileRename = $False
    fRecord "INFO" "File exists: $strHLEvent"

    fRecord "INFO" "Checking log file for error entries: 'ERR'."
    $strToRecord = Get-Content $strHLEvent | where {$_ -like '*ERR*'} | where {$_ -notlike '*REFERRAL*'}
    if ($strToRecord) {
      fRecord "ERROR" "Log entries found: $($strToRecord.Count)"
      fRecord "ERROR" $strToRecord
      $boolFileRename = $True
    } else {
      fRecord "INFO" "Log entries found: None"
    }
    fRecord "INFO" "Checking log file for error entries: 'Unable'."
    $strToRecord = Get-Content $strHLEvent | where {$_ -like '*Unable*'}
    if ($strToRecord) {
      fRecord "ERROR" "Log entries found: $($strToRecord.Count)"
      fRecord "ERROR" $strToRecord
      $boolFileRename = $True
    } else {
      fRecord "INFO" "Log entries found: None"
    }
    fRecord "INFO" "Checking log file for error entries: 'negative'."
    $strToRecord = Get-Content $strHLEvent | where {$_ -like '*negative*'}
    if ($strToRecord) {
      fRecord "ERROR" "Log entries found: $($strToRecord.Count)"
      fRecord "ERROR" $strToRecord
      $boolFileRename = $True
    } else {
      fRecord "INFO" "Log entries found: None"
    }
    fRecord "INFO" "Checking log file for error entries: 'rejected'."
    $strToRecord = Get-Content $strHLEvent | where {$_ -like '*rejected*'}
    if ($strToRecord) {
      fRecord "ERROR" "Log entries found: $($strToRecord.Count)"
      fRecord "ERROR" $strToRecord
      $boolFileRename = $True
    } else {
      fRecord "INFO" "Log entries found: None"
    }

    if ($boolFileRename) {
      fRecord "INFO" "Renaming log: $strHLEvent to: $([System.IO.Path]::GetFileNameWithoutExtension($strHLEvent))-$strDateTime.txt"
      Rename-Item $strHLEvent "$([System.IO.Path]::GetFileNameWithoutExtension($strHLEvent))-$strDateTime.txt"
      New-Item $strHLEvent -type file
    }

  } else {
    fRecord "ERROR" "File is missing: $strHLEvent"
  }
}

# ------------------------------------------------------------------
# -- START
# ------------------------------------------------------------------

fRecord "INFO" "Process Started: '$strScriptName' at $strDateTime "
fRecord "INFO" "User Set Variables: `$dtStaleBefore = '$dtStaleBefore'."
fRecord "INFO" "User Set Variables: `$intStaleHours = '$intStaleHours'."
fRecord "INFO" "User Set Variables: `$strSMTPServer = '$strSMTPServer'."
fRecord "INFO" "User Set Variables: `$strEmailFrom = '$strEmailFrom'."
fRecord "INFO" "User Set Variables: `$strEmailTo = '$strEmailTo'."

#if ($strHostname -eq 'TOLMT01') { # TOSD
  Check-StaleLogFile "\\TOLMT01\MT32\Bin\Tools\MTInbox.LOG"
  Check-MTInboxErrorInLog "\\TOLMT01\MT32\Bin\Tools\MTInbox.LOG"
  Check-StaleLogFile "\\TOLMT01\MT32\Bin\AddIns\NIR\NIRMsgTransfer.log"
  #Check-NIRMsgTransferErrorInLog "\\TOLMT01\MT32\Bin\AddIns\NIR\NIRMsgTransfer.log"
  Check-StaleLogFile "\\TOLMT01\HLINK\LOG\event.txt"
  Check-HealthLinkErrorInLog "\\TOLMT01\HLINK\LOG\error.txt" "\\TOLMT01\HLINK\LOG\event.txt"

#} elseif ($strHostname -eq 'TOLMT02') { # TOFH
  Check-StaleLogFile "\\TOLMT02\MT32\Bin\Tools\MTInbox.LOG"
  Check-MTInboxErrorInLog "\\TOLMT02\MT32\Bin\Tools\MTInbox.LOG"
  Check-StaleLogFile "\\TOLMT02\MT32\Bin\AddIns\NIR\NIRMsgTransfer.log"
  #Check-NIRMsgTransferErrorInLog "\\TOLMT02\MT32\Bin\AddIns\NIR\NIRMsgTransfer.log"
  Check-StaleLogFile "\\TOLMT02\HLINK\LOG\event.txt"
  Check-HealthLinkErrorInLog "\\TOLMT02\HLINK\LOG\error.txt" "\\TOLMT02\HLINK\LOG\event.txt"

#} else {
#  fRecord "ERROR" "Server '$strHostname' is not a Medtech32 server."
#}

fResult $global:boolSuccessResult

