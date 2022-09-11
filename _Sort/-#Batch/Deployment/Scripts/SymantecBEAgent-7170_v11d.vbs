' Activity      : Symantec 11d: Set Registry settings
' Created by    : Peter van Koppen
' Company       : Tui Ora Limited
' Date Created  : 2008-03-27
' Must be run as: <No Preference: Administrators/LocalSystem>
' -----------------------------------------------------------------

' VBScript Limitations
' -----------------------------------------------------------------
' WARNING: REG_MULTI_SZ id not supported in WSHShell.RegWrite.
' Supported are: REG_SZ, REG_DWORD, REG_EXPAND_SZ, REG_BINARY_SZ

' Set Initial Script Options
' -----------------------------------------------------------------
Option Explicit
'On Error Resume Next
'on error goto 0

' Set Constants and Variables
' -----------------------------------------------------------------
Dim WshShell
Set WshShell = WScript.CreateObject("WScript.Shell")

' Set the Installtion source folder
' -----------------------------------------------------------------
'--- x86
WSHShell.RegWrite "HKLM\SOFTWARE\Symantec\Backup Exec For Windows\Backup Exec\Engine\Agents\Advertise All", 1, "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Symantec\Backup Exec For Windows\Backup Exec\Engine\Agents\Advertise Now", 1, "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Symantec\Backup Exec For Windows\Backup Exec\Engine\Agents\Advertisement Purge", 0, "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Symantec\Backup Exec For Windows\Backup Exec\Engine\Agents\Advertising Disabled", 0, "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Symantec\Backup Exec For Windows\Backup Exec\Engine\Agents\Advertising Interval Minutes", 240, "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Symantec\Backup Exec For Windows\Backup Exec\Engine\Agents\Agent Directory List", "TOLSS01.tol.local", "REG_SZ"
WSHShell.RegWrite "HKLM\SOFTWARE\Symantec\Backup Exec For Windows\Backup Exec\Engine\Agents\Auto Discovery Enabled", 1, "REG_DWORD"
'--- x64
WSHShell.RegWrite "HKLM\SOFTWARE\Wow6432Node\Symantec\Backup Exec For Windows\Backup Exec\Engine\Agents\Advertise All", 1, "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Wow6432Node\Symantec\Backup Exec For Windows\Backup Exec\Engine\Agents\Advertise Now", 1, "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Wow6432Node\Symantec\Backup Exec For Windows\Backup Exec\Engine\Agents\Advertisement Purge", 0, "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Wow6432Node\Symantec\Backup Exec For Windows\Backup Exec\Engine\Agents\Advertising Disabled", 0, "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Wow6432Node\Symantec\Backup Exec For Windows\Backup Exec\Engine\Agents\Advertising Interval Minutes", 240, "REG_DWORD"
WSHShell.RegWrite "HKLM\SOFTWARE\Wow6432Node\Symantec\Backup Exec For Windows\Backup Exec\Engine\Agents\Agent Directory List", "TOLSS01.tol.local", "REG_SZ"
WSHShell.RegWrite "HKLM\SOFTWARE\Wow6432Node\Symantec\Backup Exec For Windows\Backup Exec\Engine\Agents\Auto Discovery Enabled", 1, "REG_DWORD"

' Finalize and Quit the script
' -----------------------------------------------------------------
WScript.Quit

