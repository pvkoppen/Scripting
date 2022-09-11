' Activity      : Windows: Change Admin Password
' Created by    : Peter van Koppen
' Company       : Tui Ora Limited
' Date Created  : 2006-08-08
' Must be run as: <No Preference: Administrators/LocalSystem>
' -----------------------------------------------------------------

' Set Initial Script Options
' -----------------------------------------------------------------
Option Explicit
On Error Resume Next

' Set Constants and Variables
' -----------------------------------------------------------------
Dim strComputer
Dim objUser

' ..
' -----------------------------------------------------------------
strComputer = "."
Set objUser = GetObject("WinNT://" & strComputer & "/Administrator, user")
objUser.SetPassword "Tu1@Ra30"
objUser.SetInfo

' Finalize and Quit the script
' -----------------------------------------------------------------
WScript.Quit

