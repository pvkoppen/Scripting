@ECHO OFF
REM Name          : Update-GroupPolicy.cmd
REM Description   : Script used to Update the local computers Group Policy Settings.
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Must be run as: <No Preference: Administrators/LocalSystem>
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2013-05-17: 1.1: Initial Version
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------

IF %1' == /silent' GOTO Log
IF %1' == /Action' GOTO Action
GOTO AreYouSure

:GetDateTime
REM -----------------------------------------------------------------------
@FOR /F "tokens=1-9 delims=/ " %%A IN ('date /t') DO @FOR /F "tokens=1-9 delims=:. " %%a IN ('time /t') DO SET strDateTime=%%D%%C%%B[%%A]-%%c%%d%%a%%b && SET strDate=%%D%%C%%B[%%A] && SET strTime=%%c%%d%%a%%b
REM -----------------------------------------------------------------------
GOTO End

:PrintDateTime
ECHO -----------------------------------------------------------------------
@FOR /F "tokens=1-9 delims=/ " %%A IN ('date /t') DO @FOR /F "tokens=1-9 delims=:. " %%a IN ('time /t') DO ECHO -- DATE-TIME=%%D%%C%%B[%%A]-%%c%%d%%a%%b
ECHO -----------------------------------------------------------------------
GOTO End

:AreYouSure
ECHO.
CHOICE /C YN /M "Are you sure you want to "%~n0" (on %COMPUTERNAME%)?"
IF %ERRORLEVEL% == 255 GOTO Error
IF %ERRORLEVEL% == 2 GOTO End
IF %ERRORLEVEL% == 1 GOTO Action
IF %ERRORLEVEL% == 0 GOTO Error
GOTO End

:Log
REM Start Logging
REM -----------------------------------------------------------------
IF NOT EXIST "%~dp0LogFiles\." MKDIR "%~dp0LogFiles"
Move /Y "%~dp0LogFiles\%~n0.Log" "%~dp0LogFiles\%~n0.Old.Log"
CALL %0 /Action >> "%~dp0LogFiles\%~n0.Log" 2>>&1
TYPE "%~dp0LogFiles\%~n0.Log" >> "%~dp0LogFiles\%~n0.History.Log"
GOTO End

:Action
ECHO.
ECHO ---------------- Start: %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime
CALL :GetDateTime
REM IF %ERRORLEVEL%' == 0' SET strSendEmail=True

IF NOT EXIST "%~dp0Logfiles\."  MKDir "%~dp0Logfiles\."
GPResult.exe /H "%~dp0Logfiles\%~n0-%ComputerName%(%ClientName%)-%UserName%-%strDateTime%-Before.html"
Start "" "%~dp0Logfiles\%~n0-%ComputerName%(%ClientName%)-%UserName%-%strDateTime%-Before.html"
rem GPUpdate.exe /Force
rem GPResult.exe /H "%~dp0Logfiles\%~n0-%ComputerName%(%ClientName%)-%UserName%-%strDateTime%-Updated.html"
rem Start "" "%~dp0Logfiles\%~n0-%ComputerName%(%ClientName%)-%UserName%-%strDateTime%-Updated.html"
GOTO DoEnd

:DoEnd
REM Email the logbook to IT Services on Error.
REM -----------------------------------------------------------------------
IF %strSendEmail%' == True' CALL "%~dp0Tools\SendMail.cmd" "%~n0 (%COMPUTERNAME%)" "%~dp0LogFiles\%~n0.Log"
ECHO ---------------- End  : %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime
IF %1' == /Action' GOTO End
GOTO AreYouSure

:Error
ECHO Error detected!
GOTO End

:ErrorParam
ECHO Invalid Parameter 1: %*
GOTO End

:End

