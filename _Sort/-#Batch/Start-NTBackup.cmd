@ECHO OFF
REM Name          : Start-NTBackup.cmd
REM Description   : Start an NTBackup process.
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Must be run as: <No Preference: Administrators/LocalSystem>
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2011-06-07: 1.0: First Build.
REM 2011-08-03: 1.1: Updated with a second backup location
REM 2011-09-26: 2.0: Merged multiple previous backup scripts.
REM 2011-09-28: 2.1: Modified script to work properly. Programming error: No % for SET variabels.
REM 2012-01-24: 2.2: Updated Backup2Tape Parameters
REM 2013-03-04: 2.2a: Added IB2009 and IB2011 shutdown and startup
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------
SET strBackupTarget=C:\Backup-Config-Dump\
SET strSecondaryBackupTarget=D:\Backup-Config-Dump\
SET boolBackupToTape=True
SET boolBackupToDisk=True
SET boolBackupDiskToSecondary=False

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
TYPE "%~dp0LogFiles\%~n0.Log" >> "%~dp0LogFiles\%~n0.History.Log"
GOTO End

:Action
ECHO.
ECHO ---------------- Start: %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime
CALL :GetDateTime
REM IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True

ECHO.
ECHO -- Prepare Backup Target Locations
IF NOT EXIST "%strBackupTarget%NTBackup\." MKDIR  "%strBackupTarget%NTBackup\"
IF NOT EXIST "%strSecondaryBackupTarget%NTBackup\." MKDIR "%strSecondaryBackupTarget%NTBackup\"
GOTO PreBackup

:PreBackup
ECHO.
ECHO -- Prepare backup: Pre-Backup
"%SystemRoot%\system32\net.exe" stop MedtechSS
"%SystemRoot%\system32\net.exe" stop InterBaseServer
"%SystemRoot%\system32\net.exe" stop IBS_Medtech_IB2009
"%SystemRoot%\system32\net.exe" stop IBS_Medtech_IB2011
GOTO NTBackupToTape

:NTBackupToTape
ECHO.
ECHO -- Backup: NTBackup to Tape (True=%boolBackupToTape%)
IF NOT %boolBackupToTape%' == True' GOTO NTBackupToDisk
CALL :CleanupNTBackupLogs
START /wait "." "%SystemRoot%\system32\ntbackup.exe" backup "@%~dpn0.bks" /N "%COMPUTERNAME% - %strDate% [%~n0]" /D "%COMPUTERNAME% - %strDate% [%~n0]" /V:yes /R:no /RS:yes /HC:on /M normal /J "%COMPUTERNAME% - %strDate% [%~n0] (Tape)" /L:s /P "4mm DDS" /UM /SNAP:on
IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True
IF %strSendEmail%' == True' CALL :PrintNTBackupLogs
GOTO NTBackupToDisk

:NTBackupToDisk
ECHO.
ECHO -- Backup: NTBackup to Disk (True=%boolBackupToDisk%)
IF NOT %boolBackupToDisk%' == True' GOTO PostBackup
CALL :CleanupNTBackupLogs
START /wait "." "%SystemRoot%\system32\ntbackup.exe" backup "@%~dpn0.bks" /N "%COMPUTERNAME% - %strDate% [%~n0]" /D "%COMPUTERNAME% - %strDate% [%~n0]" /V:yes /R:no /RS:no /HC:off /M normal /J "%COMPUTERNAME% - %strDate% [%~n0] (Disk)" /L:s /f "%strBackupTarget%NTBackup\%~n0.bkf"
IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True
IF %strSendEmail%' == True' CALL :PrintNTBackupLogs
GOTO PostBackup

:PostBackup
ECHO.
ECHO -- Complete backup: Post-Backup
"%SystemRoot%\system32\net.exe" start IBG_Medtech_IB2011 && GOTO PostBackup2
"%SystemRoot%\system32\net.exe" start IBG_Medtech_IB2009 && GOTO PostBackup2
"%SystemRoot%\system32\net.exe" start InterBaseGuardian
:PostBackup2
"%SystemRoot%\system32\net.exe" start MedtechSS
IF %boolBackupToDisk%' == True' IF %boolBackupDiskToSecondary%' == True' GOTO SecondaryDiskBackup
GOTO DoEnd

:SecondaryDiskBackup
XCopy /E /Y "%strBackupTarget%NTBackup\%~n0.bkf" "%strSecondaryBackupTarget%NTBackup\%~n0-%COMPUTERNAME%.bkf"
GOTO DoEnd

:CleanupNTBackupLogs
ECHO.
ECHO -- NTBackup Log: Cleanup
ECHO -- DIR: "%USERPROFILE%\Local Settings\Application Data\Microsoft\Windows NT\NTBackup\Data\*.Log"
DIR /A "%USERPROFILE%\Local Settings\Application Data\Microsoft\Windows NT\NTBackup\Data\*.Log"
MOVE /Y "%USERPROFILE%\Local Settings\Application Data\Microsoft\Windows NT\NTBackup\Data\*.Log" "%~dp0LogFiles\"
GOTO End

:PrintNTBackupLogs
ECHO.
CALL :PrintDateTime
ECHO -- NTBackup Log: Start
FOR %%A IN ("%USERPROFILE%\Local Settings\Application Data\Microsoft\Windows NT\NTBackup\Data\*.Log") DO TYPE "%%A"
ECHO -- NTBackup Log: End
GOTO End

:DoEnd
REM Email the logbook to IT Services on Error.
REM -----------------------------------------------------------------------
IF %strSendEmail%' == True' CALL "%~dp0Tools\SendMail.cmd" "%~n0 (%COMPUTERNAME%)" "%~dp0LogFiles\%~n0.Log"
IF NOT %strSendEmail%' == True' CALL "%~dp0Tools\SendMail.cmd" "%~n0 (%COMPUTERNAME%) - Completed Succesfully"
ECHO ---------------- End  : %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime
GOTO End

:Error
ECHO [ERROR] Error detected!
GOTO End

:End
REM -----------------------------------------------------------------------

