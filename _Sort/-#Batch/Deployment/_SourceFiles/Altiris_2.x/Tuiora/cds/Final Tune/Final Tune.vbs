'-------------------------------------------------------------------------
'---	Final Tune Script
'---	22-03-2005
'-------------------------------------------------------------------------
Option Explicit



Dim WshShell
Dim Shell
Set WshShell = WScript.CreateObject("WScript.Shell")
Set Shell = CreateObject("Wscript.Shell")
on error resume next

'-------------------------------------------------------------------------
'---	SETS THE DEFAULT DOMAIN NAME TO IWAYONLINE
'-------------------------------------------------------------------------

WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\DefaultDomainName", TUIORA, "REG_SZ"

'-------------------------------------------------------------------------
'---	REMOVES THE REGISTRY ENTRY THAT RUNS THE USERLOGON.CMD FILE
'-------------------------------------------------------------------------

Shell.RegDelete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\AppSetup"

'-------------------------------------------------------------------------
'---	REMOVES MISC REG KEYS FROM THE RUN KEY
'-------------------------------------------------------------------------

Shell.RegDelete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\shstatexe"
Shell.RegDelete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\SunJavaUpdateSched"
Shell.RegDelete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\MacfeeUpdaterUI"
Shell.RegDelete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\AClntUsr"
Shell.RegDelete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\CTFMON.EXE"