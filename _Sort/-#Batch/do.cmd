GOTO Attache

:Attache
NET USE P: \\tolpt01\applications$
GOTO End

:GP
GPUpdate /force
GPResult /H "%~dp0GPReport-%Computername%.html"
START "." "%~dp0GPReport-%Computername%.html"
GOTO DoEnd

:Login
CScript \\tol.local\sysvol\tol.local\scripts\loginscript.vbs
GOTO End

:DoEnd
Pause
GOTO End

:End
