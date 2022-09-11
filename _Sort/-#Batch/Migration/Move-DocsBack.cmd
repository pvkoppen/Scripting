@ECHO OFF
IF %1' == ' GOTO Start
IF %1' == Process' GOTO Process
GOTO End

:Start
FOR /D %%A IN (*.*) DO %0 Process %%A
Pause
GOTO End

:Process
CD %2
FOR /F "tokens=*" %%A IN ('DIR /ON /A /B') DO Move .\"%%A"\"My Documents" .\
CD ..
GOTO End

:End

