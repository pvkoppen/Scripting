' Name        : TS-Mail.vbs
' Description : Mail Fix for TS-2008 servers
' Author      : Peter van Koppen,  Tui Ora Ltd
' ----------------------------------------------------------

' ----------------------------------------------------------
' Change Log.
' ----------------------------------------------------------
' 2011-06-13: 1.0: First issue
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
'boolDebug = True
If (boolDebug) Then On Error Goto 0 Else On Error Resume Next End If


' Declare Variables and set initial Values
' ----------------------------------------------------------
Dim WshShell
Set WshShell   = CreateObject("WScript.Shell")
Dim strRegPathCheck, strRegPathRoot, strRegValue, strUniqueProfile


' Application Oriented Actions.
' ----------------------------------------------------------
' Application: Set registery for Profile.
' ----------------------------------------------------------
strRegPathCheck = "HKCU\Software\Tui Ora Ltd\OutlookOnTS08FromOffice2010BackToOffice2007"
strRegPathRoot = "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Windows Messaging Subsystem\Profiles"
strUniqueProfile = "Outlook-Off07"
strRegValue = ""& GetReg(strRegPathCheck)
If (strRegValue = "") Then 
  If (boolDebug) Then WScript.Echo "TS2008: Revert Office back from 2010 to 2007" &vbCrLf
'  WshShell.RegDelete(strRegPathRoot)
  SetReg strRegPathRoot&"\DefaultProfile", strUniqueProfile, "REG_SZ"
  SetReg strRegPathRoot&"\"&strUniqueProfile&"\Dummy", "Blank", "REG_SZ"
  WshShell.RegDelete(strRegPathRoot&"\"&strUniqueProfile&"\Dummy")
  SetReg strRegPathCheck, "Done", "REG_SZ"
End If


' Final.
' ----------------------------------------------------------
set WshShell   = nothing
WScript.Quit


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
