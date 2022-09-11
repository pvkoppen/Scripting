' Name        : LoginScript.vbs
' Description : Login script for domain TOL.local.
' Author      : Peter van Koppen,  Tui Ora Ltd
' ----------------------------------------------------------

' ----------------------------------------------------------
' Change Log.
' ----------------------------------------------------------
' 2013-01-23: 1.6ay: Remove THPH Colour Brother.
' 2013-02-14:      : Remove Barret Street Printer, Add TOL YS StAubynSt NP, Add TOL YS Hawera, Add TOL YS Hawera Colour.
' 2013-02-18:      : Add AUAHA WLG Central to from TOLPR01
' 2013-03-27:      : Glenar - BH and TOLPA
' 2013-04-15; 1.7  : Added Function SetUserAppAssoc(strExtention, strFileDecription, strApplication, strIcon)
' 2013-04-15; 1.7a : Updated TOL YS Hawera Printer
' 2013-04-15; 1.7b : Updated Printers: TAM, (and in GPO). Removed Z drive from PTO Fin and TRP Fin. Removed Old Log.
' 2013-07-19; 1.7c : Updated Printers: Remove BH Ricoh from TOLFP01, move to TOLPR01 - BH Central.
' 2013-07-19; 1.7d : Updated Printers: Remove TAM and THPH Printers from TOLFP01, move to TOLPR01.
' 2013-07-26; 1.7e : Change StAubyn to TOL YS.
' 2013-07-29; 1.7f : Updated StAubyn Settings.
' 2013-07-29; 1.7g : Updated TAM Medtech group name to: Tui Ora Ltd (TOL) Family Health Medtech Users
' 2013-09-17; 1.7h : Removed TIHI and TAM.
' 2013-09-20: 1.7i : Renamed TAM Printer to TOL FHC and changed drivers.
' 2013-12-12: 1.7j : Added TOL HomeBasedSupport printer.
' 2014-01-08: 1.7k : Removed AUAHA.
' 2014-01-09: 1.7l : Add TOLFH Nurse Label Writer.
' 2014-02-24: 1.7m : TAHL Migration.
' 2014-05-14: 1.7n : PvK: Renamed Medtech groups to App - Medtech TOL??..
' ----------------------------------------------------------

' ----------------------------------------------------------
' Here start the beginning of the VBScript. Here we set some standard global setting.
' ----------------------------------------------------------
' Option Explicit: All variabled need to be declared before they are used.
' boolDebug: If True the script will show additional information.
' On Error: Resume Next= Ingore all errors. Goto 0= Show ErrorMessage and stop.
' ----------------------------------------------------------

' Set Option Explicit and Global Variables
' ----------------------------------------------------------
Option Explicit
Dim boolDebug, MessageDelay
boolDebug = False
'boolDebug = True
MessageDelay = 30
If (boolDebug) Then On Error Goto 0 Else On Error Resume Next End If


' ----------------------------------------------------------
' Library Procedures: (Library is located at the end of this script)
' ----------------------------------------------------------
' GetUserDNName
' GetUsername
' GetUserFullName
' GetComputerDNName
' GetComputerName
' GetDomainName
' IsMember
' RemovePrinter
' MapPrinter
' SetDefaultPrinter
' MapDriveLetter
' RemoveDriveLetter
' GetReg
' SetReg
' SetRegCUBin
' RunCommand
' GetEnv
' SetEnv (Only during this script) 
' SetUserAppAssoc
'WshShell.Popup "Comment", <Delay>, "Windows Caption", <popup type>
'WshShell.Popup "Comment 0", 0, "Windows Caption", 0 'Default:ok
'WshShell.Popup "Comment 1", 0, "Windows Caption", 1 'Default: ok, Cancel
'WshShell.Popup "Comment 2", 0, "Windows Caption", 2 'Default: Abort, retry, ignore
'WshShell.Popup "Comment 4", 0, "Windows Caption", 4 'Default: Yes, No
'WshShell.Popup "Comment 16", 0, "Windows Caption", 16 'Error: OK
'WshShell.Popup "Comment 32", 0, "Windows Caption", 32 'Question: OK
'WshShell.Popup "Comment 64", 0, "Windows Caption", 64 'Info: OK
'WshShell.Popup "Comment 128", 0, "Windows Caption", 128 'Blank: OK

' ----------------------------------------------------------
' Used Drive mappings.
' ----------------------------------------------------------
' C: = Local System Drive
' D: = Local or iSCSI Data drive / CD or DVD player
' E: = CD or DVD player
' G: = Group Drive (Changes per Organization).
' H: = Home Drive (Changes per induvidual).
' I: = Shared Folder of Second Organization.
' M: = Org Apps Folder / TAM Medtech / TOL Medtech
' N: = Admins: TOLFP01 d$
' O: = Org Second Apps Folder / TAM HLink / TOL HLink
' P: = Global Programs Folder / Attache.
' S: = Shared drive, accessible by all Tui Ora Ltd Network users.
' T: = 3-Tier Storage / Archiving / TRP Equip / TOL Software.
' Z: = TOL HR / THPH Caduceus / TRP Moneyworks / PTO Moneyworks / TOLPA CGC -> Move to P?


' Define all the Organisational groups.
' Group names must be in FULL DN notation Or in short group name
' ----------------------------------------------------------
Dim grpBHUsers,     grpTAHLUsers
Dim grpTOLCSUsers,  grpTOLSAUsers,  grpTOLSDUsers, grpTOLYSUsers
Dim grpSYSInternet, grpSYSUsers
grpBHUsers    = "CN=Better Homes (BH) Users,OU=BH,DC=TOL,DC=LOCAL"
grpTAHLUsers  = "CN=Te Atiawa Holdings Ltd (TAHL) Users,OU=TAHL,DC=TOL,DC=LOCAL"
grpTOLCSUsers = "CN=Tui Ora CORPORATE SERVICES Users,OU=TOL,DC=TOL,DC=LOCAL"
grpTOLSAUsers = "CN=Tui Ora SPECIAL ACCOUNT Users,OU=TOL,DC=TOL,DC=LOCAL"
grpTOLSDUsers = "CN=Tui Ora SERVICE DELIVERY Users,OU=TOL,DC=TOL,DC=LOCAL"
grpTOLYSUsers = "CN=Tui Ora YOUTH SERVICES Team,OU=TOL,DC=TOL,DC=LOCAL"
grpSYSInternet= "CN=System (SYS) Just Internet Users,OU=Global Security Entities,DC=TOL,DC=LOCAL"
grpSYSUsers   = "CN=System (SYS) Users,OU=Global Security Entities,DC=TOL,DC=LOCAL"


