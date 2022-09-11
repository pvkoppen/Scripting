' Activity      : WinZip: Set Registry settings
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

'---	Sets the Association message off and supresses the tips window etc
'-------------------------------------------------------------------------
'--- x86
WSHShell.RegWrite "HKLM\SOFTWARE\Nico Mak Computing\WinZip\WinZip\ShowTips", 0, "REG_SZ"
WSHShell.RegWrite "HKLM\SOFTWARE\Nico Mak Computing\WinZip\WinZip\ShowComment", 0, "REG_SZ"
'--- x64
WSHShell.RegWrite "HKLM\SOFTWARE\Wow6432Node\Nico Mak Computing\WinZip\WinZip\ShowTips", 0, "REG_SZ"
WSHShell.RegWrite "HKLM\SOFTWARE\Wow6432Node\Nico Mak Computing\WinZip\WinZip\ShowComment", 0, "REG_SZ"

'---	Sets the Association message off and supresses the tips window etc
'-------------------------------------------------------------------------
'--- x86
WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\Software\Nico Mak Computing\WinZip\WinZip\ShowTips", 0, "REG_SZ"
WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\Software\Nico Mak Computing\WinZip\WinZip\ShowComment", 0, "REG_SZ"
'--- x64
WSHShell.RegWrite "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\Software\Nico Mak Computing\WinZip\WinZip\ShowTips", 0, "REG_SZ"
WSHShell.RegWrite "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\Software\Nico Mak Computing\WinZip\WinZip\ShowComment", 0, "REG_SZ"

' Delete unwanted files
' -----------------------------------------------------------------
objFSO.DeleteFile("C:\Documents and Settings\All Users\Desktop\winzip.lnk")
objFSO.DeleteFile("C:\Documents and Settings\All Users\Start Menu\winzip.lnk")

' Finalize and Quit the script
' -----------------------------------------------------------------
WScript.Quit

