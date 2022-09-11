GOTO GP

:GP
GPUpdate /Force
GPResult /r GPReport.html
if exist .\GPReport.html start .\GPReport.html
if not exist .\GPReport.html GPResult /v
GOTO DoEnd


:IP-Renew
ipconfig /release
ipconfig /renew
GOTO DoEnd

:MT32
set clientname=ITServices
M:\bin\MT32.exe
goto end

:TXT
net use m: /delete
net use m: \\tolmt02\MT32
ECHO Run: TXT2Remind as Admin
Start /Wait "" "C:\Program Files (x86)\Vensa Health\TXT2Remind for MedTech\TXT2Remind.exe"
pause
net use m: /delete
ECHO GPUpdate /Force
GOTO End

:DoEnd
Pause
GOTO End

:End
