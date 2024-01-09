#param ([string] $Param1='ValueIfNotSet')

<#
 # 23/07/2015, v1.12, PvK, TuiOra
 #  Updated logging and result email.
 # 03/08/2015, v1.13, PvK, TuiOra
 #  Changed fResultMail to fResult.
 #
 #>

<# Prerequisites:
  1. ActiveDirectory Powershell tools (Part of the RSAT tools)
  2. Set Powershell to Remote-signed with this command: set-executionpolicy remotesigned
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
  $ServerInstance = "TOLDB01\PeopleInc "
  $Database = "redpi002_2 "
  $Query = "select a.employeeid, a.status,
      a.knownas, a.surname, a.fullname, 
      a.currentcompany, a.currentdepartment, a.currentjobtitle, a.currentlocation, 
      a.worktelephone, a.workmobile, a.workddi, 
      b.reportsto, b.costcode, b.companyid, 
      officephone = case when not e.departmentalphone is null then e.departmentalphone when not d.locationphone is NULL then d.locationphone else c.telephone end,
      officefax = case when not e.departmentalfax is null then e.departmentalfax when not d.locationfax is NULL then d.locationfax else c.fax end,
      c.website, e.departmentalphone, d.locationphone, c.telephone as companyphone
    from employees a left outer join jobhistory b on a.employeeid = b.employeeid and b.currentrecord = 1
      left outer join companies c on b.companyid = c.companyid 
      left outer join locations d on b.companyid = d.companyid and b.location = d.location
      left outer join departments e on b.companyid = e.companyid and b.department = e.department
    where b.companyid = 1
      and a.status = 'Active'
      and a.currentdepartment not like '99%'
    order by 4,3"
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

