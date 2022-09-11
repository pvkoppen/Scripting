#param ([string] $Param1='ValueIfNotSet')

<#
 # 2015/11/04 v1.0 Peter van Koppen (Tui Ora)
 #  Created initial Backup checking script. 
 # 2015/12/15 v1.3 Peter van Koppen (Tui Ora)
 #  Added logging and email. 
 #>

# ------------------------------------------------------------------
# -- Load Required Modules
# ------------------------------------------------------------------

# ------------------------------------------------------------------
# -- User Set Variables
# ------------------------------------------------------------------

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
  $dtRetainFrom      = $dtNow.AddDays(-$intRetentionDays)
# -- Process: Folders
  $strTempFile       = Join-Path -Path $strLogPath -ChildPath "$strScriptName.tmp"

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

# ------------------------------------------------------------------
# -- START
# ------------------------------------------------------------------

fRecord "INFO" "Process Started: '$strScriptName' at $strDateTime "
fRecord "INFO" "User Set Variables: `$strSMTPServer = '$strSMTPServer'."
fRecord "INFO" "User Set Variables: `$strEmailFrom = '$strEmailFrom'."
fRecord "INFO" "User Set Variables: `$strEmailTo = '$strEmailTo'."

$Computers = @("HIQ90373","TOLDB02","TOLDB03","TOLSD02","TOLVS05","TOLVS06","TOLVS07","TOLVS08","TOLVS09","TOLVS10","TOLVS11","TOLVS12","TOLWU03")
# DPM: ,"TOLDB04","TOLDB05","TOLIM01","TOLSP02","TOLSP03","TOLSP04","TOLSP05","TOLZC01"
# Hyper-V: ,"TOLAM01","TOLDC02","TOLGW02","TOLMM03","TOLRD01"
# NON: ,"TOLBU01"

fRecord "INFO" "Computers to process: $Computers"

foreach ($Computer in $Computers) {
  fRecord "INFO" "Check Computer: $Computer"
  $Result = Invoke-Command -ComputerName $Computer -ScriptBlock {wbadmin get versions} | Out-String
  fRecord "INFO" "----------------------------------------------------------------------"
  fRecord "SILENT" "$Result"
  fRecord "INFO" "----------------------------------------------------------------------"
}

fResult $global:boolSuccessResult

