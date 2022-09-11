param ([string] $Folder='')

<#
 # 30/06/2016, v0.01, PvK, Datacom
 #  Initial Version.
 # 01/07/2016, v0.02, PvK, Datacom
 #  Strip logic down
 # 04/07/2016, v0.03, PvK, Datacom
 #  Open Input file
 #  Switch to input folder
 #  Don't use extension on D
 # 05/07/2016, v0.06, PvK, Datacom
 #  Changed date to use: TODATETIMEOFFSET
 #  Changed SQL to use Session table
 #  Changed table to use nvarchar
 #  Added logging info to include current FileList Session
 #  Added code to mitigate empty LastModified dates
 #  Added code to mitigate empty LastAccessed and Creation dates
 # 06/07/2016, v0.12, PvK, Datacom
 #  Resolved Duplicate Name record
 # 09/07/2016, v0.13, PvK, Datacom
 #  Added logging for DirLevel above 2
 #  Scaled down logging for DirLevel above 2
 # 10/07/2016, v0.15, PvK, Datacom
 #  If LastModified/LastAccessed is Empty, subtitute with Creation
 #  .
 # 11/07/2016, v0.19, PvK, Datacom
 #  Remove space from WARN log on ModifiedDate, CreationDate, LastAccessed
 # 11/07/2016, v0.20, PvK, Datacom
 #  C:\Admin\Scripts\Load-CSV2SQL.ps1 -Folder C:\Users\PeterVan\Documents\Clients\TDHB\Fulford\Base\FileList-Conquest\
 # 12/07/2016, v0.21, PvK, Datacom
 #  Search string for 'File List of ' before convert to CSV.
 #  Added $IntStartAt.
 # 12/07/2016, v0.22, PvK, Datacom
 #  Removed DefinitionStart and just look for the three lines. (1=File List Of, 2=, 3=Name.)
 #  Create FileList with parameters: C:\Admin\Tools\FileList\FileList.exe /ISO /COLUMNS DIRLEVEL,ATTRIBUTES,VERSIONS Drive:\Folder\Subfolder
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
  $Database          = "TDHB-FULFORD-pacs "
  $Database          = "TDHB-FULFORD-NAS04 "
  $Database          = "TDHB-FULFORD-NAS03 "
  $Database          = "TDHB-FULFORD-NAS03C "
  $qrySessionInsertPre = "INSERT INTO Session (SessionID, SessionDatetime, SessionFilename) VALUES ( "
  $qrySessionInsertEnd = " )"
  $qryFileInsertPre  = "INSERT INTO FileList (Name, Size, LastModified, LastAccessed, CreatedDate, Attributes, Extension, Path, DirLevel, FileVersion, SessionID, ImportLine) VALUES ( "
  $qryFileInsertEnd  = " )"
# -- Process: CSV
  $strCSVHeader = "Name","Size","LastModified","LastAccessed","CreationDate","Attributes","Extension","Path","DirLevel","FileVersion"
# -- Process: Show
  $boolShowOnly  = 0  #0=FALSE,1=TRUE
  $boolShowDebug = 0  #0=FALSE,1=TRUE
  $intSplit   = 500000
  $intStartAt = 0

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
fRecord "INFO" "SQL details: SQLInstance=$ServerInstance, SQLDB=$Database."
fRecord "INFO" "User Set Variables: `$intSplit = '$intSplit'."
fRecord "INFO" "User Set Variables: `$strSMTPServer = '$strSMTPServer'."
fRecord "INFO" "User Set Variables: `$strEmailFrom = '$strEmailFrom'."
fRecord "INFO" "User Set Variables: `$strEmailTo = '$strEmailTo'."

#Check Parameter
If (!$Folder -or ($Folder -eq ''))
{
  $strFolderIn = Read-Host "Input folder"
  if (!$strFolderIn) {
    Write-Error "Input folder not specified."
    exit 
  }
} Else {
  $strFolderIn = $Folder
}


