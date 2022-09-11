
set WshShell = WScript.CreateObject("WScript.Shell")

'Write Build Version to the registry
WshShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Altiris\Build Version\Build Number", "3", "REG_SZ"

