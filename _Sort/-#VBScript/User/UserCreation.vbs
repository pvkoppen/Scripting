'-------------------------------------------------------------------------
'---	Author:	Peter van Koppen
'---	Date:		26/09/2006
'---	Purpose:	This script will create a users home directory + share 
'---			and profile directory + share. And asks to set the user 
'---			up for Terminal Server use.
'-------------------------------------------------------------------------


'---	Set Program debug options
'-------------------------------------------------------------------------
'---	Set bDebug = False to not have messages print out.
'---	Set bDebug = True to have messages print out.
'-------------------------------------------------------------------------
Option Explicit
'On Error Resume Next
Public bDebug, bError
bDebug = True
bError = False

'On Error Resume Next
'Err.Raise 6   ' Raise an overflow error.
'MsgBox "Error # " & CStr(Err.Number) & " " & Err.Description
'Err.Clear   ' Clear the error.
'  If Err.Number <> 0 Then WScript.Echo "Error number:" & Err.Number  ' for example

'---	Declare Constants.
'-------------------------------------------------------------------------
Const ForReading    = 1
Const ForWriting    = 2
Const ForAppending  = 8
Const TristateFalse = 0

'---	Declare variables used throughout the script.
'-------------------------------------------------------------------------
Public sDomainName
Public sDomainController
Public sHomeServer
Public sHomePath
Public sHomeRealPath
Public sProfileServer
Public sProfilePath
Public sProfileRealPath

Public sHomeSharePrefix
Public sHomeSharePostfix
Public sProfileSharePre
Public sProfileSharePost
Public sTmpDrive
Public sMsgTmp

Public sUserName
Public sOrgName
Dim iResult

'---	Perform cleanup operations so drive mappings are removed when completed
'-------------------------------------------------------------------------
Sub CleanupDrive
	Dim xyzNetwork, xyzDrives
	Dim i
	Set xyzNetwork = WScript.CreateObject("WScript.Network")
	Set xyzDrives  = xyzNetwork.EnumNetworkDrives
	If xyzDrives.Count <> 0 Then
		For i = 0 To xyzDrives.Count - 1 Step 2
			If xyzDrives(i) = sTmpDrive Then
				xyzNetwork.RemoveNetworkDrive sTmpDrive
			End If
		Next
	End If
	Set xyzDrives  = Nothing
	Set xyzNetwork = Nothing
End Sub

'---	Create a share on a remote computer.
'-------------------------------------------------------------------------
Sub CreateShare (sServerName, sPath, sShareName)
	Const SHARE_TYPE = 0 ' 0=share a disk drive, 1=Printer
	Dim objWMI
	Dim wmiShare
	Set objWMI        = GetObject("WINMGMTS:{impersonationLevel=impersonate}!\\" & sServerName & "\ROOT\CIMV2")
	Set wmiShare      = objWMI.Get("Win32_Share")
	iResult           = wmiShare.Create(sPath, sShareName, SHARE_TYPE)
	if iResult <> 0 then
		WScript.Echo "Error creating share: " & iResult
	end if

	Set objWMI = Nothing
End Sub

'---	Declare Objects and Create them.
'-------------------------------------------------------------------------
Dim objNetwork, objShell, objFileSys, objUser, objGroup
Set objNetwork = WScript.CreateObject("WScript.Network")
Set objShell   = WScript.CreateObject("WScript.Shell")
Set objFileSys = CreateObject("Scripting.FileSystemObject")

'---	Define some constants.  Change these if/when needed.
'-------------------------------------------------------------------------
sDomainName       = "tuiora"
sDomainController = "DC12"
sHomeServer       = "DC12"
sHomePath         = "HomeDirs$"
sHomeRealPath     = "E:\Homedirs"
sProfileServer    = "DC12"
sProfilePath      = "Profiles$":
sProfileRealPath  = "E:\Profiles"

sHomeSharePrefix  = ""
sHomeSharePostfix = "$"
sProfileSharePre  = "F"
sProfileSharePost = "$"
sTmpDrive         = "Y:"

'---	Check for required tools
'-------------------------------------------------------------------------
WScript.Echo "Make sure that the following tools are available:" &CHR(13)& "dsquery.exe, dsmod.exe, tscmd.exe and cacls.exe"
'If 9059 = objShell.Run("start cacls.exe /?",1,True) Then bError = True
'If 9059 = objShell.Run("start dsquery.exe /?",1,True) Then bError = True
'If 9059 = objShell.Run("start dsmod.exe /?",1,True) Then bError = True
'If 9059 = objShell.Run("start tscmd.exe /?",1,True) Then bError = True
'If bError Then WScript.Echo "Some of the support tools are unavaiable: dsquery.exe, dsmod.exe, tscmd.exe and/or cacls.exe"
'If bError Then WScript.Quit

