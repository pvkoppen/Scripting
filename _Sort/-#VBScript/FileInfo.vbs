Set fso = CreateObject("Scripting.FileSystemObject")
Set objShell = CreateObject("Shell.Application")
Set f = fso.GetFolder("c:\windows\system32")          'change directory name
Set fc = f.Files
For Each fs In fc
	 If fso.GetExtensionName(fs) = "dll" then
		 WScript.Echo fs.Name, fs.DateLastModified, fso.GetFileVersion(fs)
	 End if
Next
For Each fs In fc
	 If fso.GetExtensionName(fs) = "exe" then
		 WScript.Echo fs.Name, fs.DateLastModified, fso.GetFileVersion(fs)
	 End if
Next

strPath = "C:\Documents and Settings\profile\desktop\dlls.txt"

Set fso = CreateObject("Scripting.FileSystemObject")

Set strFile = fso.CreateTextFile(strPath, True)

strFile.WriteLine("FileName,Last Modified,File Version")

Set f = fso.GetFolder("C:\Documents and Settings\profile\dlldir")          
Set fc = f.Files
For Each fs In fc
	 If fso.GetExtensionName(fs) = "dll" then
		 strFile.WriteLine(fs.Name & "," & fs.DateLastModified & "," & fso.GetFileVersion(fs))
	 End if
Next