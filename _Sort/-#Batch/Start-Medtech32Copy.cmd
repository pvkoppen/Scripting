@ECHO OFF
REM Name          : Start-Medtech32Copy.cmd
REM Description   : Script used to make a backup copy of Medtech.
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Must be run as: Administrator
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2010-02-06: v1.0: Initial setup
REM 2010-08-14: 1.2: Merged NR and SouthCare Scripts
REM 2010-08-14: 1.3: Added server specific folder settings
REM 2010-08-14: 1.3a: Changed Logging
REM 2010-06-06: 1.4: Changed Backup Folder name.
REM 2011-07-29: 1.4a: Added ClinicWaitara
REM 2011-11-10: 1.4b: Added TOLMT01 and TAMMT01
REM 2012-09-25: 1.4c: Updated
REM 2012-09-25: 1.4d: Updated - Stop and Start MedtechSS
REM 2012-09-25: 1.4e: Updated - Added Devon Medical
REM -----------------------------------------------------------------------

ECHO -- Default Settings
ECHO -----------------------------------------------------------------------
:General
SET MT32_BackupFolder=D:\Backup-Config-Dump\MedTech32\
SET MT32_InstallFolder=D:\Medtech\MT32\
SET IB_Version=2011
GOTO %COMPUTERNAME%.%USERDNSDOMAIN%

:AVESERVER.avenue.local
SET MT32_InstallFolder=D:\MT32\
GOTO Begin

:CLINICWAITARA.
SET MT32_InstallFolder=C:\MT32\
SET IB_Version=7
GOTO Begin

:DMCMT01.dmc.local
SET IB_Version=2009
GOTO Begin

:FAMILYSBS.family.local
GOTO Begin

:HTPHO30.tol.local
SET MT32_BackupFolder=C:\Backup-Config-Dump\MedTech32\
SET MT32_InstallFolder=C:\MT32\
SET IB_Version=7
GOTO Begin

:PHOMT01.tol.local
SET MT32_BackupFolder=C:\Backup-Config-Dump\MedTech32\
SET MT32_InstallFolder=C:\MT32\
SET IB_Version=7
GOTO Begin

:RUANUIVM.ruanui.local
GOTO Begin

:TAMMT01.tol.local
SET MT32_InstallFolder=D:\MT32\
GOTO Begin

:TOLMT01.tol.local
GOTO Begin


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

ECHO -- Create Backup Folder.
ECHO -----------------------------------------------------------------------
IF NOT EXIST "%MT32_BackupFolder%." MKDIR "%MT32_BackupFolder%"

ECHO -- Stop Services
ECHO -----------------------------------------------------------------------
NET STOP MedtechSS
IF %IB_Version%' == 7'    NET STOP InterBaseServer
IF %IB_Version%' == 2009' NET STOP IBS_MedTech_IB09
IF %IB_Version%' == 2011' NET STOP IBS_MedTech_IB11

ECHO -- Start Backup.
ECHO -----------------------------------------------------------------------
"%~dp0Tools\RoboCopy.exe" /E /R:1 /W:3 /NP "%MT32_InstallFolder%..\MT32\."  "%MT32_BackupFolder%MT32\." /xd "Attachments"
"%~dp0Tools\RoboCopy.exe" /E /R:1 /W:3 /NP "%MT32_InstallFolder%..\IDIOM\." "%MT32_BackupFolder%IDIOM\."
IF EXIST "%MT32_InstallFolder%..\MedtechCAT\." "%~dp0Tools\RoboCopy.exe" /E /R:1 /W:3 /NP "%MT32_InstallFolder%..\MedtechCAT\." "%MT32_BackupFolder%MedtechCAT\."
IF EXIST "%SystemDrive%\InetPub\."             "%~dp0Tools\RoboCopy.exe" /E /R:1 /W:3 /NP "%SystemDrive%\InetPub\."             "%MT32_BackupFolder%InetPub\."
IF EXIST "C:\ACCSend\."    "%~dp0Tools\RoboCopy.exe" /E /R:1 /W:3 /NP "C:\ACCSend\."    "%MT32_BackupFolder%C-ACCSend\."
IF EXIST "C:\HLINK\."      "%~dp0Tools\RoboCopy.exe" /E /R:1 /W:3 /NP "C:\HLINK\."      "%MT32_BackupFolder%C-HLINK\."
IF EXIST "C:\IDIOM\."      "%~dp0Tools\RoboCopy.exe" /E /R:1 /W:3 /NP "C:\IDIOM\."      "%MT32_BackupFolder%C-IDIOM\."
IF EXIST "C:\MedtechCAT\." "%~dp0Tools\RoboCopy.exe" /E /R:1 /W:3 /NP "C:\MedtechCAT\." "%MT32_BackupFolder%C-MedtechCAT\."
IF EXIST "C:\RESEARCH\."   "%~dp0Tools\RoboCopy.exe" /E /R:1 /W:3 /NP "C:\RESEARCH\."   "%MT32_BackupFolder%C-RESEARCH\."

ECHO -- Start Services
ECHO -----------------------------------------------------------------------
IF %IB_Version%' == 2011' NET START IBG_MedTech_IB11
IF %IB_Version%' == 2009' NET START IBG_MedTech_IB09
IF %IB_Version%' == 7'    NET START InterBaseGuardian
NET START MedtechSS
IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True
GOTO DoEnd

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

