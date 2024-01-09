
<# 
 # 23/07/2015, v1.12, PvK, TuiOra
 #  Updated logging and result email.
 # 03/08/2015, v1.13, PvK, TuiOra
 #  Changed fResultMail to fResult.
 #>

#Import SharePoint 2013 Powershell
Add-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue

# ------------------------------------------------------------------
# User Set Variables
# ------------------------------------------------------------------
# -- FolderPath
$strTargetPath     = "\\TOLMM02\Backup$\Data\"
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
$strLogName        = join-path -path $(join-path -path $(join-path -path $strScriptPath -ChildPath "..") -ChildPath "LogFiles") -ChildPath "$strScriptName.log"
# -- Process: Alert Email
$global:strMessage = "";
$strSMTPServer     = "smtp.tol.local"
$strEmailFrom      = "$strHostname@tuiora.co.nz"
$strEmailTo        = "it.services@tuiora.co.nz"
$global:boolSuccessResult = $True;
# -- Process: Dates
$dateNow           = Get-Date
$strDateTime       = "{0}{1:D2}{2:D2}-{3:D2}{4:D2}" -f $dateNow.year,$dateNow.month,$dateNow.day,$dateNow.hour,$dateNow.minute
$dateRetainFrom    = $dateNow.AddDays(-$intRetentionDays)
# -- Process: Folders
$strBackupType     = "SharePoint"
$strBackupName     = "TuiNet"
$strTargetPath     = Join-Path -Path $strTargetPath -ChildPath "$strBackupType"

