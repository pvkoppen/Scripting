@ECHO OFF
REM Name          : BackupAndRestore-MedTech.cmd
REM Description   : Script used to run an Interbase backup and restore of the MedTech database(s).
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Must be run as: Administrator
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2009-01-04: Version 1.1
REM 2009-01-04: 1.1c: Changed the default settings names.
REM 2009-07-20: 1.1d: Updated date&time format.
REM 2009-11-19: 1.1e: Updated Backup & Restore Sequence.
REM 2010-08-14: 1.2: Merged NR and SouthCare Scripts
REM 2010-08-14: 1.3: Added server specific folder settings
REM 2010-08-14: 1.3a: Changed Logging
REM 2010-06-06: 1.4: Changed Backup Folder name.
REM 2011-07-29: 1.4a: Added ClinicWaitara
REM 2011-11-10: 1.4b: Added TOLMT01 and TAMMT01
REM -----------------------------------------------------------------------

ECHO -- Default Settings
ECHO -----------------------------------------------------------------------
:General
SET IB_ProgramFolder=C:\Program Files\Borland\InterBase\
SET MT32_BackupFolder=D:\Backup-Config-Dump\MedTech32\
SET MT32_InstallFolder=D:\Medtech\MT32\
GOTO %COMPUTERNAME%.%USERDNSDOMAIN%
:AVESERVER.avenue.local
SET MT32_InstallFolder=D:\MT32\
GOTO Begin
:CLINICWAITARA.
SET MT32_BackupFolder=D:\Backup-Config-Dump\MedTech32\
SET MT32_InstallFolder=C:\MT32\
GOTO Begin
:FAMILYSBS.family.local
GOTO Begin
:HTPHO30.tol.local
SET MT32_BackupFolder=C:\Backup-Config-Dump\MedTech32\
SET MT32_InstallFolder=C:\MT32\
GOTO Begin
:KOIMT01.tol.local
GOTO Begin
:PHOMT01.tol.local
SET MT32_BackupFolder=C:\Backup-Config-Dump\MedTech32\
SET MT32_InstallFolder=C:\MT32\
GOTO Begin
:TAMMT01.tol.local
SET MT32_InstallFolder=D:\MT32\
GOTO Begin
:TOLMT01.tol.local
GOTO Begin
:TS01.ruanui.local
SET MT32_BackupFolder=\\RuanuiSBS\D$\Backup-Config-Dump\MedTech32\
SET MT32_InstallFolder=D:\MT32\
GOTO Begin
:SCTS01.scmt.local
SET MT32_BackupFolder=C:\Backup-Config-Dump\MedTech32\
SET MT32_BackupFolder=\\SCQM01\C$\Backup-Config-Dump\MedTech32\
SET MT32_InstallFolder=C:\Medtech\MT32\
GOTO Begin
:TAMMT01.tol.local
SET MT32_BackupFolder=C:\Backup-Config-Dump\MedTech32\
SET MT32_InstallFolder=D:\MT32\
GOTO Begin
:Begin
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

ECHO -- Remove previous Log and Dump files.
ECHO -----------------------------------------------------------------------
IF NOT EXIST "%MT32_BackupFolder%%strDate%\." MKDIR "%MT32_BackupFolder%%strDate%\"

ECHO -- Archive MTInbox and NIRMsgTransfer logs.
ECHO -----------------------------------------------------------------------
REN %MT32_InstallFolder%Bin\Tools\MTInbox.log MTInbox.%strDate%.log
REN %MT32_InstallFolder%Bin\Addins\NIR\DirectoryMonitor.log DirectoryMonitor.%strDate%.log
REN %MT32_InstallFolder%Bin\Addins\NIR\NIRMsgTransfer.log NIRMsgTransfer.%strDate%.log

ECHO -- Ensure the InterBaseGuardian (and InterBaseServer) are running.
ECHO -----------------------------------------------------------------------
NET START InterBaseGuardian

ECHO -- Set the Backup File Name
ECHO -----------------------------------------------------------------------
SET MT32_BackupFile=%MT32_BackupFolder%%strDate%\MT32-%strTime%.bak

ECHO -- Now we can start the Backup from Interbase using GBAK
ECHO -----------------------------------------------------------------------
"%IB_ProgramFolder%bin\gbak.exe" -B -V -Z -USER sysdba -PAS masterkey -Y "%MT32_BackupFolder%%strDate%\MT32-%strTime%.Log" "LocalHost:%MT32_InstallFolder%Data\MT32.ib" "%MT32_BackupFile%"
IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True
IF %strSendEmail%' == True' GOTO DoEnd
NET STOP InterBaseServer
START "Check Log" /WAIT "%MT32_BackupFolder%%strDate%\MT32-%strTime%.Log"

ECHO -- Now we can start the Restore to Interbase using GBAK
ECHO -----------------------------------------------------------------------
GOTO RestoreToNew

:RestoreToNew
ECHO -- Restore Database: Create New file
ECHO -----------------------------------------------------------------------
Move /Y "%MT32_InstallFolder%Data\MT32.ib" "%MT32_BackupFolder%%strDate%\"
IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True
IF %strSendEmail%' == True' GOTO DoEnd
NET START InterBaseGuardian
"%IB_ProgramFolder%bin\gbak.exe" -C -V -Z -USER sysdba -PAS masterkey -Y "%MT32_BackupFolder%%strDate%\Restore-MT32-%strTime%.Log" "%MT32_BackupFile%" "LocalHost:%MT32_InstallFolder%Data\MT32.IB" 
IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True
IF %strSendEmail%' == True' GOTO DoEnd
START "Check Log" /WAIT "%MT32_BackupFolder%%strDate%\Restore-MT32-%strTime%.Log"
GOTO DoEnd

:RestoreWithOverwrite
ECHO -- Restore Database: Overwrite file
ECHO -----------------------------------------------------------------------
"%IB_ProgramFolder%bin\gbak.exe" -R -V -Z -USER sysdba -PAS masterkey -Y "%MT32_BackupFolder%%strDate%\Restore-MT32-%strTime%.Log" "%MT32_BackupFile%" "LocalHost:%MT32_InstallFolder%Data\MT32.IB" 
IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True
IF %strSendEmail%' == True' GOTO DoEnd
START "Check Log" /WAIT "%MT32_BackupFolder%%strDate%\Restore-MT32-%strTime%.Log"
GOTO DoEnd

:DoEnd
ECHO -- Finalise: On Error Email, On Success Complete.
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

