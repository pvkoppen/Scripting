' Name   : LoginScript.vbs
' Descr  : Login script for domain TOL.local.
' Author : Peter van Koppen,  Tuiora
' Version: 0.2
' Date   : 2007-03-21
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
Dim boolDebug
boolDebug = False
boolDebug = True
If (boolDebug) Then On Error Goto 0 Else On Error Resume Next End If

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
    If not (IsMember) Then
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
      If (boolDebug and IsMember) then
        WScript.Echo "IsMember= True (Group is the primary group of the User.)" &vbCRLF& "Username: " &strUserDNName&vbCRLF& "Groupname: " &strGroupName
      Elseif (boolDebug) then
        WScript.Echo "IsMember= False (User is not a direct member of the Group)" &vbCRLF& "Username: " &strUserDNName&vbCRLF& "Groupname: " &strGroupName
      End If
    Elseif (boolDebug) then
      WScript.Echo "IsMember= True (User is a member of the Group)" &vbCRLF& "Username: " &strUserDNName&vbCRLF& "Groupname: " &strGroupName
    End If ' Check if IsMember is True already
    Set objIMGroup   = Nothing
    Set objIMUser    = Nothing
  Elseif (boolDebug) then
    WScript.Echo "IsMember= False (User or Group Parameter is Empty)" &vbCRLF& "Username: " &strUserDNName&vbCRLF& "Groupname: " &strGroupName
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
        'If (boolDebug) Then WScript.Echo "Local Printer No: " &(intPrinter/2)+1 &vbCrlf& "(Port: " & objPrinters.Item(intPrinter) & ")" &vbCrlf& "(Network Path: " & objPrinters.Item(intPrinter +1) & ")" &vbCrlf& "(New Printer: " & strUNCPrinter & ")." End If
        If UCase(objPrinters.Item(intPrinter+1)) = UCase(strUNCPrinter) Then
          boolRemovePrinter = True
          If (boolDebug) Then WScript.Echo "Printer Exists." &vbCrlf& _
            "(Port: " & objPrinters.Item(intPrinter) & ", Network Path: " & objPrinters.Item(intPrinter +1) & ")" 
        End If
      Next
    End If
    ' If the printer exists try to remove it.
    If True = boolRemovePrinter Then
      WScript.Echo "Need to Implement: Remove printer"
      'objNetwork.AddWindowsPrinterConnection strUNCPrinter
      If (boolDebug) Then WScript.Echo "Printer Removed: " & strUNCPrinter End If
    End If
    ' Cleanup.
    Set objPrinters = Nothing
    Set objNetwork  = Nothing
  Elseif (boolDebug) then
    WScript.Echo "RemovePrinter= Failed (One of the Parameter(s) is Empty)" &vbCRLF& "Printer: " &strUNCPrinter
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
          'If (boolDebug) Then WScript.Echo "Local Printer No: " &(intPrinter/2)+1 &vbCrlf& "(Port: " & objPrinters.Item(intPrinter) & ")" &vbCrlf& "(Network Path: " & objPrinters.Item(intPrinter +1) & ")" &vbCrlf& "(New Printer: " & strUNCPrinter & ")." End If
          If UCase(objPrinters.Item(intPrinter+1)) = UCase(strUNCPrinter) Then
            boolAddPrinter = False
            If (boolDebug) Then WScript.Echo "MapPrinter: Prevented (Printer Already Exists)" &vbCrlf& _
              "LocalPort: " & objPrinters.Item(intPrinter)&vbCrlf& "Printer: " & objPrinters.Item(intPrinter +1) 
          End If
        Next
      End If
      ' If the Printer doens't exist yet add it.
      If boolAddPrinter Then 
        objNetwork.AddWindowsPrinterConnection strUNCPrinter
        If (boolDebug) Then WScript.Echo "MapPrinter: Succes (Printer added)" &vbCrlf& "Printer: " & strUNCPrinter End If
      End If
      ' Cleanup.
      Set objPrinters = Nothing
      Set objNetwork  = Nothing
    Elseif (boolDebug) then 
      WScript.Echo "MapPrinter= Failed (Don't map printer on a Domain Controller or a Server)"& vbCrlf& "ComputerName: " &GetComputerDNName&vbCrlf& "Printer: " &strUNCPrinter
    End If ' LocalMachine = Server.
  Elseif (boolDebug) then
    WScript.Echo "MapPrinter= Failed (One of the Parameter(s) is Empty)" &vbCRLF& "Printer: " &strUNCPrinter
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
      If (boolDebug) Then WScript.Echo "MapDriveLetter: Succes (Mapping Removed)" &vbCrlf& "DriveLetter: " & strDriveLetter & ":" End If
    End If 
    ' Now connect the drive letter to the UNC path.
    objNetwork.MapNetworkDrive strDriveLetter & ":", strUNCPath 
    If (boolDebug) Then WScript.Echo "MapDriveLetter: Succes (Drive Mapped)" &vbCrlf& "DriveLetter: " & strDriveLetter & ":" &vbCrlf& "UNCPath: " & strUNCPath End If
    ' Cleanup.
    Set objCurrentDrives = Nothing 
    Set objNetwork = Nothing 
  Elseif (boolDebug) then
    WScript.Echo "MapDriveLetter= Failed (One of the Parameter(s) is Empty)" &vbCRLF& "DriveLetter: " &strDriveLetter&vbCRLF& "UNCPath: " &strUNCPath
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
    If (boolDebug) Then WScript.Echo "GetReg: Succes (Read Registry Key)" &vbCrlf& "Registry Key: " & strRegPath &vbCrlf& "Value: " & GetReg End If
  Elseif (boolDebug) then
    WScript.Echo "GetReg= Failed (One of the Parameter(s) is Empty)" &vbCRLF& "RegPath: " &strRegPath
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
    If (boolDebug) Then WScript.Echo "SetReg: Succes (Write Registry Key)" &vbCrlf& "Registry Key: " & strRegPath &vbCrlf& "Registry Value: " & strGetValue &vbCrlf& "Registry Type: " & strGetType End If
  Elseif (boolDebug) then
    WScript.Echo "SetReg= Failed (One of the Parameter(s) is Empty)" &vbCRLF& "RegPath: " &strRegPath&vbCRLF& "RegValue: " &strRegValue&vbCRLF& "RegType: " &strRegType
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
  Elseif (boolDebug) then
    WScript.Echo "RunCommand= Failed (One of the Parameter(s) is Empty)" &vbCRLF& "Command: " &strCommand&vbCRLF& "Paramaters: " &strParameters
  End If ' Check on parameters empty
