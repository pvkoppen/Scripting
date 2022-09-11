' Author     : Peter van Koppen
' Version    : v0.1
' Date       : 2006-07-13
' Description: Correct a date from GMT to local timezone.
' ------------------------------------------------------------------------

' Initial settings
' ------------------------------------------------------------------------
Option Explicit
Dim tfDebug
tfDebug = False 'tfDebug = True 

' Create Constants
' ------------------------------------------------------------------------
Const ForReading = 1, ForWriting = 2, ForAppending = 8 

' Create variables
' ------------------------------------------------------------------------
Dim objFSO, objFileIn, objFileOut
Dim strFilename, strOutputFolder, strPostFix, strStrippedFilename
Dim strLineIn, strLineOut, strDate
Dim dtLog
Dim intCounter, intDateStart, intTimezoneSep, intDateEnd
Dim intTimeCorrection

' Set Default values
' ------------------------------------------------------------------------
strFilename       = ""
strOutputFolder   = ""
strPostFix        = ".timezonecorrected"
intTimeCorrection = 12

Function funcIntToStr(intVar, intLength)
  funcIntToStr = CStr(intvar)
  funcIntToStr = String(intLength-Len(funcIntToStr), "0")&funcIntToStr
End Function 'funcIntToStr

Function funcMToMon(intM)
  If intM =  1 Then funcMToMon = "Jan"
  If intM =  2 Then funcMToMon = "Feb"
  If intM =  3 Then funcMToMon = "Mar"
  If intM =  4 Then funcMToMon = "Apr"
  If intM =  5 Then funcMToMon = "May"
  If intM =  6 Then funcMToMon = "Jun"
  If intM =  7 Then funcMToMon = "Jul"
  If intM =  8 Then funcMToMon = "Aug"
  If intM =  9 Then funcMToMon = "Sep"
  If intM = 10 Then funcMToMon = "Oct"
  If intM = 11 Then funcMToMon = "Nov"
  If intM = 12 Then funcMToMon = "Dec"
End Function 'funcMToMon

Function funcDateToStr(dtVar, strFormat)
  '
End Function 'funcDateToStr

' Retrieve Parameters/Arguments
' ------------------------------------------------------------------------
For intCounter = 0 To WScript.Arguments.Count -1
  If intCounter=0 Then strFilename     = WScript.Arguments(intCounter) End If
  If intCounter=1 Then strOutputFolder = WScript.Arguments(intCounter) End If
  If intCounter=2 Then strPostFix      = WScript.Arguments(intCounter) End If
Next

' Only continue if a filename parameter has been given.
' ------------------------------------------------------------------------
If Not strFilename = "" Then
  Set objFSO = CreateObject("Scripting.FileSystemObject")
  If strOutputFolder = "" Then 
    strOutputFolder = strFilename
    Do While Not (len(strOutputFolder) = 0) And Not (right(strOutputFolder,1) = "\")
      strOutputFolder = left(strOutputFolder,len(strOutputFolder)-1)
      If tfDebug Then WScript.Echo "OutputFolder: "&strOutputFolder End If
    Loop
  End If
  If len(strOutputFolder) = 0 Then 
    strOutputFolder = ".\"
  Elseif Not (right(strOutputFolder,1) = "\") Then
    strOutputFolder = strOutputFolder&"\"
  End If
  If tfDebug Then WScript.Echo "OutputFolder: "&strOutputFolder End If
  If objFSO.FileExists(strFilename) And objFSO.FolderExists(strOutputFolder) Then
    strStrippedFilename = objFSO.GetFilename(strFilename)
    If tfDebug Then WScript.Echo "StrippedFilename: "&strStrippedFilename End If
    Set objFileIn  = objFSO.OpenTextFile(strFilename, ForReading, False)
    Set objFileOut = objFSO.OpenTextFile(strOutputFolder&strStrippedFilename&strPostFix, ForWriting, True)
    Do While Not objFileIn.AtEndOfStream
      strLineIn  = objFileIn.ReadLine()
      'InStr(strLineIn, "["), InStr(InStr(strLineIn, "["),strLineIn, " "), InStr(strLineIn, "]")
      intDateStart   = InStr(strLineIn, "[")+1
      intTimezoneSep = InStr(intDateStart, strLineIn, " ")
      intDateEnd     = InStr(IntDateStart, strLineIn, "]")
      strDate = Mid(strLineIn, intDateStart, intTimezoneSep-intDateStart)
      strDate = left(strDate, InStr(strDate,":")-1)&" "&right(strDate, len(strDate)-InStr(strDate,":"))
      dtLog = DateAdd("h", intTimeCorrection, CDate(strDate))
      strDate = funcIntToStr(day(dtLog),2)&"/"&funcMToMon(month(dtLog))&"/"&year(dtLog)&":"&funcIntToStr(hour(dtLog),2)&":"&funcIntToStr(minute(dtLog),2)&":"&funcIntToStr(second(dtLog),2)
      strLineOut = left(strLineIn,IntDateStart-1)&""&strDate&" +"&intTimeCorrection&"00"&right(strLineIn,len(strLineIn)-intDateEnd+1)
      If tfDebug Then WScript.Echo "LineIn: "&strLineIn&vbCrlf&"LineOut: "&strLineOut End If
      objFileOut.WriteLine(strLineOut)
    Loop
    objFileOut.Close
    objFileIn.Close
    Set objFileOut = Nothing
    Set objFileIn  = Nothing
  End If
  Set objFSO = Nothing
End If

'Final closing expression
' ------------------------------------------------------------------------
If tfDebug Then WScript.Echo "Final" End If
WScript.Quit