foreach ($person in $arrSQLData) {
  If ($boolFirst -and $boolShowDebug) {
    fRecord "INFO" "Show full SQL info on the first PeopleInc Employee."
    #fRecord "INFO" "$($Person | get-member)"
  }

  $PersonEmployeeID = $person.employeeid
  $ADUser = @(get-aduser -filter {employeeid -eq $PersonEmployeeID} -searchbase "ou=tol,dc=tol,dc=local" -properties employeeid,employeenumber,givenname,surname,name,displayname,company,department,title,PhysicalDeliveryofficeName,IPPhone,mobile,homephone,telephonenumber,facsimileTelephoneNumber,wwwhomepage,manager,mail,msRTCSIP-Line,msRTCSIP-LineServer,msRTCSIP-PrimaryUserAddress)
  If ($boolFirst -and $boolShowDebug) {
    fRecord "INFO" "Show full AD info on the first PeopleInc Employee."
    $ADUser | get-member 
  }

  # If the EmployeeID is not assigned to anyone yet then find a person to assign it to.
  if ($ADUser.count -eq 0) { 

    $Personknownas = $person.knownas
    $Personsurname = $person.surname
    $ADUserGN = @(get-aduser -filter {(employeeid -notlike '*') -and (surname -eq $Personsurname) -and (givenname -eq $Personknownas)} -searchbase "ou=tol,dc=tol,dc=local" -properties employeeid,employeenumber,givenname,surname,name)
    if ($ADUserGN.count -eq 0) {
      fRecord "WARN" "$($person.fullname)($PersonEmployeeID): ID ($PersonEmployeeID) not found. No suggestions."
    } elseif ($ADUserGN.count -ne 1) { 
      fRecord "WARN" "$($person.fullname)($PersonEmployeeID): ID ($PersonEmployeeID) not found. Multiple Suggestions."
    } else { 
      fRecord "INFO" "$($person.fullname)($PersonEmployeeID): ID ($PersonEmployeeID) not found. Found suggestion and will apply to: "$ADUserGN[0].givenname" "$ADUserGN[0].surname"."
      if (-not $boolShowOnly) {
        $adusergn | set-aduser -employeeid $PersonEmployeeID
      }
    }

  # If the EmployeeID is assigned to more then one Person:
  } elseif ($aduser.count -ne 1) { 
    fRecord "ERROR" "$($person.fullname)($PersonEmployeeID): ID ($PersonEmployeeID) found multiple times" 

  # Otherwise the EmployeeID is assigned to exactly one person:
  } else { 
    #fRecord "INFO" "$($person.fullname)($PersonEmployeeID): ID ($PersonEmployeeID) found"

    # Update: Check an employees: First and last name.
    $Personknownas = ''+$person.knownas
    $PersonSurname  = ''+$person.surname
    if (($aduser[0].givenname.compareto($Personknownas)) -or ($aduser[0].Surname.compareto($PersonSurname))) {
      fRecord "INFO" "$($person.fullname)($PersonEmployeeID): Name update from: '$($aduser[0].Givenname) $($aduser[0].Surname)', to: '$Personknownas $PersonSurname'."
      if (-not $boolShowOnly) {
        $aduser[0] | set-aduser -givenname $Personknownas -surname $PersonSurname 
      }
    }

    # Update: Check an employees: Fullname.
    $PersonFullname  = ''+$person.fullname
    if ($aduser[0].displayname.compareto($PersonFullname)) {
      fRecord "INFO" "$($person.fullname)($PersonEmployeeID): Fullname update from: '$($aduser[0].displayname)', to: '$PersonFullname'."
      if (-not $boolShowOnly) {
        $aduser[0] | set-aduser -displayname $PersonFullname
      }
    }

    # Update: Check an employees: AD Object Name.
    $PersonFullname  = ''+$person.fullname
    if ($aduser[0].name.compareto($PersonFullname)) {
      fRecord "INFO" "$($person.fullname)($PersonEmployeeID): ADObject update from: '$($aduser[0].name)', to: '$PersonFullname'."
      if (-not $boolShowOnly) {
        $ADUser[0] | Rename-ADObject -NewName $PersonFullname
      }
    }

    # Update: Check an employees: Company
    $PersonCompany = ''+$person.currentCompany
    if ($aduser[0].company -ne $PersonCompany) {
      fRecord "INFO" "$($person.fullname)($PersonEmployeeID): Company update from: '$($aduser[0].company)', to: '$PersonCompany'."
      if (-not $boolShowOnly) {
        $aduser[0] | set-aduser -company $PersonCompany
      }
    }

    # Update: Check an employees: Department.
    $PersonDepartment = ''+$person.currentdepartment
    $PersonDepartment = ''+$person.currentdepartment.substring($person.currentdepartment.IndexOf(" - ")+3)
    $PersonDepartment = $PersonDepartment +' ('+ $person.currentdepartment.substring(0, $person.currentdepartment.IndexOf(" - ")) +')'
    if ($aduser[0].department -ne $PersonDepartment) {
      fRecord "INFO" "$($person.fullname)($PersonEmployeeID): Department update from: '$($aduser[0].department)', to: '$PersonDepartment'."
      if (-not $boolShowOnly) {
        $aduser[0] | set-aduser -department $PersonDepartment
      }
    }

    # Update: Check an employees: Jobtitle.
    $Personjobtitle = ''+$person.currentjobtitle
    if ($aduser[0].title -ne $Personjobtitle) {
      fRecord "INFO" "$($person.fullname)($PersonEmployeeID): Title update from: '$($aduser[0].title)', to: '$Personjobtitle'."
      if (-not $boolShowOnly) {
        $aduser[0] | set-aduser -title $Personjobtitle
      }
    }

    # Update: Check an employees: Manager.
    $Personreportsto = ''+$person.reportsto
    if ($Personreportsto -eq '') {
      fRecord "INFO" "$($person.fullname)($PersonEmployeeID): Manager update: No ManagerID"
    } else {
      $ADUserMgr = @(get-ADUser -filter {employeeid -eq $Personreportsto} -properties employeeid)
      if ($ADUserMgr.count -eq 0) {
        fRecord "WARN" "$($person.fullname)($PersonEmployeeID): Manager ID ($Personreportsto) not found."
      } elseif ($ADUserMgr.count -ne 1) {
        fRecord "ERROR" "$($person.fullname)($PersonEmployeeID): Manager ID ($Personreportsto) found multiple times" 
      } else {
        if ($ADUser[0].Manager -ne $ADUserMgr[0].DistinguishedName) {
          fRecord "INFO" "$($person.fullname)($PersonEmployeeID): Manager update from: '$($ADUser[0].manager)', to: '"$ADUserMgr[0].DistinguishedName"' ($Personreportsto)."
          if (-not $boolShowOnly) {
            $ADUser[0] | set-aduser -manager $ADUserMgr[0].DistinguishedName
          }
        }
      }
    }

    # Update: Check an employees: Mobile.
    $PersonMobile = ''+$person.workmobile
    if ($PersonMobile -like '0*') {
      $PersonMobile = '+64 '+$PersonMobile.substring(1)
    }
    $strADMobile  = ''+$aduser[0].mobile
    if ($strADMobile -ne $PersonMobile) {
      fRecord "INFO" "$($person.fullname)($PersonEmployeeID): Mobile update from: '$strADMobile', to: '$PersonMobile'."
      if ($PersonMobile -eq '') {
        if (-not $boolShowOnly) {
          $aduser[0] | Set-ADUser -Clear Mobile
        }
      } else {
        if (-not $boolShowOnly) {
          $aduser[0] | Set-ADUser -Replace @{Mobile=$PersonMobile}
        }
      }
    }

    # Update: Check an employees: IP Phone = Extension.
    $PersonPhone = ''+$person.worktelephone
    $strADPhone  = ''+$aduser[0].IPPhone
    if ($strADPhone -ne $PersonPhone) {
      fRecord "INFO" "$($person.fullname)($PersonEmployeeID): Phone update from: '$strADPhone', to: '$PersonPhone'."
      if ($PersonPhone -eq '') {
        if (-not $boolShowOnly) {
          $aduser[0] | Set-ADUser -Clear IPPhone
        }
      } else {
        if (-not $boolShowOnly) {
          $aduser[0] | Set-ADUser -Replace @{IPPhone=$PersonPhone}
        }
      }
    }

    # Update: Check an employees: HomePhone = Extention
    $PersonPhone = ''+$person.worktelephone
	$strADHomePhone = ''+$aduser[0].HomePhone
    if ($strADHomePhone -ne $PersonPhone) {
      fRecord "INFO" "$($person.fullname)($PersonEmployeeID): Phone update from: '$strADHomePhone', to: '$PersonPhone'."
      if ($PersonPhone -eq '') {
        if (-not $boolShowOnly) {
          $aduser[0] | Set-ADUser -Clear HomePhone
        }
      } else {
        if (-not $boolShowOnly) {
          $aduser[0] | Set-ADUser -Replace @{HomePhone=$PersonPhone}
        }
      }
    }

    # Update: Check an employees: OfficePhone
    $PersonOfficePhone = ''+$person.workddi
    if ($PersonOfficePhone -eq '') { $PersonOfficePhone = ''+$person.officephone }
    if ($PersonOfficePhone -like '0*') {
      $PersonOfficePhone = '+64 '+$PersonOfficePhone.substring(1)
    }
    $strADTelephoneNumber = ''+$aduser[0].telephonenumber
    if ($strADTelephoneNumber -ne $PersonOfficePhone) {
      fRecord "INFO" "$($person.fullname)($PersonEmployeeID): Phone update from: '$strADTelephoneNumber', to: '$PersonOfficePhone'."
      if ($PersonofficePhone -eq '') {
        if (-not $boolShowOnly) {
          $aduser[0] | Set-ADUser -Clear telephonenumber
        }
      } else {
        if (-not $boolShowOnly) {
          $aduser[0] | Set-ADUser -Replace @{telephonenumber=$PersonofficePhone}
        }
      }
    }

    # Update: Check an employees: OfficeFax
    $PersonOfficeFax = ''+$person.officefax
    if ($PersonOfficeFax -like '0*') {
      $PersonOfficeFax = '+64 '+$PersonOfficeFax.substring(1)
    }
    $strADFaxNumber = ''+$aduser[0].facsimileTelephoneNumber
    if ($strADFaxNumber -ne $PersonOfficeFax) {
      fRecord "INFO" "$($person.fullname)($PersonEmployeeID): Phone update from: '$strADFaxNumber', to: '$PersonOfficeFax'."
      if ($PersonOfficeFax -eq '') {
        if (-not $boolShowOnly) {
          $aduser[0] | Set-ADUser -Clear facsimileTelephoneNumber
        }
      } else {
        if (-not $boolShowOnly) {
          $aduser[0] | Set-ADUser -Replace @{facsimileTelephoneNumber=$PersonOfficeFax}
        }
      }
    }

    # Update: Check an employees: Website
    $PersonWebsite = ''+$person.website
    if ($aduser[0].wwwHomePage -ne $PersonWebsite) {
      fRecord "INFO" "$($person.fullname)($PersonEmployeeID): wwwHomePage update from: '$($aduser[0].wwwHomePage)', to: '$PersonWebsite'."
      if ($PersonWebsite -eq '') {
        if (-not $boolShowOnly) {
          $aduser[0] | Set-ADUser -Clear wwwHomePage
        }
      } else {
        if (-not $boolShowOnly) {
          $aduser[0] | Set-ADUser -Replace @{wwwHomePage=$PersonWebsite}
        }
      }
    }

#SIP
# msRTCSIP-Line = tel:+64xxx;ext=6xxx
# msRTCSIP-LineServer = sip:rcc@zccclicktodial.tol.local
# msRTCSIP-PrimaryUserAddress = sip:[emailaddress] | sip:[firstname].[lastname]@tol.local
    # Update: Check an employees: SIP Line
    $PersonSIPLine = $PersonOfficePhone -replace "[^0-9]"
	if ($person.worktelephone -eq '') {
	  $PersonSIPLine = 'tel:+'+$PersonSIPLine
	} else {
	  $PersonSIPLine = 'tel:+'+$PersonSIPLine+';ext='+$person.worktelephone
	}
	$strADSIPLine  = ''+$aduser[0].'msRTCSIP-Line'
    if ($strADSIPLine -ne $PersonSIPLine) {
      fRecord "INFO" "$($person.fullname)($PersonEmployeeID): msRTCSIP-Line update from: '$strADSIPLine', to: '$PersonSIPLine'."
      if ($PersonSIPLine -eq '') {
        if (-not $boolShowOnly) {
          $aduser[0] | Set-ADUser -Clear msRTCSIP-Line
        }
      } else {
        if (-not $boolShowOnly) {
          $aduser[0] | Set-ADUser -Replace @{'msRTCSIP-Line'=$PersonSIPLine}
        }
      }
    }

    # Update: Check an employees: SIP LineServer
    $PersonSIPLineServer = 'sip:rcc@zccclicktodial.tol.local'
	$strADSIPLineServer  = ''+$aduser[0].'msRTCSIP-LineServer'
    if ($strADSIPLineServer -ne $PersonSIPLineServer) {
      fRecord "INFO" "$($person.fullname)($PersonEmployeeID): msRTCSIP-LineServer update from: '$strADSIPLineServer', to: '$PersonSIPLineServer'."
      if ($PersonSIPLineServer -eq '') {
        if (-not $boolShowOnly) {
          $aduser[0] | Set-ADUser -Clear msRTCSIP-LineServer
        }
      } else {
        if (-not $boolShowOnly) {
          $aduser[0] | Set-ADUser -Replace @{'msRTCSIP-LineServer'=$PersonSIPLineServer}
        }
      }
    }

    # Update: Check an employees: SIP Address
    $strADSIPEmail   = 'sip:'+$aduser[0].mail
    $strADSIPUPN     = 'sip:'+$aduser[0].givenname+'.'+$aduser[0].surname+'@tuiora.co.nz'
	if ($strADSIPEmail -eq 'sip:') {
	  $strADSIPEmail = $strADSIPUPN
    }
	$strADSIPAddress = ''+$aduser[0].'msRTCSIP-PrimaryUserAddress'
    if ($strADSIPEmail -ne $strADSIPAddress) {
      fRecord "INFO" "$($person.fullname)($PersonEmployeeID): msRTCSIP-PrimaryUserAddress update from: '$($strADSIPAddress)', to: '$strADSIPEmail'."
      if ($strADSIPEmail -eq 'sip:') {
        if (-not $boolShowOnly) {
          $aduser[0] | Set-ADUser -Clear msRTCSIP-PrimaryUserAddress
        }
      } else {
        if (-not $boolShowOnly) {
          $aduser[0] | Set-ADUser -Replace @{'msRTCSIP-PrimaryUserAddress'=$strADSIPEmail}
        }
      }
    }

  }
  $boolFirst = 0 #0=FALSE,1=TRUE
}