' Declare Variables and set initial Values
' ----------------------------------------------------------
Dim strUsername, strUserDNName
Dim strRegPath, strRegValue
strUserDNName = GetUserDNName
strUserName   = GetUserName
If (boolDebug) Then WScript.Echo "DN:" & strUserDNName &vbCrLf& "User:" & strUserName &vbCrLf& "Fullname: " &GetUserFullName &vbCrLf
If (strUserDNName = "") Or (strUserName = "") Then
  WScript.Echo "Username or UserDNName is Empty! Logon Script will fail!" &vbCrLf& "Please log off and try again!" &vbCrLf& "DN: " & strUserDNName &vbCrLf& "User:" & strUserName &vbCrLf
  WScript.Quit
End If


' Clear out old drive mappings
' ----------------------------------------------------------
'RunCommand "cmd ", " /c ""for %a IN (a b c d e f g h i j k l m n o p q r s t u v w x y z) do net use %a: /DELETE "" "


' Perform basic Group printer mappings and drive mappings.
' ----------------------------------------------------------
If IsMember(strUserDNName, grpBHUsers) and IsMember(strUserDNName, grpTOLSDUsers) Then ' --- Better Homes & TOLSD
  ' Remove Old Printer Drivers
  ' Add New Printer Drivers
  ' Add Drive Mappings
  'MapDriveLetter "G", "\\TOLFP01\SharedTOL$" 
  'MapDriveLetter "H", "\\TOLFP01\UsersTOL$\" & strUserName & "\Documents"
  'MapDriveLetter "S", "\\TOLFP01\SharedProviders$"
  'MapDriveLetter "I", "\\TOLFP01\SharedBH$"

ElseIf IsMember(strUserDNName, grpBHUsers) Then ' --- Better Homes
  ' Remove Old Printer Drivers
  ' Add New Printer Drivers
  'MapPrinter("\\TOLPR01\BH Central")

  ' Add Drive Mappings
  'MapDriveLetter "G", "\\TOLFP01\SharedBH$"
  'MapDriveLetter "H", "\\TOLFP01\UsersBH$\" &strUserName & "\Documents"

ElseIf IsMember(strUserDNName, grpTAHLUsers) Then ' --- Te Atiawa
  ' Remove Old Printer Drivers
  ' Add New Printer Drivers
  'MapPrinter("\\TOLPR01\TAHL Central")
  ' Add Drive Mappings
  'MapDriveLetter "G", "\\TOL.LOCAL\TAHL\Shared"
  'MapDriveLetter "H", "\\TOL.LOCAL\TAHL\Users\" & strUserName & "\Documents"

ElseIf IsMember(strUserDNName, grpTOLYSUsers) Then ' --- Tui Ora - YS
  ' Remove Old Printer Drivers
  ' Add New Printer Drivers
  ' Add Drive Mappings
  'MapDriveLetter "G", "\\tol.local\TOL\Shared" 
  'MapDriveLetter "H", "\\tol.local\TOL\Users\" & strUserName & "\Documents"
  
ElseIf IsMember(strUserDNName, grpTOLSAUsers) Then ' --- Tui Ora - SA
  ' Remove Old Printer Drivers
  ' Add New Printer Drivers
  ' Add Drive Mappings
  'MapDriveLetter "G", "\\TOLFP01\SharedTOL$" 
  'MapDriveLetter "H", "\\TOLFP01\UsersTOL$\" & strUserName & "\Documents"
  'MapDriveLetter "S", "\\TOLFP01\SharedProviders$"

ElseIf IsMember(strUserDNName, grpTOLSDUsers) Then ' --- Tui Ora - SD
  ' Remove Old Printer Drivers
  ' Add New Printer Drivers
  ' Add Drive Mappings
  'MapDriveLetter "G", "\\TOLFP01\SharedTOL$" 
  'MapDriveLetter "H", "\\TOLFP01\UsersTOL$\" & strUserName & "\Documents"
  'MapDriveLetter "S", "\\TOLFP01\SharedProviders$"

ElseIf IsMember(strUserDNName, grpTOLCSUsers) Then ' --- Tui Ora - CS
  ' Remove Old Printer Drivers
  ' Add New Printer Drivers
  'MapPrinter("\\TOLPR01\TOL Business Support")
  ' Add Drive Mappings
  'MapDriveLetter "G", "\\TOLFP01\SharedTOL$" 
  'MapDriveLetter "H", "\\TOLFP01\UsersTOL$\" & strUserName & "\Documents"
  'MapDriveLetter "S", "\\TOLFP01\SharedProviders$"

ElseIf IsMember(strUserDNName, grpSYSInternet) Then ' --- System Internet
  ' Remove Old Printer Drivers
  ' Add New Printer Drivers
  ' Add Drive Mappings
  'MapDriveLetter "H", "\\TOLFP01\UsersSYS$\" & strUserName & "\Documents"

ElseIf IsMember(strUserDNName, grpSYSUsers) Then ' --- System Accounts
  ' Remove Old Printer Drivers
  ' Add New Printer Drivers
  'MapPrinter("\\TOLPR01\TOL Business Support")
  'MapPrinter("\\TOLPR01\TOL A5 FHC-Reception")
  ' Add Drive Mappings
  'MapDriveLetter "G", "\\TOLFP01\SharedSYS$"
  'MapDriveLetter "H", "\\TOLFP01\UsersSYS$\" & strUserName & "\Documents"
  'MapDriveLetter "S", "\\TOLFP01\SharedProviders$"

Else
  If (boolDebug) Then WScript.Echo "You do not belong to any Organisation groups." &vbCrLf
End If


' Group Oriented additional actions.
' ----------------------------------------------------------

If IsMember(strUserDNName, "Domain Admins")        or IsMember(strUserDNName, "System (SYS) Administrators")   or _
   IsMember(strUserDNName, "System (SYS) Support") Then
  'MapDriveLetter "I", "\\TOLFP01\SharedTOL$" 
  'MapDriveLetter "N", "\\TOLFP01\D$" 
  'MapDriveLetter "P", "\\TOLFP01\Applications$" 
  'MapDriveLetter "T", "\\TOLMM02\Software" 
