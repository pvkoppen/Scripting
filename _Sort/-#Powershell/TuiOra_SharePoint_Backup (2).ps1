#Import SharePoint 2013 Powershell
Add-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue

# User Set Variables
# -- FolderPath
$boolError = $FALSE

$strTargetPath     = "\\TOLMM02\Backup$\"
# -- Retention (in Days)
$intRetentionDays  = "20"
# -- Email
$strSMTPServer     = "smtp.tol.local"
$strEmailFrom      = "$($env:COMPUTERNAME)@tuiora.co.nz"
$strEmailTo        = "it.services@tuiora.co.nz" 

# Global Variables
# -- Process: Alert
$strMessage        = "";
# -- Process: Dates
$dateNow           = Get-Date
$dateRetainFrom    = $dateNow.AddDays(-$intRetentionDays)
# -- Process: Folders
$strBackupType     = "SharePoint"
$strBackupName     = "TuiNet"
$strHostname       = $env:COMPUTERNAME
$strFQDN           = [System.Net.Dns]::GetHostByName($strHostname).hostname
$strDateTime       = "{0}{1:D2}{2:D2}-{3:D2}{4:D2}" -f $dateNow.year,$dateNow.month,$dateNow.day,$dateNow.hour,$dateNow.minute

$strTargetPath     = Join-Path -Path $strTargetPath -ChildPath "$strBackupType"

Function fMailer ([string]$EmailSubject) { 
  $smtp=new-object Net.Mail.SmtpClient($strSMTPServer) 
  $smtp.Send($strEmailFrom, $strEmailTo, $EmailSubject, $global:strMessage)
}

Function fRecord ($RecordMessage) {
  if ([string]::IsNullOrEmpty($global:strMessage)) {
    $global:strMessage = "$RecordMessage"
  } else {
    $global:strMessage = "$global:strMessage`r`n$RecordMessage"
  }
  Write-Host $RecordMessage
}

Function fResultMail ($Success) {
  # -- Set Subject name
  if ($Success) {
    $strMailSubject = "Backup completed Successfully."
    Write-Host "-- $strMailSubject --`r`n$global:strMessage" -ForegroundColor Green
  } else {
    $strMailSubject = "Backup completed with Errors."
    Write-Host "-- $strMailSubject --`r`n$global:strMessage" -ForegroundColor Red
  }
  # -- Send Email
  fMailer $strMailSubject
  $global:strMessage = ""
}


