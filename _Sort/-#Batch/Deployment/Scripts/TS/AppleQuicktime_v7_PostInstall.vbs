' Activity      : Apple Quicktime: Remove Unwanted files
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

' Set Constants and Variables
' -----------------------------------------------------------------
'--- x86
WSHShell.RegWrite "HKLM\SOFTWARE\Apple Computer, Inc.\QuickTime\ActiveX\QTTaskRunFlags", "2", "REG_DWORD"
'--- x64
WSHShell.RegWrite "HKLM\SOFTWARE\Wow6432Node\Apple Computer, Inc.\QuickTime\ActiveX\QTTaskRunFlags", "2", "REG_DWORD"

' Set Constants and Variables
' -----------------------------------------------------------------
'--- x86
WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\SOFTWARE\Apple Computer, Inc.\QuickTime\ActiveX\QTTaskRunFlags", "2", "REG_DWORD"
'--- x64
WSHShell.RegWrite "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\SOFTWARE\Apple Computer, Inc.\QuickTime\ActiveX\QTTaskRunFlags", "2", "REG_DWORD"

' Delete unwanted files
' -----------------------------------------------------------------
objFSO.DeleteFile("C:\Documents and Settings\All Users\Desktop\QuickTime Player.lnk")
objFSO.DeleteFolder("C:\Documents and Settings\All Users\Start Menu\Programs\QuickTime")

' Finalize and Quit the script
' -----------------------------------------------------------------
WScript.Quit