End Sub 

' ----------------------------------------------------------
' Library Contents:
' ----------------------------------------------------------
' GetUserDNName
' GetUsername
' GetComputerDNName
' GetComputerName
' GetDomainName
' IsMember
' RemovePrinter
' MapPrinter
' MapDriveLetter
' GetReg
' SetReg
' RunCommand
' ----------------------------------------------------------
' The Library part of the Script Finishes here. Now we get to the Actions part.
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
' M: = TAM Medtech / HTPHO Mobile Bus Medtech.
' N: = \\TOLSS01\d$
' P: = TOL and HTPHO Prophet.
' S: = Shared drive, accessible by all Tui Ora Ltd Network users.
' T: = TRP Equip / TOL Software
' U: = TOL Altiris 
' Z: = TOL HR

' Define all the Organisational groups.
' Group names must be in FULL DN notation Or in short group name
' ----------------------------------------------------------
Dim grpHTPHOUsers, grpMOLUsers,   grpPTOUsers,   grpRHTUsers,   grpTAMUsers
Dim grpTHPHUsers,  grpTOLUsers,   grpTRPUsers,   grpYTSUsers,   grpSYSTEMUsers
grpHTPHOUsers = "CN=Hauora Taranaki PHO (HTPHO) Users,OU=HTPHO,DC=TOL,DC=LOCAL"
grpMOLUsers   = "CN=Manaaki Oranga Ltd (MOL) Users,OU=MOL,DC=TOL,DC=LOCAL"
grpPTOUsers   = "CN=Piki Te Ora (PTO) Users,OU=PTO,DC=TOL,DC=LOCAL"
grpRHTUsers   = "CN=Raumano Health Trust (RHT) Users,OU=RHT,DC=TOL,DC=LOCAL"
grpTAMUsers   = "CN=Te Aroha Medcare (TAM) Users,OU=TAM,DC=TOL,DC=LOCAL"
grpTHPHUsers  = "CN=Te Hauora Pou Heretanga (THPH) Users,OU=THPH,DC=TOL,DC=LOCAL"
grpTOLUsers   = "CN=Tui Ora Ltd (TOL) Users,OU=TOL,DC=TOL,DC=LOCAL"
grpTRPUsers   = "CN=Te Rau Pani (TRP) Users,OU=TRP,DC=TOL,DC=LOCAL"
grpYTSUsers   = "CN=Youth Transition Service (YTS) Users,OU=YTS,DC=TOL,DC=LOCAL"
grpSYSTEMUsers= "CN=System Account (System) Users,OU=Global Security Entities,DC=TOL,DC=LOCAL"