fRecord "[INFO ] Process Started: $strDateTime "
fRecord "[INFO ] User Set Variables: `$strTargetPath = '$strTargetPath'."
fRecord "[INFO ] User Set Variables: `$intRetentionDays  = '$intRetentionDays'."
fRecord "[INFO ] User Set Variables: `$strSMTPServer = '$strSMTPServer'."
fRecord "[INFO ] User Set Variables: `$strEmailFrom = '$strEmailFrom'."
fRecord "[INFO ] User Set Variables: `$strEmailTo = '$strEmailTo'."


 fRecord "[INFO ] Set Run Instance Target Folder (Runtime: $($(new-timespan -Start $dateNow -End $(Get-Date)).TotalMinutes.ToString("#0.00")) Min)."
 
  $strBackupTargetPath   = Join-Path -Path $strTargetPath   -ChildPath $strBackupName
  $strFullTargetPath = Join-Path -Path $strBackupTargetPath -ChildPath "$strDateTime-$strHostname"
  $strSPFarmTargetPath = Join-Path -Path $strFullTargetPath -ChildPath "Farm-Full"
  $strMySitesTargetPath = Join-Path -Path $strFullTargetPath -ChildPath "WebApp-MySites"
  $strSitesTargetPath = Join-Path -Path $strFullTargetPath -ChildPath "Sites"

  if (!(Test-Path -Path $strBackupTargetPath )) {
    fRecord "[INFO ] Backup-Target-Folder does not exist: Create."
    Try {
      $objTargetFolder = New-Item -Path $strBackupTargetPath -ItemType directory -ErrorAction Stop 
      fRecord "[INFO ] Backup-Target-Folder created."
    }
    Catch {
      fRecord "[ERROR] Backup-Target-Folder creation failed: $($_.exception.message) "
      fResultMail $FALSE
      Return
    }
  } else {
    fRecord "[INFO ] Backup-Target-Folder exists."
  }

  if (!(Test-Path -Path $strFullTargetPath )) {
    fRecord "[INFO ] Backup-Instance-Target-Folder does not exist: Create."
    Try {
      $objTargetFolder = New-Item -Path $strFullTargetPath -ItemType directory -ErrorAction Stop 
      $objTargetFolder = New-Item -Path $strSPFarmTargetPath -ItemType directory -ErrorAction Stop 
      $objTargetFolder = New-Item -Path $strMySitesTargetPath -ItemType directory -ErrorAction Stop 
      $objTargetFolder = New-Item -Path $strSitesTargetPath -ItemType directory -ErrorAction Stop 
      fRecord "[INFO ] Backup-Instance-Target-Folder created."
    }
    Catch {
      fRecord "[ERROR] Backup-Instance-Target-Folder creation failed: $($_.exception.message) "
      fResultMail $FALSE
      Return
    }
  } else {
    fRecord "[INFO ] Backup-Instance-Target-Folder exists."
  }

  
   fRecord "[INFO ] Clean up Backup-Target-Folder with Retention period: '$intRetentionDays' days."
  if (Test-Path -Path $strBackupTargetPath ) {
    fRecord "[INFO ] Backup-Target-Folder Exist: Perform Clean up."
    $arrFiles = get-childitem $strBackupTargetPath -include *.* -recurse | Where {$_.LastWriteTime -le "$dateRetainFrom"} 
    fRecord "[INFO ] Number of files to process: $($arrFiles.Count)."
    foreach ($File in $arrFiles) {
      fRecord "[INFO ] Processing file: '$File'."
      If ($File.LastWriteTime -lt ($(Get-Date).AddDays(-14))) { 
        fRecord "[INFO ] File deleted."
        Remove-Item $File
      } else {
        fRecord "[WARN ] File ignored. (Minimum retention 14 days!)"
      }
    }
  } else {
    fRecord "[ERROR] Backup-Target-Folder does not Exist: Exit!"
    fResultMail $FALSE
    Return
  }

  fRecord "[INFO ] Exporting Sharepoint." 	

  Try {
    Backup-SPFarm -Directory $strSPFarmTargetPath -BackupMethod Full -Verbose
    fRecord "[INFO ] SPFarm export successfully."
  } Catch {
    fRecord "[ERROR] SPFarm export failed: $($_.Exception.Message) "
    $boolError = $TRUE
  }

  Try {
    Backup-SPFarm -Directory $strMySitesTargetPath -BackupMethod Full -Item "MySites - 80" -Verbose
    fRecord "[INFO ] SPFarm export successfully."
  } Catch {
    fRecord "[ERROR] SPFarm export failed: $($_.Exception.Message) "
    $boolError = $TRUE
  }

  Try {
    $strSitesTargetFile = Join-Path -Path $strSitesTargetPath -ChildPath "search.bak"
    Backup-SPSite "http://tuinet.tuiora.co.nz/search" -Path $strSitesTargetFile -Force -UseSQLSnapshot -Verbose
    fRecord "[INFO ] SPSite export successfully."
  } Catch {
    fRecord "[ERROR] SPSite export failed: $($_.Exception.Message) "
    $boolError = $TRUE
  }

  Try {
    $strSitesTargetFile = Join-Path -Path $strSitesTargetPath -ChildPath "TuiNet.bak"
    Backup-SPSite "http://tuinet.tuiora.co.nz"  -Path $strSitesTargetFile -Force -UseSQLSnapshot -Verbose
    fRecord "[INFO ] SPSite export successfully."
  } Catch {
    fRecord "[ERROR] SPSite export failed: $($_.Exception.Message) "
    $boolError = $TRUE
  }

  Try {
    $strSitesTargetFile = Join-Path -Path $strSitesTargetPath -ChildPath "Apps.bak"
    Backup-SPSite "http://tuinet.tuiora.co.nz/sites/apps" -Path $strSitesTargetFile -Force -UseSQLSnapshot -Verbose
    fRecord "[INFO ] SPSite export successfully."
  } Catch {
    fRecord "[ERROR] SPSite export failed: $($_.Exception.Message) "
    $boolError = $TRUE
  }

IF ($boolError) {
  fResultMail $FALSE
  Return
}

fResultMail $TRUE
