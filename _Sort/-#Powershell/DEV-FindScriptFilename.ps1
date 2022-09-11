param ([string] $Param1='')

<#
 # 30/06/2016, v0.01, PvK, Datacom
 #  Initial Version.
 #
 #>

<# Prerequisites:
  1. Set Powershell to Remote-signed with this command: set-executionpolicy remotesigned
#>
 
# ------------------------------------------------------------------
# -- Load Required Modules
# ------------------------------------------------------------------
#$arrModule = @(Get-Module ActiveDirectory)
#if ($arrModule.Count -eq 0) {Import-Module ActiveDirectory}
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
  if ($PSCommandPath -eq '') {
    $strScriptPath     = split-path -parent $global:MyInvocation.MyCommand.Definition
    $strScriptName     = [System.IO.Path]::GetFileNameWithoutExtension($global:MyInvocation.MyCommand.Definition)
  } else {
    $strScriptPath     = split-path -parent $PSCommandPath
    $strScriptName     = [System.IO.Path]::GetFileNameWithoutExtension($PSCommandPath)
  }
  $strLogPath        = join-path -path $(join-path -path $strScriptPath -ChildPath "..") -ChildPath "LogFiles"
  $strLogName        = join-path -path $strLogPath -ChildPath "$strScriptName.log"
# -- Process: Alert Email
  $global:strMessage = "";
  $strSMTPServer     = "smtp.datacom.co.nz"
  $strEmailFrom      = "$strHostname@datacom.co.nz"
  $strEmailTo        = "PeterVan@datacom.co.nz"
  $global:boolLogErrorsWithServicedesk = $False # $True or $False
  $strEmailToSD      = "PeterVan@datacom.co.nz"
  $global:boolSuccessResult = $True # $True or $False
# -- Process: Dates
  $dtNow             = Get-Date
  $strDateTime       = "{0}{1:D2}{2:D2}-{3:D2}{4:D2}" -f $dtNow.year,$dtNow.month,$dtNow.day,$dtNow.hour,$dtNow.minute
  $strSQLDateTime    = "{0}-{1:D2}-{2:D2}  {3:D2}:{4:D2}" -f $dtNow.year,$dtNow.month,$dtNow.day,$dtNow.hour,$dtNow.minute
# -- Process: SQL
  $ServerInstance    = "PETERVAN-LT001 "
  $Database          = "tdhb-fulford-pacs "
  $QueryInsertStart  = "INSERT INTO FileList (Name, Size, LastModified, LastAccessed, CreatedDate, Attributes, Extension, Path, DirLevel, FileVersion, ImportFilename, ImportDatetime, ImportLine) VALUES ( "
  $QueryInsertEnd    = " )"
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

fRecord "INFO" "Process Started: '$strScriptPath', '$strScriptName' at $strDateTime "
#fRecord "INFO" "User Set Variables: `$strSMTPServer = '$strSMTPServer'."
#fRecord "INFO" "User Set Variables: `$strEmailFrom = '$strEmailFrom'."
#fRecord "INFO" "User Set Variables: `$strEmailTo = '$strEmailTo'."

$PSScriptRoot
$PSCommandPath
