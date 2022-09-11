#param ([string] $Param1='ValueIfNotSet')

<#
 # 2015/06/29 Version 0.1 Peter van Koppen
 #  Script to clean up Windows Temp folder. 
 # 23/07/2015, 0.02, PvK, TuiOra
 #  Updated logging and result email.
 #>

<# Prerequisites:
#>
 
# ------------------------------------------------------------------
# -- Load Required Modules
# ------------------------------------------------------------------

# ------------------------------------------------------------------
# -- User Set Variables
# ------------------------------------------------------------------
# -- Retention (in Days)
  $intRetentionDays  = "180"

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

function CleanUpFolder ([string] $Path) {
  $intProcessed = 0
  $intRemoved   = 0
  If (Test-Path -Path $Path) {
    $Files = Get-ChildItem $Path -File -Recurse | where {($_.LastAccessTime -lt ($dtRetainFrom)) -and ($_.LastAccessTime -lt ($(Get-Date).AddDays(-35))) }
    foreach ($File in $Files) {
      Remove-Item $File -ErrorAction SilentlyContinue
      if ($?) { 
        fRecord "INFO" "Removed file: $File ($($File.LastAccessTime))"
        $intRemoved++
      } else { 
        fRecord "ERROR" "File removal failed for: $File ($($File.LastAccessTime))"
      }
      $intProcessed++
    }
  } else {
    fRecord "ERROR" "Path does not exist: $Path"
  }
  fRecord "INFO" "Removed $intRemoved out of $intProcessed files."
}

# ------------------------------------------------------------------
# -- START
# ------------------------------------------------------------------

fRecord "INFO" "Process Started: '$strScriptName' at $strDateTime "
fRecord "INFO" "User Set Variables: `$strSMTPServer = '$strSMTPServer'."
fRecord "INFO" "User Set Variables: `$strEmailFrom = '$strEmailFrom'."
fRecord "INFO" "User Set Variables: `$strEmailTo = '$strEmailTo'."

CleanupFolder('C:\Windows\Temp')

fResult $global:boolSuccessResult

