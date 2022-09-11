On Error Resume Next

' Load Parameters into Variables
intParams = WScript.Arguments.Count
strFolder = WScript.Arguments(0)
strComputer = "."
boolGetOwner = True


' Check if the parameter list is not empty
Set objFSO = CreateObject("Scripting.FileSystemObject")
if intParams = 0 then
  WScript.Echo "Missing parameters"
  WScript.Quit
  'Set File = objFSO.OpenTextFile(workFolder &"\test.txt", 2, True)
' Check if the parameter is a folder
Elseif Not objFSO.FolderExists(strFolder) then
  WScript.Echo "First parameter not a folder"
  WScript.Quit
' Get Current Date and Time and Open file for CSV export
else
  dtDate = now
  strDate = Year(dtDate)
  If Month(dtDate) < 10 then
	strDate = strDate & "0" & Month(dtDate)
  else
	strDate = strDate & Month(dtDate)
  End If
  if Day(dtDate) < 10 then
	strDate = strDate & "0" & Day(dtDate)
  else
	strDate = strDate & Day(dtDate)
  End If
  strTime = Hour(dtDate)
  If Minute(dtDate) < 10 then
	strTime = strTime & "0" & Minute(dtDate)
  else
  	strTime = strTime & Minute(dtDate)
  End If
  
  Wscript.Echo "Date: "&strDate&", Time: "&strTime
  Set objFile = objFSO.OpenTextFile(WScript.Arguments(0) &"\"&objFSO.GetBaseName(Wscript.ScriptName)&"-"&strDate&"-"&strTime&".txt", 2, True)
end if

' Write CSV Headers string and kick of folder loop
objFile.Write "Fullname;Name;Size (B);Size (KB);Size (MB);Type;Attributes;Owner;DateTimeCreated;DateCreated;DateTimeLastModified;DateLastModified" & vbCRLF
ProcessFolder objFSO.GetFolder(strFolder), objFile
objFile.Close

' Clean up Variables
set objFile = Nothing
Set objFSO = Nothing
Set strFolder = Nothing
Set intParams = Nothing

' The Work is done here
Sub ProcessFolder(objFolder, objFile)
    For Each SubFolder in objFolder.SubFolders
        Wscript.Echo "-- Dir: " & SubFolder.Path
        'objFile.Write "-- Dir: " & SubFolder.Path
        ProcessFolder SubFolder, objFile
    Next
    For Each SubFile in objFolder.Files
	    if boolGetOwner then
            Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\" &strComputer& "\root\cimv2")
            Set colItems = objWMIService.ExecQuery ("ASSOCIATORS OF {Win32_LogicalFileSecuritySetting='" & SubFile & "'}" _
                & " WHERE AssocClass=Win32_LogicalFileOwner ResultRole=Owner")
            strOwner = ""
            boolFirst = True
            For Each objItem in colItems
                if not boolFirst then strOwner = strOwner & ","
	            strOwner = strOwner & objItem.ReferencedDomainName &":"& objItem.AccountName
                boolFirst = False
            Next
		Else
            strOwner = "[Blank]"
		End If

	    strCSVLine = SubFile.Path & ";" &_
            SubFile.Name & ";" &_
            SubFile.Size & ";" &_
            SubFile.Size/1024 & ";" &_
            SubFile.Size/1024/1024 & ";" &_
            SubFile.Type & ";" &_
            SubFile.Attributes & ";" &_
            strOwner & ";" &_
            SubFile.DateCreated & ";" &_
            FormatDateTime(SubFile.DateCreated,2) & ";" &_
            SubFile.DateLastModified & ";" &_
            FormatDateTime(SubFile.DateLastModified,2) & vbCRLF
        'Wscript.Echo strCSVLine
        objFile.Write strCSVLine
    Next
End Sub
