' Activity      : Windows: Set Registry settings
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
Dim Shell
Set WshShell = WScript.CreateObject("WScript.Shell")
Set Shell = CreateObject("Wscript.Shell")

'---	SETS THE DEFAULT DOMAIN NAME TO TOL
'-------------------------------------------------------------------------
'--- x86
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\DefaultDomainName", TOL, "REG_SZ"
'--- x64
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon\DefaultDomainName", TOL, "REG_SZ"

'---	REMOVES THE REGISTRY ENTRY THAT RUNS THE USERLOGON.CMD FILE
'-------------------------------------------------------------------------
'--- x86
Shell.RegDelete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\AppSetup"
'--- x64
Shell.RegDelete "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon\AppSetup"

'---	REMOVES MISC REG KEYS FROM THE RUN KEY
'-------------------------------------------------------------------------
'--- x86
Shell.RegDelete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\shstatexe"
Shell.RegDelete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\SunJavaUpdateSched"
Shell.RegDelete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\MacfeeUpdaterUI"
Shell.RegDelete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\AClntUsr"
Shell.RegDelete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\CTFMON.EXE"
'--- x64
Shell.RegDelete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run\shstatexe"
Shell.RegDelete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run\SunJavaUpdateSched"
Shell.RegDelete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run\MacfeeUpdaterUI"
Shell.RegDelete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run\AClntUsr"
Shell.RegDelete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run\CTFMON.EXE"

' Finalize and Quit the script
' -----------------------------------------------------------------
WScript.Quit

