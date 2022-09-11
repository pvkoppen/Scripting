' Name        : Report-FreeDiskSpace.vbs
' Description : Script used to Report on free disk space on all domain server computers.
' Author      : Peter van Koppen,  Tui Ora Limited
' Version     : 1.1b
' -----------------------------------------------------------------------

' -----------------------------------------------------------------------
' Change Log.
' -----------------------------------------------------------------------
' 2010-03-xx: 1.0: Original version by: Chrissy LeMaire (clemaire@gmail.com)
' 2010-03-xx: 1.0: Website: http://netnerds.net/
' 2010-03-xx: 1.0: Requirements -- ability to read WinNT://, create events and read WMI
' 2010-03-22: 1.1: Rebuild version for our needs
' 2010-03-22: 1.1a: Entered all this logging info.
' 2010-03-29: 1.1b: Changed Labelling
' -----------------------------------------------------------------------

' -- Default Settings and Variables
' -----------------------------------------------------------------------
Option Explicit
Dim boolDebug
boolDebug = False
boolDebug = True
If (boolDebug) Then On Error Goto 0 Else On Error Resume Next End If
Dim objAdRootDSE, objRS, varConfigNC, strConnstring, strWQL
Dim objServer, strServerName


' Customize values here to fit your needs
' -----------------------------------------------------------------------
Set objAdRootDSE = GetObject("LDAP://RootDSE")
Set objRS = CreateObject("adodb.recordset")

  varConfigNC = objAdRootDSE.Get("defaultNamingContext")
  strConnstring = "Provider=ADsDSOObject"
  strWQL = "SELECT * FROM 'LDAP://" & varConfigNC & "' WHERE objectCategory= 'Computer' and OperatingSystem = 'Windows*Server*'"
  objRS.Open strWQL, strConnstring
    Do until objRS.eof
       Set objServer = GetObject(objRS.Fields.Item(0))
       strServerName = objServer.CN
       Call CheckLowDiskSpaceAndLogEvent(strServerName)
       objRS.movenext
    Loop
    Set objServer = Nothing
  objRS.close

Set objRS = Nothing
Set objAdRootDSE = Nothing


' CheckLowDiskSpaceAndLogEvent
' -----------------------------------------------------------------------
Sub CheckLowDiskSpaceAndLogEvent(strComputer)

  Dim objWMIService, colItems, objItem, PercentFree
  WScript.Echo "Processing server: " & strComputer
  Err.Clear
  Set objWMIService = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2") 
  'Set objWMIService = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
  If Not (Err = 0) Then
    DisplayErrorInfo
    Call LogEvent("", "Low Disk Space.", "ERROR", "1000", "System", "Connection failed to WMI on " & StrComputer & ".")
  Else
    Call LogEvent("", "Low Disk Space.", "INFORMATION", "1000", "System", "Connected to WMI on " & StrComputer & ".")
    Set colItems = objWMIService.ExecQuery  ("Select DeviceID, Size, FreeSpace from Win32_LogicalDisk where DriveType = 3") 'Grab the name and the free space for fixed drives
    For Each objItem in colItems
      WScript.Echo " - Checking Device: " & objItem.DeviceID
      PercentFree = formatnumber(((objItem.FreeSpace/objItem.Size)*100),2)
      WScript.Echo " - Percent Free: " & PercentFree
      If PercentFree <= 10 Then 'Convert to MB then check for < 1GB
        Call LogEvent("", "Low Disk Space.", "ERROR", "1000", "System", "The free space of disk " & objItem.DeviceID & " on " & StrComputer & " has dropped below 10% (" & PercentFree & "% free).")
      Else
        Call LogEvent("", "Low Disk Space.", "INFORMATION", "1000", "System", "The free space of disk " & objItem.DeviceID & " on " & StrComputer & " is above 10% (" & PercentFree & "% free).")
      End If
    Next
    Set colItems = Nothing
  End If
  Set objWMIService = Nothing

End Sub


' LogEvent
' -----------------------------------------------------------------------
Sub LogEvent(strLogComputer, strSource, strType, strID, strLogType, strDescription)

  Dim runThis, WindowStyle, WshShell
  If ((strLogComputer = "") or (strLogComputer = ".")) Then
    runThis =  "%COMSPEC% /c eventcreate /so """ & strSource & """ /T " & strType & " /ID " & strID & " /L " & strLogType & " /D """ & strDescription & """"
  Else
    runThis =  "%COMSPEC% /c eventcreate /s " & strLogComputer & " /so """ & strSource & """ /T " & strType & " /ID " & strID & " /L " & strLogType & " /D """ & strDescription & """"
  End If
  WScript.Echo runThis
  WindowStyle = 0 'Do not pop up a dos box
  Set WshShell = WScript.CreateObject("WScript.Shell") 'generate the object
  Call WshShell.Run (runThis, WindowStyle, false) 'execute the dos command listed above (COMSPEC = cmd.exe)
  Set WshShell = Nothing

End Sub


' DisplayErrorInfo
' -----------------------------------------------------------------------
Sub DisplayErrorInfo
  WScript.Echo "Error:      : " & Err
  WScript.Echo "Error (hex) : &H" & Hex(Err)
  WScript.Echo "Source      : " & Err.Source
  WScript.Echo "Description : " & Err.Description
  Err.Clear
End Sub