#Logic to remove account names.
fRecord "WARN" "Remove users: "
  $Result = get-aduser -searchbase "ou=users,ou=tol,dc=tol,dc=local" -filter {(employeeid -notlike "*")} | ft DistinguishedName | Out-String
  fRecord "SILENT" "$Result"

fRecord "WARN" "Users with no expiry on Password: "

  $Result = get-aduser -filter {(PasswordNeverExpires -ne 'False') -and (surname -notlike 'Service*Account')} -searchbase "ou=tol,dc=tol,dc=local" | ft DistinguishedName | Out-String
  fRecord "SILENT" "$Result"
  $Result = get-aduser -filter {(PasswordNeverExpires -ne 'False') -and (surname -notlike 'Service*Account')} -searchbase "ou=Global Security Entities,dc=tol,dc=local" | ft DistinguishedName | Out-String
  fRecord "SILENT" "$Result"

  # Start of Script: Check for Snapin
  if (!(Get-PSSnapin Microsoft.Exchange.Management.PowerShell.Admin)) {
    add-PSSnapin Microsoft.Exchange.Management.PowerShell.Admin
  }

fRecord "INFO" "Regenerate all address books."
  $Result = Get-EmailAddressPolicy | Update-EmailAddressPolicy | Out-String
  fRecord "SILENT" "$Result"
  $Result = Get-AddressList        | Update-AddressList | Out-String
  fRecord "SILENT" "$Result"
  $Result = Get-GlobalAddressList  | Update-GlobalAddressList | Out-String
  fRecord "SILENT" "$Result"
  $Result = Get-OfflineAddressBook | Update-OfflineAddressBook | Out-String
  fRecord "SILENT" "$Result"

fResult $global:boolSuccessResult

