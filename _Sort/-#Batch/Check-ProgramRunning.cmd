@ECHO OFF
REM Name          : Check-ProgramRunning.cmd
REM Description   : Script used to check if a program is running and launching it if it isn't.
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Version       : 1.0
REM Must be run as: <No Preference: Administrators/LocalSystem>
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2011-06-06: 1.0: Initial Version.
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------

IF %1' == /GetDateTime' GOTO GetDateTime
IF %1' == /PrintDateTime' GOTO PrintDateTime
IF %1' == /Action' GOTO Action
GOTO Log

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
IF NOT EXIST "%~dp0LogFiles\." MKDir "%~dp0LogFiles\."
CALL %0 /Action >> "%~dp0LogFiles\%~n0.log" 2>>&1
GOTO End

:Action
ECHO.
ECHO ---------------- Start: %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime 
REM IF %ERRORLEVEL%' == 0' SET strSendEmail=True
GOTO V2

:V1
ECHO Check For Process.
ECHO ----------------------------------
TaskList | find /I "uTorrent"
IF %ErrorLevel%' == 0' GOTO Running
GOTO NotRunning
:Running
ECHO -- Process Already Running.
GOTO DoEnd
:NotRunning
ECHO -- Starting Process.
rem Start "." "C:\Windows\explorer.exe"
rem Start "." "C:\Program Files (x86)\uTorrent\uTorrent.exe"
GOTO DoEnd

:V2
MSTSC.exe "%~dpn0.rdp"
GOTO DoEnd

:DoEnd
REM Email the logbook to IT Services on Error.
REM -----------------------------------------------------------------------
REM IF %strSendEmail%' == True' CALL "%~dp0Tools\SendMail.cmd" "%~n0 (%COMPUTERNAME%)" "%~dp0LogFiles\%~n0.Log"
ECHO ---------------- End  : %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime
GOTO End

:Error
ECHO Error detected!
GOTO End

:End
REM -----------------------------------------------------------------------

