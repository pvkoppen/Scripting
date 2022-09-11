@ECHO OFF
REM Name          : TWPOTT-Files.cmd
REM Description   : Script used to Copy TWPOTT Files.
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Must be run as: Administrator
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2011-07-04: 1.0. Start
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------
SET RoboPath=C:\Windows\System32\

IF %1' == ' GOTO Log
IF %1' == /Action' GOTO Action
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
IF NOT EXIST "%~dp0LogFiles\." MKDIR "%~dp0LogFiles\"
CALL :GetDateTime
Call %0 /Action >> "%~dp0LogFiles\%~n0-%strDateTime%.Log" 2>>&1
start "Log" "%~dp0LogFiles\%~n0-%strDateTime%.Log"
GOTO End

:Action
ECHO.
ECHO ---------------- Start: %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime

%RoboPath%RoboCopy.exe /e /move /xjd /np /r:1 /w:1 "\\DON\Shared" "D:\Company Shared Folders\TOL\Historic\Te Whare Puawai O Te Tangata"
%RoboPath%RoboCopy.exe /e /move /xjd /np /r:1 /w:1 "\\DON\Users\Suzy\Documents" "D:\Users Shared Folders\TOL\SuzyP\Documents\Documents"
%RoboPath%RoboCopy.exe /e /move /xjd /np /r:1 /w:1 "\\DON\Users\Linda\Documents" "D:\Users Shared Folders\TOL\LindaW\Documents\Documents"

ECHO ---------------- End  : %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime
GOTO End

:PauseEnd
Pause
GOTO End

:End