End If
If IsMember(strUserDNName, "App - Attache") Then
  'MapDriveLetter "P", "\\TOLFP01\Applications$" 
End If
If IsMember(strUserDNName, "App - Caduceus") Then
  MapPrinter("\\TOLPR01\TOL HomeBasedSupport")
  'MapDriveLetter "P", "\\TOLFP01\Applications$" 
  'MapDriveLetter "Z", "\\TOLFP01\Applications$" 
  'RunCommand "P:\Caduceus\AutoUpdateStuff\Install.bat", "/silent"
End If
If IsMember(strUserDNName, "App - DynamicsGP Access") Then
  'MapDriveLetter "P", "\\TOLFP01\Applications$" 
End If
If IsMember(strUserDNName, "App - IMS Payroll") Then
  'MapDriveLetter "P", "\\TOLFP01\Applications$" 
  'SetUserAppAssoc "PPC", "IMS Payroll Company File", "P:\IMS\IMS Payroll Partner\IMSPayrollPartner.exe", "P:\IMS\IMS Payroll Partner\IMSPayrollPartner.exe,1"
End If
If IsMember(strUserDNName, "App - Medtech TOLFH") Then
  'MapPrinter("\\TOLPR01\TOL FHC-Reception")
  'MapPrinter("\\TOLPR01\TOL A5 FHC-Reception")
  'MapDriveLetter "M", "\\TAMMT01\MT32$" 
  'MapDriveLetter "O", "\\TAMMT01\HLINK" 
  'RunCommand "\\TAMMT01\mt32$\bestpractice\BPAC-BestPractice\Load-BPACCertificate.cmd", " "
End If
If IsMember(strUserDNName, "App - Medtech TOLSD") Then
  'MapDriveLetter "M", "\\TOLMT01\MT32" 
  'MapDriveLetter "O", "\\TOLMT01\HLINK" 
End If
If IsMember(strUserDNName, "Tui Ora Ltd (TOL) Chronic Care") Then
  'MapPrinter("\\TOLPR01\TOL ChronicCare-Navigator-TPC")
End If
If IsMember(strUserDNName, "Tui Ora FAMILY HEALTH Team") Then 
  ' Add New Printer Drivers
  'MapPrinter("\\TOLPR01\TOL FHC-Doc1")
  'MapPrinter("\\TOLPR01\TOL A5 FHC-Doc1")
  'MapPrinter("\\TOLPR01\TOL FHC-Nurse1")
  'MapPrinter("\\TOLPR01\TOL A5 FHC-Nurse1")
  'MapPrinter("\\TOLPC48\TOL FH-Nurse1-Label")
  'MapPrinter("\\TOLPR01\TOL FHC-Doc2")
  'MapPrinter("\\TOLPR01\TOL A5 FHC-Doc2")
  'MapPrinter("\\TOLPR01\TOL A5 CC-Nav-TPC")
  'MapPrinter("\\TOLPR01\TOL FHC-Reception")
  'MapPrinter("\\TOLPR01\TOL A5 FHC-Reception")
  End If
If IsMember(strUserDNName, "Tui Ora FINANCE Team") Then
  'MapPrinter("\\TOLPR01\TOL HumanResource")
  'MapPrinter("\\TOLPR01\TOL Finance")
  'MapDriveLetter "P", "\\TOLFP01\Applications$" 
End If
If IsMember(strUserDNName, "Tui Ora HUMAN RESOURCES Team") Then
  'MapPrinter("\\TOLPR01\TOL HumanResource")
End If
If IsMember(strUserDNName, "Tui Ora ICT Team") Then
  'MapDriveLetter "P", "\\TOLFP01\Applications$" 
  'MapDriveLetter "T", "\\TOLMM02\Software" 
End If
If IsMember(strUserDNName, "Tui Ora Ltd (TOL) Management") Then
  'MapPrinter("\\TOLPR01\TOL Management")
End If
If IsMember(strUserDNName, "Tui Ora Ltd (TOL) MHAS") Then
  'MapPrinter("\\TOLPR01\TOL Mental Health")
End If
If IsMember(strUserDNName, "Tui Ora Ltd (TOL) Navigator") Then
  'MapPrinter("\\TOLPR01\TOL ChronicCare-Navigator-TPC")
End If
If IsMember(strUserDNName, "Tui Ora Ltd (TOL) Printing Residential") Then
  'MapPrinter("\\TOLPR01\TOL DevonRd Brixton")
  'MapPrinter("\\TOLPR01\TOL Lynton NP")
  'MapPrinter("\\TOLPR01\TOL Mill Road")
  'MapPrinter("\\TOLPR01\TOL Pukekohatu")
  'MapPrinter("\\TOLPR01\TOL Powderham")
End If
If IsMember(strUserDNName, "Tui Ora Ltd (TOL) Printing South Office") Then
  'MapPrinter("\\TOLPR01\TOL Hawera")
  'MapPrinter("\\TOLPR01\TOL Patea")
End If
If IsMember(strUserDNName, "Tui Ora Ltd (TOL) Printing Wellness") Then
  'MapPrinter("\\TOLPR01\TOL Leadership-Wellness")
End If
If IsMember(strUserDNName, "Tui Ora Ltd (TOL) Printing Waitara") Then
  'MapPrinter("\\TOLPR01\TOL Waitara Office")
End If
If IsMember(strUserDNName, "Tui Ora Ltd (TOL) PTO Finance") Then
  'MapDriveLetter "P", "\\TOLFP01\Applications$" 
  ' Application: Set registery for MoneyWorks 5.
 ' SetUserAppAssoc "mwd5", "MoneyWorks Company Data", "P:\MoneyWorks Gold 5\MoneyWorks Gold.exe", "P:\MoneyWorks Gold 5\MoneyWorks Gold.exe,11"
End If
If IsMember(strUserDNName, "Tui Ora Ltd (TOL) Reception") Then
  'MapPrinter("\\TOLPR01\TOL Finance")
End If
If IsMember(strUserDNName, "Tui Ora Ltd (TOL) Smoking Cessation") Then
  'MapDriveLetter "P", "\\TOLFP01\Applications$" 
End If
If IsMember(strUserDNName, "Tui Ora TPC Team") Then
  'MapPrinter("\\TOLPR01\TOL ChronicCare-Navigator-TPC")
