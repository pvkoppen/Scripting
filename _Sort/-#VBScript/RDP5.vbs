' Name        : Restore RDP5.vbs
' Description : Remove two limiting Registry entries
' Author      : Peter van Koppen,  Tui Ora Ltd
' Version     : 1.0
' ----------------------------------------------------------

' ----------------------------------------------------------
' Change Log.
' ----------------------------------------------------------
' 2010-08-27: 1.0: Initila version

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
Dim WshShell, RegCU, RegLM, Result

Set WshShell   = CreateObject("WScript.Shell")
RegCU = "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{4eb89ff4-7f78-4a0f-8b8d-2bf02e94e4b2}\"
RegLM = "HKLM\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{4eb89ff4-7f78-4a0f-8b8d-2bf02e94e4b2}\"


' Make Registry changes
'----------------------------------------------------------------------------------------------
WScript.Echo "Trying: " & RegCU
Result = WshShell.RegRead(RegCU)
IF (err.number = 0) then
  WScript.Echo "Current User: Cleanup required (" & Err.Number & ")."
  WshShell.RegDelete RegCU
  IF (err.number = 0) then 
    WScript.Echo "Current User: Cleanup completed (" & Err.Number & ")."
  Else
    WScript.Echo "Current User: Cleanup failed (" & Err.Number & ")."
  End If 
Else 
  WScript.Echo "Current User: No action required (" & Err.Number & ")."
End If

WScript.Echo "Trying: " & RegLM
Result = WshShell.RegRead(RegLM)
IF (err.number = 0) then
  WScript.Echo "Local Machine: Cleanup required (" & Err.Number & ")."
  WshShell.RegDelete RegLM
  IF (err.number = 0) then 
    WScript.Echo "Local Machine: Cleanup completed (" & Err.Number & ")."
  Else
    WScript.Echo "Local Machine: Cleanup failed (" & Err.Number & ")."
  End If 
Else 
  WScript.Echo "Local Machine: No action required (" & Err.Number & ")."
End If

' Clean up Allocated memory
'----------------------------------------------------------------------------------------------
set WshShell   = nothing


' Final.
' ----------------------------------------------------------
Wscript.Quit