' Declare Variables and set initial Values
' ----------------------------------------------------------
Dim strUsername, strUserDNName
strUserDNName = GetUserDNName
strUserName   = GetUserName
If (boolDebug) Then WScript.Echo "DN:" & strUserDNName &vbCrlf& "User:" & strUserName

' Perform basic Group printer mappings and drive mappings.
' ----------------------------------------------------------
If (IsMember(strUserDNName, grpHTPHOUsers) and IsMember(strUserDNName, grpTOLUsers)) Then ' --- HTPHO and TOL
  ' Remove Old Printer Drivers
  'RemovePrinter("")
  ' Add New Printer Drivers
  MapPrinter("\\tolss01.tol.local\HTPHO HP LaserJet 2300")
  MapPrinter("\\tolss01.tol.local\HTPHO Color RICOH Aficio 3260C")
  MapPrinter("\\tolss01.tol.local\HTPHO-TOL RICOH Aficio Replacement")
  MapPrinter("\\tolss01.tol.local\TOL Color RICOH Aficio 3260C")
  ' Add Drive Mappings
  MapDriveLetter "G", "\\tolss01.tol.local\SharedTOL$"
  MapDriveLetter "I", "\\tolss01.tol.local\SharedHTPHO$"
  MapDriveLetter "H", "\\tolss01.tol.local\HomeTOL$\" & strUserName
  MapDriveLetter "S", "\\tolss01.tol.local\SharedALL$"
Elseif (IsMember(strUserDNName, grpTOLUsers) and IsMember(strUserDNName, grpYTSUsers)) Then ' --- TOL and YTS
  ' Remove Old Printer Drivers
  'RemovePrinter("")
  ' Add New Printer Drivers
  MapPrinter("\\tolss01.tol.local\TOL Color RICOH Aficio 3260C")
  MapPrinter("\\tolss01.tol.local\YTS NP BW KONICA MINOLTA 7222")
  MapPrinter("\\tolss01.tol.local\YTS NP Color HP Business Inkjet 1200")
  MapPrinter("\\tolss01.tol.local\YTS Hawera BW RICOH Aficio 2020D")
  MapPrinter("\\tolss01.tol.local\YTS Hawera Color HP Officejet Pro K550")
  'MapPrinter("\\tolss01.tol.local\YTS Waitara BW HP Officejet 6310")
  MapPrinter("\\tolss01.tol.local\YTS Waitara Color HP Officejet 6310")
  ' Add Drive Mappings
  MapDriveLetter "G", "\\tolss01.tol.local\SharedYTS$"
  MapDriveLetter "I", "\\tolss01.tol.local\SharedTOL$"
  MapDriveLetter "H", "\\tolss01.tol.local\HomeYTS$\" & strUserName
  MapDriveLetter "S", "\\tolss01.tol.local\SharedALL$"