End If
If IsMember(strUserDNName, "Tui Ora Ltd (TOL) TRP Finance") Then
  'MapDriveLetter "P", "\\TOLFP01\Applications$" 
End If
If IsMember(strUserDNName, "Tui Ora YOUTH SERVICES Team") Then
  ' Add New Printer Drivers
  'MapPrinter("\\TOLPR01\TOL GloverRd Hawera")
  'MapPrinter("\\TOLPR01\TOL YS Hawera Colour")
  'MapPrinter("\\TOLPR01\TOL YS StAubynSt NP")
  'MapPrinter("\\TOLRODC01\TOL YS StAubynSt NP")
End If


' Person Oriented additional actions.
' ----------------------------------------------------------
'If (UCase(strUserName) = UCase("Peter")) Then
'  MapDriveLetter "U", "\\TOLDS01\eXpress" 
'End If


' Computer Oriented additional actions.
' ----------------------------------------------------------
If (UCase(GetEnv("COMPUTERNAME")) = UCase("TAMMT01")) Then
 ' MapDriveLetter "M", "\\TAMMT01\MT32$"
  'MapDriveLetter "O", "\\TAMMT01\HLINK"
End If
If (UCase(GetEnv("COMPUTERNAME")) = UCase("TOLMT01")) Then
  'MapDriveLetter "M", "\\TOLMT01\MT32" 
  'MapDriveLetter "O", "\\TOLMT01\HLINK" 
End If


' Application Oriented Actions.
' ----------------------------------------------------------
' Application: Set registry for Profile.
' ----------------------------------------------------------
strRegPath = "HKCU\Software\IntraHealth\Profile\Client\Logons"
strRegValue = ""& GetReg(strRegPath)
If (strRegValue = "") Or (strRegValue <> strUserName & "=TOLPE01") Then 
  If (boolDebug) Then WScript.Echo "Profile: Replace (Registry setting Is Empty Or Old)" &vbCrLf& "Previous Reg Value: " &strRegValue &vbCrLf
  SetReg strRegPath, strUserName & "=TOLPE01", "REG_SZ"
End If
' Application: Set registry for IE7/IE8.
' ----------------------------------------------------------
If (boolDebug) Then WScript.Echo "IE7/IE8: Disable Runonce startpage." &vbCrLf
SetReg "HKCU\Software\Microsoft\Internet Explorer\Main\RunOnceComplete", 1, "REG_DWORD"
SetReg "HKCU\Software\Microsoft\Internet Explorer\Main\RunOnceHasShown", 1, "REG_DWORD"
' Application: Set registry for MsOffice 2007.
' ----------------------------------------------------------
strRegPath = "HKCU\Software\Microsoft\Office\Common\UserInfo\UserName"
strRegValue = ""& GetReg(strRegPath)
If (strRegValue = "") Or (strRegValue <> GetUserFullName) Then 
  If (boolDebug) Then WScript.Echo "MsOffice 2007: Replace Username (Registry setting Is Empty)" &vbCrLf& "Previous Reg Value: " &strRegValue &vbCrLf
  SetReg strRegPath, GetUserFullName, "REG_SZ"
End If
' Application: DO NOT Set registry for WinHTTP.
' ----------------------------------------------------------
'RunCommand "proxycfg.exe", "-p tolgw01:8080 ""<local>;wsus;*.tol.local;*"" "


' Final.
' ----------------------------------------------------------
'boolDebug = True
If (boolDebug) Then WScript.Echo "Done." &vbCrLf
WScript.Quit


' ----------------------------------------------------------
' The Library part of the script starts here. The Actions part will folow below.
' ----------------------------------------------------------


' Procedure: GetUserDNName
' Does: Returns the current users accounts Full DN Name
' ----------------------------------------------------------
Public Function GetUserDNName
  ' Declare Variables.
  Dim objSysInfo
  ' Bind to Active Directory.
  Set objSysInfo = CreateObject("ADSystemInfo")
  'objSysInfo.RefreshSchemaCache
  ' Get the DN value.
  GetUserDNName = objSysInfo.UserName
  Set objSysInfo = Nothing
End Function

' Procedure: GetUserName
' Does: Returns the current users Login name
' ----------------------------------------------------------
Public Function GetUserName
  ' Declare Variables.
  Dim objUser
  ' Bind to Active Directory.
  Set objUser = GetObject("LDAP://" & GetUserDNName )
  ' Get the login name value.
  GetUserName = objUser.sAMAccountName
  Set objUser = Nothing
End Function

' Procedure: GetUserFullName
' Does: Returns the current users Fullname
' ----------------------------------------------------------
Public Function GetUserFullName
  ' Declare Variables.
  Dim objUser
  ' Bind to Active Directory.
  Set objUser = GetObject("LDAP://" & GetUserDNName )
  ' Get the Fullname value.
  GetUserFullName = objUser.FullName
  Set objUser = Nothing
End Function

' Procedure: GetComputerDNName
' Does: Returns the Local Machine's full DN name
' ----------------------------------------------------------
Public Function GetComputerDNName
  ' Declare Variables.
  Dim objSysInfo
  ' Bind to Active Directory.
  Set objSysInfo = CreateObject("ADSystemInfo")
  'objSysInfo.RefreshSchemaCache
  ' Get the login Machine name value.
  GetComputerDNName = objSysInfo.ComputerName
  Set objSysInfo = Nothing
End Function

' Procedure: GetComputerName
' Does: Returns the Local Machine name
' ----------------------------------------------------------
Public Function GetComputerName
  ' Declare Variables.
  Dim objNet
  ' Bind to Active Directory.
  Set objNet = CreateObject("WScript.NetWork") 
  ' Get the login Machine name value.
  GetComputerName = objNet.ComputerName
  Set objNet = Nothing
End Function

' Procedure: GetDomainName
' Does: Returns the current Domain Name
' ----------------------------------------------------------
Public Function GetDomainName
  ' Declare Variables.
  Dim objRootDSE
  ' Bind to Active Directory. 
  ' Get Current Domain Name.
  Set objRootDSE = GetObject("LDAP://rootDSE")
  ' Get the Domain Name value.
  GetDomainName  = objRootDSE.Get("defaultNamingContext")
  Set objRootDSE = Nothing
End Function

