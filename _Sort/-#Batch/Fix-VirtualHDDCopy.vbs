' Name        : Fix-VirtualHDDCopy.vbs
' Description : Remove two ID's that limit management of copied/Ghosted HDD's
' Author      : Peter van Koppen,  Tui Ora Ltd
' ----------------------------------------------------------

' ----------------------------------------------------------
' Change Log.
' ----------------------------------------------------------
' 2011-08-23: 1.0: Initial version

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
Dim RegItem, RegValue


'Process ID's
RegItem = "HKLM\SOFTWARE\Network Associates\ePolicy Orchestrator\Agent\AgentGUID"
ProcessID RegItem
RegItem = "HKLM\SOFTWARE\Microsoft\Windows\CUrrentVersion\WindowsUpdate\SusClientId"
ProcessID RegItem


' Procedure: ProcessID
' Does: Checks and Removes ID
' ----------------------------------------------------------
Public Function ProcessID(strRegItem)
  Dim WshShell, strResult
  Set WshShell   = CreateObject("WScript.Shell")
  WScript.Echo ""
  WScript.Echo "Removing ID: Checking (" & strRegItem &")."
  strResult = WshShell.RegRead(strRegItem)
  IF (err.number = 0) then
    WScript.Echo "Removing ID: Required ("& strRegItem &"="& strResult &")."
    WshShell.RegDelete strRegItem
    IF (err.number = 0) then 
      WScript.Echo "Removing ID: Completed ("& strRegItem &")."
    Else
      WScript.Echo "Removing ID: Failed ("& strRegItem &")."
    End If 
  Else 
    WScript.Echo "Removing ID: No action required ("& strRegItem &")."
  End If
  Set WshShell   = nothing
End Function


' Clean up Allocated memory
'----------------------------------------------------------------------------------------------


' Final.
' ----------------------------------------------------------
Wscript.Quit

