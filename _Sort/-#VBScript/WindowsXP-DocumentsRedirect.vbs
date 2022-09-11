' Name        : WindowsXP-DOcumentsRedirect.vbs
' Description : Script for Redirecting Users My Documents Folder
' Author      : Peter van Koppen,  Tui Ora Ltd
' ----------------------------------------------------------

' ----------------------------------------------------------
' Change Log.
' ----------------------------------------------------------
' 2011-07-05: 1.0: Initial version: Copy from TSLogin.vbs
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

Dim strRegPath, strRegVersion, strRegBuild

strRegPath = "HKLM\Software\Microsoft\Windows NT\CurrentVersion\"
strRegVersion = ""& GetReg(strRegPath&"CurrentVersion")
strRegBuild = ""& GetReg(strRegPath&"CurrentBuildNumber")
If (strRegVersion = "5.1") Then 
  If (boolDebug) Then WScript.Echo "OS: Windows XP" &vbCrlf& "Version: " &strRegVersion& ", Build: " &strRegBuild &vbCrLf
  ' Make Registry changes
  '----------------------------------------------------------------------------------------------
  'File Explorer show file extensions
  WshShell.RegWrite "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\HideFileExt", 0, "REG_DWORD"
  'File Explorer Display Full Path in Title Bar
  WshShell.RegWrite "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState\FullPath", 1, "REG_DWORD"
  'File Explorer remember each folders view settings
  WshShell.RegWrite "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ClassicViewState", 1, "REG_DWORD"
  'Move My documents from profile to H:\
  WshShell.RegWrite "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders\Personal", "H:\", "REG_EXPAND_SZ"
  'Move My Pictures from profile to H:\
  WshShell.RegWrite "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders\My Pictures", "H:\My Pictures", "REG_EXPAND_SZ"

  ' Clean up Menus
  '----------------------------------------------------------------------------------------------
  If Not FileSysObj.FolderExists("H:\Templates") Then
    FileSysObj.CreateFolder("H:\Templates")
  end if
  If Not FileSysObj.FileExists("H:\Templates\Normal.dot") Then
    FileSysObj.CopyFile "\\tol.local\sysvol\tol.LOCAL\scripts\normal.dot", "H:\Templates\Normal.dot", True
  end if
  if FileSysObj.FileExists(uprof + "\start menu\programs\Outlook express.lnk") Then
    FileSysObj.deleteFile (uprof + "\start menu\programs\outlook express.lnk"), True
  end if
  if FileSysObj.FileExists(uprof + "\application data\microsoft\internet explorer\quick launch\Launch Outlook express.lnk") Then
    FileSysObj.deleteFile (uprof + "\application data\microsoft\internet explorer\quick launch\Launch outlook express.lnk"), True
  end if
  If FileSysObj.FileExists(uprof + "\start menu\programs\windows messaging.lnk") Then
    FileSysObj.deleteFile (uprof + "\start menu\programs\windows messaging.lnk"), True
  End If
  If FileSysObj.FileExists(uprof + "\start menu\programs\accessories\address book.lnk") Then
    FileSysObj.deleteFile (uprof + "\start menu\programs\accessories\address book.lnk"), True
  End If       	
  If FileSysObj.FileExists(uprof + "\start menu\programs\accessories\Entertainment\Windows Media Player.lnk") Then
    FileSysObj.deleteFile (uprof + "\start menu\programs\accessories\Entertainment\Windows Media Player.lnk"), True       	
  End If       	
End If


' Clean up Allocated memory
'----------------------------------------------------------------------------------------------
set WshEnv     = nothing
set FileSysObj = nothing
set WshShell   = nothing


' Final.
' ----------------------------------------------------------
Wscript.Quit

' Procedure: GetReg
' Does: Retrieves the registry information.
' ----------------------------------------------------------
Public Function GetReg(strRegPath)
  If (strRegPath <> "") Then
    ' Declare variables and set initial value.
    Dim WsShell
    Set WsShell = WScript.CreateObject("WScript.Shell")
    ' Retrieve the Registry information.
    GetReg = ""
    On Error Resume Next
    GetReg = WsShell.RegRead(strRegPath)
    If (boolDebug) Then On Error Goto 0 Else On Error Resume Next End If
    If (boolDebug) Then WScript.Echo "GetReg: Succes (Read Registry Key)" &vbCrLf& "Registry Key: " & strRegPath &vbCrLf& "Value: " & GetReg &vbCrLf End If
  ElseIf (boolDebug) Then
    WScript.Echo "GetReg= Failed (One of the Parameter(s) is Empty)" &vbCrLf& "RegPath: " &strRegPath &vbCrLf
  End If ' Check on parameters empty
End Function 

