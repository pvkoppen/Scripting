@ECHO OFF
REM Name          : Start-DPMBackup.cmd
REM Description   : Script used to backup the DPM aatabase.
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Must be run as: Administrator
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2009-01-04: Version 1.1
REM 2009-01-04: v1.1c: Changed the default settings names.
REM 2009-07-20: v1.1d: Updated date&time format.
REM 2011-09-26: 1.2: Updated Script
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------
SET DPMInstallLocation="C:\Program Files\Microsoft DPM\DPM"
SET strBackupTarget=C:\Backup-Config-Dump\
SET strSecondaryBackupTarget="\\tolfp01\d$\Backup-Config-Dump\"

IF %1' == ' GOTO Log
IF %1' == /Action' GOTO Action
GOTO End

:GetDateTime
REM -----------------------------------------------------------------------
@FOR /F "tokens=1-9 delims=/ " %%A IN ('date /t') DO @FOR /F "tokens=1-9 delims=:. " %%a IN ('time /t') DO SET strDateTime=%%D%%C%%B[%%A]-%%c%%d%%a%%b&& SET strDate=%%D%%C%%B[%%A]&& SET strTime=%%c%%d%%a%%b
REM -----------------------------------------------------------------------
GOTO End

:PrintDateTime
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
CALL :PrintDateTime
REM IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True

ECHO.
ECHO -- Prepare Backup Target Locations
IF NOT EXIST "%strBackupTarget%MsDPM\." MKDIR  "%strBackupTarget%MsDPM\"
IF NOT EXIST "%strSecondaryBackupTarget%MsDPM\." MKDIR "%strSecondaryBackupTarget%MsDPM\"

ECHO.
ECHO -- Backup: DPM
C:
cd "%DPMInstallLocation%\bin"
DPMBackup.exe -db 
IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True
DPMBackup.exe -certificates 
IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True

ECHO.
ECHO -- Copy Backup to Secondary location
XCOPY /E /Y "%DPMInstallLocation%\Volumes\ShadowCopy\Database Backups\*.*" %strSecondaryBackupTarget%MsDPM\
IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True
GOTO DoEnd

:DoEnd
REM Email the logbook to IT Services on Error.
REM -----------------------------------------------------------------------
IF %strSendEmail%' == True' CALL "%~dp0Tools\SendMail.cmd" "%~n0 (%COMPUTERNAME%)" "%~dp0LogFiles\%~n0.Log"
ECHO ---------------- End  : %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime
GOTO End

:Error
ECHO [ERROR] Error detected!
GOTO End

:End
REM -----------------------------------------------------------------------

