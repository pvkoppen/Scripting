' Name        : LoginScript.vbs
' Description : Login script for domain TOL.local.
' Author      : Peter van Koppen,  Tui Ora Ltd
' ----------------------------------------------------------

' ----------------------------------------------------------
' Change Log.
' ----------------------------------------------------------
' 2007-09-20: Version 1.0 of this logon script
' 2008-01-14: Added Procedures: GetEnv and SetEnv
' 2008-02-11: Addes WshShell.Popup Info
' 2008-05-15: Added TRP Finance group Z drive. TOL and TRP users have Access
' 2008-06-03: Added Kaiawhina (KAI) organisation
' 2008-06-06: Added Karangaora Inc (KOI) organisation
' 2008-06-19: Added Function SetEnv and this Changelog and upgraded Loginscript version to 1.1
' 2008-09-23: v1.2: Added new function: SetDefaultPrinter
' 2009-01-12: v1.2a: Added KOI Medtech entries
' 2009-04-21: v1.2b: Added TOL-HTPHO-YTS combo group
' 2009-06-15: 1.2c: Added Setup for TIR office.
' 2009-07-13: 1.2d: Added Printer for MOL TPK office.
' 2009-09-25: 1.2e: Added Printer for TAM.
' 2009-10-06: 1.2f: Added Printer for TOL/HTPHO.
' 2009-10-12: 1.2g: Added MoneyWorks for PTO.
' 2009-11-13: 1.2h: Added YTS Hawera printer to TRP.
' 2009-11-13: 1.2i: Added YTS Waitara printer.
' 2009-12-15: 1.2j: Added TAM BPAC Cert script.
' 2009-12-21: 1.2k: Added Org: TIHI.
' 2010-01-08: 1.2l: Fixed Moneyworks File Assoc code
' 2010-01-11: 1.2m: Added Printer Code Assignment and SetRegCUBin
' 2010-01-20: 1.2n: Changed T: target of Domain Admins to TOLOCS01
' 2010-02-10: 1.2o: Testing HTPHO/TOL Shared G Drive.
' 2010-02-11: 1.3: Added orgs: Avenue (AMC), Better Homes (BH) and Mahia Mai (MMAWT).
' 2010-02-10: 1.3a: Implementing HTPHO/TOL Shared G Drive.
' 2010-02-25: 1.3b: Added YTS Waitara printer (move from YTS Hawera).
' 2010-03-xx: 1.3c: 
' 2010-03-04: 1.3d: Added RHT Mapuna Printer.
' 2010-03-05: 1.3e: Added BH Ricoh Printer.
' 2010-03-18: 1.4: Fixed an issue with the login script when a user is not correctly logged on.
' 2010-03-31: 1.4a: Remove Old YTS Printers, Change YTS&TOL settings, Remove HTPHO&TOL&YTS Section.
' 2010-04-14: 1.4b: Added 2 Brother 2150n printers for TRP
' 2010-06-04: 1.5: Added org: Te Atiawa (TAHL)
' 2010-07-07: 1.5a: Updated YTS printer
' 2010-07-07: 1.5b: Added TAHL printer
' 2010-07-30: 1.5c: Added TAA printer
' 2010-09-02: 1.5d: Added TRP BW CM Office Printer
' 2010-09-07: 1.5e: Add TOL MH Drive
' 2010-09-17: 1.5f: Updated THPH Printer
' 2010-09-21: 1.5g: Added TAM Doc2 Printer
' 2010-11-05: 1.5h: Replace MOL Brother with MK C35 Printer
' 2010-11-22: 1.5i: Added THPH Reception Printer
' 2010-11-22: 1.5j: Added TAM Nurse Printers
' 2010-11-23: 1.5k: Added THPH Carleen Printer & Removed KaiAwhina Organisation
' 2010-11-23: 1.5l: Updated Merle's Printer
' 2010-12-14: 1.5m: Added MOL Fax Driver
' 2010-12-15: 1.5n: Added Tihi Brother Driver
' 2010-12-15: 1.50: Added TOL HR Brother Printer
' 2010-12-15: 1.5p: Added PTO Clinic Brother Printer
' 2011-03-17: 1.5q: Updated KOI Printer. (TOLFP01) & Adjusted SYS account to use TOLFP01
' 2011-04-13: 1.5r: Added combo group RHT & TRP.
' 2011-05-03: 1.5s: Moved Finance printer to TOLFP01
' 2011-05-10: 1.5t: Changed naming for System (SYS) Users group.
' 2011-05-11: 1.5u: Removed K drive (MOLMH), Merged TOL and TRP drives.
' 2011-05-11: 1.6: Added Procedure: RemoveDriveLetter
' 2011-05-11: 1.6a: Added YTS Colour Printer
' 2011-05-19: 1.6b: Updated guest printer group(s).
' 2011-05-21: 1.6c: Add TOL Mgnmt printer group(s). (and Updated)
' 2011-06-08: 1.6d: Added TRP&TOL, PTO&TOL, MOL&TOL sections
' 2011-06-14: 1.6e: Added TOL Provider Arm K drive
' 2011-06-28: 1.6f: Migrate TOL and HTPHO Profile and Home folders.
' 2011-06-29: 1.6g: Migrate Profile and Home folders for: AMC, BH, KOI, MOL.
' 2011-06-30: 1.6h: Migrate Profile and Home folders for: PTO, RHT, TAHL, TAM, THPH, TIHI, TIR, TRP, YTS.
' 2011-07-05: 1.6i: Migrate from TOLSS01 to TOLFP01: Applications.
' 2011-07-07: 1.6j: Migrate from TOLSS01 to TOLFP01: Printers.
' 2011-07-11: 1.6k: Migrate from TOLPT01 to TOLFP01: Applications.
' 2011-07-12: 1.6l: Migrate from TOLSS01 to TOLFP01: TAHL.
' 2011-07-18: 1.6m: Migrate from TOLSS01 to TOLFP01: ALL.
' 2011-07-19: 1.6n: Added Drive removal script to remap drives correctly.
' 2011-07-20: 1.6o: Migrate from TOLSS01 to TOLFP01: TOL&TRP&HTPHO.
' 2011-07-21: 1.6p: Migrate from TOLSS01 to TOLFP01: BH, KOI, MOL, PAT & PTO.
' 2011-07-30: 1.6q: Migrate from TOLSS01 to TOLFP01: THPH, TIHI & TIR. (RHT &YTS to go)
' 2011-08-02: 1.6r: Migrate from TOLSS01 to TOLFP01: RHT & YTS.
' 2011-09-16: 1.6s: Migrated TAM print Queue's
' 2011-09-23: 1.6s: Added Drive mapping for Members of TOL Medtech Users.
' 2011-10-12: 1.6t: Remove MOL TPK and MOL Hawera printer.
' 2011-10-26: 1.6u: Merged some changes from NR
' 2011-10-31: 1.6v: Added Organization: Auaha
' 2011-11-14: 1.6w: Add drive mappings for Servers. When on TAMMT01 map TAMMT01\MT32
' 2011-11-18: 1.6x: Auaha: Add drive mapping to S for sharepoint
' 2012-01-09: 1.6y: Remove Organization: KOI
' 2012-02-01: 1.6z: Remove Organization: HTPHO
' 2012-02-17: 1.6aa: Added MOL printer to Piki Staff
' 2012-02-21: 1.6ab: Added TOL Finance and TOL Central printers
' 2012-02-21: 1.6ac: Migrated Users folder to TOL: MOL, PTO, RHT, TRP
' 2012-02-27: 1.6ad: Renamed MOL printer to: TOL Wellness BW
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
' J: = Terminal Server Home drive (Part of Users Terminal Server profile).
' K: = TOL Provider Arm Transition Group K drive.
' M: = TAM Medtech / Tihi Apps / Auaha Apps
' N: = \\TOLSS01\d$ for Admins
' P: = Attache.
' S: = Shared drive, accessible by all Tui Ora Ltd Network users. / AUAHA Sharepoint
' T: = TRP Equip / TOL Software / TihiMedia.
' U: = TOL Altiris 
' Z: = TOL HR / THPH Caduceus / TRP Moneyworks / PTO Moneyworks.


