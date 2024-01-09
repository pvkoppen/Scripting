'-------------------------------------------------------------------------
'---	Acrobat Reader update Script
'---	15 June 2004 By Kelvin Brace
'-------------------------------------------------------------------------
Option Explicit

Dim WshShell
Set WshShell = WScript.CreateObject("WScript.Shell")


'-------------------------------------------------------------------------
'---	Sets the EULA not to prompt and turns off autoupdates
'-------------------------------------------------------------------------

WSHShell.RegWrite "HKLM\SOFTWARE\Adobe\Acrobat Reader\6.0\AdobeViewer\EULA", "1", "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Adobe\Acrobat Reader\6.0\Originals\iPageUnits", "2", "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Adobe\Acrobat Reader\6.0\AdobeViewer\Updater\bShowAutoUpdateConfDialog", "0", "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Adobe\Acrobat Reader\6.0\AdobeViewer\Updater\bShowNotifDialog", "0", "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Adobe\Acrobat Reader\6.0\AVGeneral\iConnectionSpeed", "521000", "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Adobe\Acrobat Reader\6.0\AdobeViewer\Updater\iUpdateFrequency", "0", "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Adobe\Acrobat Reader\6.0\Originals\bDisplayAboutDialog", "0", "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Adobe\Acrobat Reader\6.0\Search\cOptions\bEnableBGIndexing", "0", "REG_DWORD"

WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\Software\Adobe\Acrobat Reader\6.0\AdobeViewer\EULA", "1", "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\Software\Adobe\Acrobat Reader\6.0\Originals\iPageUnits", "2", "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\Software\Adobe\Acrobat Reader\6.0\AdobeViewer\Updater\bShowAutoUpdateConfDialog", "0", "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\Software\Adobe\Acrobat Reader\6.0\AdobeViewer\Updater\bShowNotifDialog", "0", "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\Software\Adobe\Acrobat Reader\6.0\AVGeneral\iConnectionSpeed", "521000", "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\Software\Adobe\Acrobat Reader\6.0\AdobeViewer\Updater\iUpdateFrequency", "0", "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\Software\Adobe\Acrobat Reader\6.0\Originals\bDisplayAboutDialog", "0", "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\Software\Adobe\Acrobat Reader\6.0\Search\cOptions\bEnableBGIndexing", "0", "REG_DWORD"
