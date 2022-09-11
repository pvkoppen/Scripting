' Activity      : Acrobat Reader: Set Registry settings
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

'---	Sets the EULA not to prompt and turns off autoupdates
'-------------------------------------------------------------------------
'--- x86
WSHShell.RegWrite "HKLM\SOFTWARE\Adobe\Acrobat Reader\7.0\AdobeViewer\EULA", "1", "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Adobe\Acrobat Reader\7.0\AdobeViewer\Updater\bShowAutoUpdateConfDialog", "0", "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Adobe\Acrobat Reader\7.0\AdobeViewer\Updater\bShowNotifDialog", "0", "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Adobe\Acrobat Reader\7.0\AdobeViewer\Updater\iUpdateFrequency", "0", "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Adobe\Acrobat Reader\7.0\AVGeneral\iConnectionSpeed", "521000", "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Adobe\Acrobat Reader\7.0\Originals\bDisplayAboutDialog", "0", "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Adobe\Acrobat Reader\7.0\Originals\iPageUnits", "2", "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Adobe\Acrobat Reader\7.0\Search\cOptions\bEnableBGIndexing", "0", "REG_DWORD"
'--- x64
WSHShell.RegWrite "HKLM\SOFTWARE\Wow6432Node\Adobe\Acrobat Reader\7.0\AdobeViewer\EULA", "1", "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Wow6432Node\Adobe\Acrobat Reader\7.0\AdobeViewer\Updater\bShowAutoUpdateConfDialog", "0", "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Wow6432Node\Adobe\Acrobat Reader\7.0\AdobeViewer\Updater\bShowNotifDialog", "0", "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Wow6432Node\Adobe\Acrobat Reader\7.0\AdobeViewer\Updater\iUpdateFrequency", "0", "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Wow6432Node\Adobe\Acrobat Reader\7.0\AVGeneral\iConnectionSpeed", "521000", "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Wow6432Node\Adobe\Acrobat Reader\7.0\Originals\bDisplayAboutDialog", "0", "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Wow6432Node\Adobe\Acrobat Reader\7.0\Originals\iPageUnits", "2", "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Wow6432Node\Adobe\Acrobat Reader\7.0\Search\cOptions\bEnableBGIndexing", "0", "REG_DWORD"

'---	Sets the EULA not to prompt and turns off autoupdates
'-------------------------------------------------------------------------
'WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\Software\Adobe\Acrobat Reader\7.0\AdobeViewer\EULA", "1", "REG_DWORD"
'WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\Software\Adobe\Acrobat Reader\7.0\AdobeViewer\Updater\bShowAutoUpdateConfDialog", "0", "REG_DWORD"
'WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\Software\Adobe\Acrobat Reader\7.0\AdobeViewer\Updater\bShowNotifDialog", "0", "REG_DWORD"
'WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\Software\Adobe\Acrobat Reader\7.0\AdobeViewer\Updater\iUpdateFrequency", "0", "REG_DWORD"
'WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\Software\Adobe\Acrobat Reader\7.0\AVGeneral\iConnectionSpeed", "521000", "REG_DWORD"
'WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\Software\Adobe\Acrobat Reader\7.0\Originals\bDisplayAboutDialog", "0", "REG_DWORD"
'WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\Software\Adobe\Acrobat Reader\7.0\Originals\iPageUnits", "2", "REG_DWORD"
'WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\Software\Adobe\Acrobat Reader\7.0\Search\cOptions\bEnableBGIndexing", "0", "REG_DWORD"

' Delete unwanted files
' -----------------------------------------------------------------
objFSO.DeleteFile("C:\Documents and Settings\All Users\Desktop\Adobe Reader 7.0.lnk")
objFSO.DeleteFile("C:\Documents and Settings\All Users\Start Menu\Programs\Adobe Reader 7.0.lnk")

' Finalize and Quit the script
' -----------------------------------------------------------------
WScript.Quit

