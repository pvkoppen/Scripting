@ECHO OFF
REM Name          : Start-eTempCopy.cmd
REM Description   : Script used to make a backup copy of eTemp data.
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Must be run as: Administrator
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2012-10-12: 1.0: Initial setup

REM -----------------------------------------------------------------------

ECHO -- Default Settings
ECHO -----------------------------------------------------------------------
:General
SET eTemp_BackupPath=OISTempLogs\
SET eTemp_LocalFolder=D:\Medtech\MT32\
SET eTemp_Username=TOL\svc_eTemp
SET eTemp_Password=HotInHere
SET eTemp_BackupServer=tolfp01


:Begin

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
ECHO -- Start Logging
ECHO -----------------------------------------------------------------------
IF NOT EXIST "%~dp0LogFiles\." MKDIR "%~dp0LogFiles"
Move /Y "%~dp0LogFiles\%~n0.Log" "%~dp0LogFiles\%~n0.Old.Log"
Call %0 /Action >> "%~dp0LogFiles\%~n0.Log" 2>>&1
GOTO End

:Action
ECHO.
ECHO ---------------- Start: %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime
CALL :GetDateTime
REM IF %ERRORLEVEL%' == 0' SET strSendEmail=True

ECHO -- Map Drive
ECHO -----------------------------------------------------------------------
net use \\%eTemp_BackupServer% /delete 
net use \\%eTemp_BackupServer% /user:%eTemp_Username% %eTemp_Password% 
IF %ERRORLEVEL%' == 1' SET strSendEmail=True

ECHO -- Create Backup Folder.
ECHO -----------------------------------------------------------------------
IF NOT EXIST "\\%eTemp_BackupServer%\%eTemp_BackupPath%." MKDIR "\\%eTemp_BackupServer%\%eTemp_BackupPath%"

ECHO -- Start Backup.
ECHO -----------------------------------------------------------------------
"%~dp0Tools\RoboCopy.exe" /E /R:1 /W:3 /NP "%eTemp_LocalFolder%."  "\\%eTemp_BackupServer%\%eTemp_BackupPath%."
IF %ERRORLEVEL%' == 1' SET strSendEmail=True

:DoEnd
ECHO -- Email the logbook to IT Services on Error.
ECHO -----------------------------------------------------------------------
IF %strSendEmail%' == True' CALL "%~dp0Tools\SendMail.cmd" "%~n0 (%COMPUTERNAME%)" "%~dp0LogFiles\%~n0.Log"
ECHO ---------------- End  : %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime
GOTO End

:Error
ECHO.
ECHO -----------------------------------------------------------------------
ECHO [ERROR] Error detected!
ECHO [ERROR] Full Internal Server DNS name = %COMPUTERNAME%.%USERDNSDOMAIN%
GOTO End

:End
ECHO -----------------------------------------------------------------------

