' ---------------------------------------------------
' Author: Peter van Koppen: Copied base script from the web
' DaTE: 2012-09-21
' ---------------------------------------------------

' ---------------------------------------------------
' -- Set Initial options and variables
Option Explicit
Dim boolDebug
boolDebug = True
boolDebug = False
If (boolDebug) Then On Error Goto 0 Else On Error Resume Next End If

Dim objFileSystem, objShell, objOutFile
Set objFileSystem = CreateObject("Scripting.FileSystemObject")
'Set objShell      = CreateObject("Shell.Application")
Set objShell      = CreateObject("WScript.Shell")
Set objOutFile    = objFileSystem.CreateTextFile(".\FileInfo.htm", True)

objOutFile.WriteLine("<html><head><title>FileInfo</title></head><body><table border=""1"">")

Dim intParameterCount, i
intParameterCount = WScript.Arguments.Count
If intParameterCount = 0 Then
 WScript.Echo "Nothing to do."
 WScript.Quit(0)
End If

For i = 0 to intParameterCount-1
  CheckFolder WScript.Arguments(i)
Next

objOutFile.WriteLine("</table></body></html>")
objShell.Run """.\FileInfo.htm"""

Set objOutFile    = Nothing
Set objShell      = Nothing
Set objFileSystem = Nothing

Function CheckFolder(strBaseFolder)
  Dim objFolder, arrFiles, strFile, strPrintLine

  strPrintLine = "<tr><td colspan=""3""><h1>"&strBaseFolder&"</h1></td></tr>"
  strPrintLine = strPrintLine&"<tr><th>Filename</th><th>DateLastModified</th><th>FileVersion</th></tr>"
  '-- 
  If (boolDebug) Then WScript.Echo "Folder="&strBaseFolder 
  Set objFolder = objFileSystem.GetFolder(strBaseFolder)

  Set arrFiles  = objFolder.Files
  For Each strFile In arrFiles
    If objFileSystem.GetExtensionName(strFile) = "exe" then
      If not (strPrintLine = "") then objOutFile.WriteLine(strPrintLine)
      strPrintLine = ""
      If (boolDebug) Then WScript.Echo "Name="&strFile.Name&", DateModified="&strFile.DateLastModified&", Version="&objFileSystem.GetFileVersion(strFile)&"."
      objOutFile.WriteLine("<tr><td>"&strFile.Name&"</td><td>"&strFile.DateLastModified&"</td><td>"&objFileSystem.GetFileVersion(strFile)&"</td></tr>")
    End if
  Next
  Set strFile  = Nothing
  Set arrFiles = Nothing
  objOutFile.WriteLine("")

  Dim arrFolders, strFolder
  Set arrFolders  = objFolder.Subfolders
    For Each strFolder In arrFolders
      CheckFolder strFolder
    Next
  Set strFolder  = Nothing
  Set arrFolders = Nothing

  Set objFolder = Nothing

End Function 'CheckFolder
