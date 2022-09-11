
<# 
 # 14/08/2015, v1.13, PvK, TuiOra
 #  First verion.
 #>

# ------------------------------------------------------------------
# User Set Variables
# ------------------------------------------------------------------

# ------------------------------------------------------------------
# -- Global Variables
# ------------------------------------------------------------------
# -- Process: Hostname
  $strHostname       = $env:COMPUTERNAME
  $strFQDN           = [System.Net.Dns]::GetHostByName($strHostname).hostname
  $strScriptPath     = split-path -parent $global:MyInvocation.MyCommand.Definition
  $strScriptName     = [System.IO.Path]::GetFileNameWithoutExtension($global:MyInvocation.MyCommand.Definition)
  $strLogName        = join-path -path $(join-path -path $(join-path -path $strScriptPath -ChildPath "..") -ChildPath "LogFiles") -ChildPath "$strScriptName.log"
# -- Process: Alert Email
  $global:strMessage = "";
  $strSMTPServer     = "smtp.tol.local"
  $strEmailFrom      = "$strHostname@tuiora.co.nz"
  $strEmailTo        = "it.services@tuiora.co.nz"
  $global:boolLogErrorsWithServicedesk = $True # $True or $False
  $strEmailToSD      = "servicedesk@tuiora.co.nz"
  $global:boolSuccessResult = $True # $True or $False
# -- Process: Dates
  $dtNow             = Get-Date
  $strDateTime       = "{0}{1:D2}{2:D2}-{3:D2}{4:D2}" -f $dtNow.year,$dtNow.month,$dtNow.day,$dtNow.hour,$dtNow.minute

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
  $RecordMessage = "[$MessageLevel] $($(new-timespan -Start $dtNow -End $(Get-Date)).TotalMinutes.ToString("#0.00")) $Message"
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


#get-adcomputer -filter * -properties IPv4Address,IPv6Address,OperatingSystem,OperatingSystemVersion |where-object {$_.Enabled -and ($_.OperatingSystemVersion -notlike '5*') -and ($_.OperatingSystemVersion -notlike '6*')} | Ft name,operatingsystem

#TOLMS01
$CMDComputers = get-adcomputer -filter * -properties IPv4Address,IPv6Address,OperatingSystem,OperatingSystemVersion |where-object {$_.Enabled -and ($_.OperatingSystemVersion -like '5*') -and ($_.OperatingSystem -like '*server*')} | Sort-Object OperatingSystem,Name
foreach ($PC in $CMDComputers) {
  fRecord "INFO" "`$pc.name = '$($pc.name)'."
  $NICs = Get-WMIObject Win32_NetworkAdapterConfiguration -computername $pc.name | where {$_.IPEnabled }
  $NICS | Format-List DHCPEnabled,IPAddress,DefaultIPGateway,Description,Index,DNSServerSearchOrder
  #Enter-PSSession $pc.name
  #$env:COMPUTERNAME
  #Exit-PSSession
}

#TOLTS03, TOLMM02(?), TOLMT01, TOLWU02
$PSComputers = get-adcomputer -filter * -properties IPv4Address,IPv6Address,OperatingSystem,OperatingSystemVersion |where-object {$_.Enabled -and ($_.OperatingSystemVersion -like '6*') -and ($_.OperatingSystem -like '*server*')} | Sort-Object OperatingSystem,Name
foreach ($PC in $PSComputers) {
  fRecord "INFO" "`$pc.name = '$($pc.name)'."
  $NICs = Get-WMIObject Win32_NetworkAdapterConfiguration -computername $pc.name | where {$_.IPEnabled }
  $NICS | Format-List DHCPEnabled,IPAddress,DefaultIPGateway,Description,Index,DNSServerSearchOrder
  #Enter-PSSession $pc.name
  #$env:COMPUTERNAME
  #Exit-PSSession
}

fResult $global:boolSuccessResult
