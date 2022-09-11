@ECHO OFF
REM Name          : Restart-ExchangeServer.cmd
REM Description   : Script used to Restart the Exchange Server (With a /silent option for scheduled operation).
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Must be run as: Administrator/SYSTEM
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2009-01-04: v1.1: First published Edition
REM 2009-07-20: v1.1c: Updated date&time format.
REM 2011-09-14: 1.2a: Removed version number
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------

IF %1' == /silent' GOTO Log
IF %1' == /Action' GOTO Action
IF %1' == /GetDateTime' GOTO GetDateTime
IF %1' == /PrintDateTime' GOTO PrintDateTime
GOTO AreYouSure

:GetDateTime
REM -----------------------------------------------------------------------
@FOR /F "tokens=1-9 delims=/ " %%A IN ('date /t') DO @FOR /F "tokens=1-9 delims=:. " %%a IN ('time /t') DO SET strDateTime=%%D%%C%%B[%%A]-%%c%%d%%a%%b && SET strDate=%%D%%C%%B[%%A] && SET strTime=%%c%%d%%a%%b 
REM -----------------------------------------------------------------------
GOTO End

:PrintDateTime
REM -----------------------------------------------------------------------
ECHO -----------------------------------------------------------------------
@FOR /F "tokens=1-9 delims=/ " %%A IN ('date /t') DO @FOR /F "tokens=1-9 delims=:. " %%a IN ('time /t') DO ECHO -- DATE-TIME=%%D%%C%%B[%%A]-%%c%%d%%a%%b 
ECHO -----------------------------------------------------------------------
GOTO End

:AreYouSure
ECHO.
CHOICE /C YN /M "Are you sure you want to restart this server (%COMPUTERNAME%) ?"
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
Call %0 /Action >> "%~dp0LogFiles\%~n0.Log" 2>>&1
GOTO End

:Action
ECHO.
ECHO ---------------- Start: %~dpnx0 on %ComputerName% ----------------
CALL %0 /PrintDateTime
REM IF %ERRORLEVEL%' == 0' SET strSendEmail=True

ECHO Y | NET STOP MsExchangeIS
IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True

ECHO Y | NET STOP MsExchangeSA
IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True

"%SystemRoot%\System32\Shutdown.exe" /f /r /t 30 /c "System: Server restart by batch: %~f0"
IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True
GOTO DoEnd

:DoEnd
REM Email the logbook to IT Services on Error.
REM -----------------------------------------------------------------------
IF %strSendEmail%' == True' CALL "%~dp0Tools\SendMail.cmd" "%~n0 (%COMPUTERNAME%)" "%~dp0LogFiles\%~n0.Log"
ECHO ---------------- End  : %~dpnx0 on %ComputerName% ----------------
CALL %0 /PrintDateTime
GOTO End

:Error
ECHO Error detected!
GOTO End

:End
REM -----------------------------------------------------------------------

