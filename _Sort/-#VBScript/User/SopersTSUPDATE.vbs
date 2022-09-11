'-------------------------------------------------------------------------
'---	Author:		Chris Fuller
'---	Date:		17/3/2002
'---	Purpose:	This script will create user Terminal Server Profile and Home 
'---                    directory
'---	Make sure drive letter Y: is not used before starting.
'---	Once started, you will not see much activity.
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
        HomeServer = "SOPDC30"
        DomName = "sopers"
'	LogonScript = "sopers.bat"
	InitialPassword = "InitialPassword"
	UserHomeUpperDir = "\\" & HomeServer & "\Home"
	root = "WinNT://" & HomeServer & "/"
	NewDrvValue = "H:"

'-------------------------------------------------------------------------
'---	Get the username
'-------------------------------------------------------------------------

	Username = Inputbox ("Terminal Server Profile and Shares" & CHR(13) & "Enter the Username")
	MSGBOX ("You entered: " & Username)
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
 	Network.MapNetworkDrive "Y:", "\\SOPDC30\Users$"
	Set FileSys = CreateObject("Scripting.FileSystemObject")
	
	FileSys.CreateFolder("Y:\Home\" & UserName)
	FileSys.CreateFolder("Y:\Home\" & UserName & "\Templates")
	FileSys.CreateFolder("Y:\Home\" & UserName & "\Mail")
	FileSys.CreateFolder("Y:\TSHome\" & UserName)
	FileSys.CreateFolder("Y:\Profiles\" & UserName)
	FileSys.CreateFolder("Y:\Profiles\" & UserName & "\TSProf")
	FileSys.CreateFolder("Y:\Profiles\" & UserName & "\FatProf")
	If Debug = True then
		WScript.Echo "Setting permissions on home directory"
	End If

'-------------------------------------------------------------------------
	'--- Give the User full rights to the new home folder

'-------------------------------------------------------------------------
	wshShell.run "cacls Y:\" & UserName & " /T /E /C /G " & UserName & ":F",1,true

'-------------------------------------------------------------------------
'---  	Create the home directory share

'-------------------------------------------------------------------------

    Set fserv = GetObject("WinNT://sopers/SOPDC30/lanmanserver")
    Set shareNew = fserv.Create("fileshare", "P" & Username & "$")
    shareNew.Path = "E:\Users\Profiles\" & Username
    shareNew.SetInfo  ' Commit new share
    Set shareNew = fserv.Create("fileshare", "T" & Username & "$")
    shareNew.Path = "E:\Users\TSHome\" & Username
    shareNew.SetInfo  ' Commit new share
    Set shareNew = fserv.Create("fileshare", Username & "$")
    shareNew.Path = "E:\Users\Home\" & Username
    shareNew.SetInfo  ' Commit new share



'-------------------------------------------------------------------------
	'--- Add user to Terminal Server Group

'-------------------------------------------------------------------------
'	Set User = GetObject("WinNT://" & DomName & "/" & UserName & ",user")
'	Set Group = GetObject("WinNT://" & DomName & "/Terminal Server RDP Users,group")
'	Group.Add(User.ADsPath)
'	Group.SetInfo

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
