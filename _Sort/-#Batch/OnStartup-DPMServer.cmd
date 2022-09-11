@ECHO OFF
REM Name          : OnStartup-DPMServer.cmd
REM Description   : Start, Stop and Configure services after DPM server startup.
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Must be run as: <No Preference: Administrators/LocalSystem>
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2009-07-20: v1.0a: First version.
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------

IF %1' == '                GOTO Log
IF %1' == /Action'         GOTO Action
ECHO [ERROR] No valid action selected
GOTO End

:GetDateTime
REM -----------------------------------------------------------------------
@FOR /F "tokens=1-9 delims=/ " %%A IN ('date /t') DO @FOR /F "tokens=1-9 delims=:. " %%a IN ('time /t') DO SET strDateTime=%%D%%C%%B[%%A]-%%c%%d%%a%%b&& SET strDate=%%D%%C%%B[%%A]&& SET strTime=%%c%%d%%a%%b 
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
CALL :PrintDateTime
REM IF %ERRORLEVEL%' == 0' SET strSendEmail=True

ECHO.
ECHO -- Delay the startup activities by: 60 Seconds (1 min)
IF EXIST "%~dp0Tools\await.exe" "%~dp0Tools\await.exe" 60 "Waiting %%d seconds for action to complete." >nul

ECHO [INFO ] No Action required.
GOTO DoEnd

:ServiceStatus
IF %1' == ' GOTO Error
ECHO.
ECHO -- Get config and status of service: %1
sc qc %1 | FIND "START_TYPE"
sc query %1 | FIND "STATE"
GOTO End

:DisableService
IF %1' == ' GOTO Error
CALL :ServiceStatus %1
ECHO.
ECHO -- Stop and Disable service: %1
sc stop %1
IF EXIST "%~dp0Tools\await.exe" "%~dp0Tools\await.exe" 10 "Waiting %%d seconds for action to complete." >nul
sc config %1 start= disabled

CALL :ServiceStatus %1
GOTO End

:EnableService
IF %1' == ' GOTO Error
sc config %1 start= demand
IF %2' == auto' sc config %1 start= auto
IF %2' == AUTO' sc config %1 start= auto
GOTO End

:StartService
IF %1' == ' GOTO Error
sc start %1
GOTO End

:DoEnd
REM Email the logbook to IT Services on Error.
REM -----------------------------------------------------------------------
IF %strSendEmail%' == True' CALL "%~dp0Tools\SendMail.cmd" "%~n0 (%COMPUTERNAME%)" "%~dp0LogFiles\%~n0.Log"
ECHO ---------------- End  : %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime
GOTO End

:Error
ECHO Error, Parameters: %*
GOTO End

:End
REM -----------------------------------------------------------------------

