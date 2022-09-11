' Activity      : Moneyworks
' Created by    : Peter van Koppen
' Company       : Tui Ora Limited
' Version       : 1.0
' Must be run as: <No Preference: Administrators/LocalSystem>
' -----------------------------------------------------------------

' ChangeLog
' -----------------------------------------------------------------
' 2010-01-08: 1.0: Initial version
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
WScript.Echo "Before:" & WshShell.RegRead("HKCU\Software\Classes\.mwgz\")
WSHShell.RegWrite "HKCU\Software\Classes\.mwbackup\", "mwgzfile", "REG_SZ"
WSHShell.RegWrite "HKCU\Software\Classes\.mwd3\", "mwd3file", "REG_SZ"
WSHShell.RegWrite "HKCU\Software\Classes\.mwgz\", "mwgzfile", "REG_SZ"
WScript.Echo "After:" & WshShell.RegRead("HKCU\Software\Classes\.mwgz\")


'-------------------------------------------------------------------------
WScript.Echo "DocName:" & WshShell.RegRead("HKCU\Software\Classes\mwd3file\")
WSHShell.RegWrite "HKCU\Software\Classes\mwd3file\", "MoneyWorks Document", "REG_SZ"
WScript.Echo "DocName:" & WshShell.RegRead("HKCU\Software\Classes\mwd3file\")

WScript.Echo "Icon:" & WshShell.RegRead("HKCU\Software\Classes\mwd3file\DefaultIcon\")
WSHShell.RegWrite "HKCU\Software\Classes\mwd3file\DefaultIcon\", "M:\Moneyworks\MoneyWorks Gold.exe,11", "REG_SZ"
WScript.Echo "Icon:" & WshShell.RegRead("HKCU\Software\Classes\mwd3file\DefaultIcon\")

WScript.Echo "Open:" & WshShell.RegRead("HKCU\Software\Classes\mwd3file\shell\open\command\")
WSHShell.RegWrite "HKCU\Software\Classes\mwd3file\shell\open\command\", """M:\Moneyworks\MoneyWorks Gold.exe"" ""%1""", "REG_SZ"
WScript.Echo "Open:" & WshShell.RegRead("HKCU\Software\Classes\mwd3file\shell\open\command\")

'-------------------------------------------------------------------------
WScript.Echo "DocName:" & WshShell.RegRead("HKCU\Software\Classes\mwgzfile\")
WSHShell.RegWrite "HKCU\Software\Classes\mwgzfile\", "MoneyWorks Backup", "REG_SZ"
WScript.Echo "DocName:" & WshShell.RegRead("HKCU\Software\Classes\mwgzfile\")

WScript.Echo "EditFlags:" & WshShell.RegRead("HKCU\Software\Classes\mwgzfile\EditFlags")
WSHShell.RegWrite "HKCU\Software\Classes\mwgzfile\EditFlags", CLng(&H00000000), "REG_BINARY"
WScript.Echo "EditFlags:" & WshShell.RegRead("HKCU\Software\Classes\mwgzfile\EditFlags")

WScript.Echo "Icon:" & WshShell.RegRead("HKCU\Software\Classes\mwgzfile\DefaultIcon\")
WSHShell.RegWrite "HKCU\Software\Classes\mwgzfile\DefaultIcon\", "M:\Moneyworks\MoneyWorks Gold.exe,5", "REG_SZ"
WScript.Echo "Icon:" & WshShell.RegRead("HKCU\Software\Classes\mwgzfile\DefaultIcon\")

WScript.Echo "Open:" & WshShell.RegRead("HKCU\Software\Classes\mwgzfile\shell\open\command\")
WSHShell.RegWrite "HKCU\Software\Classes\mwgzfile\shell\open\command\", """M:\Moneyworks\MoneyWorks Gold.exe"" ""%1""", "REG_SZ"
WScript.Echo "Open:" & WshShell.RegRead("HKCU\Software\Classes\mwgzfile\shell\open\command\")


'[HKEY_CURRENT_USER\Software\Classes\mwgzfile]
'@="MoneyWorks Backup"
'"EditFlags"=
'[HKEY_CURRENT_USER\Software\Classes\mwgzfile\DefaultIcon]
'@="M:\\Moneyworks\\MoneyWorks Gold.exe,5"
'[HKEY_CURRENT_USER\Software\Classes\mwgzfile\shell\open\command]
'@="\"M:\\Moneyworks\\MoneyWorks Gold.exe\" \"%1\""




' Finalize and Quit the script
' -----------------------------------------------------------------
WScript.Quit

