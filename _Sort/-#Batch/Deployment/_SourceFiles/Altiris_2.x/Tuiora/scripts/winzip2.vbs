'-------------------------------------------------------------------------
'---	WinZip update Script
'---	16 June 2004
'-------------------------------------------------------------------------
Option Explicit

Dim WshShell
Set WshShell = WScript.CreateObject("WScript.Shell")


'-------------------------------------------------------------------------
'---	Sets the Association message off and supresses the tips window etc
'-------------------------------------------------------------------------

WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\Software\Nico Mak Computing\WinZip\WinZip\ShowTips", 0, "REG_SZ"
WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\Software\Nico Mak Computing\WinZip\WinZip\ShowComment", 0, "REG_SZ"
