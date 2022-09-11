@ECHO OFF
REM Name          : Shutdown-ByUPS.cmd
REM Description   : Script used to Shutdown the servers when there is a power failure.
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Version       : 1.1c
REM Must be run as: Administrator
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2009-01-04: Version 1.1
REM 2009-07-20: v1.1c: Updated date&time format.
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------

IF %1' == ' GOTO Log
IF %1' == /Action' GOTO Action
IF %1' == /GetDateTime' GOTO GetDateTime
IF %1' == /PrintDateTime' GOTO PrintDateTime
GOTO End

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

:Log
REM Start Logging
REM -----------------------------------------------------------------
IF NOT EXIST "%~dp0LogFiles\." MKDIR "%~dp0LogFiles"
Move /Y "%~dp0LogFiles\%~n0.Log" "%~dp0LogFiles\%~n0.Old.Log"
Call %0 /Action >> "%~dp0LogFiles\%~n0.Log" 2>>&1
TYPE "%~dp0LogFiles\%~n0.Log" >> "%~dp0LogFiles\%~n0.History.Log"
GOTO End

:Action
ECHO.
ECHO ---------------- Start: %~dpnx0 on %ComputerName% ----------------
CALL %0 /PrintDateTime
REM IF %ERRORLEVEL%' == 0' SET strSendEmail=True

Shutdown /f /s /t 5 /c "System: UPS Power Failure" /m TS01 
Shutdown /f /s /t 5 /c "System: UPS Power Failure" /m TS02
Shutdown /f /s /t 5 /c "System: UPS Power Failure" /m NRFin01
Shutdown /f /s /t 60 /c "System: UPS Power Failure" /m RuanuiVM
ECHO Y | NET STOP MsExchangeIS
IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True

ECHO Y | NET STOP MsExchangeSA
IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True

REM Shutdown /f /s /t 10 /c "System: UPS Power Failure" 
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

