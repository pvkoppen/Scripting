Option Explicit
'On Error Resume Next

Dim intParams, strFileIn, intFileNo, intCount, intSplit
Dim objFSO, objFileIn, strFileOut, objFileOut
Dim dtDate, strDate, strTime
Dim strHeader, strLine

' Load Parameters into Variables
intParams = WScript.Arguments.Count
strFileIn = WScript.Arguments(0)
intFileNo = 0
intCount = 0
intSplit = 3000000

Set objFSO = CreateObject("Scripting.FileSystemObject")

' Check if the parameter list is not empty
if intParams = 0 then
  WScript.Echo "Missing parameters"
  WScript.Quit

' Check if the parameter is a file
Elseif Not objFSO.FileExists(strFileIn) then
  WScript.Echo "First parameter not a file"
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
  If Hour(dtDate) < 10 then
    strTime = "0" & Hour(dtDate)
  else
    strTime = Hour(dtDate)
  End If
  If Minute(dtDate) < 10 then
    strTime = strTime & "0" & Minute(dtDate)
  else
    strTime = strTime & Minute(dtDate)
  End If
  Wscript.Echo "Date: "&strDate&", Time: "&strTime

  Set objFileIn  = objFSO.OpenTextFile(strFileIn, 1, False)
  strFileOut = objFSO.GetParentFolderName(WScript.Arguments(0)) &"\"&objFSO.GetBaseName(WScript.Arguments(0))&"-"&strDate&"-"&strTime
  Set objFileOut = objFSO.OpenTextFile(strFileOut&"_"&intFileNo&".txt", 2, True)
end if

Do While (objFileIn.AtEndOfStream <> True) and (intCount < 3)
  strLine = objFileIn.ReadLine
  if IntCount = 2 then
    strHeader = strLine
  end If
  intCount = intCount +1
  objFileOut.WriteLine strHeader
Loop

Do While objFileIn.AtEndOfStream <> True
  strLine = objFileIn.ReadLine
  objFileOut.WriteLine strLine
  intCount = intCount +1
  if intCount > intSplit then
    objFileOut.Close
    intFileNo = intFileNo + 1
    Set objFileOut = objFSO.OpenTextFile(strFileOut&"_"&intFileNo&".txt", 2, True)
    intCount = intCount - intSplit
    objFileOut.WriteLine strHeader
  end if
Loop
objFileIn.Close
objFileOut.Close

Wscript.Echo "Lines: "&intFileNo&" x "&intSplit&" + "&intCount&" = "&(intFileNo*intSplit+intCount)

' Clean up Variables
Set objFileIn = Nothing
Set objFileOut = Nothing
Set objFSO = Nothing