$strSPFarmMySite = "MySites - 80"
$strSPSiteMain   = "http://tuinet.tuiora.co.nz"
$strSPSiteApps   = "http://tuinet.tuiora.co.nz/sites/apps"
$strSPSiteSearch = "http://tuinet.tuiora.co.nz/search"
  
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
  $RecordMessage = "[$MessageLevel] $($(new-timespan -Start $dateNow -End $(Get-Date)).TotalMinutes.ToString("#0.00")) $Message"
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
fRecord "INFO" "User Set Variables: `$strTargetPath = '$strTargetPath'."
fRecord "INFO" "User Set Variables: `$intRetentionDays  = '$intRetentionDays'."
fRecord "INFO" "User Set Variables: `$dateRetainFrom    = '$dateRetainFrom'."
fRecord "INFO" "User Set Variables: `$strSMTPServer = '$strSMTPServer'."
fRecord "INFO" "User Set Variables: `$strEmailFrom = '$strEmailFrom'."
fRecord "INFO" "User Set Variables: `$strEmailTo = '$strEmailTo'."
fRecord "INFO" "Set Run Instance Target Folder."

  $strBackupTargetPath   = Join-Path -Path $strTargetPath   -ChildPath $strBackupName
  fRecord "INFO" "User Set Variables: `$strBackupTargetPath = '$strBackupTargetPath'."
  $strFullTargetPath = Join-Path -Path $strBackupTargetPath -ChildPath "$strDateTime-$strHostname"
  fRecord "INFO" "User Set Variables: `$strFullTargetPath = '$strFullTargetPath'."
  $strSPFarmTargetPath = Join-Path -Path $strFullTargetPath -ChildPath "Farm-Full"
  fRecord "INFO" "User Set Variables: `$strSPFarmTargetPath = '$strSPFarmTargetPath'."
  $strMySitesTargetPath = Join-Path -Path $strFullTargetPath -ChildPath "WebApp-MySites"
  fRecord "INFO" "User Set Variables: `$strMySitesTargetPath = '$strMySitesTargetPath'."
  $strSitesTargetPath = Join-Path -Path $strFullTargetPath -ChildPath "Sites"
  fRecord "INFO" "User Set Variables: `$strSitesTargetPath = '$strSitesTargetPath'."

  if (!(Test-Path -Path $strBackupTargetPath )) {
    fRecord "INFO" "Backup-Target-Folder does not exist: Create."
    Try {
      $objTargetFolder = New-Item -Path $strBackupTargetPath -ItemType directory -ErrorAction Stop 
      fRecord "INFO" "Backup-Target-Folder created."
    } Catch {
      fRecord "ERROR" "Backup-Target-Folder creation failed: $($_.exception.message) "
      fResult $FALSE
      Return
    }
  } else {
    fRecord "INFO" "Backup-Target-Folder exists."
  }

  if (!(Test-Path -Path $strFullTargetPath )) {
    fRecord "INFO" "Backup-Instance-Target-Folder does not exist: Create."
    Try {
      $objTargetFolder = New-Item -Path $strFullTargetPath -ItemType directory -ErrorAction Stop 
      $objTargetFolder = New-Item -Path $strSPFarmTargetPath -ItemType directory -ErrorAction Stop 
      $objTargetFolder = New-Item -Path $strMySitesTargetPath -ItemType directory -ErrorAction Stop 
      $objTargetFolder = New-Item -Path $strSitesTargetPath -ItemType directory -ErrorAction Stop 
      fRecord "INFO" "Backup-Instance-Target-Folder created."
    } Catch {
      fRecord "ERROR" "Backup-Instance-Target-Folder creation failed: $($_.exception.message) "
      fResult $FALSE
      Return
    }
  } else {
    fRecord "INFO" "Backup-Instance-Target-Folder exists."
  }
  
  fRecord "INFO" "Clean up Backup-Target-Folder with Retention period: '$intRetentionDays' days. (v2)"
  if (Test-Path -Path $strBackupTargetPath ) {
    fRecord "INFO" "Backup-Target-Folder Exist: Perform Clean up."
    $arrFolders = Get-ChildItem $strBackupTargetPath -Directory | Where {$_.LastWriteTime -le "$dateRetainFrom"} 
    fRecord "INFO" "Number of folders to process: $($arrFolders.Count)."
    foreach ($Folder in $arrFolders) {
      fRecord "INFO" "Processing folder: '$Folder'."
      If ($Folder.LastWriteTime -lt ($(Get-Date).AddDays(-14))) { 
	Remove-Item $Folder.FullName -Recurse
        fRecord "INFO" "Folder deleted."
      } else {
        fRecord "WARN" "Folder ignored. (Minimum retention 14 days!)"
      }
    }
  } else {
    fRecord "ERROR" "Backup-Target-Folder does not Exist: Exit!"
    fResult $FALSE
    Return
  }

  fRecord "INFO" "Exporting Sharepoint." 	
  Try {
    Backup-SPFarm -Directory $strSPFarmTargetPath -BackupMethod Full -Verbose
    fRecord "INFO" "SPFarm export successfully."
  } Catch {
    fRecord "ERROR" "SPFarm export failed: $($_.Exception.Message) "
    $global:boolSuccessResult = $FALSE
  }

  Try {
    Backup-SPFarm -Directory $strMySitesTargetPath -BackupMethod Full -Item "MySites - 80" -Verbose
    fRecord "INFO" "SPFarm export successfully."
  } Catch {
    fRecord "ERROR" "SPFarm export failed: $($_.Exception.Message) "
    $global:boolSuccessResult = $FALSE
  }

  Try {
    $strSitesTargetFile = Join-Path -Path $strSitesTargetPath -ChildPath "search.bak"
    Backup-SPSite "http://tuinet.tuiora.co.nz/search" -Path $strSitesTargetFile -Force -UseSQLSnapshot -Verbose
    fRecord "INFO" "SPSite export successfully."
  } Catch {
    fRecord "ERROR" "SPSite export failed: $($_.Exception.Message) "
    $global:boolSuccessResult = $FALSE
  }

  Try {
    $strSitesTargetFile = Join-Path -Path $strSitesTargetPath -ChildPath "TuiNet.bak"
    Backup-SPSite "http://tuinet.tuiora.co.nz"  -Path $strSitesTargetFile -Force -UseSQLSnapshot -Verbose
    fRecord "INFO" "SPSite export successfully."
  } Catch {
    fRecord "ERROR" "SPSite export failed: $($_.Exception.Message) "
    $global:boolSuccessResult = $FALSE
  }

  Try {
    $strSitesTargetFile = Join-Path -Path $strSitesTargetPath -ChildPath "Apps.bak"
    Backup-SPSite "http://tuinet.tuiora.co.nz/sites/apps" -Path $strSitesTargetFile -Force -UseSQLSnapshot -Verbose
    fRecord "INFO" "SPSite export successfully."
  } Catch {
    fRecord "ERROR" "SPSite export failed: $($_.Exception.Message) "
    $global:boolSuccessResult = $FALSE
  }

fResult $global:boolSuccessResult

