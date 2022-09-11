' Activity      : Softgrid Delete Reg Key
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
Dim objFSO
Set WshShell = WScript.CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")

'---	Delete Reg Key or value and all subkeys
'-------------------------------------------------------------------------

WshShell.RegDelete "HKEY_CURRENT_USER\Software\Classes\"
' Delete unwanted files
' -----------------------------------------------------------------
'objFSO.DeleteFile("C:\Path\file.ext")


' Finalize and Quit the script
' -----------------------------------------------------------------
WScript.Quit

