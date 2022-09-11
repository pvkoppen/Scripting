@ECHO OFF
REM Name          : Start-ProfileCopy.cmd
REM Description   : Script used to make a copy of Profile folders.
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Must be run as: <No Preference: Administrators/LocalSystem>
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2009-01-04: Version 1.1
REM 2009-07-20: v1.0b: Updated date&time format.
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------
SET strSource=\\tolfp01\d$\Users Shared Folders\
SET strTarget=D:\Backup-Config-Dump\
SET strTarget=C:\PvK\TOL\Download\

IF %1' == ' GOTO Log
IF %1' == /Action' GOTO Action
IF %1' == /ActionItems' GOTO ActionItems
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
CALL %0 /Action >> "%~dp0LogFiles\%~n0.Log" 2>>&1
TYPE "%~dp0LogFiles\%~n0.Log" >> "%~dp0LogFiles\%~n0.History.Log"
GOTO End

:Action
ECHO.
ECHO ---------------- Start: %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime
FOR /F "tokens=1,2" %%A IN (%~dpn0.txt) DO CALL %0 /ActionItems %%A %%B
REM IF %ERRORLEVEL%' == 0' SET strSendEmail=True
GOTO DoEnd

:ActionItems
ECHO [INFO ] %~n0: Starting Org:%2, User:%3
IF NOT EXIST "%strTarget%%~n0\%2\%3\." MKDIR "%strTarget%%~n0\%2\%3"
"%~dp0Tools\RoboCopy.exe" /E /XJD /NP /R:1 /W:1 "%strSource%%2\%3" "%strTarget%%~n0\%2\%3"
GOTO DoEnd

:DoEnd
REM Email the logbook to IT Services on Error.
REM -----------------------------------------------------------------------
IF %strSendEmail%' == True' CALL "%~dp0Tools\SendMail.cmd" "%~n0 (%COMPUTERNAME%)" "%~dp0LogFiles\%~n0.Log"
ECHO ---------------- End  : %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime
GOTO End

:End
REM -----------------------------------------------------------------------

