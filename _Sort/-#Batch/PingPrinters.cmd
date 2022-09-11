@ECHO OFF
IF %1' == /ping' goto DoPing
IF %1' == ' GOTO Start
GOTO Error

:Start
for %%a in (71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100) do Call %0 /ping 10.203.200. %%a
for %%a in (200 205 210 215 216 217 220 225 230 235 240 245) do Call %0 /ping 10.203. %%a .71
pause
GOTO End

:DoPing
ping -n 2 -w 10 %2%3%4 > nul
IF %ERRORLEVEL%' == 0' ECHO %2%3%4: Success && GOTO End
IF %ERRORLEVEL%' == 1' ECHO %2%3%4: Failed && GOTO End
ECHO %2%3%4: Unknown
GOTO End

:Error
ECHO Wrong Parameter 
GOTO End

:End