ElseIf IsMember(strUserDNName, grpHTPHOUsers) Then ' --- Hauora Taranaki PHO
  ' Remove Old Printer Drivers
  'RemovePrinter("")
  ' Add New Printer Drivers
  MapPrinter("\\tolss01.tol.local\HTPHO HP LaserJet 2300")
  MapPrinter("\\tolss01.tol.local\HTPHO Color RICOH Aficio 3260C")
  MapPrinter("\\tolss01.tol.local\HTPHO-TOL RICOH Aficio Replacement")
  ' Add Drive Mappings
  MapDriveLetter "G", "\\tolss01.tol.local\SharedHTPHO$"
  MapDriveLetter "H", "\\tolss01.tol.local\HomeHTPHO$\" & strUserName
  MapDriveLetter "S", "\\tolss01.tol.local\SharedALL$"
Elseif IsMember(strUserDNName, grpMOLUsers) Then ' --- Manaaki Oranga Ltd
  ' Remove Old Printer Drivers
  'RemovePrinter("")
  ' Add New Printer Drivers
  MapPrinter("\\tolss01.tol.local\MOR BW HP Laserjet 4000")
  'MapPrinter("Hawera(Merle): HP Laserjet 1020")
  ' Add Drive Mappings
  MapDriveLetter "G", "\\tolss01.tol.local\SharedMOL$"
  MapDriveLetter "H", "\\tolss01.tol.local\HomeMOL$\" & strUserName
  MapDriveLetter "S", "\\tolss01.tol.local\SharedALL$"
Elseif IsMember(strUserDNName, grpPTOUsers) Then ' --- Piki Te Ora
  ' Remove Old Printer Drivers
  'RemovePrinter("")
  ' Add New Printer Drivers
  MapPrinter("\\tolss01.tol.local\PTO BW HP LaserJet 1320")
  MapPrinter("\\tolss01.tol.local\PTO BW HP LaserJet 2100")
  'MapPrinter("Clinical area: Dymo LabelWriter 400 Turbo")
  'MapPrinter("Chris: HP PSC 1510 All-in-One (Local Printer only!)")
  ' Add Drive Mappings
  MapDriveLetter "G", "\\tolss01.tol.local\SharedPTO$"
  MapDriveLetter "H", "\\tolss01.tol.local\HomePTO$\" & strUserName
  MapDriveLetter "S", "\\tolss01.tol.local\SharedALL$"
Elseif IsMember(strUserDNName, grpRHTUsers) Then ' --- Raumano Health Trust
  ' Remove Old Printer Drivers
  'RemovePrinter("")
  ' Add New Printer Drivers
  MapPrinter("\\tolss01.tol.local\RHT BW FX DocuCentre-II C3000")
  ' Add Drive Mappings
  MapDriveLetter "G", "\\tolss01.tol.local\SharedRHT$"
  MapDriveLetter "H", "\\tolss01.tol.local\HomeRHT$\" & strUserName
  MapDriveLetter "S", "\\tolss01.tol.local\SharedALL$"
Elseif IsMember(strUserDNName, grpTAMUsers) Then ' --- Te Aroha Medcare
  ' Remove Old Printer Drivers
  'RemovePrinter("")
  ' Add New Printer Drivers
  'MapPrinter("")
  ' Add Drive Mappings
  MapDriveLetter "G", "\\tolss01.tol.local\SharedTAM$"
  MapDriveLetter "H", "\\tolss01.tol.local\HomeTAM$\" & strUserName
  MapDriveLetter "S", "\\tolss01.tol.local\SharedALL$"
Elseif IsMember(strUserDNName, grpTHPHUsers) Then ' --- Te Hauora Pou Heretanga
  ' Remove Old Printer Drivers
  RemovePrinter("\\tolss01.tol.local\THPH BW Minolta Di200")
  ' Add New Printer Drivers
  MapPrinter("\\tolss01.tol.local\THPH BW KONICA MINOLTA BizHub 350")
  ' Add Drive Mappings
  MapDriveLetter "G", "\\tolss01.tol.local\SharedTHPH$"
  MapDriveLetter "H", "\\tolss01.tol.local\HomeTHPH$\" & strUserName
  MapDriveLetter "S", "\\tolss01.tol.local\SharedALL$"