'---	Get the username
'-------------------------------------------------------------------------
sUserName = UCase(InputBox ("New User: Set the Folders and Shares up for Home Directory and Profile." &CHR(13)& "Enter the Username"))
If sUserName = "" Then 
	WScript.Echo "The Username was empty."
	WScript.Quit
Else
	Set objUser  = GetObject("WinNT://" &sDomainName& "/" &sUserName& ",user")
	If objUser.ADsPath = "" then
		WScript.Echo "User doesn't exist in the domain: " &sDomainName& "\" &sUserName
		WScript.Echo ":" &objUser.ADsPath& "."
		WScript.Quit
	End If
End If
sMsgTmp   = "New User: Set the Folders and Shares up for Home Directory and Profile." &CHR(13)& "You entered Username: " &sUserName& "."
sOrgName  = UCase(Inputbox ("New User: Set the Folders And Shares up For Home Directory and Profile." &CHR(13)& "Enter the Organisation Code (TOL, MOR, ...)"))
If sOrgName = "" Then
	sMsgTmp = sMsgTmp &CHR(13)& "You entered Organisation name: <Empty>."
Else 
	sMsgTmp = sMsgTmp &CHR(13)& "You entered Organisation name: " &sOrgName& "."
End If
MsgBox (sMsgTmp)