' Define all the Organisational groups.
' Group names must be in FULL DN notation Or in short group name
' ----------------------------------------------------------
Dim grpMOLUsers,   grpPTOUsers,   grpRHTUsers,   grpAUAHAUsers
Dim grpTAMUsers,   grpTHPHUsers,  grpTOLUsers,   grpTRPUsers,   grpYTSUsers,   grpSYSTEMUsers
Dim grpTIRUsers,   grpTIHIUsers,  grpAMCUsers,   grpBHUsers,    grpMMAWTUsers, grpTAHLUsers
grpAMCUsers   = "CN=Avenue Medical Center (AMC) Users,OU=AMC,DC=TOL,DC=LOCAL"
grpAUAHAUsers = "CN=Auaha Ltd (AUAHA) Users,OU=AUAHA,DC=TOL,DC=LOCAL"
grpBHUsers    = "CN=Better Homes (BH) Users,OU=BH,DC=TOL,DC=LOCAL"
grpMMAWTUsers = "CN=Mahia Mai A Whai Tara (MMAWT) Users,OU=MMAWT,DC=TOL,DC=LOCAL"
grpMOLUsers   = "CN=Manaaki Oranga Ltd (MOL) Users,OU=MOL,DC=TOL,DC=LOCAL"
grpPTOUsers   = "CN=Piki Te Ora (PTO) Users,OU=PTO,DC=TOL,DC=LOCAL"
grpRHTUsers   = "CN=Raumano Health Trust (RHT) Users,OU=RHT,DC=TOL,DC=LOCAL"
grpTAMUsers   = "CN=Te Aroha Medcare (TAM) Users,OU=TAM,DC=TOL,DC=LOCAL"
grpTAHLUsers  = "CN=Te Atiawa Holdings Ltd (TAHL) Users,OU=TAHL,DC=TOL,DC=LOCAL"
grpTHPHUsers  = "CN=Te Hauora Pou Heretanga (THPH) Users,OU=THPH,DC=TOL,DC=LOCAL"
grpTIHIUsers  = "CN=Tihi Ltd (TIHI) Users,OU=TIHI,DC=TOL,DC=LOCAL"
grpTIRUsers   = "CN=Te Ihi Rangi (TIR) Users,OU=TIR,DC=TOL,DC=LOCAL"
grpTOLUsers   = "CN=Tui Ora Ltd (TOL) Users,OU=TOL,DC=TOL,DC=LOCAL"
grpTRPUsers   = "CN=Te Rau Pani (TRP) Users,OU=TRP,DC=TOL,DC=LOCAL"
grpYTSUsers   = "CN=Youth Transition Service (YTS) Users,OU=YTS,DC=TOL,DC=LOCAL"
grpSYSTEMUsers= "CN=System (SYS) Users,OU=Global Security Entities,DC=TOL,DC=LOCAL"


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
If (IsMember(strUserDNName, grpTOLUsers) And IsMember(strUserDNName, grpYTSUsers)) Then ' --- TOL and YTS
  ' Remove Old Printer Drivers
  'RemovePrinter("")
  ' Add New Printer Drivers
  MapPrinter("\\tolfp01\TOL Color RICOH Central")
  MapPrinter("\\tolfp01\TOL Central")
  MapPrinter("\\tolfp01\YTS Hawera Central BW")
  MapPrinter("\\tolfp01\YTS Hawera Colour")
  MapPrinter("\\tolfp01\YTS NP BW")
  MapPrinter("\\tolfp01\YTS NP Color HP Business Inkjet 1200")
  MapPrinter("\\tolfp01\YTS Waitara Central")
  SetRegCUBin "Software\RICOH\JOBCODE\JCUserCode", "\\tolfp01\TOL Color RICOH Central", Array(118,97,63,142,172,6,152,157)  'hex:76,61,3f,8e,ac,06,98,9d=5050
  SetRegCUBin "Software\RICOH\JOBCODE\JCUserCode", "\\tolfp01\TOL Central", Array(118,97,63,142,172,6,152,157)  'hex:76,61,3f,8e,ac,06,98,9d=5050
  ' Add Drive Mappings
  MapDriveLetter "G", "\\tolfp01\SharedTOL$" 
  MapDriveLetter "I", "\\tolfp01\SharedYTS$"
  MapDriveLetter "H", "\\tolfp01\UsersTOL$\" & strUserName & "\Documents"
  MapDriveLetter "S", "\\tolfp01\SharedProviders$"

ElseIf (IsMember(strUserDNName, grpRHTUsers) And IsMember(strUserDNName, grpTRPUsers)) Then ' --- RHT & TRP
  ' Remove Old Printer Drivers
  ' Add New Printer Drivers
  MapPrinter("\\tolfp01\RHT BW FX DocuCentre-II C3000")
  MapPrinter("\\tolfp01\RHT Mapuna Central")
  MapPrinter("\\tolfp01\TRP BW KONICA MINOLTA C253")
  MapPrinter("\\tolfp01\TRP Hawera BW")
  MapPrinter("\\tolfp01\TRP BW GM Office")
  MapPrinter("\\tolfp01\TRP BW OM Office")
  MapPrinter("\\tolfp01\TRP BW CM Office")
  ' Add Drive Mappings
  MapDriveLetter "G", "\\tolfp01\SharedRHT$"
  MapDriveLetter "H", "\\tolfp01\UsersRHT$\" & strUserName & "\Documents"
  MapDriveLetter "I", "\\tolfp01\SharedTOL$"
  MapDriveLetter "S", "\\tolfp01\SharedProviders$"

ElseIf (IsMember(strUserDNName, grpTOLUsers) And IsMember(strUserDNName, grpTRPUsers)) Then ' --- TRP & TOL
  ' Add New Printer Drivers
  MapPrinter("\\tolfp01\TOL Color RICOH Central")
  MapPrinter("\\tolfp01\TOL Central")
  SetRegCUBin "Software\RICOH\JOBCODE\JCUserCode", "\\tolfp01\TOL Color RICOH Central", Array(118,97,63,142,172,6,152,157)  'hex:76,61,3f,8e,ac,06,98,9d=5050
  SetRegCUBin "Software\RICOH\JOBCODE\JCUserCode", "\\tolfp01\TOL Central", Array(118,97,63,142,172,6,152,157)  'hex:76,61,3f,8e,ac,06,98,9d=5050
  ' Add Drive Mappings
  MapDriveLetter "G", "\\tolfp01\SharedTOL$"
  MapDriveLetter "H", "\\tolfp01\UsersTOL$\" & strUserName & "\Documents"
  MapDriveLetter "S", "\\tolfp01\SharedProviders$"

