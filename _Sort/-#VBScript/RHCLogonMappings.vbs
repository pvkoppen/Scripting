'  LogonMappings.vbs
' VBScript to map different groups to different drive & printer shares.
' Author Simon F. GILMOUR from script by Guy Thomas http://computerperformance.co.uk/
' Version 3.0 - March 30th 2006
' -----------------------------------------------------------------'
Option Explicit
Dim objNetwork, objSysInfo, objUser, objDrives, objPrinters, objFSO
Dim colstrGroups, colstrPrinters, objDriveDict, objGroupList, objPrinterDict
Dim strGroups, strDrive, strUNCPath, strComputerName, strUNCPrinter, strUserDN
Dim ix
Dim WshShell, msg, debug, status
Dim Printers, Paths

debug = False

Const MEDtechUsers_Group = "MEDtechUsers"
Const HLinkUsers_Group = "HLinkUsers"
Const SCPUsers_Group = "SCPUsers"
Const Users_Group = "Users"
Const Administrators_Group = "Administrators"

Set WshShell = Wscript.CreateObject("Wscript.Shell")
Set objNetwork = CreateObject("WScript.Network")
Set objSysInfo = CreateObject("ADSystemInfo")
Set objFSO = CreateObject("Scripting.FileSystemObject")

strUserDN = objSysInfo.userName
WshShell.Popup "Username = " & strUserDN, 1, "User DN", 64
Set objUser = GetObject("LDAP://" & strUserDN)

Set objDriveDict = CreateObject("Scripting.Dictionary")

strGroups = Administrators_Group

If debug Then
  WshShell.Popup "User is " & objUser.sAMAccountName, 1, "User Login Account", 64
End If

If debug Then
  WshShell.Popup "Computer name = " & objSysInfo.ComputerName, 2, "System Information", 64
End If
strComputerName = LCase(objSysInfo.ComputerName)

If Instr(1, strComputerName, "rhc-rongo", vbTextCompare) = 0 And Instr(1, strComputerName, "rhc-hpserver1", vbTextCompare) = 0 Then

  WshShell.Popup "Checking Network Drives...", 1, "Network Drive Mappings", 64

  ' Populate Drive list

  Set objDrives = objNetwork.EnumNetworkDrives
  For ix = 0 to objDrives.Count - 2 Step 2   
    strDrive = objDrives(ix)
    strUNCPath = objDrives(ix+1)
    If strDrive = "" Then strDrive = "--"
   
    objDriveDict.Add strDrive, strUNCPath
  Next

  ' Now check for required mappings

  If IsMember(objUser, MedtechUsers_Group) Then
    WshShell.Popup "MEDtech32 User ", 1, "User Group", 64
    ' Does User have M: mapping
    If Not objDriveDict.Exists("M:") Or _
            (objDriveDict.Exists("M:") And objDriveDict("M:") <> "\\RHC-HPServer1\MT32") Then
      status = MapDrive ("M:", "\\RHC-HPServer1\MT32")
    End If
  End If

  If IsMember(objUser, HLinkUsers_Group) Then
    WshShell.Popup " HealthLink User ", 1, "User Group", 64
    ' Does User have Z: mapping
    If Not objDriveDict.Exists("Z:") Or _
	    ( objDriveDict.Exists("Z:") And objDriveDict("Z:") <> "\\RHC-HPServer1\HLink") Then
      status = MapDrive("Z:", "\\RHC-HPServer1\HLink")
    End If
  End If

  If IsMember(objUser, "SCP Users") Then
    WshShell.Popup " Smoking Cessation User ", 1, "User Group", 64
    ' Does User have Z: mapping
    If Not objDriveDict.Exists("S:") Or _
          ( objDriveDict.Exists("S:") And objDriveDict("S:") <> "\\RHC-Rongo\CGC") Then
      status = MapDrive("S:", "\\RHC-Rongo\CGC")
    End If
  End If

  ' Map Printers

  WshShell.Popup "Checking Printers...", 1, "Printer Configuration", 32

  Set objPrinters = objNetwork.EnumPrinterConnections
  If debug Then
    msg = Cstr(objPrinters.Count / 2) & " Printers"
    WshShell.Popup msg, 1, "Connected Printers", 64
  End If

  For ix = 0 to objPrinters.Count - 2 Step 2
    colstrPrinters = colstrPrinters & objPrinters.Item(ix + 1)
    If ix < (objPrinters.Count - 1) Then
      colstrPrinters = colstrPrinters & + ","
    End If
  Next

  Set objPrinterDict = CreateObject("Scripting.Dictionary")
  objPrinterDict.CompareMode = vbTextCompare
  Set objPrinters = objNetwork.EnumPrinterConnections 

  For ix = 0 To objPrinters.Count - 2 Step 2
    strUNCPrinter = objPrinters(ix)
    strUNCPath = objPrinters(ix + 1)
    If strUNCPrinter = "" Then strUNCPrinter = "--"
    objPrinterDict.Add strUNCPath, strUNCPrinter

    If debug Then
      WshShell.Popup "Printer/Port: " & strUNCPrinter & " - UNC Path: " & strUNCPath, 1, "Installed Printers", 64
    End If

  Next

