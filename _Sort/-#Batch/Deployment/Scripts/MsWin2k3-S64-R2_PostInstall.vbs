' Activity      : Win2k3 S64 R2: Set Registry settings
' Created by    : Peter van Koppen
' Company       : Tui Ora Limited
' Date Created  : 2006-08-28
' Must be run as: <No Preference: Administrators/LocalSystem>
' -----------------------------------------------------------------

' Set Initial Script Options
' -----------------------------------------------------------------
Option Explicit
On Error Resume Next

' Set Constants and Variables
' -----------------------------------------------------------------
Dim WshShell
Set WshShell = WScript.CreateObject("WScript.Shell")

' Set the Installtion source folder
' -----------------------------------------------------------------
'--- x86
WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Setup\SourcePath", "\\TOLDS01.tol.local\eXpress\lib\OSdist\W52S64R2.CD1", "REG_SZ"
WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Setup\ServicePackSourcePath", "\\TOLDS01.tol.local\eXpress\lib\OSdist\W52-64.SP2", "REG_SZ"
'--- x64
WSHShell.RegWrite "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Setup\SourcePath", "\\TOLDS01.tol.local\eXpress\lib\OSdist\W52S64R2.CD1", "REG_SZ"
WSHShell.RegWrite "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Setup\ServicePackSourcePath", "\\TOLDS01.tol.local\eXpress\lib\OSdist\W52-64.SP2", "REG_SZ"

' Finalize and Quit the script
' -----------------------------------------------------------------
WScript.Quit