ElseIf (IsMember(strUserDNName, grpTOLUsers) And IsMember(strUserDNName, grpPTOUsers)) Then ' --- PTO & TOL
  ' Add New Printer Drivers
  MapPrinter("\\tolfp01\TOL Color RICOH Central")
  MapPrinter("\\tolfp01\TOL Central")
  SetRegCUBin "Software\RICOH\JOBCODE\JCUserCode", "\\tolfp01\TOL Color RICOH Central", Array(118,97,63,142,172,6,152,157)  'hex:76,61,3f,8e,ac,06,98,9d=5050
  SetRegCUBin "Software\RICOH\JOBCODE\JCUserCode", "\\tolfp01\TOL Central", Array(118,97,63,142,172,6,152,157)  'hex:76,61,3f,8e,ac,06,98,9d=5050
  ' Add Drive Mappings
  MapDriveLetter "G", "\\TOLfp01\SharedPTO$" 
  MapDriveLetter "I", "\\tolfp01\SharedTOL$"
  MapDriveLetter "H", "\\tolfp01\UsersTOL$\" & strUserName & "\Documents"
  MapDriveLetter "S", "\\tolfp01\SharedProviders$"

ElseIf (IsMember(strUserDNName, grpTOLUsers) And IsMember(strUserDNName, grpMOLUsers)) Then ' --- MOL & TOL
  ' Add New Printer Drivers
  MapPrinter("\\tolfp01\TOL Color RICOH Central")
  MapPrinter("\\tolfp01\TOL Central")
  MapPrinter("\\tolfp01\MOL BW HP LaserJet 4100")
  MapPrinter("\\tolfp01\TOL Wellness BW")
  MapPrinter("\\tolfp01\MOL BW Central")
  MapPrinter("\\tolfp01\MOL BW Central Fax")
  SetRegCUBin "Software\RICOH\JOBCODE\JCUserCode", "\\tolfp01\TOL Color RICOH Central", Array(118,97,63,142,172,6,152,157)  'hex:76,61,3f,8e,ac,06,98,9d=5050
  SetRegCUBin "Software\RICOH\JOBCODE\JCUserCode", "\\tolfp01\TOL Central", Array(118,97,63,142,172,6,152,157)  'hex:76,61,3f,8e,ac,06,98,9d=5050
  ' Add Drive Mappings
  MapDriveLetter "G", "\\TOLfp01\SharedMOL$" 
  MapDriveLetter "I", "\\tolfp01\SharedTOL$"
  MapDriveLetter "H", "\\tolfp01\UsersTOL$\" & strUserName & "\Documents"
  MapDriveLetter "S", "\\tolfp01\SharedProviders$"

ElseIf IsMember(strUserDNName, grpAMCUsers) Then ' --- Avenue Medical
  ' Remove Old Printer Drivers
  ' Add New Printer Drivers
  ' Add Drive Mappings
  MapDriveLetter "G", "\\tolfp01\SharedAMC$"
  MapDriveLetter "H", "\\tolfp01\UsersAMC$\" &strUserName & "\Documents"
  MapDriveLetter "S", "\\tolfp01\SharedProviders$"

ElseIf IsMember(strUserDNName, grpAUAHAUsers) Then ' --- Auaha Ltd
  ' Remove Old Printer Drivers
  ' Add New Printer Drivers
  MapPrinter("\\tolfp01\AUAHA NPL Central")
  MapPrinter("\\tolfp01\AUAHA WLG Central")
  ' Add Drive Mappings
  MapDriveLetter "G", "\\tolfp01\SharedAUAHA$"
  MapDriveLetter "H", "\\tolfp01\UsersAUAHA$\" &strUserName & "\Documents"
  MapDriveLetter "M", "\\auahas01\Applications$"
  MapDriveLetter "S", "\\auahaweb.tol.local\DavWWWRoot"

ElseIf IsMember(strUserDNName, grpBHUsers) Then ' --- Better Homes
  ' Remove Old Printer Drivers
  ' Add New Printer Drivers
  MapPrinter("\\tolfp01\BH RICOH Aficio C2500")
  ' Add Drive Mappings
  MapDriveLetter "G", "\\tolfp01\SharedBH$"
  MapDriveLetter "H", "\\tolfp01\UsersBH$\" &strUserName & "\Documents"

ElseIf IsMember(strUserDNName, grpMMAWTUsers) Then ' --- Mahia Mai A Whai Tara
  ' Remove Old Printer Drivers
  ' Add New Printer Drivers
  ' Add Drive Mappings
  MapDriveLetter "G", "\\tolfp01\SharedMMAWT$"
  MapDriveLetter "H", "\\tolfp01\UsersMMAWT$\" &strUserName& "\Documents"
  MapDriveLetter "S", "\\tolfp01\SharedProviders$"

ElseIf IsMember(strUserDNName, grpMOLUsers) Then ' --- Manaaki Oranga Ltd
  ' Remove Old Printer Drivers
  ' Add New Printer Drivers
  MapPrinter("\\tolfp01\MOL BW HP LaserJet 4100")
  MapPrinter("\\tolfp01\TOL Wellness BW")
  MapPrinter("\\tolfp01\MOL BW Central")
  MapPrinter("\\tolfp01\MOL BW Central Fax")
  ' Add Drive Mappings
  MapDriveLetter "G", "\\tolfp01\SharedMOL$"
  MapDriveLetter "H", "\\tolfp01\UsersTOL$\" & strUserName & "\Documents"
  MapDriveLetter "S", "\\tolfp01\SharedProviders$"

ElseIf IsMember(strUserDNName, grpPTOUsers) Then ' --- Piki Te Ora
  ' Remove Old Printer Drivers
  ' Add New Printer Drivers
  MapPrinter("\\tolfp01\MOL BW Central")
  MapPrinter("\\tolfp01\PTO Clinic BW")
  'MapPrinter("Clinical area: Dymo LabelWriter 400 Turbo")
  ' Add Drive Mappings
  MapDriveLetter "G", "\\tolfp01\SharedPTO$"
  MapDriveLetter "H", "\\tolfp01\UsersTOL$\" & strUserName & "\Documents"
  MapDriveLetter "S", "\\tolfp01\SharedProviders$"

ElseIf IsMember(strUserDNName, grpRHTUsers) Then ' --- Raumano Health Trust
  ' Remove Old Printer Drivers
  'RemovePrinter("")
  ' Add New Printer Drivers
  MapPrinter("\\tolfp01\RHT BW FX DocuCentre-II C3000")
  MapPrinter("\\tolfp01\RHT BW")
  MapPrinter("\\tolfp01\RHT Mapuna Central")
  'MapPrinter("Mihi: HP LaserJet 2200DN")
  'MapPrinter("Reception: HP DeskJet 710C")
  'MapPrinter("Reception: Dymo LabelWriter 330 Turbo")
  ' Add Drive Mappings
  MapDriveLetter "G", "\\tolfp01\SharedRHT$"
  If IsMember(strUserDNName, "Tui Ora Ltd (TOL) Provider Arm Users") Then
    MapDriveLetter "H", "\\tolfp01\UsersTOL$\" & strUserName & "\Documents"
  Else
    MapDriveLetter "H", "\\tolfp01\UsersRHT$\" & strUserName & "\Documents"
  End If
  MapDriveLetter "S", "\\tolfp01\SharedProviders$"