'  Map printers


  If IsMember(objUser, MEDtechUsers_Group) Then
    strUNCPrinter = "\\RHC-HPSERVER1\KONICA MINOLTA 7222-7235/IP-424"
    If objPrinterDict.Exists(strUNCPrinter) Then
      WshShell.Popup strUNCPrinter & " already installed.", 2, "Printer Configuration", 16
    Else
      WshShell.Popup "Installing MEDtech printer - " & strUNCPrinter, 1, "MEDtech A4 Printer", 64
      objNetwork.AddWindowsPrinterConnection strUNCPrinter
    End If

    strUNCPrinter = "\\RHC-HPSERVER1\KONICA MINOLTA A5"
    If objPrinterDict.Exists(strUNCPrinter) Then
      WshShell.Popup strUNCPrinter & " already installed.", 2, "Printer Confiuration", 16
    Else
      WshShell.Popup "Installing MEDtech printer - " & strUNCPrinter, 1, "MEDtech A5 Printer", 64
      objNetwork.AddWindowsPrinterConnection strUNCPrinter
    End If

  End If

  strUNCPrinter = "\\RHC-HPSERVER1\KONICA MINOLTA 7222-7235/IP-424"
  If objPrinterDict.Exists(strUNCPrinter) Then
    WshShell.Popup strUNCPrinter & " already installed.", 2, "Printer Configuration", 16
  Else
    ' Map Konica 7222 printer
    WshShell.Popup "Installing Management printer - " & strUNCPrinter, 1, "Konica Minolta Printer", 64
    objNetwork.AddWindowsPrinterConnection strUNCPrinter
  End If


End If


WshShell.Popup "Finished Drive/Printer Mapping for User " & objSysInfo.UserName, 2, "Logon Configuration", 64 

Set objNetwork = Nothing
Set objUser = Nothing
Set objDriveDict = Nothing
Set objPrinterDict = Nothing
Set strUserDN = Nothing
Set WshShell = Nothing

WScript.Quit


Function MapDrive(strDrive, strShare)
' Function to map network share to a drive letter.
' If the drive letter specified is already in use, the function
' attempts to remove the network connection.
' objFSO is the File System Object, with global scope.
' objNetwork is the Network object, with global scope.
' Returns True if drive mapped, False otherwise.

  Dim objDrive
  Dim errNum, errDesc

  On Error Resume Next
  If objFSO.DriveExists(strDrive) Then
    Set objDrive = objFSO.GetDrive(strDrive)
    If Err.Number <> 0 Then
      On Error GoTo 0
      MapDrive = False
      If debug Then
      	errNum = Err.Number
      	errDesc = Err.Description
        WshShell.Popup "Mapdrive failed. GetDrive Error " & errNum & " - " & errDesc, 2, "MapDrive Status", 16
      End If
      Exit Function
    End If
    If CBool(objDrive.DriveType = 3) Then
      objNetwork.RemoveNetworkDrive strDrive, True, True
    Else
      MapDrive = False
      If debug Then
      	errNum = Err.Number
      	errDesc = Err.Description
        WshShell.Popup "Mapdrive failed. RemoveDrive Error " & errNum & " - " & errDesc, 2, "MapDrive Status", 16
      End If
      Exit Function
    End If
    Set objDrive = Nothing
  End If
  objNetwork.MapNetworkDrive strDrive, strShare
  If Err.Number = 0 Then
    MapDrive = True
    If debug Then
      WshShell.Popup "Mapdrive successful.", 1, "MapDrive Status", 8
    End If
  Else
    If debug Then
     	errNum = Err.Number
     	errDesc = Err.Description
      WshShell.Popup "Mapdrive failed. General Error " & errNum & " - " & errDesc, 2, "MapDrive Status", 16
    End If
    Err.Clear
    MapDrive = False
  End If
  On Error GoTo 0
End Function



Function IsMember(objADObject, strGroup)
' Function to test for group membership.
' objGroupList is a dictionary object with global scope.

  Dim j, objItems, objKeys

  If IsEmpty(objGroupList) Then
    Set objGroupList = CreateObject("Scripting.Dictionary")
  End If
  If Not objGroupList.Exists(objADObject.sAMAccountName & "\") Then
    Call LoadGroups(objADObject, objADObject)
    objGroupList(objADObject.sAMAccountName & "\") = True
  End If
  IsMember = objGroupList.Exists(objADObject.sAMAccountName & "\" _
    & strGroup)
End Function

Sub LoadGroups(objPriObject, objADSubObject)
' Recursive subroutine to populate dictionary object objGroupList.

  Dim colstrGroups, objGroup, j

  objGroupList.CompareMode = vbTextCompare
  colstrGroups = objADSubObject.memberOf
  If IsEmpty(colstrGroups) Then
    Exit Sub
  End If
  If TypeName(colstrGroups) = "String" Then
    Set objGroup = GetObject("LDAP://" & colstrGroups)
    If Not objGroupList.Exists(objPriObject.sAMAccountName & "\" _
        & objGroup.sAMAccountName) Then
      objGroupList(objPriObject.sAMAccountName & "\" _
        & objGroup.sAMAccountName) = True
      Call LoadGroups(objPriObject, objGroup)
    End If
    Set objGroup = Nothing
    Exit Sub
  End If
  For j = 0 To UBound(colstrGroups)
    Set objGroup = GetObject("LDAP://" & colstrGroups(j))
    If Not objGroupList.Exists(objPriObject.sAMAccountName & "\" _
        & objGroup.sAMAccountName) Then
      objGroupList(objPriObject.sAMAccountName & "\" _
        & objGroup.sAMAccountName) = True
      Call LoadGroups(objPriObject, objGroup)
    End If
  Next
  Set objGroup = Nothing
End Sub