'---  (Re)Map a drive and create the Home Dir
'-------------------------------------------------------------------------
If (sOrgName <> "") Then
	If (vbOk = MsgBox("Set up the full Home dir for: " &sUserName& "? (" &sOrgName& ")" &CHR(13)& "Click OK to perform this action, Click Cancel for next step.",1)) Then
		Call CleanupDrive
		objNetwork.MapNetworkDrive sTmpDrive, "\\" &sHomeServer& "\" &sHomePath
		If Not objFileSys.FolderExists(sTmpDrive& "\" &sOrgName) then
			bError = True
			If bDebug = True Then Wscript.Echo "Home directory Organisation folder doesn't exist: \\" &sHomeServer& "\" &sHomePath& "\" &sOrgName
		Else 
			If Not objFileSys.FolderExists(sTmpDrive& "\" &sOrgName& "\" &sUserName) Then
				objFileSys.CreateFolder(sTmpDrive& "\" &sOrgName& "\" &sUserName)
			Else
				If bDebug = True Then Wscript.Echo "Home directory already exist: \\" &sHomeServer& "\" &sHomePath& "\" &sOrgName& "\" &sUserName
			End If
			Call CreateShare(sHomeServer, sHomeRealPath& "\" &sOrgName& "\" &sUsername, sHomeSharePrefix & sUsername & sHomeSharePostfix)
			iResult = objShell.run("cacls.exe " &sTmpDrive& "\" &sOrgName& "\" &sUserName& " /T /E /C /G " &sUserName& ":F >> UserCreation-ShellRun.Log 2>&1",1,True)
			WScript.Echo iResult
			'Update profile: Nothing to do.
		End If
	End If
End If

'---  (Re)Map a drive and create the Profile Dir
'-------------------------------------------------------------------------
If (sOrgName <> "") Then
	If (vbOk = MsgBox("Set up the full Profile dir for: "&sUsername&"? ("&sOrgName&")" &CHR(13)& "Click OK to perform this action, Click Cancel for next step.",1)) Then
		Call CleanupDrive
		objNetwork.MapNetworkDrive sTmpDrive, "\\" &sProfileServer& "\" &sProfilePath
		If Not objFileSys.FolderExists(sTmpDrive& "\" &sOrgName) then
			bError = True
			If bDebug = True Then Wscript.Echo "Profile directory Organisation folder doesn't exist: \\" &sProfileServer& "\" &sProfilePath& "\" &sOrgName
		Else 
			If Not objFileSys.FolderExists(sTmpDrive& "\" &sOrgName& "\" &sUserName) Then
				objFileSys.CreateFolder(sTmpDrive& "\" &sOrgName& "\" &sUserName)
			Else
				If bDebug = True Then Wscript.Echo "Profile directory already exist: \\" &sProfileServer& "\" &sProfilePath& "\" &sOrgName& "\" &sUserName
			End If
			Call CreateShare(sProfileServer, sProfileRealPath& "\" &sOrgName& "\" &sUsername, sProfileSharePre & sUsername & sProfileSharePost)
			objShell.run "cacls.exe " &sTmpDrive& "\" &sOrgName& "\" &sUserName& " /T /E /C /G " &sUserName& ":F >> .\UserCreation-ShellRun.Log 2>&1",1,True
			If Not objFileSys.FolderExists(sTmpDrive& "\" &sOrgName& "\" &sUserName& "\FatProf") Then
				objFileSys.CreateFolder(sTmpDrive& "\" &sOrgName& "\" &sUserName& "\FatProf")
			End If
			If (vbOk = MsgBox("Do you want to set up a Roaming Profile for: "&sUsername&"? ("&sOrgName&")" &CHR(13)& "Click OK for setting up a Roaming Profile, Click Cancel for Local Profile.",1)) Then
				objShell.run "dsquery.exe user -samid " &sUserName& "| dsmod.exe user -profile \\" &sProfileServer& "\" & sProfileSharePre & sUsername & sProfileSharePost & "\FatProf >> .\UserCreation-ShellRun.Log 2>&1",1,True
			End If
		End If
	End If
End If

'---  (Re)Map a drive and create the Profile Dir
'-------------------------------------------------------------------------
If (vbOk = MsgBox("Set up the Terminal Server Profile for: "&sUsername&"? ("&sOrgName&")" &CHR(13)& "Click OK to perform this action, Click Cancel for next step.",1)) Then
	Call CleanupDrive
	If (sOrgName <> "") Then
		objNetwork.MapNetworkDrive sTmpDrive, "\\" &sProfileServer& "\" &sProfilePath
		If Not objFileSys.FolderExists(sTmpDrive& "\" &sOrgName) then
			bError = True
			If bDebug = True Then Wscript.Echo "Profile directory Organisation folder doesn't exist: \\" &sProfileServer& "\" &sProfilePath& "\" &sOrgName
		Else
			'Check for users Profile folder or create.
			If Not objFileSys.FolderExists(sTmpDrive& "\" &sOrgName& "\" &sUserName) Then
				objFileSys.CreateFolder(sTmpDrive& "\" &sOrgName& "\" &sUserName)
			Else
				If bDebug = True Then Wscript.Echo "Profile directory already exist: \\" &sProfileServer& "\" &sProfilePath& "\" &sOrgName& "\" &sUserName
			End If
			'Create Share
			Call CreateShare(sProfileServer, sProfileRealPath, sProfileSharePre & sUsername & sProfileSharePost)
			'Apply permissions
			objShell.run "cacls.exe " &sTmpDrive& "\" &sOrgName& "\" &sUserName& " /T /E /C /G " &sUserName& ":F >> .\UserCreation-ShellRun.Log 2>&1",1,True
			'Create Profile folders
		End If
	End If
	If (sOrgName <> "") or (bError <> True) Then
		Call CleanupDrive
		objNetwork.MapNetworkDrive sTmpDrive, "\\" &sProfileServer& "\" & sProfileSharePre & sUsername & sProfileSharePost
		If Not objFileSys.FolderExists(sTmpDrive& "\TSProf") Then
			objFileSys.CreateFolder(sTmpDrive& "\TSProf")
		End If
		If Not objFileSys.FolderExists(sTmpDrive& "\TSHome") Then
			objFileSys.CreateFolder(sTmpDrive& "\TSHome")
		End If
		'Update Profile
		objShell.run "tscmd.exe " &sDomainController& " " &sUsername& " TerminalServerProfilePath  \\" &sProfileServer& "\" & sProfileSharePre & sUsername & sProfileSharePost & "\TSProf >> .\UserCreation-ShellRun.Log 2>&1",5,True
		objShell.run "tscmd.exe " &sDomainController& " " &sUsername& " TerminalServerHomeDir      \\" &sProfileServer& "\" & sProfileSharePre & sUsername & sProfileSharePost & "\TSHome >> .\UserCreation-ShellRun.Log 2>&1",5,True
		iResult = objShell.run("tscmd.exe " &sDomainController& " " &sUsername& " TerminalServerHomeDirDrive J: >> .\UserCreation-ShellRun.Log 2>&1",5,True)
		'Add User to Terminal Server User group
		Set objUser  = GetObject("WinNT://" &sDomainName& "/" &sUserName& ",user")
		Set objGroup = GetObject("WinNT://" &sDomainName& "/Terminal Server Users,group")
		objGroup.Add(objUser.ADsPath)
		objGroup.SetInfo
		If bDebug = True Then WScript.Echo "Added user to 'Terminal Server Users' group."
	End If
End If

'Cleanup final objects
Call CleanupDrive
Set objNetwork = Nothing
Set objShell   = Nothing
Set objFileSys = Nothing

WScript.Quit
