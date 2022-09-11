@ECHO OFF
REM Name        : Move-Medtech32-Once.cmd
REM Description : Script used only once to Move Medtech from SBS to TS.
REM Author      : Peter van Koppen,  Tui Ora Limited
REM Version     : 1.0
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2009-01-17: v1.0: Initial setup
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
Call %0 Action >> %~dp0LogFiles\%~n0.Log 2>>&1
CALL C:\Scripts\Tools\SendMail.cmd "After log (%COMPUTERNAME%)" %~dp0LogFiles\%~n0.Log
GOTO End

:Action
ECHO.
ECHO ---------------- Start: %~dpnx0 on %ComputerName% ----------------
CALL %0 PrintDateTime
GOTO DoWait

:DoWait
REM IF EXIST "%~dp0Tools\aWait.exe" "%~dp0Tools\aWait.exe" 3600 "Waiting for 30 minute(s) for COpy to Finish. Seconds remaining: %%d." 1>nul
CALL C:\Scripts\Tools\SendMail.cmd "Starting Copy (%COMPUTERNAME%)" %~dp0LogFiles\%~n0.Log
GOTO DoMove

:DoMove
%~dp0Tools\RoboCopy.exe /e /r:1 /MOVE /w:3 C:\Documentation-Drivers-Software \\scsbs01\d$\Documentation-Drivers-Software
%~dp0Tools\RoboCopy.exe /e /r:1 /MOVE /w:3 \\scsbs01\d$\Medtech\MT32 C:\Medtech\MT32
CALL C:\Scripts\Tools\SendMail.cmd "Copy complete, restart servers. (%COMPUTERNAME%)" %~dp0LogFiles\%~n0.Log
GOTO DoRestart

:DoRestart
shutdown /f /r /t 60 /C "%0: Medtech Moved" /m SCSBS01
shutdown /f /r /t 60 /C "%0: Medtech Moved" /m SCTS01
CALL %0 PrintDateTime
GOTO DoEnd

:DoEnd
ECHO.
ECHO ---------------- End  : %~dpnx0 on %ComputerName% ----------------
CALL %0 PrintDateTime
CALL C:\Scripts\Tools\SendMail.cmd "Script Finished. (%COMPUTERNAME%)" %~dp0LogFiles\%~n0.Log
GOTO End

:End
REM -----------------------------------------------------------------------