Elseif IsMember(strUserDNName, grpTOLUsers) Then ' --- Tui Ora Limited
  ' Remove Old Printer Drivers
  'RemovePrinter("")
  ' Add New Printer Drivers
  MapPrinter("\\tolss01.tol.local\TOL Color RICOH Aficio 3260C")
  MapPrinter("\\tolss01.tol.local\HTPHO-TOL RICOH Aficio Replacement")
  ' Add Drive Mappings
  MapDriveLetter "G", "\\tolss01.tol.local\SharedTOL$"
  MapDriveLetter "H", "\\tolss01.tol.local\HomeTOL$\" & strUserName
  MapDriveLetter "S", "\\tolss01.tol.local\SharedALL$"
Elseif IsMember(strUserDNName, grpTRPUsers) Then ' --- Te Rau Pani
  ' Remove Old Printer Drivers
  'RemovePrinter("")
  ' Add New Printer Drivers
  MapPrinter("\\tolss01.tol.local\TRP BW KONICA MINOLTA BizHub C250")
  'MapPrinter("Jo: Brother HL-2040")
  'MapPrinter("Hawera: Brother HL-1440")
  ' Add Drive Mappings
  MapDriveLetter "G", "\\tolss01.tol.local\SharedTRP$"
  MapDriveLetter "H", "\\tolss01.tol.local\HomeTRP$\" & strUserName
  MapDriveLetter "S", "\\tolss01.tol.local\SharedALL$"
Elseif IsMember(strUserDNName, grpYTSUsers) Then ' --- Youth Transitional Services
  ' Remove Old Printer Drivers
  'RemovePrinter("")
  ' Add New Printer Drivers
  MapPrinter("\\tolss01.tol.local\YTS NP BW KONICA MINOLTA 7222")
  MapPrinter("\\tolss01.tol.local\YTS NP Color HP Business Inkjet 1200")
  MapPrinter("\\tolss01.tol.local\YTS Hawera BW RICOH Aficio 2020D")
  MapPrinter("\\tolss01.tol.local\YTS Hawera Color HP Officejet Pro K550")
  'MapPrinter("\\tolss01.tol.local\YTS Waitara BW HP Officejet 6310")
  MapPrinter("\\tolss01.tol.local\YTS Waitara Color HP Officejet 6310")
  ' Add Drive Mappings
  MapDriveLetter "G", "\\tolss01.tol.local\SharedYTS$"
  MapDriveLetter "H", "\\tolss01.tol.local\HomeYTS$\" & strUserName
  MapDriveLetter "S", "\\tolss01.tol.local\SharedALL$"
Elseif IsMember(strUserDNName, grpSYSTEMUsers) Then ' --- System Accounts
  ' Remove Old Printer Drivers
  'RemovePrinter("")
  ' Add New Printer Drivers
  MapPrinter("\\tolss01.tol.local\TOL Color RICOH Aficio 3260C")
  ' Add Drive Mappings
  MapDriveLetter "G", "\\TOLSS01.tol.local\d$" 
  MapDriveLetter "H", "\\tolss01.tol.local\HomeSystem$\" & strUserName
  MapDriveLetter "S", "\\tolss01.tol.local\SharedALL$"
Else
  If (boolDebug) Then WScript.Echo "You do not belong to any Provider groups."
End If

' Group Oriented additional actions.
' ----------------------------------------------------------
If IsMember(strUserDNName, "Domain Admins") Then
  MapDriveLetter "T", "\\TOLSS01.tol.local\Software" 
End If
If IsMember(strUserDNName, "Hauora Taranaki PHO (HTPHO) Medtech Bus") Then
  MapDriveLetter "M", "\\htpho27\mt32$" 
End If
If IsMember(strUserDNName, "Prophet Access") Then
  MapDriveLetter "P", "\\TOLPT01.tol.local\Prophet$" 
