em Nic Team script for Tuiora
rem Created by Aaron Gayton @ Staples Rodway Ltd 27-04-2005
rem Last change date:
rem Contact +64 6 7580956
rem copyright Staples Rodway Ltd


C:\cpqsystem\cqniccfg.cmd /c c:\cpqsystem\teamcfg.xml
if %ERRORLEVEL%=1 goto success
if %ERRORLEVEL%=0 goto success
goto exit

:success
set %ERRORLEVEL%=0
goto exit

:failure
echo failed
set %ERRORLEVEL%=0
rem  EXIT 1
goto exit

exit
