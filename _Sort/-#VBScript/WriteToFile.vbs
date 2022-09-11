' NewTextEC.vbs
' Sample VBScript to write to a file. With added error-correcting
' Author Guy Thomas http://computerperformance.co.uk/
' Version 1.5 - August 2005
' ---------------------------------------------------------------'

' First options
Option Explicit
'On Error
Dim boolDebug
boolDebug = True
boolDebug = False

'Declare and initialize variables.
Dim objShell
Dim strDirectory, strFile
strDirectory = "\\dc12\peter$\Development\Log"
strFile = "\test.log"


Function FolderExists(FolderName, Create)
  Dim objFSO, objFolder
  FolderExists = True
  ' Check that the strDirectory folder exists
  Set objFSO = CreateObject("Scripting.FileSystemObject")
  If objFSO.FolderExists(strDirectory) Then
   ' Return True
  Elseif Create Then
    'Create Folder
    'On Success Return True
    'On Failure Return False
  Else
    If boolDebug Then Wscript.Echo "Directory doesn't exist and will not be created: " & FolderName End If
    FolderExists = False
  End If
  Set objFolder = Nothing
  Set objFSO    = Nothing
End Function 'FolderExists

Function FileExists(FolderName, FileName, Create)
  Dim objFSO, objFile
  FileExists = True
  ' Check that the strDirectory folder exists
  Set objFSO = CreateObject("Scripting.FileSystemObject")
  If FolderExists(FolderName, False) Then
    If objFSO.FileExists(FolderName & FileName) Then
      ' Return True
    Elseif Create Then
      Set objFile = objFSO.CreateTextFile(FolderName & FileName)
      If objFSO.FileExists(FolderName & FileName) Then 
        ' Retun True
        If boolDebug Then Wscript.Echo "Created file: " & FolderName & FileName End If
      Else
        If boolDebug Then Wscript.Echo "Can't create file: " & FolderName & FileName End If
        FileExists = False
      End If
    Else
      If boolDebug Then Wscript.Echo "File doesn't exist and will not be created: " & FolderName & FileName End If
      FileExists = False
    End If
  Else
    If boolDebug Then Wscript.Echo "Directory doesn't exist: " & FolderName End If
    FileExists = False
  End If
  Set objFile   = Nothing
  Set objFSO    = Nothing
End Function 'FileExists

Sub AppendToFile(FolderName, FileName, AppendText)
  ' OpenTextFile Method needs a Const value: ForAppending = 8 ForReading = 1, ForWriting = 2
  Const ForReading = 1, ForWriting = 2, ForAppending = 8 
  'Declare and initialize variables.
  Dim objFSO, objFile

  'Open Text file for Adding.
  Set objFSO = CreateObject("Scripting.FileSystemObject")
  Set objFile = objFSO.OpenTextFile(strDirectory & strFile, ForAppending, True)

  ' Close Text File
  objFile.WriteLine(AppendText)
  objFile.Close

  Set objFile   = Nothing
  Set objFSO    = Nothing
End Sub 'AppendToFile

If FileExists(strDirectory, strFile, True) Then
  Dim objNetwork, objPrinter, intPrinter, strWrite, dttmCurrent
  Set objNetwork = CreateObject("WScript.Network")
  Set objPrinter = objNetwork.EnumPrinterConnections
  dttmCurrent = Now

  ' Extra section to troubleshoot
  If objPrinter.Count = 0 Then
    strWrite = dttmCurrent &";"& objNetwork.UserName &";"& objNetwork.UserDomain &";"& objNetwork.ComputerName &";-1;NULL;No Printers Mapped"
    Call AppendToFile(strDirectory, strFile, strWrite)
  Else
    ' Here is the where the script reads the array
    For intPrinter = 0 To objPrinter.Count -1 Step 2
      strWrite = dttmCurrent &";"& objNetwork.UserName &";"& objNetwork.UserDomain &";"& objNetwork.ComputerName &";"& (intPrinter/2)+1 &";"& objPrinter.Item(intPrinter) &";"& objPrinter.Item(intPrinter +1)
      Call AppendToFile(strDirectory, strFile, strWrite)
    Next
  End If


End If

'try {
'  bagger = "2";
'} catch(err) {
'  WScript.Echo "Error ("& err.number &"):"& err.Description
'}


' Bonus or cosmetic section to launch explorer to check file
If err.number = vbEmpty then
   'Set objShell = CreateObject("WScript.Shell")
   'objShell.run ("Explorer" &" " & strDirectory & "\" )
Else WScript.echo "VBScript Error: " & err.number
End If

WScript.Quit

' End of VBScript to write to a file with error-correcting Code