' Procedure: IsMember
' Does: Returns TRUE if the DN name is a member if the Group.
'     : The group name can be a full DN name or a short name 
'       (Short names are not always unique).
'     : We only check the direct group memberships and the primary group.
' ----------------------------------------------------------
Public Function IsMember(strUserDNName, strGroupName)
  If (strUserDNName <> "") And (strGroupName <> "")Then 
    ' Declare Variables.
    Dim objIMUser, objIMGroup
    ' Set Initial Values.
    IsMember  = False
    ' Bind to Active Directory.
    Set objIMUser  = GetObject("LDAP://" & strUserDNName)
    ' Scroll thru the group memberships for the right group.
    For Each objIMGroup In objIMUser.Groups
      If (UCase(objIMGroup.Name) = UCase(strGroupName)) Or (UCase(objIMGroup.ADSPath) = UCase(strGroupName)) _
        Or (UCase(objIMGroup.Name) = UCase("CN=" & strGroupName)) Or (UCase(objIMGroup.ADSPath) = UCase("LDAP://" & strGroupName)) Then
        IsMember = True
        Exit For
      End If
    Next
    ' If the group was not part of the group memberships look at the primary group.
    If Not (IsMember) Then
      ' Declare additional Variables.
      Dim intIMPrimaryGroupID, objIMConnection, objIMCommand, objIMRecordSet
      ' Retrieve the user's PrimaryGroupID attribute.
      intIMPrimaryGroupID = objIMUser.Get("primaryGroupID")
      ' Query AD for the Name and GroupID of all groups.
      Set objIMConnection = CreateObject("ADODB.Connection")
      objIMConnection.Open "Provider=ADsDSOObject;"
      Set objIMCommand = CreateObject("ADODB.Command")
      objIMCommand.ActiveConnection = objIMConnection
      objIMCommand.CommandText = "<LDAP://" &GetDomainName& ">;(objectCategory=Group);" & _
        "distinguishedName,primaryGroupToken;subtree"
      Set objIMRecordSet = objIMCommand.Execute
      ' Scroll thru the group list to find the PrimaryGroupID
      While Not objIMRecordset.EOF
        If objIMRecordset.Fields("primaryGroupToken") = intIMPrimaryGroupID Then
          ' Found the primary group, now check if it is the right group.
          Set objIMGroup = GetObject("LDAP://" & objIMRecordset.Fields("distinguishedName"))
          If (UCase(objIMGroup.Name) = UCase(strGroupName)) Or (UCase(objIMGroup.ADSPath) = UCase(strGroupName)) _
            Or (UCase(objIMGroup.Name) = UCase("CN=" & strGroupName)) Or (UCase(objIMGroup.ADSPath) = UCase("LDAP://" & strGroupName)) Then
            IsMember = True
          End If
        End If
        objIMRecordset.MoveNext
      Wend
      objIMConnection.Close 
      Set objIMRecordSet  = Nothing
      Set objIMCommand    = Nothing
      Set objIMConnection = Nothing
      If (boolDebug And IsMember) Then
        WScript.Echo "IsMember= True (Group is the primary group of the User.)" &vbCrLf& "Username: " &strUserDNName&vbCrLf& "Groupname: " &strGroupName &vbCrLf
      ElseIf (boolDebug) Then
        WScript.Echo "IsMember= False (User is not a direct member of the Group)" &vbCrLf& "Username: " &strUserDNName&vbCrLf& "Groupname: " &strGroupName &vbCrLf
      End If
    ElseIf (boolDebug) Then
      WScript.Echo "IsMember= True (User is a member of the Group)" &vbCrLf& "Username: " &strUserDNName&vbCrLf& "Groupname: " &strGroupName &vbCrLf
    End If ' Check if IsMember is True already
    Set objIMGroup   = Nothing
    Set objIMUser    = Nothing
  ElseIf (boolDebug) Then
    WScript.Echo "IsMember= False (User or Group Parameter is Empty)" &vbCrLf& "Username: " &strUserDNName&vbCrLf& "Groupname: " &strGroupName &vbCrLf
  End If ' Check on parameters empty
End Function

' Procedure: RemovePrinter
' Does: Checks if the current user has the give printer installed.
'     : If the printer is installed an attempt will be made to remove it.
'     : The UNC printer name has to be the long name as listed in the 
'       'printers and faxes' folder on the server!
' ----------------------------------------------------------
Public Sub RemovePrinter(strUNCPrinter)
  If (strUNCPrinter <> "") Then 
    ' Declare Variables.
    Dim objNetwork, objPrinters, intPrinter, boolRemovePrinter
    ' Set the default values for the variables. 
    boolRemovePrinter  = False
    ' Bind to Active Directory.
    Set objNetwork  = CreateObject("WScript.Network")
    Set objPrinters = objNetwork.EnumPrinterConnections
    ' Here we check if the printer exists.
    If objPrinters.Count <> 0 Then
      ' Here is the where the script reads the array.
      For intPrinter = 0 To objPrinters.Count -1 Step 2
        'If (boolDebug) Then WScript.Echo "Local Printer No: " &(intPrinter/2)+1 &vbCrlf& "(Port: " & objPrinters.Item(intPrinter) & ")" &vbCrlf& "(Network Path: " & objPrinters.Item(intPrinter +1) & ")" &vbCrlf& "(New Printer: " & strUNCPrinter & ")." End If &vbCrLf
        If UCase(objPrinters.Item(intPrinter+1)) = UCase(strUNCPrinter) Then
          boolRemovePrinter = True
          If (boolDebug) Then WScript.Echo "Printer Exists." &vbCrLf& _
            "(Port: " & objPrinters.Item(intPrinter) & ", Network Path: " & objPrinters.Item(intPrinter +1) & ")"  &vbCrLf
        End If
      Next
    End If
    ' If the printer exists try to remove it.
    If True = boolRemovePrinter Then
      objNetwork.RemovePrinterConnection  strUNCPrinter, True, True
      If (boolDebug) Then WScript.Echo "Printer Removed: " & strUNCPrinter &vbCrLf End If
    End If
    ' Cleanup.
    Set objPrinters = Nothing
    Set objNetwork  = Nothing
  ElseIf (boolDebug) Then
    WScript.Echo "RemovePrinter= Failed (One of the Parameter(s) is Empty)" &vbCrLf& "Printer: " &strUNCPrinter &vbCrLf
  End If ' Check on parameters empty
End Sub