ElseIf IsMember(strUserDNName, grpTAMUsers) Then ' --- Te Aroha Medcare
  ' Remove Old Printer Drivers
  'RemovePrinter("")
  ' Add New Printer Drivers
  MapPrinter("\\tolfp01\TAM-A4-HPLaserJetM2727")
  MapPrinter("\\tolfp01\TAM-A5-HPLaserJetM2727")
  MapPrinter("\\tolfp01\TAM-A4DOC1-HL-5350DN")
  MapPrinter("\\tolfp01\TAM-A5DOC1-HL-5350DN")
  MapPrinter("\\tolfp01\TAM A5 Doc2")
  MapPrinter("\\tolfp01\TAM A4 Doc2")
  MapPrinter("\\tolfp01\TAM A4 Nurse1")
  MapPrinter("\\tolfp01\TAM A5 Nurse1")
  ' Add Drive Mappings
  MapDriveLetter "G", "\\tolfp01\SharedTAM$"
  MapDriveLetter "H", "\\tolfp01\UsersTAM$\" & strUserName & "\Documents"
  MapDriveLetter "S", "\\tolfp01\SharedProviders$"

ElseIf IsMember(strUserDNName, grpTAHLUsers) Then ' --- Te Atiawa
  ' Remove Old Printer Drivers
  ' Add New Printer Drivers
  MapPrinter("\\tolfp01\TAHL Central")
  ' Add Drive Mappings
  MapDriveLetter "G", "\\tolfp01\SharedTAHL$"
  MapDriveLetter "H", "\\tolfp01\UsersTAHL$\" & strUserName & "\Documents"

ElseIf IsMember(strUserDNName, grpTHPHUsers) Then ' --- Te Hauora Pou Heretanga
  ' Remove Old Printer Drivers
  ' Add New Printer Drivers
  MapPrinter("\\tolfp01\THPH Central Staffroom")
  MapPrinter("\\tolfp01\THPH KONICA MINOLTA C200")
  ' Add Drive Mappings
  MapDriveLetter "G", "\\tolfp01\SharedTHPH$"
  MapDriveLetter "H", "\\tolfp01\UsersTHPH$\" & strUserName & "\Documents"
  MapDriveLetter "S", "\\tolfp01\SharedProviders$"

ElseIf IsMember(strUserDNName, grpTIHIUsers) Then ' --- Tihi Ltd
  ' Remove Old Printer Drivers
  ' Add New Printer Drivers
  MapPrinter("\\tolfp01\TIHI BW Reception")
  ' Add Drive Mappings
  MapDriveLetter "G", "\\tolfp01\SharedTIHI$"
  MapDriveLetter "H", "\\tolfp01\UsersTIHI$\" & strUserName & "\Documents"
  MapDriveLetter "M", "\\tihis01\Applications$"
  MapDriveLetter "S", "\\tolfp01\SharedProviders$"
  MapDriveLetter "T", "\\tolvs01.tol.local\TihiMedia$"

ElseIf IsMember(strUserDNName, grpTIRUsers) Then ' --- Te Ihi Rangi
  ' Add New Printer Drivers
  MapPrinter("\\tolfp01\TIR RICOH Aficio 1027")
  'MapPrinter("Frances: Brother DCP-130C")
  ' Add Drive Mappings
  MapDriveLetter "G", "\\tolfp01\SharedTIR$"
  MapDriveLetter "H", "\\tolfp01\UsersTIR$\" & strUserName & "\Documents"
  MapDriveLetter "S", "\\tolfp01\SharedProviders$"

ElseIf IsMember(strUserDNName, grpTOLUsers) Then ' --- Tui Ora Limited
  ' Remove Old Printer Drivers
  ' Add New Printer Drivers
  MapPrinter("\\tolfp01\TOL Color RICOH Central")
  MapPrinter("\\tolfp01\TOL Central")
  SetRegCUBin "Software\RICOH\JOBCODE\JCUserCode", "\\tolfp01\TOL Color RICOH Central", Array(118,97,63,142,172,6,152,157)  'hex:76,61,3f,8e,ac,06,98,9d=5050
  SetRegCUBin "Software\RICOH\JOBCODE\JCUserCode", "\\tolfp01\TOL Central", Array(118,97,63,142,172,6,152,157)  'hex:76,61,3f,8e,ac,06,98,9d=5050
  ' Add Drive Mappings
  MapDriveLetter "G", "\\tolfp01\SharedTOL$" 
  MapDriveLetter "H", "\\tolfp01\UsersTOL$\" & strUserName & "\Documents"
  MapDriveLetter "S", "\\tolfp01\SharedProviders$"

ElseIf IsMember(strUserDNName, grpTRPUsers) Then ' --- Te Rau Pani
  ' Remove Old Printer Drivers
  ' Add New Printer Drivers
  MapPrinter("\\tolfp01\TRP BW KONICA MINOLTA C253")
  MapPrinter("\\tolfp01\TRP BW GM Office")
  MapPrinter("\\tolfp01\TRP BW OM Office")
  MapPrinter("\\tolfp01\TRP BW CM Office")
  MapPrinter("\\tolfp01\RHT BW FX DocuCentre-II C3000")
  ' Add Drive Mappings
  MapDriveLetter "G", "\\tolfp01\SharedTOL$"
  MapDriveLetter "H", "\\tolfp01\UsersTOL$\" & strUserName & "\Documents"
  MapDriveLetter "S", "\\tolfp01\SharedProviders$"

ElseIf IsMember(strUserDNName, grpYTSUsers) Then ' --- Youth Transitional Services
  ' Remove Old Printer Drivers
  ' Add New Printer Drivers
  MapPrinter("\\tolfp01\YTS Hawera Central BW")
  MapPrinter("\\tolfp01\YTS Hawera Colour")
  MapPrinter("\\tolfp01\YTS NP BW")
  MapPrinter("\\tolfp01\YTS NP Color HP Business Inkjet 1200")
  MapPrinter("\\tolfp01\YTS Waitara Central")
  ' Add Drive Mappings
  MapDriveLetter "G", "\\tolfp01\SharedYTS$"
  MapDriveLetter "H", "\\tolfp01\UsersYTS$\" & strUserName & "\Documents"
  MapDriveLetter "S", "\\tolfp01\SharedProviders$"

ElseIf IsMember(strUserDNName, grpSYSTEMUsers) Then ' --- System Accounts
  ' Remove Old Printer Drivers
  ' Add New Printer Drivers
  MapPrinter("\\tolfp01\TOL Color RICOH Central")
  MapPrinter("\\tolfp01\TOL Central")
  SetRegCUBin "Software\RICOH\JOBCODE\JCUserCode", "\\tolfp01\TOL Color RICOH Central", Array(118,97,63,142,172,6,152,157)  'hex:76,61,3f,8e,ac,06,98,9d=5050
  SetRegCUBin "Software\RICOH\JOBCODE\JCUserCode", "\\tolfp01\TOL Central", Array(118,97,63,142,172,6,152,157)  'hex:76,61,3f,8e,ac,06,98,9d=5050
  ' Add Drive Mappings
  MapDriveLetter "G", "\\tolfp01\SharedSYS$"
  MapDriveLetter "H", "\\tolfp01\UsersSYS$\" & strUserName & "\Documents"
  MapDriveLetter "S", "\\tolfp01\SharedProviders$"
