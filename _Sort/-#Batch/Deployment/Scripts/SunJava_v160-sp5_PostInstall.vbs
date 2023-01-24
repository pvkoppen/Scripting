' Activity      : Java: Set Registry settings v1.6-sp16
' Created by    : Peter van Koppen
' Company       : Tui Ora Limited
' Date Created  : 2006-08-11
' Date Changed  : 2007-07-16
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

'---	Sets the EULA not to prompt and turns off autoupdates
'-------------------------------------------------------------------------
'--- x86
WSHShell.RegWrite "HKLM\SOFTWARE\JavaSoft\Java Update\Policy\EnableJavaUpdate", "0", "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\JavaSoft\Java Update\Policy\EnableAutoUpdateCheck", "0", "REG_DWORD"
'--- x64
WSHShell.RegWrite "HKLM\SOFTWARE\Wow6432Node\JavaSoft\Java Update\Policy\EnableJavaUpdate", "0", "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Wow6432Node\JavaSoft\Java Update\Policy\EnableAutoUpdateCheck", "0", "REG_DWORD"

'---	Sets the EULA not to prompt and turns off autoupdates
'-------------------------------------------------------------------------
'--- x86
WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\Software\JavaSoft\Java Update\Policy\EnableJavaUpdate", "0", "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\Software\JavaSoft\Java Update\Policy\EnableAutoUpdateCheck", "0", "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\SunJavaUpdateSched", "rem ""C:\Program Files\Java\jre6\bin\jusched.exe""", "REG_SZ"
'--- x64
WSHShell.RegWrite "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\Software\JavaSoft\Java Update\Policy\EnableJavaUpdate", "0", "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\Software\JavaSoft\Java Update\Policy\EnableAutoUpdateCheck", "0", "REG_DWORD"

' Finalize and Quit the script
' -----------------------------------------------------------------
WScript.Quit
