@ECHO OFF
REM Name          : Start-DailyMaintenanceTasks.cmd
REM Description   : Start Daily Maintenance Tasks.
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Version       : 1.1a
REM Must be run as: <No Preference: Administrators/LocalSystem>
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2010-03-22: 1.0: Initial setup.
REM 2010-04-24: 1.1: Added WeeklyActions to run on Sunday's. (Action Defrag C:, D:, E:)
REM 2010-04-24: 1.1a: Added a check for the existence of the maintenance scripts.
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

IF EXIST "%~dp0Start-FailedServices.cmd" Call "%~dp0Start-FailedServices.cmd"
IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True
IF EXIST "%~dp0Report-FreeDiskSpace.vbs" "%SYSTEMROOT%\System32\CScript.exe" "%~dp0Report-FreeDiskSpace.vbs"
IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True
GOTO WeeklyActions

:WeeklyActions
@FOR /F "tokens=1-9 delims=/ " %%A IN ('date /t') DO SET strDayOfTheWeek=[%%A]
IF NOT %strDayOfTheWeek%' == [Sun]' GOTO DoEnd
IF EXIST C:\. "%SYSTEMROOT%\System32\Defrag.exe" C:
IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True
IF EXIST D:\. "%SYSTEMROOT%\System32\Defrag.exe" D:
IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True
IF EXIST E:\. "%SYSTEMROOT%\System32\Defrag.exe" E:
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
GOTO End

:End
REM -----------------------------------------------------------------------

