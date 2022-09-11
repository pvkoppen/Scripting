'-------------------------------------------------------------------------
'---	Author:		Aaron Gayton
'---	Date:		
'---	Purpose:	This script will create user Terminal Server Profile and Home 
'---                    directory
'---	Once started, you will not see much activity.
'

'-------------------------------------------------------------------------

'-------------------------------------------------------------------------
'---	Declare variables used throughout the script.
'-------------------------------------------------------------------------
Public DomName
Public HomeServer
Public HomeServerObj
Public FirstName
Public LastName
Public UserName
Public Debug
Public Network
Public Office
Public NewDrvValue
Public PasswordExpired
Public User
Public Group
Public GroupName
Public GroupName2
Public UserFile
Public fs
Public fso
Public f
Public ws
Public w
Public intButtonClicked

Public WSHNetwork
Public WshShell
Public fserv
Public Sharenew

Public InstallDir 
Public LogFile 
Public Response
Public UserGroups

const ForReading = 1
const ForWriting = 2
const ForAppending = 8
Const TristateFalse = 0

Set WshShell = WScript.CreateObject("WScript.Shell")
Set WSHNetwork = WScript.CreateObject("WScript.Network")

'-------------------------------------------------------------------------
'---	Set Debug = False to not have messages print out.
'---	Set Debug = True to have messages print out.
'-------------------------------------------------------------------------
	Debug = True
'	Debug = False
'-------------------------------------------------------------------------
'---	Define some constants.  Change these if/when needed.
'-------------------------------------------------------------------------
'	Username = "TSUser2"
	Home = "Profiles$"
      HomeServer = "dc12"
      DomName = "tuiora.co.nz"
	LogonScript = "iwayonline.bat"
	InitialPassword = "InitialPassword"
	UserHomeUpperDir = "\\" & HomeServer & "\Home"
	root = "WinNT://" & HomeServer & "/"
	NewDrvValue = "H:"

'-------------------------------------------------------------------------
'---	Define log file
'-------------------------------------------------------------------------

	InstallDir = "\\Altiris\common\Admin\BCS\TSUpdate DevScript" 
	Set fso = CreateObject("Scripting.FileSystemObject")
	Set LogFile = fso.CreateTextFile(InstallDir & "\TSUpdate2003RDP.txt", True)
	If Debug = True then
		WScript.Echo "Log file Is located at: G:\Admin\BCS\TSUpdate DevScript"
	End If

	LogFile.WriteLine("This is a Log file for TSUpdate2003RDP on " & Date)
'-------------------------------------------------------------------------
'---	Get the username
'-------------------------------------------------------------------------

	Username = Inputbox ("Terminal Server Profile and Shares" & CHR(13) & "Enter the Username")
	MSGBOX ("You entered: " & Username)
	
'-------------------------------------------------------------------------
'---  If Y Drive is mapped, disconnect Y Drive (call Cleanup)
'-------------------------------------------------------------------------
	Call Cleanup

'-------------------------------------------------------------------------
'---	If user is already a member of "Terminal Server 2003 RDP users" group 
'---	then Exit script
'-------------------------------------------------------------------------
	UserGroups = Null
	If IsMember("Terminal Server 2003 RDP users") Then
		LogFile.WriteLine(Username & " is already a member of Terminal Server 2003 RDP group.")
	Else
	
f

'*************************************************************************
'	End of main script.  Subroutines follow	
'*************************************************************************

'*************************************************************************
Function IsMember(sGroup)
'-------------------------------------------------------------------------
'---	Is the the current user a member of a group
'-------------------------------------------------------------------------

Dim oUser, oGroup

	IsMember = FALSE
	
      If IsNull(UserGroups) Then

		Set oUser = Getobject("WinNT://" & WSHNetwork.UserDomain & "/" & UserName & ",user")
		UserGroups = ""
		For Each oGroup In oUser.Groups
			UserGroups = UserGroups & "[" & oGroup.Name & "]"
		Next
		Set oUser = Nothing
      End If

	If InStr(UserGroups,"[" & sGroup & "]") Then
		IsMember = True
	End If

End Function	'	IsMember

'*************************************************************************
Sub 	CreateUser
'-------------------------------------------------------------------------
'---	Create the user's home directory 
'-------------------------------------------------------------------------
	If Debug = True then
		Wscript.Echo "Creating Home Directory for " & UserName
	End If
	LogFile.WriteLine ("Creating Home Directory for " & UserName)

