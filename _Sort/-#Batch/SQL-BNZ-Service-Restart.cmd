@ECHO OFF
REM Name        : SQL-BNZ-Service-Restart.cmd
REM Description : Script used to Restart the SQL Service for the BNZ database.
REM Author      : Peter van Koppen,  Tui Ora Limited
REM Version     : 1.1b
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2009-01-04: Version 1.1
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------

IF %1' == ' GOTO Log
IF %1' == Action' GOTO Action
IF %1' == PrintDateTime' GOTO PrintDateTime
IF %1' == GetDateTime' GOTO GetDateTime
GOTO Action

:PrintDateTime
REM -----------------------------------------------------------------------
ECHO -----------------------------------------------------------------------
@FOR /F "tokens=1-9 delims=/ " %%A IN ('date /t') DO @FOR /F "tokens=1-9 delims=:. " %%a IN ('time /t') DO ECHO -- DATE-TIME=%%A%%B%%C%%D-%%a%%b%%c%%d 
ECHO -----------------------------------------------------------------------
GOTO End

:GetDateTime
REM -----------------------------------------------------------------------
@FOR /F "tokens=1-9 delims=/ " %%A IN ('date /t') DO @FOR /F "tokens=1-9 delims=:. " %%a IN ('time /t') DO SET strDateTime=%%A%%B%%C%%D-%%a%%b%%c%%d && SET strDate=%%A%%B%%C%%D && SET strTime=%%a%%b%%c%%d
REM -----------------------------------------------------------------------
GOTO End

:Log
IF NOT EXIST "%~dp0LogFiles\." MKDIR "%~dp0LogFiles"
Move /Y "%~dp0LogFiles\%~n0.Log" "%~dp0LogFiles\%~n0.Old.Log"
Call %0 Action >> "%~dp0LogFiles\%~n0.Log" 2>>&1
TYPE "%~dp0LogFiles\%~n0.Log" >> "%~dp0LogFiles\%~n0.History.Log"
GOTO End

:Action
ECHO.
ECHO ---------------- Start: %~dpnx0 on %ComputerName% ----------------
CALL %0 PrintDateTime
Net Stop MSSQL$BNZPCBB
Net Start MSSQL$BNZPCBB

ECHO ---------------- End  : %~dpnx0 on %ComputerName% ----------------
CALL %0 PrintDateTime
GOTO End

:End
REM -----------------------------------------------------------------------

