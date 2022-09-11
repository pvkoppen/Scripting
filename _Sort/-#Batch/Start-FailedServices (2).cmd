@ECHO OFF
REM Name          : Start-FailedServices.cmd
REM Description   : Start 'AUTOSTART' services that are not running, except for: 'Performance'.
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Must be run as: <No Preference: Administrators/LocalSystem>
REM Location      : C:\Admin\Scripts
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2009-05-11: v1.0.
REM 2009-07-20: v1.0a: First version.
REM 2009-10-23: v1.0b: Added a wait period.
REM 2014-12-21: 2.0 New Structure
REM 2015-07-22: 2.0a New structure implemented
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------

IF %1' == ' GOTO Log
IF %1' == /?' GOTO Help
IF %1' == /silent' GOTO Log
IF %1' == /Action' GOTO Action
IF %1' == /IsAutoStart' GOTO IsAutoStart
IF %1' == /IsNotRunning' GOTO IsNotRunning
IF %1' == /ListServices' GOTO ListServices
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

:Documentation
GOTO End
...
GOTO End

:Help
GOTO End

:Log
REM Start Logging
REM -----------------------------------------------------------------
IF NOT EXIST "%~dp0..\LogFiles\." MKDIR "%~dp0..\LogFiles"
MOVE /Y "%~dp0..\LogFiles\%~n0.Log" "%~dp0..\LogFiles\%~n0.Old.Log"
CALL %0 /Action %2 >> "%~dp0..\LogFiles\%~n0.Log" 2>>&1
TYPE "%~dp0..\LogFiles\%~n0.Log" >> "%~dp0..\LogFiles\%~n0.History.Log"
GOTO End

:Action
ECHO.
ECHO ---------------- Start: %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime
REM IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True

ECHO.
ECHO [INFO ] Delay the "%~n0" process by: 60 seconds (1 Min), or press any key to continue.
%~dp0..\Tools\await 60 "Waiting %%d seconds before starting failed services." >nul

ECHO.
for /f "tokens=2" %%a in ('call %0 /ListServices') do for /f %%A in ('call %0 /IsAutoStart %%a') do for /f %%M in ('%0 /IsNotRunning %%a') do Echo [INFO ] %%a: ! Running && net start %%a && IF %ERRORLEVEL%' == 0' SET strSendEmail=True
GOTO DoEnd

:IsAutoStart
sc qc %2 | find /i "AUTO_START"
GOTO End

:IsNotRunning
sc query %2 | find /i "STOPPED"
sc query %2 | find /i "START"
sc query %2 | find /i "STOP_PENDING"
GOTO End

:ListServices
sc query state= all | find /i "SERVICE_NAME:" | find /v /i "SysmonLog"
GOTO End

:DoEnd
REM Email the logbook to IT Services on Error.
REM -----------------------------------------------------------------------
IF %strSendEmail%' == True' CALL "%~dp0..\Tools\SendMail.cmd" "%~n0 (%COMPUTERNAME%)" "%~dp0..\LogFiles\%~n0.Log"
ECHO ---------------- End  : %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime
GOTO End

:Error
ECHO [ERROR] Error detected! [%ERRORLEVEL%]
GOTO End

:ErrorParam
ECHO [ERROR] Invalid Parameter 1: %*
GOTO End

:End
REM -----------------------------------------------------------------------

