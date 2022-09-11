@ECHO OFF
TITLE Login Script

IF %1' == /Temp' GOTO Action
GOTO Begin

:Begin
ECHO.
ECHO [INFO] Making a local copy.
COPY /Y %0 "%temp%%~n0.cmd"
"%temp%%~n0.cmd" /Temp
GOTO End

:Action
ECHO.
ECHO [INFO] Removing Mapped Drives
ECHO [INFO] If asked to disconnect a drive, please answer: Y
ECHO ----------------------------------------------
FOR %%A IN (g h i m s) DO NET USE %%A: /DELETE

:LoginScript
ECHO.
ECHO [INFO] Running the Login Script
ECHO ----------------------------------------------
CScript \\tol.local\netlogon\loginscript.vbs
GOTO Done

:GPUpdate
ECHO.
ECHO [INFO] Reload Group Policies: DO NOT LOG OFF!
ECHO ----------------------------------------------
GPUpdate /Force

:Done
ECHO.
ECHO [INFO] Done!
ECHO ----------------------------------------------
DEL /Q %0
GOTO End

:End