End If
If IsMember(strUserDNName, "Raumano Health Trust (RHT) Admin") Then
  MapPrinter("\\tolss01.tol.local\RHT Color FX DocuCentre-II C3000")
End If
If IsMember(strUserDNName, "Te Aroha Medcare (TAM) Medtech") Then
  MapDriveLetter "M", "\\TAMMT01.tol.local\MT32$" 
End If
If IsMember(strUserDNName, "Te Rau Pani (TRP) Equip") Then
  MapDriveLetter "T", "\\TRPEQ01.tol.local\Equip$" 
End If
If IsMember(strUserDNName, "Te Rau Pani (TRP) Reception") Then
  MapPrinter("\\tolss01.tol.local\TRP Color KONICA MINOLTA BizHub C250")
End If
If IsMember(strUserDNName, "Tui Ora Ltd (TOL) Finance") Then
  MapPrinter("\\tolss01.tol.local\TOL Finance RICOH C410DN")
  MapPrinter("\\tolss01.tol.local\TOL HR HP Laserjet 4000")
End If
If IsMember(strUserDNName, "Tui Ora Ltd (TOL) HR") Then
  MapPrinter("\\tolss01.tol.local\TOL HR HP Laserjet 4000")
  MapDriveLetter "Z", "\\TOLSS01.tol.local\Applications$" 
End If

' Person Oriented additional actions.
' ----------------------------------------------------------
'If (UCase(strUserName) = UCase("awm")) Then
'  MapDriveLetter "I", "\\TOLSS01.tol.local\SharedTOL$" 
'End If
If (UCase(strUserName) = UCase("clb") or UCase(strUserName) = UCase("aab")) Then
  MapPrinter("\\tolss01.tol.local\THPH Color HP Officejet Pro K550")
End If
If (UCase(strUserName) = UCase("dek")) Then
  MapPrinter("\\htpho32\HTPHO HP Officejet 7100") 
End If
'If (UCase(strUserName) = UCase("hww")) Then
'  MapDriveLetter "I", "\\TOLSS01.tol.local\SharedHTPHO$" 
'End If
If (UCase(strUserName) = UCase("Peter")) Then
  MapDriveLetter "U", "\\TOLDS01.tol.local\eXpress" 
  MapDriveLetter "N", "\\TOLSS01.tol.local\d$" 
End If
If (UCase(strUserName) = UCase("russell") or UCase(strUserName) = UCase("trpi"))Then
  MapDriveLetter "H", "\\tolss01.tol.local\hometrp$\" & strUserName 
End If
If (UCase(strUserName) = UCase("ytsi")) Then
  MapDriveLetter "H", "\\tolss01.tol.local\homeyts$\" & strUserName 
End If

' Application Oriented Actions.
' ----------------------------------------------------------
' Application: Set registery for Profile.
' ----------------------------------------------------------
Dim strRegPath, strRegValue
strRegPath = "HKCU\Software\IntraHealth\Profile\Client\Logons"
strRegValue = GetReg(strRegPath)
If (strRegValue = "") Or (InStr(UCase(strRegValue), UCase("DC14"))) Then 
  If (boolDebug) Then WScript.Echo "Profile: Replace (Registry setting Is Empty Or Old)" &vbCrlf& "Previous Reg Value: " &strRegValue
  SetReg strRegPath, strUserName & "=TOLPE01", "REG_SZ"
End If
If (boolDebug) Then WScript.Echo "IE7: Disable Runonce startpage."
SetReg "HKCU\Software\Microsoft\Internet Explorer\Main\RunOnceComplete", 1, "REG_DWORD"
SetReg "HKCU\Software\Microsoft\Internet Explorer\Main\RunOnceHasShown", 1, "REG_DWORD"

' Application: Set registery for WinHTTP.
' ----------------------------------------------------------
'RunCommand "proxycfg.exe", "-p tolgw01:8080 ""<local>;wsus;*.tol.local;*"" "

' Final.
' ----------------------------------------------------------
If (boolDebug) Then WScript.Echo "Done."
Wscript.Quit

