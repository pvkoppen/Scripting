'-------------------------------------------------------------------------
'---	Author:		Aaron Gayton
'---	Date:		17/3/2002
'---	Purpose:	This script will create user Terminal Server Profile and Home 
'---                    directory
'--------------------- 

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
	Public f
	Public ws
	Public w
	Public intButtonClicked

Dim WSHNetwork
Dim WshShell
Dim fserv
Dim Sharenew

	const ForReading = 1
	const ForWriting = 2
	const ForAppending = 8
	Const TristateFalse = 0

Set WshShell = WScript.CreateObject("WScript.Shell")
Set WSHNetwork = WScript.CreateObject("WScript.Network")

On Error Resume Next 
'-------------------------------------------------------------------------
'---	Set Debug = False to not have messages print out.
'---	Set Debug = True to have messages print out.
'-------------------------------------------------------------------------
	Debug = True

'-------------------------------------------------------------------------
'---	Define some constants.  Change these if/when needed.
'-------------------------------------------------------------------------
'	Username = "TSUser2"
	Home = "Profiles$"
        HomeServer = "DC12"
        DomName = "tuiora"
'	LogonScript = "tuiora.bat"
	InitialPassword = "InitialPassword"
	UserHomeUpperDir = "\\" & HomeServer & "\Home"
	root = "WinNT://" & HomeServer & "/"
	NewDrvValue = "H:"

'-------------------------------------------------------------------------
'---	Get the username
'-------------------------------------------------------------------------

	Username = Inputbox ("Terminal Server Profile and Shares" & CHR(13) & "Enter the Username")
	MSGBOX ("You entered: " & Username)
	'Orgname = Inputbox ("Terminal Server Profile and Shares" & CHR(13) & "Enter the Organisation name")
	'MSGBOX ("You entered: " & orgname)
'-------------------------------------------------------------------------
'---	Create the user's home directory 
'-------------------------------------------------------------------------
	If Debug = True then
		Wscript.Echo "Creating Home Directory for " & UserName
	End If

'-------------------------------------------------------------------------
	'---  Map a drive and create the Home Dir

'-------------------------------------------------------------------------
 	Set Network = WScript.CreateObject("WScript.Network")
 	Network.MapNetworkDrive "Y:", "\\dc12\f"  & Username & "$"  
 	Set FileSys = CreateObject("Scripting.FileSystemObject")
	FileSys.CreateFolder("Y:\TSPROF")
	FileSys.CreateFolder("Y:\TSHOME")
	If Debug = True Then
		WScript.Echo "Setting permissions on home directory"
	End If



' 	Network.MapNetworkDrive "X:", "\\" & Homeserver & "\Profiles$"
'	Set FileSys = CreateObject("Scripting.FileSystemObject")
'	
'	FileSys.CreateFolder("X:\Users\" & UserName)
'	FileSys.CreateFolder("X:\Users\" & UserName & "\Templates")
'	FileSys.CreateFolder("X:\Users\" & UserName & "\Mail")
'	FileSys.CreateFolder("X:\" & UserName)
'	FileSys.CreateFolder("X:\" & UserName & "\TSHome")
'	FileSys.CreateFolder("X:\" & UserName & "\TSProf")
'	FileSys.CreateFolder("X:\" & UserName & "\FatProf")





'-------------------------------------------------------------------------
'	'--- Give the User full rights to the new home folder
'
'-------------------------------------------------------------------------
'	wshShell.run "cacls Y:\tshome" " /T /E /C /G " & UserName & ":F",1,True
'	wshShell.run "cacls Y:\tsprof" " /T /E /C /G " & UserName & ":F",1,True

'-------------------------------------------------------------------------
	'--- Terminal Server Profile Path

'-------------------------------------------------------------------------
wshShell.run "tscmd.exe dc12 " & Username & " TerminalServerProfilePath \\dc12\f" & Username & "$\tsprof",5,True
wshShell.run "tscmd.exe dc12 " & Username & " TerminalServerHomeDir \\dc12\f" & Username & "$\tshome",5,True
wshShell.run "tscmd.exe dc12 " & Username & " TerminalServerHomeDirDrive J:",5,True
 

'-------------------------------------------------------------------------
	'--- Add user to Terminal Server Group

'-------------------------------------------------------------------------
	Set User = GetObject("WinNT://" & DomName & "/" & UserName & ",user")
	Set Group = GetObject("WinNT://" & DomName & "/Terminal Server Users,group")
	Group.Add(User.ADsPath)
	Group.SetInfo
'-------------------------------------------------------------------------
'---	Perform cleanup operations so drive mappings are removed when completed
'-------------------------------------------------------------------------
Sub Cleanup
	Set WSHNetwork = WScript.CreateObject("WScript.Network")
	Set colDrives = WSHNetwork.EnumNetworkDrives

	If colDrives.Count <> 0 Then
		For i = 0 To colDrives.Count - 1 Step 2
			IF colDrives(i) = "Y:" THEN
				WSHNetwork.RemoveNetworkDrive "Y:"
			End IF
		Next
	END IF
End Sub

Cleanup