'-------------------------------------------------------------------------
'---  Map a drive and create the Home Dir
'-------------------------------------------------------------------------
 	Set Network = WScript.CreateObject("WScript.Network")
 	Network.MapNetworkDrive "Y:", "\\npl03\Profiles$"
	Set FileSys = CreateObject("Scripting.FileSystemObject")
	FileSys.CreateFolder("Y:\" & UserName)
	FileSys.CreateFolder("Y:\" & UserName & "\TSProf")
	FileSys.CreateFolder("Y:\" & UserName & "\FatProf")
	If Debug = True then
		WScript.Echo "Setting permissions on home directory"
	End If
	LogFile.WriteLine ("Setting permissions On home directory")

'-------------------------------------------------------------------------
'--- Give the User full rights to the new home folder
'-------------------------------------------------------------------------
	wshShell.run "cacls Y:\" & UserName & " /T /E /C /G " & UserName & ":F",1,true

'-------------------------------------------------------------------------
'---  	Create the home directory share
'-------------------------------------------------------------------------

    Set fserv = GetObject("WinNT://iwayonline/npl03/lanmanserver")
    Set shareNew = fserv.Create("fileshare", "P" & Username & "$")
    shareNew.Path = "E:\Profiles\" & Username
    shareNew.SetInfo  ' Commit new share
	
End Sub	'	CreateUser

'*************************************************************************
'-------------------------------------------------------------------------
'---	Perform cleanup operations so drive mappings are removed 
'-------------------------------------------------------------------------
Sub Cleanup
	Set WSHNetwork = WScript.CreateObject("WScript.Network")
	Set colDrives = WSHNetwork.EnumNetworkDrives

	If colDrives.Count <> 0 Then
		For i = 0 To colDrives.Count - 1 Step 2
			If colDrives(i) = "Y:" Then
				WSHNetwork.RemoveNetworkDrive "Y:"
			End If
		Next
	END IF
End Sub	'	Cleanup

'*************************************************************************
'-------------------------------------------------------------------------
'---	User is current TS user - modify for 2003 RDP Group.
'-------------------------------------------------------------------------
Sub ModifyUser

'-------------------------------------------------------------------------
'---	Create new W2K folder under \\npl03\P%username%$.
'-------------------------------------------------------------------------
 	If Debug = True Then
		WScript.Echo "Create new W2K folder."
	End If

	LogFile.WriteLine ("Create new W2K folder.")
	
 	Set Network = WScript.CreateObject("WScript.Network")
 	Network.MapNetworkDrive "Y:", "\\npl03\Profiles$"
	Set FileSys = CreateObject("Scripting.FileSystemObject")
	FileSys.CreateFolder("Y:\" & UserName & "\W2K")

'-------------------------------------------------------------------------
'---	Create new TSPROF folder under W2K
'  	Move user's TSPROF files & sub folders to this W2K\TSPROF folder.
'	NB. TSPROF folder is not moved - only its subfolers and files
'-------------------------------------------------------------------------

	FileSys.CreateFolder("Y:\" & UserName & "\W2K\TSProf")

      FileSys.MoveFolder  "Y:\" & UserName & "\TSProf\*", "Y:\" & UserName & "\W2K\TSProf\"
	If Debug = True Then
		WScript.Echo "TSPROF folder moved to W2K\TSProf."
	End If
	LogFile.WriteLine ("TSPROF folder moved to W2K\TSProf.")

      FileSys.MoveFile "Y:\" & UserName & "\TSProf\*.*", "Y:\" & UserName & "\W2K\TSProf\"
	If Debug = True Then
		WScript.Echo "Files below TSPROF folder moved to W2K\TSProf."
	End If
	LogFile.WriteLine ("Files below TSPROF folder moved to W2K\TSProf.")


	
'-------------------------------------------------------------------------
'---	Call sub to add user to "Terminal Server 2003 RDP Users" group
'-------------------------------------------------------------------------
	Call AddTo2003RDPGroup

'*************************************************************************
Sub AddTo2003RDPGroup
'-------------------------------------------------------------------------
'---	Add user to "Terminal Server 2003 RDP Users" group
'-------------------------------------------------------------------------

	Set User = GetObject("WinNT://" & DomName & "/" & UserName & ",user")
	Set Group = GetObject("WinNT://" & DomName & "/Terminal Server 2003 RDP Users,group")
	Group.Add(User.ADsPath)
	Group.SetInfo
	If Debug = True then
		WScript.Echo "User added to Terminal Server 2003 RDP Users group."
	End If
	LogFile.WriteLine ("User added to Terminal Server 2003 RDP Users group.")

End Sub
'*************************************************************************
