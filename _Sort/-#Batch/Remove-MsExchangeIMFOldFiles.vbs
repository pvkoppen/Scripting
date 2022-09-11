' Name        : Remove-MsExchangeIMFOldFiles.vbs
' Description : Script used to remove old files from the IMF archive folder.
' Author      : Peter van Koppen,  Tui Ora Limited
' Version     : 1.1b
' -----------------------------------------------------------------------

' -----------------------------------------------------------------------
' Change Log.
' -----------------------------------------------------------------------
' 2009-01-04: Version 1.1
' -----------------------------------------------------------------------

' -- Default Settings and Variables
' -----------------------------------------------------------------------
Option Explicit
Dim oFSO, oFolder, oFile
Dim iDaysOld, iFilesDeleted
Dim boolDebug
boolDebug = True
boolDebug = False
If (boolDebug) Then On Error Goto 0 Else On Error Resume Next End If

' Customize values here to fit your needs
' -----------------------------------------------------------------------
  iDaysOld=70
  iFilesDeleted=0
  Set oFSO=CreateObject("Scripting.FileSystemObject")
  Set oFolder=oFSO.GetFolder("C:\Program Files\Exchsrvr\Mailroot\vsi 1\UceArchive")

' Walk through each file in this folder collection.
' If the file is older than the days specified, then delete it.
' -----------------------------------------------------------------------
  For each oFile in oFolder.Files
    If oFile.DateLastModified < (Date() - iDaysOld) Then
      iFilesDeleted = iFilesDeleted+1
      WScript.Echo "Will Delete file: " & oFolder.Path & "\" & oFile.Name
      oFSO.DeleteFile oFolder.Path & "\" & oFile.Name
    End If
  Next
  WScript.Echo "Number of files older then " & iDaysOld & " days deleted: " & iFilesDeleted 

' Clean up
' -----------------------------------------------------------------------
  Set oFSO = Nothing
  Set oFolder = Nothing
  Set oFile = Nothing

WScript.Quit

