'CTFMON rename script for STDC by Kelvin Brace Created 16 June 2994


' Renames CTFMON
Set objFSO = CreateObject("Scripting.FileSystemObject")
objFSO.MoveFile "C:\windows\system32\ctfmon.exe" , "C:\windows\system32\ctfmon.old"


' Creates a txt file called CTFMON.txt
strPath = "c:\windows\system32"
strFileName = "ctfmon.txt"
strFullName = objFSO.BuildPath(strPath, strFileName)
Set objFile = objFSO.CreateTextFile(strFullName)
objFile.Close

' Then renames it to CTFMON.exe
objFSO.MoveFile "C:\windows\system32\ctfmon.txt" , "C:\windows\system32\ctfmon.exe"


 