' Procedure: MapPrinter
' Does: Checks if the current user has the give printer installed.
'     : If the printer is not installed an attempt will be made to install it.
'     : The UNC printer name has to be the long name as listed in the 
'       'printers and faxes' folder on the server!
' ----------------------------------------------------------
Public Sub MapPrinter(strUNCPrinter)
  If (strUNCPrinter <> "") Then 
    If Not (InStr(UCase(GetComputerDNName), UCase("CN="&GetComputerName&",OU=Domain Controllers,DC="))) And _
      Not (InStr(UCase(GetComputerDNName), UCase("CN="&GetComputerName&",OU=Servers,DC="))) Then 
      ' Declare Variables.
      Dim objNetwork, objPrinters, intPrinter, boolAddPrinter
      ' Set the default values for the variables.
      boolAddPrinter  = True
      ' Bind to Active Directory.
      Set objNetwork  = CreateObject("WScript.Network")
      Set objPrinters = objNetwork.EnumPrinterConnections
      ' Here we check if the printer already exists.
      If objPrinters.Count <> 0 Then
        ' Here is the where the script reads the array of installed printers.
        For intPrinter = 0 To objPrinters.Count -1 Step 2
          'If (boolDebug) Then WScript.Echo "Local Printer No: " &(intPrinter/2)+1 &vbCrlf& "(Port: " & objPrinters.Item(intPrinter) & ")" &vbCrlf& "(Network Path: " & objPrinters.Item(intPrinter +1) & ")" &vbCrlf& "(New Printer: " & strUNCPrinter & ")." End If &vbCrLf
          If UCase(objPrinters.Item(intPrinter+1)) = UCase(strUNCPrinter) Then
            boolAddPrinter = False
            If (boolDebug) Then WScript.Echo "MapPrinter: Prevented (Printer Already Exists)" &vbCrLf& _
              "LocalPort: " & objPrinters.Item(intPrinter)&vbCrLf& "Printer: " & objPrinters.Item(intPrinter +1)  &vbCrLf
          End If
        Next
      End If
      ' If the Printer doens't exist yet add it.
      If boolAddPrinter Then 
        objNetwork.AddWindowsPrinterConnection strUNCPrinter
        If (boolDebug) Then WScript.Echo "MapPrinter: Succes (Printer added)" &vbCrLf& "Printer: " & strUNCPrinter &vbCrLf End If
      End If
      ' Cleanup.
      Set objPrinters = Nothing
      Set objNetwork  = Nothing
    ElseIf (boolDebug) Then 
      WScript.Echo "MapPrinter= Failed (Don't map printer on a Domain Controller or a Server)"& vbCrLf& "ComputerName: " &GetComputerDNName&vbCrLf& "Printer: " &strUNCPrinter &vbCrLf
    End If ' LocalMachine = Server.
  ElseIf (boolDebug) Then
    WScript.Echo "MapPrinter= Failed (One of the Parameter(s) is Empty)" &vbCrLf& "Printer: " &strUNCPrinter &vbCrLf
  End If ' Check on parameters empty
End Sub

' Procedure: SetDefaultPrinter
' Does: Checks if the current user has the give printer installed.
'     : If the printer is not installed nothing else is done.
'     : If the Printer exists is will be set to the default.
'     : The UNC printer name has to be the long name as listed in the 
'       'printers and faxes' folder on the server!
' ----------------------------------------------------------
Public Sub SetDefaultPrinter(strUNCPrinter)
  If (strUNCPrinter <> "") Then 
    If Not (InStr(UCase(GetComputerDNName), UCase("CN="&GetComputerName&",OU=Domain Controllers,DC="))) And _
      Not (InStr(UCase(GetComputerDNName), UCase("CN="&GetComputerName&",OU=Servers,DC="))) Then 
      ' Declare Variables.
      Dim objNetwork, objPrinters, intPrinter, boolPrinterExists
      ' Set the default values for the variables.
      boolPrinterExists  = False
      ' Bind to Active Directory.
      Set objNetwork  = CreateObject("WScript.Network")
      Set objPrinters = objNetwork.EnumPrinterConnections
      ' Here we check if the printer already exists.
      If objPrinters.Count <> 0 Then
        ' Here is the where the script reads the array of installed printers.
        For intPrinter = 0 To objPrinters.Count -1 Step 2
          'If (boolDebug) Then WScript.Echo "Local Printer No: " &(intPrinter/2)+1 &vbCrlf& "(Port: " & objPrinters.Item(intPrinter) & ")" &vbCrlf& "(Network Path: " & objPrinters.Item(intPrinter +1) & ")" &vbCrlf& "(New Printer: " & strUNCPrinter & ")." End If &vbCrLf
          If UCase(objPrinters.Item(intPrinter+1)) = UCase(strUNCPrinter) Then
            boolPrinterExists = True
            objNetwork.SetDefaultPrinter strUNCPrinter
            If (boolDebug) Then WScript.Echo "SetDefaultPrinter: Success (Printer Set As Active)" &vbCrLf& "Printer: " & objPrinters.Item(intPrinter +1) &vbCrLf
          End If
        Next
      End If
      ' If the Printer does not exist, do nothing.
      If Not boolPrinterExists Then 
        If (boolDebug) Then WScript.Echo "SetDefaultPrinter: Failed (Printer does not exist yet)" &vbCrLf& "Printer: " & strUNCPrinter &vbCrLf End If
      End If
      ' Cleanup.
      Set objPrinters = Nothing
      Set objNetwork  = Nothing
    ElseIf (boolDebug) Then 
      WScript.Echo "SetDefaultPrinter= Failed (Don't set printers active on a Domain Controller or a Server)"& vbCrLf& "ComputerName: " &GetComputerDNName&vbCrLf& "Printer: " &strUNCPrinter &vbCrLf
    End If ' LocalMachine = Server.
  ElseIf (boolDebug) Then
    WScript.Echo "SetDefaultPrinter= Failed (One of the Parameter(s) is Empty)" &vbCrLf& "Printer: " &strUNCPrinter &vbCrLf
  End If ' Check on parameters empty
End Sub

