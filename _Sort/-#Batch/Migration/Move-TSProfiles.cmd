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
MKDIR .\TSProfile
FOR /F "tokens=*" %%A IN ('DIR /ON /A /B') DO IF NOT "%%A"' == "TSProfile"' IF NOT "%%A"' == "My Documents"' Attrib -H -S -R "%%A" && Move "%%A" .\TSProfile\
CD ..
GOTO End

:End

