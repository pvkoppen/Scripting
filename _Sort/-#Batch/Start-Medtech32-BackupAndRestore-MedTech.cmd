@ECHO OFF
REM Name          : BackupAndRestore-MedTech.cmd
REM Description   : Script used to run an Interbase backup and restore of the MedTech database(s).
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Version       : 1.1e
REM Must be run as: Administrator
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2009-01-04: Version 1.1
REM 2009-01-04: 1.1c: Changed the default settings names.
REM 2009-07-20: 1.1d: Updated date&time format.
REM 2009-11-19: 1.1e: Updated Backup & Restore Sequence.
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------
SET MT32_BackupFolder=D:\Backup-Config-Dump\MedTech32\
SET MT32_InstallFolder=D:\Medtech\MT32\
SET IB_ProgramFolder=C:\Program Files\Borland\InterBase\
SET MT32_BackupFile=%MT32_BackupFolder%MT32.bak

IF %1' == ' GOTO Log
IF %1' == /Action' GOTO Action
IF %1' == /GetDateTime' GOTO GetDateTime
IF %1' == /PrintDateTime' GOTO PrintDateTime
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
GOTO End

:Action
ECHO.
ECHO ---------------- Start: %~dpnx0 on %ComputerName% ----------------
CALL %0 /PrintDateTime
CALL %0 /GetDateTime
REM IF %ERRORLEVEL%' == 0' SET strSendEmail=True

REM Remove previous Log and Dump files.
REM -----------------------------------------------------------------------
IF NOT EXIST "%MT32_BackupFolder%." MKDIR "%MT32_BackupFolder%"
IF NOT EXIST "%MT32_BackupFolder%Yesterday\." MKDIR "%MT32_BackupFolder%Yesterday"
Move /Y "%MT32_BackupFolder%*.*" "%MT32_BackupFolder%Yesterday\"

REM Ensure the IntabaseGuardian (and InterbaseServer) are running.
REM -----------------------------------------------------------------------
Net Start InterbaseGuardian

REM Set the Backup File Name
REM --------------------------------------------------------
SET MT32_BackupFile=%MT32_BackupFolder%%strTime%-MT32.bak

REM Now we can start the Backup from Interbase using GBAK
REM --------------------------------------------------------
"%IB_ProgramFolder%bin\gbak.exe" -B -V -Z -USER sysdba -PAS masterkey -Y "%MT32_BackupFolder%%strTime%-MT32.Log" "LocalHost:%MT32_InstallFolder%Data\MT32.ib" "%MT32_BackupFile%"
IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True
IF %strSendEmail%' == True' GOTO DoEnd
START "Check Log" /WAIT "%MT32_BackupFolder%%strTime%-MT32.Log"

REM Now we can start the Restore to Interbase using GBAK
REM -----------------------------------------------------------------------
GOTO RestoreToNew

:RestoreToNew
REM Restore Database: Create New file
Move /Y "%MT32_InstallFolder%Data\MT32.ib" "%MT32_BackupFolder%"
IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True
IF %strSendEmail%' == True' GOTO DoEnd
"%IB_ProgramFolder%bin\gbak.exe" -C -V -Z -USER sysdba -PAS masterkey -Y "%MT32_BackupFolder%\Restore-%strTime%-MT32.Log" "%MT32_BackupFile%" "LocalHost:%MT32_InstallFolder%Data\MT32.IB" 
IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True
IF %strSendEmail%' == True' GOTO DoEnd
START "Check Log" /WAIT "%MT32_BackupFolder%\Restore-%strTime%-MT32.Log"
GOTO DoEnd

:RestoreWithOverwrite
REM Restore Database: Overwrite file
"%IB_ProgramFolder%bin\gbak.exe" -R -V -Z -USER sysdba -PAS masterkey -Y "%MT32_BackupFolder%\Restore-%strTime%-MT32.Log" "%MT32_BackupFile%" "LocalHost:%MT32_InstallFolder%Data\MT32.IB" 
GOTO DoEnd

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

