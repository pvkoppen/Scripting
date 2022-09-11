@ECHO OFF
if %1' == ' goto StartNew
goto Continue

:StartNew
ECHO. > %0.log
call %0 .
ECHO.
ECHO ------- Summary: Begin -------
type %0.log
ECHO ------- Summary: End -------
goto end

:Continue
echo -- Folder:%1 >>%0.log
LINKD.exe %1
REM IF %ERRORLEVEL%==0 LinkD.exe %1
fsutil reparsepoint query %1
IF %ERRORLEVEL%==0 fsutil reparsepoint query %1 >>%0.log
FOR /D %%A in (%1\*) DO call %0 "%%A"
goto End

:End
