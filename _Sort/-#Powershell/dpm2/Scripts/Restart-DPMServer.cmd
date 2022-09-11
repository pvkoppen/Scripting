@ECHO OFF
REM Name          : Restart-DPMServer.cmd
REM Description   : Backup Server: Automated Weekly Restart.
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Version       : 1.0c
REM Must be run as: Administrator
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2008-08-01: v1.0: Modified script for rebooting the Terminal servers to reboot this Backup server.
REM 2008-08-01: v1.0b: schtasks /create /RU "SYSTEM" /SC WEEKLY /MO 1 /D SUN /TN "Automated Weekly Reboot" /TR "C:\Scripts\Reboot.cmd" /ST 03:01:00
REM 2009-07-20: v1.0c: Updated date&time format.
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------
set DPMInstallLocation="C:\Program Files\Microsoft DPM\DPM"

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
GOTO End

:Action
ECHO.
ECHO ---------------- Start: %~dpnx0 on %ComputerName% ----------------
CALL %0 /PrintDateTime
REM IF %ERRORLEVEL%' == 0' SET strSendEmail=True

REM Make a backup of the DPM Database and Certificates.
REM -----------------------------------------------------------------
C:
cd "%DPMInstallLocation%\bin"
DPMBackup.exe -db 
IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True

DPMBackup.exe -certificates 
IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True

XCOPY "%DPMInstallLocation%\Volumes\ShadowCopy\Database Backups\*.*" \\tolss01.tol.local\d$\Backup-Config-Dump\MsDPM\
IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True

REM Now perform a restart to start up clean again.
REM -----------------------------------------------------------------
"%SystemRoot%\System32\Shutdown.exe" /r /f /t 30 /d p:0:0 /c "%0: Weekly Restart of Backup Server to clear cache."
IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True
ECHO ERRORLEVEL: %ERRORLEVEL%
ECHO -----------------------------------------------------------------

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

