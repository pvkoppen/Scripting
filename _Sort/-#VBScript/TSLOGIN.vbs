' Name        : TSLOGON.vbs
' Description : Logon Script for Tui Ora Windows 2003 Terminal Servers
' Author      : Peter van Koppen,  Tui Ora Ltd
' Version     : 1.2
' ----------------------------------------------------------

' ----------------------------------------------------------
' Change Log.
' ----------------------------------------------------------
' 200?-??-??: v0.x: Initial version by: Aaron.Gayton@staplestaranaki.co.nz
' 2007-11-20: Version 1.0 of this logon script
' 2007-11-26: Version 1.1 of this logon script
' 2009-03-26: v1.2: Removed redundant info
' ----------------------------------------------------------

' ----------------------------------------------------------
' Here start the beginning of the VBScript. Here we set some standard global setting.
' ----------------------------------------------------------
' Option Explicit: All variabled need to be declared before they are used.
' boolDebug: If True the script will show additional information.
' On Error: Resume Next= Ingore all errors. Goto 0= Show ErrorMessage and stop.
' ----------------------------------------------------------

' Set Option Explicit and Global Variables
' ----------------------------------------------------------
Option Explicit
Dim boolDebug
boolDebug = False
'boolDebug = True
If (boolDebug) Then On Error Goto 0 Else On Error Resume Next End If


' Declare Variables and set initial Values
' ----------------------------------------------------------
Dim WshShell, FileSysObj, WshEnv
Dim uProf

Set WshShell   = CreateObject("WScript.Shell")
Set FileSysObj = CreateObject("Scripting.FileSystemObject")
Set WshEnv     = WshShell.Environment("process")
uProf          = WshEnv("userprofile")



' Make Registry changes
'----------------------------------------------------------------------------------------------
'Set IE Cache Size
WshShell.RegWrite "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\cache\Content\CacheLimit", 2048, "REG_DWORD"
'Set IE History Size
WshShell.RegWrite "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\cache\History\CacheLimit", 1024, "REG_DWORD"
'File Explorer show file extensions
WshShell.RegWrite "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\HideFileExt", 0, "REG_DWORD"
'File Explorer Display Full Path in Title Bar
WshShell.RegWrite "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState\FullPath", 1, "REG_DWORD"
'File Explorer remember each folders view settings
WshShell.RegWrite "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ClassicViewState", 1, "REG_DWORD"
'Move My documents from profile to H:\
WshShell.RegWrite "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders\Personal", "H:\", "REG_SZ"
'Move My documents from profile to H:\
WshShell.RegWrite "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders\Personal", "H:\", "REG_EXPAND_SZ"
'Move My Pictures from profile to H:\
WshShell.RegWrite "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders\My Pictures", "H:\My Pictures", "REG_SZ"
'Disable CTFMON
WshShell.RegWrite "HKCU\Software\Microsoft\Windows\CurrentVersion\Run\ctfmon.exe", "-", "REG_EXPAND_SZ"
WshShell.RegWrite "HKCU\Software\Microsoft\Windows\CurrentVersion\Run\ctfmon.exe", "-", "REG_SZ"
WshShell.RegWrite "HKCU\Software\Microsoft\CTF\Disable Thread Input Manager", 1, "REG_DWORD"
WshShell.RegWrite "HKCU\Software\Microsoft\CTF\MSUTB\ShowDeskBand", 0, "REG_DWORD"


' Clean up Menus
'----------------------------------------------------------------------------------------------
If Not FileSysObj.FolderExists("H:\Templates") Then
  FileSysObj.CreateFolder("H:\Templates")
end if
If Not FileSysObj.FileExists("H:\Templates\Normal.dot") Then
  FileSysObj.CopyFile "\\tol.local\sysvol\tol.LOCAL\scripts\normal.dot", "H:\Templates\Normal.dot", True
end if
if FileSysObj.FileExists(uprof + "\desktop\Connect to the Internet.lnk") Then
  FileSysObj.deleteFile (uprof + "\desktop\connect to the Internet.lnk"), True
end if
if FileSysObj.FileExists(uprof + "\start menu\programs\Outlook express.lnk") Then
  FileSysObj.deleteFile (uprof + "\start menu\programs\outlook express.lnk"), True
end if
if FileSysObj.FileExists(uprof + "\application data\microsoft\internet explorer\quick launch\Launch Outlook express.lnk") Then
  FileSysObj.deleteFile (uprof + "\application data\microsoft\internet explorer\quick launch\Launch outlook express.lnk"), True
end if
'If Not FileSysObj.FileExists(uprof + "\application data\microsoft\internet explorer\quick launch\Excel.lnk") Then
'  FileSysObj.CopyFile "C:\documents and settings\all users\start menu\programs\Excel.lnk", uprof + "\application data\microsoft\internet explorer\quick launch\Microsoft Excel.lnk", True
'end if
'if Not FileSysObj.FileExists(uprof + "\application data\microsoft\internet explorer\quick launch\Word.lnk") Then
'  FileSysObj.CopyFile "C:\documents and settings\all users\start menu\programs\Word.lnk", uprof + "\application data\microsoft\internet explorer\quick launch\Microsoft Word.lnk", True
'End If
If FileSysObj.FileExists(uprof + "\start menu\programs\windows messaging.lnk") Then
  FileSysObj.deleteFile (uprof + "\start menu\programs\windows messaging.lnk"), True
End If
If FileSysObj.FileExists(uprof + "\start menu\programs\accessories\synchronize.lnk") Then
  FileSysObj.deleteFile (uprof + "\start menu\programs\accessories\synchronize.lnk"), True
End If
'if fs.FileExists(uprof + "\start menu\programs\accessories\hyperterminal\AT&T Mail.ht") Then
'  fs.deleteFile (uprof + "\start menu\programs\accessories\hyperterminal\AT&T Mail.ht"), True
'End If
If FileSysObj.FileExists(uprof + "\start menu\programs\accessories\address book.lnk") Then
  FileSysObj.deleteFile (uprof + "\start menu\programs\accessories\address book.lnk"), True
End If       	
If FileSysObj.FileExists(uprof + "\start menu\programs\accessories\Entertainment\Windows Media Player.lnk") Then
  FileSysObj.deleteFile (uprof + "\start menu\programs\accessories\Entertainment\Windows Media Player.lnk"), True       	
End If       	
'If Not fs.FileExists(uprof + "\application data\microsoft\internet explorer\quick launch\Windows Explorer.lnk") Then
'  fs.CopyFile "C:\documents and settings\all users\start menu\Windows Explorer.lnk", uprof + "\application data\microsoft\internet explorer\quick launch\Windows Explorer.lnk", True
'end if


' Clean up Allocated memory
'----------------------------------------------------------------------------------------------
set WshEnv     = nothing
set FileSysObj = nothing
set WshShell   = nothing


' Final.
' ----------------------------------------------------------
Wscript.Quit

