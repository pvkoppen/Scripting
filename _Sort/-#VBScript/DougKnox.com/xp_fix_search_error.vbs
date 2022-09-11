'Fix Windows XP Search (error)
'xp_fix_search_error.vbs
'© Doug Knox - 02/03/2002
'Downloaded from http://www.dougknox.com

p1 = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{e17d4fc0-5564-11d1-83f2-00a0c90dc849}\"
p2 = "Search Results Folder"

Set WshShell = WScript.CreateObject("WScript.Shell")
WshShell.RegWrite p1, p2
Set WshShell = Nothing

x = MsgBox("Search has been fixed",4096,"Finished")