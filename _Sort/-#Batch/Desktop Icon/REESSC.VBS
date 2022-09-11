Dim WSHShell
Set WSHShell = WScript.CreateObject("WScript.Shell")
Dim MyShortcut, DesktopPath
DesktopPath = WSHShell.SpecialFolders("Desktop")
Set MyShortcut = WSHShell.CreateShortcut(DesktopPath & "\Rees2000.lnk")
MyShortcut.TargetPath = "R:\RE2000.EXE"
MyShortcut.WorkingDirectory = "R:\DATA\"
MyShortcut.WindowStyle = 4
MyShortcut.IconLocation = "R:\RE2000.EXE"
MyShortcut.Save
Set MyShortcut = WSHShell.CreateShortcut(DesktopPath & "\Copy To Last Month.lnk")
MyShortcut.TargetPath = "R:\RE2000.EXE"
MyShortcut.Arguments = " LMONTH"
MyShortcut.WorkingDirectory = "R:\DATA\"
MyShortcut.WindowStyle = 4
MyShortcut.IconLocation = "R:\RE2000.EXE"
MyShortcut.Save
Set MyShortcut = WSHShell.CreateShortcut(DesktopPath & "\Rees2000 Last Month.lnk")
MyShortcut.TargetPath = "R:\RE2000.EXE"
MyShortcut.WorkingDirectory = "R:\LMONTH\"
MyShortcut.WindowStyle = 4
MyShortcut.IconLocation = "R:\RE2000.EXE"
MyShortcut.Save