#Check Paramater is a file
fRecord "INFO" "Test for Input Folder: '$strFolderIn'."
if (Test-Path -Path $strFolderIn ) {
  fRecord "INFO" "Folder exists."
} else {
  fRecord "INFO" "Folder does not exist."
  exit 
}

#Check Parameter is a CSV file
#$read = New-Object System.IO.StreamReader($file)
#while (($line = $read.ReadLine()) -ne $null) {
#  $line
#}
#$read.Dispose()

$arrFileList = Get-ChildItem -Path $strFolderIn *.csv
$intFileID = 0
foreach ($strFileIn in $arrFileList) {
    $idSession = "$strDateTime-$intFileID"
    fRecord "INFO" "Processing file: $strFileIn ($idSession)"
    $objFileHandle = [System.IO.File]::OpenText($(Join-Path $strFolderIn $strFileIn))
    $boolFirst = 1 #0=FALSE,1=TRUE
    $intCount = 0
    $strExecQuery = "$qrySessionInsertPre '$idSession', '$strSQLDateTime', '$(Split-Path -Path $strFileIn -Leaf)' $qrySessionInsertEnd"
    Try {
        if ($boolShowOnly -eq 1) {
            fRecord "INFO" "SQL [Line: $intCount]: $strExecQuery"
        } else {
            $arrSQLData = Invoke-SQL -datasource $ServerInstance -database $Database -sqlcommand $strExecQuery
            if ($boolShowDebug -eq 1) { fRecord "INFO" "SQL [Line: $intCount]: Success." }
        } #boolShowOnly
    } Catch {
        fRecord "ERROR" "SQL Failure [Line: $intCount]: $strExecQuery"
        $error
        exit
    } #Try
    while ((($strLine = $objFileHandle.ReadLine()) -ne $null) -and ($global:boolSuccessResult)) {
        $intCount = $intCount + 1
        if ($boolShowDebug -eq 1) { fRecord "INFO" "Line[$intCount]: $strLine" }
        if ($intCount -lt $intStartAt) {
            if ($boolFirst) { fRecord "WARN" "Skipping the first '$intStartAt' records." }
        } elseif ($strLine -like '*File List of *') {
            fRecord "WARN" "Line[$intCount]: Start a new File List. ($strLine)"
        } elseif ($strLine -eq '') {
            fRecord "WARN" "Line[$intCount]: Empty Line. ($strLine)"
        } else { # File List Of
            $arrCSVLine = $strLine | ConvertFrom-Csv -Delimiter ";" -Header $strCSVHeader
            if (($arrCSVLine.Name -eq "Name") -or ($arrCSVLine.Name -eq "")) {
                fRecord "WARN" "Line[$intCount]: Name = '$($arrCSVLine.Name)' ($strLine)." 
            } else { #Name
                if ($arrCSVLine.CreationDate.Length -lt 24) {
                    $strCreation  = "null"
                    fRecord "WARN" "Line[$intCount]: CreationDate='$($arrCSVLine.CreationDate)'." 
                } else { 
                    $strCreation  = "TODATETIMEOFFSET ('$($arrCSVLine.CreationDate.Remove(23,6).Replace("T", " "))','$($arrCSVLine.CreationDate.Remove(0,23))')"
                } #CreationDate.Length
                if ($arrCSVLine.LastModified.Length -lt 24) {
                    $strModified  = $strCreation
                    fRecord "WARN" "Line[$intCount]: LastModified='$($arrCSVLine.LastModified)', Using CreationDate='$strCreation'." 
                } else { 
                    $strModified  = "TODATETIMEOFFSET ('$($arrCSVLine.LastModified.Remove(23,6).Replace("T", " "))','$($arrCSVLine.LastModified.Remove(0,23))')"
                } #LastModified.Length
                if ($arrCSVLine.LastAccessed.Length -lt 24) {
                    $strAccessed  = $strCreation
                    fRecord "WARN" "Line[$intCount]: LastAccessed='$($arrCSVLine.LastAccessed)', Using CreationDate='$strCreation'." 
                } else { 
                    $strAccessed  = "TODATETIMEOFFSET ('$($arrCSVLine.LastAccessed.Remove(23,6).Replace("T", " "))','$($arrCSVLine.LastAccessed.Remove(0,23))')"
                } #LastAccessed.Length
                $strExtention = $(IF ($arrCSVLine.Attributes -eq 'D') { "" } else { $arrCSVLine.Extension })
                IF ($arrCSVLine.DirLevel -eq '') {
                    $strDirLevel  = "null"
                    $strPath      = $arrCSVLine.Path 
                } elseif ($arrCSVLine.DirLevel -eq '0') {
                    $strDirLevel  = "'$($arrCSVLine.DirLevel)'"
                    $strPath      = $arrCSVLine.Path 
                } elseif ($arrCSVLine.DirLevel -eq '1') {
                    $strDirLevel  = "'$($arrCSVLine.DirLevel)'"
                    $strPath      = $(Split-Path -Path $arrCSVLine.Path -Leaf)
                } elseif (($arrCSVLine.DirLevel -eq '2') -or ($arrCSVLine.DirLevel -eq '3') -or ($arrCSVLine.DirLevel -eq '4')) {
                    $strDirLevel  = "'$($arrCSVLine.DirLevel)'"
                    $strPath      = $(Join-Path -Path $(Split-Path -Path $(Split-Path -Path $arrCSVLine.Path -Parent) -Leaf) -ChildPath $(Split-Path -Path $arrCSVLine.Path -Leaf))
                } else { #DirLevel
                    fRecord "WARN" "Line[$intCount]: DirLevel='$($arrCSVLine.DirLevel)', Path = '$($arrCSVLine.Path)'." 
                    $strDirLevel  = "'$($arrCSVLine.DirLevel)'"
                    $strPath      = $(Join-Path -Path $(Split-Path -Path $(Split-Path -Path $arrCSVLine.Path -Parent) -Leaf) -ChildPath $(Split-Path -Path $arrCSVLine.Path -Leaf))
                } #DirLevel
                $strExecQuery = "$qryFileInsertPre '$($arrCSVLine.Name)', '$($arrCSVLine.Size)', $strModified, $strAccessed, $strCreation, '$($arrCSVLine.Attributes)', '$strExtention', '$strPath', $strDirLevel, '$($arrCSVLine.FileVersion)', '$idSession', '$intCount' $qryFileInsertEnd"
                Try {
                    if ($boolShowOnly -eq 1) {
                        fRecord "INFO" "SQL [Line: $intCount]: $strExecQuery"
                    } else {
                        $arrSQLData = Invoke-SQL -datasource $ServerInstance -database $Database -sqlcommand $strExecQuery
                        if ($boolShowDebug -eq 1) { fRecord "INFO" "SQL [Line: $intCount]: Success." }
                    } #boolShowOnly
                } Catch {
                    fRecord "ERROR" "SQL Failure [Line: $intCount]: $strExecQuery"
                    $error
                    exit
                } #Try
            } #arrCSVLine.Name
        } # File List Of
        $boolFirst = 0 #0=FALSE,1=TRUE
        $intProgress = $intCount % $intSplit
        if ($intProgress -eq 0) { 
            fRecord "INFO" "Lines processed: $intCount..."
        } #intProgress
        #test if ($intCount -gt 5) { $global:boolSuccessResult = $False }
    } #While objFileHandle.ReadLine
    #test $global:boolSuccessResult = $True
    $objFileHandle.Close()
    fRecord "INFO" "Total lines processed: $intCount."
    $intFileID = $intFileID + 1
} #foreach strFileIn in arrFileList

fResult $global:boolSuccessResult
