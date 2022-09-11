@ECHO OFF
if %1' == ' goto StartNew
goto COntinue

:StartNew
ECHO. > %0.log
LinkD.exe .
REM IF %ERRORLEVEL%==0 LinkD.exe "."
FOR /D %%A in (*) DO call %0 "%%A"
ECHO.
ECHO ------- Summary: Begin -------
type %0.log
ECHO ------- Summary: End -------
goto end

:Continue
LINKD.exe %1
REM IF %ERRORLEVEL%==0 LinkD.exe %1
FOR /D %%A in (%1\*) DO call %0 "%%A"
goto End

:End