Else
  If (boolDebug) Then WScript.Echo "You do not belong to any Provider groups." &vbCrLf
End If


' Cleanup Printer Migration
IF (True) then
'BH
  RemovePrinter("\\tolss01.tol.local\BH RICOH Aficio C2500")
  RemovePrinter("\\tolss01\BH RICOH Aficio C2500")
'HTPHO
  RemovePrinter("\\tolss01.tol.local\HTPHO-TOL RICOH Aficio Replacement")
  RemovePrinter("\\tolss01\HTPHO-TOL RICOH Aficio Replacement")
  RemovePrinter("\\tolss01.tol.local\HTPHO Color RICOH Aficio 3260C")
  RemovePrinter("\\tolss01\HTPHO Color RICOH Aficio 3260C")
  RemovePrinter("\\tolss01.tol.local\HTPHO HP LaserJet 2300")
  RemovePrinter("\\tolss01\HTPHO HP LaserJet 2300")
  RemovePrinter("\\tolss01.tol.local\HTPHO Color RICOH Central")
  RemovePrinter("\\tolss01\HTPHO Color RICOH Central")
  RemovePrinter("\\HTPHO32.tol.local\HTPHO HP Officejet 7100") 
  RemovePrinter("\\HTPHO32\HTPHO HP Officejet 7100") 
'MOL
  RemovePrinter("\\tolss01.tol.local\MOR BW HP Laserjet 4000")
  RemovePrinter("\\tolss01\MOR BW HP Laserjet 4000")
  RemovePrinter("\\tolss01.tol.local\MOL BW Brother MFC-7820N")
  RemovePrinter("\\tolss01\MOL BW Brother MFC-7820N")
  RemovePrinter("\\tolss01.tol.local\MOL BW Brother MFC-7440N")
  RemovePrinter("\\tolss01\MOL BW Brother MFC-7440N")
  RemovePrinter("\\tolss01.tol.local\MOL Hawera BW HP LaserJet 4000")
  RemovePrinter("\\tolss01\MOL Hawera BW HP LaserJet 4000")
  RemovePrinter("\\tolss01.tol.local\MOL TPK HP Color LaserJet CP1518")
  RemovePrinter("\\tolss01\MOL TPK HP Color LaserJet CP1518")
  RemovePrinter("\\tolss01.tol.local\MOL BW HP LaserJet 4100")
  RemovePrinter("\\tolss01\MOL BW HP LaserJet 4100")
  RemovePrinter("\\tolss01.tol.local\MOL Hawera BW")
  RemovePrinter("\\tolss01\MOL Hawera BW")
  RemovePrinter("\\tolss01.tol.local\MOL BW Central")
  RemovePrinter("\\tolss01\MOL BW Central")
  RemovePrinter("\\tolss01.tol.local\MOL BW Central Fax")
  RemovePrinter("\\tolss01\MOL BW Central Fax")
  RemovePrinter("\\tolfp01\MOL TPK HP Color LaserJet CP1518")
  RemovePrinter("\\tolfp01\MOL Hawera BW")
'PTO
  RemovePrinter("\\tolss01.tol.local\PTO BW HP LaserJet 1320")
  RemovePrinter("\\tolss01\PTO BW HP LaserJet 1320")
  RemovePrinter("\\tolss01.tol.local\PTO BW HP LaserJet 2100")
  RemovePrinter("\\tolss01\PTO BW HP LaserJet 2100")
  RemovePrinter("\\pto20.tol.local\DCP-8025D")
  RemovePrinter("\\pto20\DCP-8025D")
  RemovePrinter("\\pto20.tol.local\Brother DCP-8025D USB")
  RemovePrinter("\\pto20\Brother DCP-8025D USB")
  RemovePrinter("\\tolss01.tol.local\PTO Clinic BW HP LaserJet 2100")
  RemovePrinter("\\tolss01\PTO Clinic BW HP LaserJet 2100")
  'RemovePrinter("Clinical area: HP PSC 1510 All-in-One (Local Printer\Scanner only!)")
  RemovePrinter("\\tolss01.tol.local\PTO Admin BW HP LaserJet 1320")
  RemovePrinter("\\tolss01\PTO Admin BW HP LaserJet 1320")
  RemovePrinter("\\tolss01.tol.local\PTO Clinic Brother MFC-7440N")
  RemovePrinter("\\tolss01\PTO Clinic Brother MFC-7440N")
  RemovePrinter("\\tolss01.tol.local\PTO Admin Color")
  RemovePrinter("\\tolss01\PTO Admin Color")
  RemovePrinter("\\tolfp01\PTO Clinic Brother MFC-7440N")
  RemovePrinter("\\tolfp01\PTO Admin BW HP LaserJet 1320")
  RemovePrinter("\\tolfp01\PTO Admin Color")
'RHT
  RemovePrinter("\\tolss01.tol.local\RHT BW FX DocuCentre-II C3000")
  RemovePrinter("\\tolss01\RHT BW FX DocuCentre-II C3000")
  RemovePrinter("\\tolss01.tol.local\RHT Mapuna Central")
  RemovePrinter("\\tolss01\RHT Mapuna Central")
  RemovePrinter("\\tolss01.tol.local\RHT Color FX DocuCentre-II C3000")
  RemovePrinter("\\tolss01\RHT Color FX DocuCentre-II C3000")
'  RemovePrinter("\\tolfp01\RHT BW FX DocuCentre-II C3000")
'TAM
  RemovePrinter("\\tolss01.tol.local\TAM-A4-HPLaserJetM2727")
  RemovePrinter("\\tolss01\TAM-A4-HPLaserJetM2727")
  RemovePrinter("\\tolss01.tol.local\TAM-A5-HPLaserJetM2727")
  RemovePrinter("\\tolss01\TAM-A5-HPLaserJetM2727")
  RemovePrinter("\\tolss01.tol.local\TAM-A4DOC1-HL-5350DN")
  RemovePrinter("\\tolss01\TAM-A4DOC1-HL-5350DN")
  RemovePrinter("\\tolss01.tol.local\TAM-A5DOC1-HL-5350DN")
  RemovePrinter("\\tolss01\TAM-A5DOC1-HL-5350DN")
  RemovePrinter("\\tolss01.tol.local\TAM A5 Doc2")
  RemovePrinter("\\tolss01\TAM A5 Doc2")
  RemovePrinter("\\tolss01.tol.local\TAM A4 Doc2")
  RemovePrinter("\\tolss01\TAM A4 Doc2")
  RemovePrinter("\\tolss01.tol.local\TAM A4 Nurse1")
  RemovePrinter("\\tolss01\TAM A4 Nurse1")
  RemovePrinter("\\tolss01.tol.local\TAM A5 Nurse1")
  RemovePrinter("\\tolss01\TAM A5 Nurse1")
  RemovePrinter("\\GPSPZ0749.tol.local\A4TAMNurse1200") 
  RemovePrinter("\\GPSPZ0749\A4TAMNurse1200") 
  RemovePrinter("\\GPSPZ0749.tol.local\A5TAMNurse1200") 
  RemovePrinter("\\GPSPZ0749\A5TAMNurse1200") 
  RemovePrinter("\\TAM01.tol.local\A4TAMDoc1") 
  RemovePrinter("\\TAM01\A4TAMDoc1") 
  RemovePrinter("\\TAM01.tol.local\A5TAMDoc1") 
  RemovePrinter("\\TAM01\A5TAMDoc1") 
  RemovePrinter("\\TAM02.tol.local\A4TAMDoc2") 
  RemovePrinter("\\TAM02\A4TAMDoc2") 
  RemovePrinter("\\TAM02.tol.local\A5TAMDoc2") 
  RemovePrinter("\\TAM02\A5TAMDoc2") 
