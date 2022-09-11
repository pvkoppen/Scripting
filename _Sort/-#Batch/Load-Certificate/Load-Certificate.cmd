@ECHO OFF
REM ECHO Params: %*
IF %1' == ' GOTO Begin
IF %1' == /CheckForCert' GOTO CheckForCert
GOTO Action

:BEGIN
FOR /f "USEBACKQ TOKENS=1,2,3 DELIMS=," %%A IN ("%~dpn0.txt") DO CALL %0 "%%A" %%B "%%C"
GOTO End

:Action
IF NOT EXIST "%~dp3%~nx1" GOTO FileError
FOR /F "TOKENS=*" %%A IN ('%0 /CheckForCert "%~n1"') DO ECHO Certificate Already Loaded! (%%A)&& GOTO CertAlreadyLoaded
"%~dp0importpfx\importpfx.exe" -f "%~dp3%~nx1" -p %2 -t USER -s MY
IF %ERRORLEVEL%' == 0' GOTO Success
IF %ERRORLEVEL%' == 1' GOTO Failed
GOTO Failed

:CheckForCert
CertUtil.exe -store -user my | find /i %2 
GOTO End

:CertAlreadyLoaded
GOTO End

:Success
ECHO Certificate Loaded successfully.
GOTO End

:Failed
ECHO Error loading file: "%~dp3%~nx1"
ECHO Bad Password!
GOTO End

:FileError
ECHO Error loading file: "%~dp3%~nx1"
ECHO File does not exist!
GOTO End

:End
