@ECHO OFF
REM Name          : Backup-MedTech.cmd
REM Description   : Script used to run an Interbase backup of the MedTech database(s).
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Must be run as: Administrator
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2009-01-04: Version 1.1
REM 2009-01-04: 1.1c: Changed the default settings names.
REM 2009-07-20: 1.1d: Updated date&time format.
REM 2009-11-19: 1.1e: Updated Backup Sequence.
REM 2010-08-14: 1.2: Merged NR and SouthCare Scripts
REM 2010-08-14: 1.3: Added server specific folder settings
REM 2010-08-14: 1.3a: Changed Logging
REM 2010-08-14: 1.4: Upgraded to get file listing.
REM 2011-11-10: 1.4b: Added TOLMT01 and TAMMT01
REM 2013-06-17: 1.4c: Update minor settings...
REM -----------------------------------------------------------------------

ECHO -- Default Settings
ECHO -----------------------------------------------------------------------
:General
SET IB_ProgramFolder=C:\Program Files\Borland\InterBase\
SET IB_Instance=
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
SET IB_ProgramFolder=C:\Program Files\Borland\InterBase2009-Medtech\
SET IB_Instance=MedTech_IB09
GOTO Begin
:TS01.ruanui.local
SET MT32_BackupFolder=\\RuanuiSBS\D$\Backup-Config-Dump\MedTech32\
SET MT32_InstallFolder=D:\MT32\
GOTO Begin
:SCTS01.scmt.local
SET MT32_BackupFolder=C:\Backup-Config-Dump\MedTech32\
REM SET MT32_BackupFolder=\\SCQM01\C$\Backup-Config-Dump\MedTech32\
SET MT32_InstallFolder=C:\Medtech\MT32\
GOTO Begin
:TAMMT01.tol.local
SET MT32_BackupFolder=C:\Backup-Config-Dump\MedTech32\
SET MT32_InstallFolder=D:\MT32\
GOTO Begin

:Begin
IF %IB_Instance%' == ' SET IB_ServiceGuardian=InterbaseGuardian&&SET IB_ServiceServer=InterbaseServer&&SET IB_Connection=localhost
IF NOT %IB_Instance%' == ' SET IB_ServiceGuardian=IBG_%IB_Instance%&&SET IB_ServiceServer=IBS_%IB_Instance%&&SET IB_Connection=localhost/%IB_Instance%
ECHO [INFO] Parameters: %*

IF %1' == ' GOTO Log
IF %1' == /Action' GOTO Action
IF %1' == /DoBackup' GOTO DoBackup
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
IF EXIST "%~dp0LogFiles\%~n0.Log" MOVE /Y "%~dp0LogFiles\%~n0.Log" "%~dp0LogFiles\%~n0.Old.Log"
CALL %0 /Action >> "%~dp0LogFiles\%~n0.Log" 2>>&1
GOTO End

:Action
ECHO.
ECHO ---------------- Start: %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime
CALL :GetDateTime
REM IF %ERRORLEVEL%' == 0' SET strSendEmail=True

ECHO -- Remove previous Log and Dump files.
ECHO -----------------------------------------------------------------------
IF NOT EXIST "%MT32_BackupFolder%." MKDIR "%MT32_BackupFolder%"
IF NOT EXIST "%MT32_BackupFolder%Archive\." MKDIR "%MT32_BackupFolder%Archive"
MOVE /Y "%MT32_BackupFolder%*.*" "%MT32_BackupFolder%Archive\"

ECHO -- Ensure the InterBaseGuardian (and InterBaseServer) are running.
ECHO -----------------------------------------------------------------------
NET START %IB_ServiceGuardian%

ECHO -- Get all the non xxBLOBxx .IB filenames for Backup
ECHO -----------------------------------------------------------------------
DIR /A/B "%MT32_InstallFolder%Data\*.IB" | Find /V /I "xxBLOBxx" > "%~dp0LogFiles\%~n0.txt"
FOR /F %%A IN (%~dp0LogFiles\%~n0.txt) DO CALL %0 /DoBackup %%A
GOTO DoEnd

:DoBackup
ECHO -- Now we can start the Backup from Interbase using GBAK
ECHO -----------------------------------------------------------------------
"%IB_ProgramFolder%bin\gbak.exe" -B -V -Z -USER sysdba -PAS masterkey -Y "%MT32_BackupFolder%%strTime%-%~n2.Log" "%IB_Connection%:%MT32_InstallFolder%Data\%~n2.ib" "%MT32_BackupFolder%%strTime%-%~n2.bak"
IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True
GOTO End

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
