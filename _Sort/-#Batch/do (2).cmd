GOTO T
net use t: /delete

:GP
GPUpdate /force
GPResult /H "%~dp0GPReport-%Computername%.html"
START "." "%~dp0GPReport-%Computername%.html"
GOTO End

:MapDrive
rem NET USE P: \\tolpt01\applications$
NET USE z: \\tolws01\inetpub
GOTO End

:Medtech-TOL
set clientname=
net use m: /delete
net use m: \\tolmt01\mt32
m:\bin\mt32.exe
GOTO End

:OutlookResetFolders
"C:\Program Files\Microsoft Office\Office12\outlook.exe" /resetfolders /resetfoldernames 
GOTO End

:help
GOTO End

:TXT
start "" "C:\Program Files (x86)\Vensa Health\TXT2Remind for MedTech\TXT2Remind.exe"
Pause
dir "C:\Program Files (x86)\Vensa Health\TXT2Remind for MedTech"
Pause
notepad "C:\Program Files (x86)\Vensa Health\TXT2Remind for MedTech\TXT2Remind.exe.config"
Pause
regedit.exe
Pause
GOTO End

:T
net use t: \\tolmm02\software
got end

:DoEnd
Pause
GOTO End

:End