'TAHL
  RemovePrinter("\\tolss01.tol.local\TAHL Central")
  RemovePrinter("\\tolss01\TAHL Central")
'THPH
  RemovePrinter("\\tolss01.tol.local\THPH BW Minolta Di200")
  RemovePrinter("\\tolss01\THPH BW Minolta Di200")
  RemovePrinter("\\tolss01.tol.local\THPH BW KONICA MINOLTA BizHub 350")
  RemovePrinter("\\tolss01\THPH BW KONICA MINOLTA BizHub 350")
  RemovePrinter("\\tolss01.tol.local\THPH Color HP Officejet Pro K550")
  RemovePrinter("\\tolss01\THPH Color HP Officejet Pro K550")
  RemovePrinter("\\tolss01.tol.local\THPH Central Staffroom")
  RemovePrinter("\\tolss01\THPH Central Staffroom")
  RemovePrinter("\\tolss01.tol.local\THPH KONICA MINOLTA C200")
  RemovePrinter("\\tolss01\THPH KONICA MINOLTA C200")
  RemovePrinter("\\tolss01.tol.local\THPH Color Carleen")
  RemovePrinter("\\tolss01\THPH Color Carleen")
  RemovePrinter("\\tolss01.tol.local\THPH Reception")
  RemovePrinter("\\tolss01\THPH Reception")
'TIHI
  RemovePrinter("\\tolss01.tol.local\TIHI BW Reception")
  RemovePrinter("\\tolss01\TIHI BW Reception")
  RemovePrinter("\\TOLSS01.tol.local\TIHI BW Finance")
  RemovePrinter("\\TOLSS01\TIHI BW Finance")
  RemovePrinter("\\tolss01.tol.local\TIHI Color Reception")
  RemovePrinter("\\tolss01\TIHI Color Reception")
  RemovePrinter("\\tolfp01\TIHI BW Finance")
'TIR
  RemovePrinter("\\tolss01.tol.local\TIR RICOH Aficio 1027")
  RemovePrinter("\\tolss01\TIR RICOH Aficio 1027")
'TOL
  RemovePrinter("\\tolss01.tol.local\TOL Color RICOH Aficio 3260C")
  RemovePrinter("\\tolss01\TOL Color RICOH Aficio 3260C")
  RemovePrinter("\\tolss01.tol.local\TOL Color RICOH Central")
  RemovePrinter("\\tolss01\TOL Color RICOH Central")
  RemovePrinter("\\tolss01.tol.local\TOL Finance RICOH C410DN")
  RemovePrinter("\\tolss01\TOL Finance RICOH C410DN")
  RemovePrinter("\\tolss01.tol.local\TOL HR HP Laserjet 4000")
  RemovePrinter("\\tolss01\TOL HR HP Laserjet 4000")
  RemovePrinter("\\tolss01.tol.local\TOL Management Brother")
  RemovePrinter("\\tolss01\TOL Management Brother")
  RemovePrinter("\\tolss01.tol.local\TOL HR Brother")
  RemovePrinter("\\tolss01\TOL HR Brother")
  RemovePrinter("\\tolss01.tol.local\TAA Color Ricoh Central")
  RemovePrinter("\\tolss01\TAA Color Ricoh Central")
'TRP
  RemovePrinter("\\tolss01.tol.local\TRP BW KONICA MINOLTA BizHub C250")
  RemovePrinter("\\tolss01\TRP BW KONICA MINOLTA BizHub C250")
  RemovePrinter("\\tolss01.tol.local\TRP Color KONICA MINOLTA BizHub C250")
  RemovePrinter("\\tolss01\TRP Color KONICA MINOLTA BizHub C250")
  RemovePrinter("\\tolss01.tol.local\TRP Hawera BW")
  RemovePrinter("\\tolss01\TRP Hawera BW")
  RemovePrinter("\\tolss01.tol.local\TRP BW KONICA MINOLTA C253")
  RemovePrinter("\\tolss01\TRP BW KONICA MINOLTA C253")
  RemovePrinter("\\tolss01.tol.local\TRP BW GM Office")
  RemovePrinter("\\tolss01\TRP BW GM Office")
  RemovePrinter("\\tolss01.tol.local\TRP BW OM Office")
  RemovePrinter("\\tolss01\TRP BW OM Office")
  RemovePrinter("\\tolss01.tol.local\TRP BW CM Office")
  RemovePrinter("\\tolss01\TRP BW CM Office")
  RemovePrinter("\\tolss01.tol.local\TRP Color KONICA MINOLTA C253")
  RemovePrinter("\\tolss01\TRP Color KONICA MINOLTA C253")
'YTS
  RemovePrinter("\\tolss01.tol.local\YTS Hawera BW RICOH Aficio 2020D")
  RemovePrinter("\\tolss01\YTS Hawera BW RICOH Aficio 2020D")
  RemovePrinter("\\tolss01.tol.local\YTS Hawera Color HP Officejet Pro K550")
  RemovePrinter("\\tolss01\YTS Hawera Color HP Officejet Pro K550")
  RemovePrinter("\\tolss01.tol.local\YTS Hawera Central BW")
  RemovePrinter("\\tolss01\YTS Hawera Central BW")
  RemovePrinter("\\tolss01.tol.local\YTS NP BW KONICA MINOLTA 7222")
  RemovePrinter("\\tolss01\YTS NP BW KONICA MINOLTA 7222")
  RemovePrinter("\\tolss01.tol.local\YTS Waitara BW HP Officejet 6310")
  RemovePrinter("\\tolss01\YTS Waitara BW HP Officejet 6310")
  RemovePrinter("\\tolss01.tol.local\YTS Waitara Color HP Officejet 6310")
  RemovePrinter("\\tolss01\YTS Waitara Color HP Officejet 6310")
  RemovePrinter("\\tolss01.tol.local\YTS Waitara BW RICOH Aficio 2020D")
  RemovePrinter("\\tolss01\YTS Waitara BW RICOH Aficio 2020D")
  RemovePrinter("\\tolss01.tol.local\YTS NP BW")
  RemovePrinter("\\tolss01\YTS NP BW")
  RemovePrinter("\\tolss01.tol.local\YTS NP Color HP Business Inkjet 1200")
  RemovePrinter("\\tolss01\YTS NP Color HP Business Inkjet 1200")
  RemovePrinter("\\tolss01.tol.local\YTS Waitara Central")
  RemovePrinter("\\tolss01\YTS Waitara Central")