' Procedure: MapDriveLetter
' Does: Checks if the current user has the give DriveLetter in use.
'     : In the DriveLetter is already used try to disconnect from it.
'     : Now map the DriveLetter to the UNCPath.
' ----------------------------------------------------------
Public Sub MapDriveLetter(strDriveLetter, strUNCPath)
  If (strDriveLetter <> "") And (strUNCPath <> "") Then
    ' Declare Variables.
    Dim objNetwork, objCurrentDrives
    Dim boolAlreadyConnected, intDrive 
    ' Bind to you local settings.
    Set objNetwork = CreateObject("WScript.Network") 
    Set objCurrentDrives = objNetwork.EnumNetworkDrives() 
    ' Check if the Driveletter is already in use.
    boolAlreadyConnected = False 
    For intDrive = 0 To objCurrentDrives.Count - 1 Step 2 
      If objCurrentDrives.Item(intDrive) = strDriveLetter & ":" Then boolAlreadyConnected = True
    Next 
    ' In the DriveLetter is in use try to disconnect it.
    If boolAlreadyConnected = True Then 
      objNetwork.RemoveNetworkDrive strDriveLetter & ":" 
      If (boolDebug) Then WScript.Echo "MapDriveLetter: Succes (Mapping Removed)" &vbCrLf& "DriveLetter: " & strDriveLetter & ":" &vbCrLf End If
    End If 
    ' Now connect the drive letter to the UNC path.
    objNetwork.MapNetworkDrive strDriveLetter & ":", strUNCPath 
    If (boolDebug) Then WScript.Echo "MapDriveLetter: Succes (Drive Mapped)" &vbCrLf& "DriveLetter: " & strDriveLetter & ":" &vbCrLf& "UNCPath: " & strUNCPath &vbCrLf End If
    ' Cleanup.
    Set objCurrentDrives = Nothing 
    Set objNetwork = Nothing 
  ElseIf (boolDebug) Then
    WScript.Echo "MapDriveLetter= Failed (One of the Parameter(s) is Empty)" &vbCrLf& "DriveLetter: " &strDriveLetter&vbCrLf& "UNCPath: " &strUNCPath &vbCrLf
  End If ' Check on parameters empty
End Sub

' Procedure: RemoveDriveLetter
' Does: Checks if the current user has the given DriveLetter in use.
'     : If the DriveLetter is used it will be removed.
' ----------------------------------------------------------
Public Sub RemoveDriveLetter(strDriveLetter)
  If (strDriveLetter <> "") Then
    ' Declare Variables.
    Dim objNetwork, objCurrentDrives
    Dim boolAlreadyConnected, intDrive 
    ' Bind to you local settings.
    Set objNetwork = CreateObject("WScript.Network") 
    Set objCurrentDrives = objNetwork.EnumNetworkDrives() 
    ' Check if the Driveletter is already in use.
    boolAlreadyConnected = False 
    For intDrive = 0 To objCurrentDrives.Count - 1 Step 2 
      If objCurrentDrives.Item(intDrive) = strDriveLetter & ":" Then boolAlreadyConnected = True
    Next 
    ' In the DriveLetter is in use try to disconnect it.
    If boolAlreadyConnected = True Then 
      objNetwork.RemoveNetworkDrive strDriveLetter & ":" 
      If (boolDebug) Then WScript.Echo "RemoveDriveLetter: Succes (Mapping Removed)" &vbCrLf& "DriveLetter: " & strDriveLetter & ":" &vbCrLf End If
    Else 
      If (boolDebug) Then WScript.Echo "RemoveDriveLetter: Succes (Mapping not present)" &vbCrLf& "DriveLetter: " & strDriveLetter & ":" &vbCrLf End If
    End If 
    ' Cleanup.
    Set objCurrentDrives = Nothing 
    Set objNetwork = Nothing 
  ElseIf (boolDebug) Then
    WScript.Echo "RemoveDriveLetter= Failed (One of the Parameter(s) is Empty)" &vbCrLf& "DriveLetter: " &strDriveLetter &vbCrLf
  End If ' Check on parameters empty
End Sub

' Procedure: GetReg
' Does: Retrieves the registry information.
' ----------------------------------------------------------
Public Function GetReg(strRegPath)
  If (strRegPath <> "") Then
    ' Declare variables and set initial value.
    Dim WsShell
    Set WsShell = WScript.CreateObject("WScript.Shell")
    ' Retrieve the Registry information.
    GetReg = ""
    On Error Resume Next
    GetReg = WsShell.RegRead(strRegPath)
    If (boolDebug) Then On Error Goto 0 Else On Error Resume Next End If
    If (boolDebug) Then WScript.Echo "GetReg: Succes (Read Registry Key)" &vbCrLf& "Registry Key: " & strRegPath &vbCrLf& "Value: " & GetReg &vbCrLf End If
  ElseIf (boolDebug) Then
    WScript.Echo "GetReg= Failed (One of the Parameter(s) is Empty)" &vbCrLf& "RegPath: " &strRegPath &vbCrLf
  End If ' Check on parameters empty
End Function 

' Procedure: SetReg
' Does: Writes the registry information.
' ----------------------------------------------------------
Public Sub SetReg(strRegPath, strRegValue, strRegType)
  If (strRegPath <> "") And (strRegValue <> "") And (strRegType <> "") Then
    ' Declare variables and set initial value.
    Dim WsShell
    Set WsShell = WScript.CreateObject("WScript.Shell")
    ' Write the Registry information.
    WsShell.RegWrite strRegPath, strRegValue, strRegType
    If (boolDebug) Then WScript.Echo "SetReg: Succes (Write Registry Key)" &vbCrLf& "Registry Key: " & strRegPath &vbCrLf& "Registry Value: " & strRegValue &vbCrLf& "Registry Type: " & strRegType &vbCrLf End If
  ElseIf (boolDebug) Then
    WScript.Echo "SetReg= Failed (One of the Parameter(s) is Empty)" &vbCrLf& "RegPath: " &strRegPath&vbCrLf& "RegValue: " &strRegValue&vbCrLf& "RegType: " &strRegType &vbCrLf
  End If ' Check on parameters empty
End Sub 

