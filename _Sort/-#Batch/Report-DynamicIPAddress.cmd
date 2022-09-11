@ECHO OFF
REM Name        : Report-DymanicIPAdress.cmd
REM Description : Script used to Send an email when the Dymanic IP address changes.
REM Author      : Peter van Koppen,  Tui Ora Limited
REM Version     : 1.0a
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2009-09-09: Version 1.0
REM 2009-09-23: v1.0a: Updated the script
REM 2012-07-14: v1.0b: Updated the script
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------
SET InternetTarget=checkip.dyndns.org

IF %1' == ' GOTO Log
IF %1' == /Action' GOTO Action
GOTO Action

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
IF NOT EXIST "%~dp0LogFiles\." MKDIR "%~dp0LogFiles"
Move /Y "%~dp0LogFiles\%~n0.Log" "%~dp0LogFiles\%~n0.Old.Log"
Call %0 /Action >> "%~dp0LogFiles\%~n0.Log" 2>>&1
REM TYPE "%~dp0LogFiles\%~n0.Log" >> "%~dp0LogFiles\%~n0.History.Log"
GOTO End

:Action
ECHO.
ECHO ---------------- Start: %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime

"%~dp0Tools\wget\wget.exe" -t 2 --output-document="%~dp0LogFiles\%~n0.html" http://%InternetTarget%
FC /L "%~dp0LogFiles\%~n0.html" "%~dp0LogFiles\%~n0.past"
IF NOT %ERRORLEVEL%' == 0' GOTO Error-Fix
GOTO DoEnd

:Error-Fix
ECHO.
ECHO Dynamic IP Address Changed.
ECHO -------------------------------------------------------------------------------------
TYPE "%~dp0LogFiles\%~n0.html" 
ECHO -------------------------------------------------------------------------------------
CALL "%~dp0Tools\SendMail.cmd" "%~n0" "%~dp0LogFiles\%~n0.Log"
COPY "%~dp0LogFiles\%~n0.html" "%~dp0LogFiles\%~n0.past"
GOTO DoEnd

:DoEnd
ECHO ---------------- End  : %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime
GOTO End

:End
REM -----------------------------------------------------------------------