'Printer Codes
  SetRegCUBin "Software\RICOH\JOBCODE\JCUserCode", "\\tolss01.tol.local\HTPHO Color RICOH Central", Array(227,7,123,142,93,25,189,253)  'hex:e3,07,7b,8e,5d,19,bd,fd=6095
  SetRegCUBin "Software\RICOH\JOBCODE\JCUserCode", "\\tolss01\HTPHO Color RICOH Central", Array(227,7,123,142,93,25,189,253)  'hex:e3,07,7b,8e,5d,19,bd,fd=6095
  SetRegCUBin "Software\RICOH\JOBCODE\JCUserCode", "\\tolss01.tol.local\TOL Color RICOH Central", Array(118,97,63,142,172,6,152,157)  'hex:76,61,3f,8e,ac,06,98,9d=5050
  SetRegCUBin "Software\RICOH\JOBCODE\JCUserCode", "\\tolss01\TOL Color RICOH Central", Array(118,97,63,142,172,6,152,157)  'hex:76,61,3f,8e,ac,06,98,9d=5050
  SetRegCUBin "Software\RICOH\JOBCODE\JCUserCode", "\\tolss01.tol.local\TAA Color RICOH Central", Array(211,108,84,40,128,41,81,156)  'hex:d3,6c,54,28,80,29,51,9c=3519
  SetRegCUBin "Software\RICOH\JOBCODE\JCUserCode", "\\tolss01\TAA Color RICOH Central", Array(211,108,84,40,128,41,81,156)  'hex:d3,6c,54,28,80,29,51,9c=3519
End If


' Group Oriented additional actions.
' ----------------------------------------------------------

If IsMember(strUserDNName, "Domain Admins") Then
  MapDriveLetter "T", "\\TOLOCS01\Software" 
  MapDriveLetter "Z", "\\TOLfp01\Applications$" 
End If
If IsMember(strUserDNName, "Piki Te Ora (PTO) Finance") Then
  MapDriveLetter "Z", "\\TOLFP01\Applications$" 
  ' Application: Set registery for MoneyWorks 5.
  ' ----------------------------------------------------------
  strRegPath = "HKCU\Software\Classes\.mwd5\"
  strRegValue = ""& GetReg(strRegPath)
  If (strRegValue = "") Or (strRegValue <> "mwd5_auto_file") Then 
    If (boolDebug) Then WScript.Echo "MoneyWorks: Set MWD5 file assoc (Registry setting Is Empty)" &vbCrlf& "Previous Reg Value: " &strRegValue &vbCrLf
    SetReg strRegPath, "mwd5_auto_file", "REG_SZ"
  End If
  strRegPath = "HKCU\Software\Classes\mwd5_auto_file\"
  strRegValue = ""& GetReg(strRegPath)
  If (strRegValue = "") Or (strRegValue <> "MoneyWorks Company Data") Then 
    If (boolDebug) Then WScript.Echo "MoneyWorks: Set MWD5 file assoc name (Registry setting Is Empty)" &vbCrlf& "Previous Reg Value: " &strRegValue &vbCrLf
    SetReg strRegPath, "MoneyWorks Company Data", "REG_SZ"
  End If
  strRegPath = "HKCU\Software\Classes\mwd5_auto_file\DefaultIcon\"
  strRegValue = ""& GetReg(strRegPath)
  If (strRegValue = "") Or (strRegValue <> "Z:\MoneyWorks Gold 5\MoneyWorks Gold.exe,11") Then 
    If (boolDebug) Then WScript.Echo "MoneyWorks: Set MWD5 file assoc icon (Registry setting Is Empty)" &vbCrlf& "Previous Reg Value: " &strRegValue &vbCrLf
    SetReg strRegPath, "Z:\MoneyWorks Gold 5\MoneyWorks Gold.exe,11", "REG_SZ"
  End If
  strRegPath = "HKCU\Software\Classes\mwd5_auto_file\shell\open\command\"
  strRegValue = ""& GetReg(strRegPath)
  If (strRegValue = "") Or (strRegValue <> """Z:\MoneyWorks Gold 5\MoneyWorks Gold.exe"" ""%1""") Then 
    If (boolDebug) Then WScript.Echo "MoneyWorks: Set MWD5 file assoc command (Registry setting Is Empty)" &vbCrlf& "Previous Reg Value: " &strRegValue &vbCrLf
    SetReg strRegPath, """Z:\MoneyWorks Gold 5\MoneyWorks Gold.exe"" ""%1""", "REG_SZ"
  End If
End If
If IsMember(strUserDNName, "Prophet Access") Then
  MapDriveLetter "P", "\\TOLFP01\Applications$" 
End If
If IsMember(strUserDNName, "Raumano Health Trust (RHT) Admin") Then
  MapPrinter("\\tolfp01\RHT Color FX DocuCentre-II C3000")
End If
If IsMember(strUserDNName, "Te Aroha Medcare (TAM) Medtech Users") Then
  MapDriveLetter "M", "\\TAMMT01\MT32$" 
  RunCommand "\\TAMMT01\mt32$\bestpractice\BPAC-BestPractice\Load-BPACCertificate.cmd", " "
End If
If IsMember(strUserDNName, "Te Hauora Pou Heretanga (THPH) Caduceus") Then
  MapDriveLetter "Z", "\\TOLFP01\Applications$" 
  'RunCommand "Z:\Caduceus\AutoUpdateStuff\Install.bat", "/silent"
End If
If IsMember(strUserDNName, "Te Hauora Pou Heretanga (THPH) Color Print") Then
  MapPrinter("\\tolfp01\THPH Color Carleen")
End If
If IsMember(strUserDNName, "Te Hauora Pou Heretanga (THPH) Reception") Then
  MapPrinter("\\tolfp01\THPH Reception")
End If
If IsMember(strUserDNName, "Te Rau Pani (TRP) Equip") Then
  MapDriveLetter "T", "\\TRPEQ01\Equip$" 
End If
If IsMember(strUserDNName, "Te Rau Pani (TRP) Finance") Then
  MapDriveLetter "Z", "\\TOLFP01\Applications$" 
End If
If IsMember(strUserDNName, "Te Rau Pani (TRP) Color Printing") Then
  MapPrinter("\\tolfp01\TRP Color KONICA MINOLTA C253")
End If
If IsMember(strUserDNName, "Tihi Ltd (TIHI) Color Printing") Then
  MapPrinter("\\tolfp01\TIHI Color Reception")
End If
If IsMember(strUserDNName, "Tihi Ltd (TIHI) Moneyworks") Then
  MapDriveLetter "M", "\\TIHIS01\Applications$" 
  ' Application: Set registery for MoneyWorks 4.
  ' ----------------------------------------------------------
  strRegPath = "HKCU\Software\Classes\.mwd3\"
  strRegValue = ""& GetReg(strRegPath)
  If (strRegValue = "") Or (strRegValue <> "mwd3_auto_file") Then 
    If (boolDebug) Then WScript.Echo "MoneyWorks: Set MWD3 file assoc (Registry setting Is Empty)" &vbCrlf& "Previous Reg Value: " &strRegValue &vbCrLf
    SetReg strRegPath, "mwd3_auto_file", "REG_SZ"
  End If
  strRegPath = "HKCU\Software\Classes\mwd3_auto_file\"
  strRegValue = ""& GetReg(strRegPath)
  If (strRegValue = "") Or (strRegValue <> "MoneyWorks Company Data") Then 
    If (boolDebug) Then WScript.Echo "MoneyWorks: Set MWD3 file assoc name (Registry setting Is Empty)" &vbCrlf& "Previous Reg Value: " &strRegValue &vbCrLf
    SetReg strRegPath, "MoneyWorks Company Data", "REG_SZ"
  End If
  strRegPath = "HKCU\Software\Classes\mwd3_auto_file\DefaultIcon\"
  strRegValue = ""& GetReg(strRegPath)
  If (strRegValue = "") Or (strRegValue <> "M:\MoneyWorks\MoneyWorks Gold.exe,11") Then 
    If (boolDebug) Then WScript.Echo "MoneyWorks: Set MWD3 file assoc icon (Registry setting Is Empty)" &vbCrlf& "Previous Reg Value: " &strRegValue &vbCrLf
    SetReg strRegPath, "M:\MoneyWorks\MoneyWorks Gold.exe,11", "REG_SZ"
  End If
  strRegPath = "HKCU\Software\Classes\mwd3_auto_file\shell\open\command\"
  strRegValue = ""& GetReg(strRegPath)
  If (strRegValue = "") Or (strRegValue <> """M:\MoneyWorks\MoneyWorks Gold.exe"" ""%1""") Then 
    If (boolDebug) Then WScript.Echo "MoneyWorks: Set MWD3 file assoc command (Registry setting Is Empty)" &vbCrlf& "Previous Reg Value: " &strRegValue &vbCrLf
    SetReg strRegPath, """M:\MoneyWorks\MoneyWorks Gold.exe"" ""%1""", "REG_SZ"
  End If
