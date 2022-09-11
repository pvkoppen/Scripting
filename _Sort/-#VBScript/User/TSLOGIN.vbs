' Logon Script for Tui Ora Windows 2003 Terminal Servers
' Aaron.Gayton@staplestaranaki.co.nz




option explicit
Const Tuiora		= "cn=Tui Ora (TOL) Users"
dim WSHNetwork
Dim LDrive
Dim fs
Dim f
Dim WshShell
Dim sFolder
Dim sFile
Dim WshSysEnv
Dim uProf
Dim uUsername
Dim MSTM

Set WshShell = WScript.CreateObject("WScript.Shell")
Set fs = CreateObject("Scripting.FileSystemObject")
Set WshSysEnv = WshShell.Environment("process")
uProf = WshSysEnv("userprofile")
uUsername = WshSysEnv("username")
On Error Resume Next 

Set oWshnetwork=CreateObject("wscript.network")
Set oShell=CreateObject("wscript.shell")
Set ADSysInfo = CreateObject("ADSystemInfo")
Set CurrentUser = GetObject("LDAP://" & ADSysInfo.UserName)
strGroups = LCase(Join(CurrentUser.MemberOf))

If InStr(strGroups, TuiOra) Then
wshNetwork.MapNetworkDrive "G:", "\\dc12\tol$"
wshNetwork.MapNetworkDrive "H:", "\\DC12\" & wshNetwork.Username & "$"
wshNetwork.MapNetworkDrive "H:", "\\DC12\shared$" 
End If





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

''''''''''''''''''''''''''''
' Clean up Menus
''''''''''''''''''''''''''''
If Not fs.FolderExists("H:\Templates") Then
       	fs.CreateFolder("H:\Templates")
end if
       
If Not fs.FileExists("H:\Templates\Normal.dot") Then
       	fs.CopyFile "\\tuiora.local\sysvol\TUIORA.LOCAL\scripts\normal.dot", "H:\Templates\Normal.dot", True
end if

if fs.FileExists(uprof + "\desktop\Connect to the Internet.lnk") Then
       	fs.deleteFile (uprof + "\desktop\connect to the Internet.lnk"), True
end if

if fs.FileExists(uprof + "\start menu\programs\Outlook express.lnk") Then
       :	fs.deleteFile (uprof + "\start menu\programs\outlook express.lnk"), True
end if

if fs.FileExists(uprof + "\application data\microsoft\internet explorer\quick launch\Launch Outlook express.lnk") Then
       	fs.deleteFile (uprof + "\application data\microsoft\internet explorer\quick launch\Launch outlook express.lnk"), True
end if

If Not fs.FileExists(uprof + "\application data\microsoft\internet explorer\quick launch\Excel.lnk") Then
       	fs.CopyFile "C:\documents and settings\all users\start menu\programs\Excel.lnk", uprof + "\application data\microsoft\internet explorer\quick launch\Microsoft Excel.lnk", True
end if

if Not fs.FileExists(uprof + "\application data\microsoft\internet explorer\quick launch\Word.lnk") Then
       	fs.CopyFile "C:\documents and settings\all users\start menu\programs\Word.lnk", uprof + "\application data\microsoft\internet explorer\quick launch\Microsoft Word.lnk", True
End If

If fs.FileExists(uprof + "\start menu\programs\windows messaging.lnk") Then
       	fs.deleteFile (uprof + "\start menu\programs\windows messaging.lnk"), True
End If

If fs.FileExists(uprof + "\start menu\programs\accessories\synchronize.lnk") Then
       	fs.deleteFile (uprof + "\start menu\programs\accessories\synchronize.lnk"), True
End If

'if fs.FileExists(uprof + "\start menu\programs\accessories\hyperterminal\AT&T Mail.ht") Then
'       	fs.deleteFile (uprof + "\start menu\programs\accessories\hyperterminal\AT&T Mail.ht"), True

If fs.FileExists(uprof + "\start menu\programs\accessories\address book.lnk") Then
       	fs.deleteFile (uprof + "\start menu\programs\accessories\address book.lnk"), True
End If       	
If fs.FileExists(uprof + "\start menu\programs\accessories\Entertainment\Windows Media Player.lnk") Then
       	fs.deleteFile (uprof + "\start menu\programs\accessories\Entertainment\Windows Media Player.lnk"), True       	
End If       	
If Not fs.FileExists(uprof + "\application data\microsoft\internet explorer\quick launch\Windows Explorer.lnk") Then
       	fs.CopyFile "C:\documents and settings\all users\start menu\Windows Explorer.lnk", uprof + "\application data\microsoft\internet explorer\quick launch\Windows Explorer.lnk", True
end if



set WSHNetwork = nothing