' Procedure: SetRegCUBin
' Does: Writes the registry information.
' ----------------------------------------------------------
Public Sub SetRegCUBin(strRegPath, strRegName, arrRegValues)
  If (strRegPath <> "") And (strRegName <> "") Then
    ' Declare variables and set initial value.
    Const HKEY_CLASSES_ROOT  = &H80000000
    Const HKEY_CURRENT_USER  = &H80000001
    Const HKEY_LOCAL_MACHINE = &H80000002
    Const HKEY_USERS         = &H80000003
    Const HKEY_CURRENT_CONFIG= &H80000005
    Const HKEY_DYN_DATA      = &H80000006
    Dim strComputer, ObjRegistry, errReturn
    strComputer = "."  
    Set objRegistry = GetObject ("winmgmts:\\" & strComputer & "\root\default:StdRegProv")
    ' Write the Registry information.
    errReturn = objRegistry.CreateKey (HKEY_CURRENT_USER, strRegPath)
    errReturn = objRegistry.SetBinaryValue (HKEY_CURRENT_USER, strRegPath, strRegName, arrRegValues)
    If (boolDebug) Then WScript.Echo "SetRegCUBin: Succes (Write Registry Key)" &vbCrLf& "Registry Key: " & strRegPath &vbCrLf& "Registry Name: " & strRegName &vbCrLf& "Registry Value: " &vbCrLf End If
  ElseIf (boolDebug) Then
    WScript.Echo "SetRegCUBin= Failed (One of the Parameter(s) is Empty)" &vbCrLf& "RegPath: " &strRegPath&vbCrLf& "RegName: " &strRegName&vbCrLf& "RegValue: "  &vbCrLf
  End If ' Check on parameters empty
End Sub 

' Procedure: RunCommand
' Does: Runs the command.
' ----------------------------------------------------------
Public Sub RunCommand(strCommand, strParameters)
  If (strCommand <> "") And (strParameters <> "") Then
    ' Declare variables and set initial value.
    Dim WsShell
    Set WsShell = WScript.CreateObject("WScript.Shell")
    ' Run the command.
    WsShell.Run strCommand &" "& strParameters
  ElseIf (boolDebug) Then
    WScript.Echo "RunCommand= Failed (One of the Parameter(s) is Empty)" &vbCrLf& "Command: " &strCommand&vbCrLf& "Paramaters: " &strParameters &vbCrLf
  End If ' Check on parameters empty
End Sub 

' Procedure: GetEnv
' Does: Returns the value of the environment variable.
' ----------------------------------------------------------
Public Function GetEnv(strVariable)
  If (strVariable <> "") Then
    ' Declare variables and set initial value.
    Dim WsShell
    Set WsShell = WScript.CreateObject("WScript.Shell")
    GetEnv = WsShell.ExpandEnvironmentStrings("%"+strVariable+"%")
    Set WsShell = Nothing    
  ElseIf (boolDebug) Then
    WScript.Echo "GetEnv= Failed (One of the Parameter(s) is Empty)" &vbCrLf& "Variable: " &strVariable &vbCrLf
  End If ' Check on parameters empty
End Function 

' Procedure: SetEnv
' Does: Set's the value of the environment variable for the duration of this script.
' ----------------------------------------------------------
Public Function SetEnv(strVariable, strValue)
  If (strVariable <> "") Then
    ' Declare variables and set initial value.
    Dim WsShell
    Set WsShell = WScript.CreateObject("WScript.Shell")
    'Only during this script!
    WSHShell.Environment.item(strVariable) = strValue
    Set WsShell = Nothing    
  ElseIf (boolDebug) Then
    WScript.Echo "SetEnv= Failed (One of the Parameter(s) is Empty)" &vbCrLf& "Variable: " &strVariable &vbCrLf
  End If ' Check on parameters empty
End Function 

' Procedure: SetUserAppAssoc
' Does: Set's the value of the environment variable for the duration of this script.
' ----------------------------------------------------------
  ' Application: Set registery for MoneyWorks 4.
  ' ----------------------------------------------------------
Public Function SetUserAppAssoc(strExtention, strFileDecription, strApplication, strIcon)
  If (strExtention <> "") and (strFileDecription <> "") and (strApplication <> "") Then
    Dim strRegPath, strRegValue
    strRegPath = "HKCU\Software\Classes\"
    ' -- .mwd3\"
    ' -- Adjust File Extention
    strRegValue = ""& GetReg(strRegPath &"."& strExtention & "\")
    If (strRegValue = "") Or (strRegValue <> strExtention & "_auto_file") Then 
      If (boolDebug) Then WScript.Echo "SetUserAppAssoc: Set "&strExtention&" file assoc" &vbCrlf& "Previous Reg Value: " &strRegValue &vbCrLf
      SetReg strRegPath &"."& strExtention & "\", strExtention & "_auto_file", "REG_SZ"
    End If
    ' -- mwd3_auto_file\"
    ' -- Adjust File Description
    strRegValue = ""& GetReg(strRegPath & strExtention & "_auto_file\")
    If (strRegValue = "") Or (strRegValue <> strFileDecription) Then 
      If (boolDebug) Then WScript.Echo "SetUserAppAssoc: Set "&strExtention&" file assoc description" &vbCrlf& "Previous Reg Value: " &strRegValue &vbCrLf
      SetReg strRegPath& strExtention & "_auto_file\", strFileDecription, "REG_SZ"
    End If
    ' -- mwd3_auto_file\shell\open\command\"
    ' -- Adjust File Application
    strRegValue = ""& GetReg(strRegPath & strExtention & "_auto_file\shell\open\command\")
    If (strRegValue = "") Or (strRegValue <> """"&strApplication&""" ""%1""") Then 
      If (boolDebug) Then WScript.Echo "SetUserAppAssoc: Set "&strExtention&" file assoc application" &vbCrlf& "Previous Reg Value: " &strRegValue &vbCrLf
      SetReg strRegPath & strExtention & "_auto_file\shell\open\command\", """"&strApplication&""" ""%1""", "REG_SZ"
    End If
    ' -- mwd3_auto_file\DefaultIcon\"
    ' -- Adjust File Icon
    strRegValue = ""& GetReg(strRegPath & strExtention & "_auto_file\DefaultIcon\")
    If (strRegValue = "") Or (strRegValue <> strIcon) Then 
      If (boolDebug) Then WScript.Echo "SetUserAppAssoc: Set "&strExtention&" file assoc icon" &vbCrlf& "Previous Reg Value: " &strRegValue &vbCrLf
      SetReg strRegPath & strExtention & "_auto_file\DefaultIcon\", strIcon, "REG_SZ"
    End If
  ElseIf (boolDebug) Then
    WScript.Echo "SetUserAppAssoc= Failed (One of the Parameter(s) is Empty)" &vbCrLf& "Extention: " &strExtention &vbCrLf& "File Description: " &strFileDecription &vbCrLf& "Application: " &strApplication &vbCrLf
  End If ' Check on parameters empty
End Function 

' ----------------------------------------------------------
' The Library part of the Script Finishes here. Now we get to the Actions part.
' ----------------------------------------------------------

