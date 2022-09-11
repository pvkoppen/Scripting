' Activity      : Altiris: Set Registry Settings
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
Dim WshShell

' Write Build Version to the registry
' -----------------------------------------------------------------
set WshShell = WScript.CreateObject("WScript.Shell")
WshShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Altiris\Build Version\Build Number", "3", "REG_SZ"

' Finalize and Quit the script
' -----------------------------------------------------------------
WScript.Quit

