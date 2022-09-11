@ECHO OFF
REM Name          : Run-DPMBackup.cmd
REM Description   : Script used to start the DPM backup.
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Must be run as: Administrator
REM Location      : C:\Admin\Scripts
REM Tools Required: DPMBackup, SendMail.cmd
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2014-12-08: v1.0: Added documentation.
REM 2014-12-21: 2.0 New Structure
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------
SET DPMPath=C:\Program Files\Microsoft DPM\DPM\
SET BackupTarget=\\TOLMM02\Backup$\

IF %1' == /?' GOTO Help
IF %1' == /silent' GOTO Log
IF %1' == /Action' GOTO Action
GOTO AreYouSure

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

ECHO [INFO ] Start Backup.
"%DPMPath%bin\DpmBackup.exe" -db -certificates

ECHO [INFO ] Check Target folder exists.
IF NOT EXIST "%BackupTarget%DPMBackup\%COMPUTERNAME%\."          MKDIR "%BackupTarget%DPMBackup\%COMPUTERNAME%"
IF NOT EXIST "%BackupTarget%DPMBackup\%COMPUTERNAME%-Previous\." MKDIR "%BackupTarget%DPMBackup\%COMPUTERNAME%-Previous"

ECHO [INFO ] Copy last weeks backup to previous location.
ROBOCOPY /r:1 /w:1 /e /mir /np "%BackupTarget%DPMBackup\%COMPUTERNAME%" "%BackupTarget%DPMBackup\%COMPUTERNAME%-Previous"

ECHO [INFO ] Copy Data to External location.
ROBOCOPY /r:1 /w:1 /e /np "%DPMPath%Volumes\ShadowCopy\Database Backups" "%BackupTarget%DPMBackup\%COMPUTERNAME%\Database Backups"
ROBOCOPY /r:1 /w:1 /e /np "%DPMPath%DPMBackup\Certificates"              "%BackupTarget%DPMBackup\%COMPUTERNAME%\Certificates"

ECHO [INFO ] Completed.
GOTO DoEnd

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

:End
REM -----------------------------------------------------------------------

