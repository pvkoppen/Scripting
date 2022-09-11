''Auto Approve SUS Patches
'' 
''V0.1 07/08/03 - Steven Gill (gillsr@iee.org)
''V0.2 07/08/03 - SG: updated to add ",2@|" for new updates
''v0.3 18/11/03 - New functionalities (Thibault.LeMeur@supelec.fr)
''  		  - Backups the old ApprovedItems.txt to "ApprovedItems_backup.txt"
''		  - Parses the new approved patches names and send a summary email
''v0.4 23/11/03 - SG: updated to use Jmail (free from http://www.dimac.net/) instead of CDO.
''v0.5 13/11/04 - SG: Added CDonts option and SP2 bypass
''v0.6 10/04/05 - Stuart Hedges - No W2k3sp1
''v0.7 26/04/05 - Chris de Vidal <Chris@deVidal.tv> - No W2K SP4, changed exclude logic a bit
''Usage and more info at: http://gatefold.co.uk/sus 
''
''To use:
''Set up a scheduled job to run "cscript c:\autoapproveupdates.vbs" and run with admin rights
''

'' SETUP Section
'' -------------------------
''Use default C on local machine

strSUSpath = "C:"

''Uncomment the line below and insert your server name if you want to run remotely
''strSUSpath = "\\Installsvr\c$"

'' If true will not approve XP SP2

nosp2 = false

'' If true will not approve Windows 2003 server SP1

noWS03SP1 = true

'' If true will not approve Windows 2000 service pack 4

noW2KSP4 = false

'' If false will use CDonts

usejmail = true


'' Email configuration

EmailDstName = "susadmin@company.com"
EmailReplyToName = "susserver@company.com"

'' Can use localhost if you have an smtp server locally

EmailSrvName = "smtp.company.com"


'' Start of Code 
'' -------------------------

debugflag = true
NumNewPatches = 0

Const ForReading = 1		''Open a file for reading only. You can't write to this file. 
Const ForWriting = 2		''Open a file for writing. If a file with the same name exists, its previous contents is overwritten. 
Const ForAppending = 8   	''Open a file and write to the end of the file. 
Const TristateUseDefault = -2 	''Opens the file using the system default. 
Const TristateTrue = -1 	''Opens the file as Unicode. 
Const TristateFalse = 0 	''Opens the file as ASCII. 

Set objFileSystem = CreateObject("Scripting.FileSystemObject")

strPath = strSUSpath & "\Inetpub\wwwroot\autoupdate\dictionaries\ApprovedItems.txt"

strappenddate = year(now()) & month(now()) & day(now()) & hour(Now()) & minute(now())
strPathBackup = strSUSpath & "\Inetpub\wwwroot\autoupdate\dictionaries\ApprovedItems_"& strappenddate &".txt"

''Opens the input file
set objApprovalfile = objFileSystem.GetFile(strPath)
set txtStream = objApprovalfile.OpenAsTextStream(ForReading, TristateUseDefault)
strApprovalContents = txtStream.ReadAll
txtStream.close()
Set objApprovalfile = Nothing

LogIt("Opened Approvedupdates.txt")

''Backup the previous ApprovedItems.txt file
set CopyobjApprovalfile = objFileSystem.GetFile(strPath)
CopyobjApprovalfile.Copy(strPathBackup)
Set CopyobjApprovalfile = Nothing

'Parse the new patches description
set objRegEx = New RegExp 
set ParsePatchName = New RegExp 
objRegEx.Global = True		
ParsePatchName.Global = False
objRegEx.Pattern = "com_microsoft.[A-z0-9_\.\s]*,[0 2]@\|"
ParsePatchName.Pattern = "\.[A-z0-9_\s]*,"
Set Matches = objRegEx.Execute(strApprovalContents) 
For Each Match in Matches
	Set ParseMatch = ParsePatchName.Execute(Match.Value)
	StrTemp = ParseMatch.Item(0).Value

	StrTemp = Replace(StrTemp, ".", "")
	StrTemp = Replace(StrTemp, ",", "")

	Select case StrTemp
		case "xp_sp_2"
			If not nosp2 then strReturnStr = increment_NumNewPatches ()
		case "ws03_sp1_sus"
			If not noWS03SP1 then strReturnStr = increment_NumNewPatches ()
		case "windows 2000 service pack 4 network install for it professionals"
			If not noW2KSP4	then strReturnStr = increment_NumNewPatches ()
		case else
			strReturnStr = increment_NumNewPatches ()
	End select
Next

Function increment_NumNewPatches ()
	StrArray = Split(StrTemp, "_")
	NumKeywords = Ubound(StrArray)  

	If NumKeywords  >= 0 Then
		increment_NumNewPatches = increment_NumNewPatches & VBNewLine & "" & StrArray(0) & " : "
		If NumKeywords >= 2 Then
			For k = 1 To NumKeywords
				increment_NumNewPatches = increment_NumNewPatches & StrArray(k) & " "
			Next 
		End If
	Else
		increment_NumNewPatches = increment_NumNewPatches & VBNewLine & "Unknown patch name format :" & StrTemp
	End If
	NumNewPatches = NumNewPatches+1
End function

Set objRegEx = Nothing
Set ParsePatchName= Nothing


'' Approve patches

strApprovalContents = Replace(strApprovalContents, ",0@|", ",1@|")
strApprovalContents = Replace(strApprovalContents, ",2@|", ",1@|")

If (nosp2) Then
	strApprovalContents = Replace(strApprovalContents, "xp_sp_2,1@|", "xp_sp_2,0@|")
End If

if (noWS03SP1) Then
	strApprovalContents = Replace(strApprovalContents, "ws03_sp1_sus,1@|", "ws03_sp1_sus,0@|")
End If

if (noW2KSP4) Then
	strApprovalContents = Replace(strApprovalContents, "windows 2000 service pack 4 network install for it professionals,1@|", "windows 2000 service pack 4 network install for it professionals,0@|")
End If

LogIt(strApprovalContents)

'' Write file back to disk
set objApprovalfile = objFileSystem.GetFile(strPath)
set txtStream = objApprovalfile.OpenAsTextStream(ForWriting, TristateUseDefault)
txtStream.Write(strApprovalContents)
txtStream.Close()

Set objApprovalfile = Nothing

LogIt("File updated")

'' Send email if new patches are approved
if (NumNewPatches > 0) then

	if (NumNewPatches > 1) then strPlural="es"
	
	strMsgBody =	"New patch" & strPlural & " approved: (" & Now & ")" & VBNewLine & _
		"--------------------------------------------" & VBCR & _
		strReturnStr


	if (usejmail) then

		' Create the JMail message Object
		set msg = CreateOBject("JMail.Message")

		msg.Logging = true
		msg.silent = true
		msg.From = EmailReplyToName
		msg.AddRecipient(EmailDstName)
		msg.Subject = "[SUS Server] " & NumNewPatches & " New Patch" & strPlural & " Approved"
		msg.Body = strMsgBody

		if (msg.Send(EmailSrvName)) then
			LogIt("Success sent:" & vbNewline & strMsgBody)
			Logit(msg.log)
		else
			LogIt("Error sending email!")
			Logit(msg.log)
		end if
	
	else
	
		Set iMsg = CreateObject("CDO.Message")
		
		iMsg.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = EmailSrvName
		iMsg.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25
		iMsg.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2

		'' Uncomment these and set for authenticated SMTP etc
		
		''iMsg.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpaccountname") = "My Name"
		''iMsg.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendemailaddress") = """MySelf"" <myself@example.com>"
		''iMsg.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/senduserreplyemailaddress") = """Another"" <another@example.com>"
		''iMsg.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = cdoBasic
		''iMsg.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = "domain\username"
		''iMsg.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = "password"

		iMsg.from = EmailReplyToName
		iMsg.to = EmailDstName
		iMsg.subject = "[SUS Server] " & NumNewPatches & " New Patch" & strPlural & " Approved" 
		iMsg.textbody = strMsgBody
		iMsg.send

		LogIt("Sent:" & vbNewline & strMsgBody)
	
	end if

else
	LogIt("No new patches to approve ") 
End if

sub LogIt(logtxt)
	if (debugflag) then
		wscript.echo(now() & ": " & logtxt)
	end if
end sub
