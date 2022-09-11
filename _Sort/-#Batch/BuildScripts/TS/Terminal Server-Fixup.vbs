' Activity      : Acrobat Reader: Set Registry settings
' Created by    : Peter van Koppen
' Company       : Tui Ora Limited
' Date Created  : 2006-08-08
' Date Changed  : 2007-07-16
' Must be run as: <No Preference: Administrators/LocalSystem>
' -----------------------------------------------------------------

' Set Initial Script Options
' -----------------------------------------------------------------
Option Explicit
On Error Resume Next

' Set Constants and Variables
' -----------------------------------------------------------------
Dim WshShell, objFSO, strDomainName
Set WshShell = WScript.CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")
strDomainName = "SCMT"
strDomainName = "TTW"

'--- Sets the EULA not to prompt and turns off autoupdates: x86
'-------------------------------------------------------------------------
'Adobe Acrobat Reader
WSHShell.RegWrite "HKLM\SOFTWARE\Adobe\Acrobat Reader\8.0\AdobeViewer\EULA", "1", "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Adobe\Acrobat Reader\8.0\AdobeViewer\Launched", "1", "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Adobe\Acrobat Reader\9.0\AdobeViewer\EULA", "1", "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Adobe\Acrobat Reader\9.0\AdobeViewer\Launched", "1", "REG_DWORD"
'Apple Quicktime
WSHShell.RegWrite "HKLM\SOFTWARE\Apple Computer, Inc.\QuickTime\ActiveX\QTTaskRunFlags", "2", "REG_DWORD"
'Nico Mak Winzip
WSHShell.RegWrite "HKLM\SOFTWARE\Nico Mak Computing\WinZip\WinZip\ShowTips", 0, "REG_SZ"
WSHShell.RegWrite "HKLM\SOFTWARE\Nico Mak Computing\WinZip\WinZip\ShowComment", 0, "REG_SZ"
'-- Default domain
WSHShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\DefaultDomainName", strDomainName, "REG_SZ"
'Sun Java
WSHShell.RegWrite "HKLM\SOFTWARE\JavaSoft\Java Update\Policy\EnableJavaUpdate", "0", "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\JavaSoft\Java Update\Policy\EnableAutoUpdateCheck", "0", "REG_DWORD"

'--- Sets the Association message off and supresses the tips window etc: x86-Terminal Server
'-------------------------------------------------------------------------
WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\Software\Adobe\Acrobat Reader\8.0\AdobeViewer\EULA", "1", "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\Software\Adobe\Acrobat Reader\8.0\AdobeViewer\Launched", "1", "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\SOFTWARE\Apple Computer, Inc.\QuickTime\ActiveX\QTTaskRunFlags", "2", "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\Software\Nico Mak Computing\WinZip\WinZip\ShowTips", 0, "REG_SZ"
WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\Software\Nico Mak Computing\WinZip\WinZip\ShowComment", 0, "REG_SZ"
WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\Software\JavaSoft\Java Update\Policy\EnableJavaUpdate", "0", "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\Software\JavaSoft\Java Update\Policy\EnableAutoUpdateCheck", "0", "REG_DWORD"

' Remove Unwanted autorun application
'-------------------------------------------------------------------------
WSHShell.RegDelete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\Adobe Reader Speed Launcher"
WSHShell.RegDelete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\CTFMON.EXE"
WSHShell.RegDelete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\QuickTime Task"
WSHShell.RegDelete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\shstatexe"
WSHShell.RegDelete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\SunJavaUpdateSched"


'-------------------------------------------------------------------------
'-------------------------------------------------------------------------
'--- Sets the Association message off and supresses the tips window etc: x64
'-------------------------------------------------------------------------
'WSHShell.RegWrite "HKLM\SOFTWARE\Wow6432Node\Adobe\Acrobat Reader\8.0\AdobeViewer\EULA", "1", "REG_DWORD"
' Delete unwanted files
'-------------------------------------------------------------------------
'objFSO.DeleteFile("C:\Documents and Settings\All Users\Desktop\Adobe Reader 8.lnk")
'objFSO.DeleteFile("C:\Documents and Settings\All Users\Start Menu\Programs\Adobe Reader 8.lnk")
'-------------------------------------------------------------------------
'-------------------------------------------------------------------------

' Finalize and Quit the script
' -----------------------------------------------------------------
WScript.echo "Completed"
WScript.Quit