End If
If IsMember(strUserDNName, "Tui Ora Ltd (TOL) Finance") Then
  MapPrinter("\\tolfp01\TOL Finance RICOH C410DN")
  MapPrinter("\\tolfp01\TOL HR Brother")
  MapPrinter("\\tolfp01\TOL Finance")
End If
If IsMember(strUserDNName, "Tui Ora Ltd (TOL) Management") Then
  MapPrinter("\\tolfp01\TOL Management Brother")
End If
If IsMember(strUserDNName, "Tui Ora Ltd (TOL) HR") Then
  MapPrinter("\\tolfp01\TOL HR Brother")
  MapDriveLetter "Z", "\\TOLFP01\Applications$" 
End If
If IsMember(strUserDNName, "Tui Ora Ltd (TOL) Provider Arm Transition Group") Then
   MapDriveLetter "K", "\\tolfp01\SharedPAT$" 
End If
If IsMember(strUserDNName, "Tui Ora Ltd (TOL) Printer Users") Then
  MapPrinter("\\tolfp01\TOL Color RICOH Central")
  MapPrinter("\\tolfp01\TOL Central")
  SetRegCUBin "Software\RICOH\JOBCODE\JCUserCode", "\\tolfp01\TOL Color RICOH Central", Array(118,97,63,142,172,6,152,157)  'hex:76,61,3f,8e,ac,06,98,9d=5050
  SetRegCUBin "Software\RICOH\JOBCODE\JCUserCode", "\\tolfp01\TOL Central", Array(118,97,63,142,172,6,152,157)  'hex:76,61,3f,8e,ac,06,98,9d=5050
End If
If IsMember(strUserDNName, "Tui Ora Ltd (TOL) Reception") Then
  MapPrinter("\\tolfp01\TOL Finance RICOH C410DN")
  MapPrinter("\\tolfp01\TOL Finance")
End If
If IsMember(strUserDNName, "Tui Ora Ltd (TOL) Te Ao Auahatanga") Then
  MapPrinter("\\tolfp01\TAA Color Ricoh Central")
  SetRegCUBin "Software\RICOH\JOBCODE\JCUserCode", "\\tolfp01\TAA Color RICOH Central", Array(211,108,84,40,128,41,81,156)  'hex:d3,6c,54,28,80,29,51,9c=3519
End If
If IsMember(strUserDNName, "Youth Transition Service (YTS) Printer Users") Then
  MapPrinter("\\tolfp01\YTS Waitara Central")
End If
If IsMember(strUserDNName, "Tui Ora Ltd (TOL) Medtech Users") Then
  MapDriveLetter "M", "\\TOLMT01\MT32" 
End If


' Person Oriented additional actions.
' ----------------------------------------------------------
If (UCase(strUserName) = UCase("Peter")) Then
  MapDriveLetter "U", "\\TOLDS01\eXpress" 
End If
If (UCase(strUserName) = UCase("ytsi")) Then
  MapDriveLetter "H", "\\tolfp01\UsersYTS$\" & strUserName  & "\Documents"
End If


' Computer Oriented additional actions.
' ----------------------------------------------------------
If (UCase(GetEnv("COMPUTERNAME")) = UCase("TAMMT01")) Then
  MapDriveLetter "M", "\\TAMMT01\MT32$"
End If
If (UCase(GetEnv("COMPUTERNAME")) = UCase("TOLMT01")) Then
  MapDriveLetter "M", "\\TOLMT01\MT32" 
End If
If (UCase(GetEnv("COMPUTERNAME")) = UCase("TIHIS01")) Then
  MapDriveLetter "M", "\\tihis01\Applications$"
End If
If (UCase(GetEnv("COMPUTERNAME")) = UCase("AUAHAS01")) Then
  MapDriveLetter "M", "\\auahas01\Applications$"
End If


' Application Oriented Actions.
' ----------------------------------------------------------
' Application: Set registery for Profile.
' ----------------------------------------------------------
strRegPath = "HKCU\Software\IntraHealth\Profile\Client\Logons"
strRegValue = ""& GetReg(strRegPath)
If (strRegValue = "") Or (InStr(UCase(strRegValue), UCase("DC14"))) Then 
  If (boolDebug) Then WScript.Echo "Profile: Replace (Registry setting Is Empty Or Old)" &vbCrLf& "Previous Reg Value: " &strRegValue &vbCrLf
  SetReg strRegPath, strUserName & "=TOLPE01", "REG_SZ"
End If
' Application: Set registery for IE7/IE8.
' ----------------------------------------------------------
If (boolDebug) Then WScript.Echo "IE7/IE8: Disable Runonce startpage." &vbCrLf
SetReg "HKCU\Software\Microsoft\Internet Explorer\Main\RunOnceComplete", 1, "REG_DWORD"
SetReg "HKCU\Software\Microsoft\Internet Explorer\Main\RunOnceHasShown", 1, "REG_DWORD"
' Application: Set Trusted Websites.
' ----------------------------------------------------------
'SetReg "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\acc.co.nz\http", 2, "REG_DWORD"
'SetReg "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains\acc.co.nz\http", 2, "REG_DWORD"
' Application: Set registery for MsOffice 2007.
' ----------------------------------------------------------
strRegPath = "HKCU\Software\Microsoft\Office\Common\UserInfo\UserName"
strRegValue = ""& GetReg(strRegPath)
If (strRegValue = "") Or (strRegValue <> GetUserFullName) Then 
  If (boolDebug) Then WScript.Echo "MsOffice 2007: Replace Username (Registry setting Is Empty)" &vbCrLf& "Previous Reg Value: " &strRegValue &vbCrLf
  SetReg strRegPath, GetUserFullName, "REG_SZ"
End If
' Application: DO NOT Set registery for WinHTTP.
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
    WScript.Echo "GetEnv= Failed (One of the Parameter(s) is Empty)" &vbCrLf& "Variable: " &strVariable &vbCrLf
  End If ' Check on parameters empty
End Function 

' ----------------------------------------------------------
' The Library part of the Script Finishes here. Now we get to the Actions part.
' ----------------------------------------------------------

