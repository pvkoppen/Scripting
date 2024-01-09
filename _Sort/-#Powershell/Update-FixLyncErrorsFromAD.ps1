#param ([string] $Param1='ValueIfNotSet')

<#
 # 23/07/2015, v1.12, PvK, TuiOra
 #  Updated logging and result email.
 # 03/08/2015, v1.13, PvK, TuiOra
 #  Changed fResultMail to fResult.
 # 07/08/2015, 1.13b, PvK, TuiOra
 #  Updated Query to look at all Lync AD Ojects
 #  Changed Get-ADUser to Get-ADObject to include Groups and Contacts
 #>

<# Prerequisites:
#>
 
# ------------------------------------------------------------------
# -- Load Required Modules
# ------------------------------------------------------------------
$arrModule = @(Get-Module ActiveDirectory)
if ($arrModule.Count -eq 0) {Import-Module ActiveDirectory}
# add-pssnapin SqlServerCmdletSnapin
# invoke-sqlcmd -query “sp_databases” -database master -serverinstance TOLDB01\PeopleInc | format-table

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
# -- Process: SQL
  $ServerInstance = "TOLIM01\RTC "
  $Database = "rtcab"
  $Query = "select aue.UserId, aue.UserGuid, adm.AdDn
    from AbUserEntry aue join AbDnMapping adm on aue.UserId = adm.UserId "
# -- Process: Show
  $boolShowOnly  = 0  #0=FALSE,1=TRUE
  $boolShowDebug = 0  #0=FALSE,1=TRUE

# ------------------------------------------------------------------
# -- Define FUNCTIONS
# ------------------------------------------------------------------

function Invoke-SQL {
    param(
        [string] $DataSource = ".\SQLEXPRESS",
        [string] $Database = "MasterData",
        [string] $sqlCommand = $(throw "Please specify a query.")
      )

    $connectionString = "Data Source=$DataSource; " +
      "Integrated Security=SSPI; " +
      "Initial Catalog=$Database"

    $Connection = new-object system.data.SqlClient.SQLConnection($ConnectionString)
    $Command    = new-object system.data.sqlclient.sqlcommand($sqlCommand,$Connection)
    $connection.Open()

    $Adapter = New-Object System.Data.sqlclient.sqlDataAdapter $Command
    $DataSet = New-Object System.Data.DataSet
    $Adapter.Fill($dataSet) | Out-Null

    [Array]$Results = $DataSet.Tables[0]
    $Results
}

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

fRecord "INFO" "Start SQL Query"
$arrSQLData = Invoke-SQL -datasource $ServerInstance -database $Database -sqlcommand $Query
$boolFirst = 1 #0=FALSE,1=TRUE

foreach ($SQLPerson in $arrSQLData) {
  If ($boolFirst -and $boolShowDebug) {
    fRecord "INFO" "Show full SQL info on the first Lync Employee."
    $SQLPerson | foreach-object { fRecord "INFO" "`$SQLPerson = $($_)" }
  }

  $LyncGUID = $SQLPerson.UserGuid
  $ADObject   = @(GET-ADObject $LyncGUID)
  If ($boolFirst -and $boolShowDebug) {
    fRecord "INFO" "Show full AD info on the first AD Employee."
    fRecord "INFO" '$($ADObject | get-member)'
  }

  # If the GUID is not assigned to anyone then report it.
  if ($ADObject.count -eq 0) { 
    fRecord "WARN" "No AD Objects found with GUID: $LyncGUID ($($SQLPerson.AdDn))"

  # If the GUID is assigned to more then one Person:
  } elseif ($ADObject.count -ne 1) { 
    fRecord "ERROR" "Found two AD Objects with GUID: $LyncGUID ($($SQLPerson.AdDn))"

  # Otherwise the GUID is assigned to exactly one person:
  } else { 
    
    #Update Lync: DN from GUID
    $LyncDN = ''+$SQLPerson.AdDn
    $ADDN   = ''+$ADObject[0].DistinguishedName
    fRecord "INFO" "Compare LyncDN '$LyncDN' to ADDN '$ADDN'."
    if ($ADDN -ne $LyncDN) {
    #if ($ADDN.compareto($LyncDN) {
      fRecord "INFO" "DN's Differ: Update LyncDN."
      if (-not $boolShowOnly) {
        # Perform SQL to update record.
        #$strUpdateQuery = "select * from AbDnMapping where UserId in (select UserId from AbUserEntry aue where aue.UserGuid = '$LyncGUID') "
        $strUpdateQuery = "update AbDnMapping set AdDn = '$ADDN' where UserId in (select UserId from AbUserEntry aue where aue.UserGuid = '$LyncGUID') "
        $arrSQLUpdateData = Invoke-SQL -datasource $ServerInstance -database $Database -sqlcommand $strUpdateQuery
        fRecord "INFO" "SQL: $strUpdateQuery"
      }
    }

  }
  $boolFirst = 0 #0=FALSE,1=TRUE
}

fResult $global:boolSuccessResult

