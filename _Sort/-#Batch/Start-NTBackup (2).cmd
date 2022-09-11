@ECHO OFF
REM Name          : Start-NTBackup.cmd
REM Description   : Start an NTBackup process.
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Must be run as: <No Preference: Administrators/LocalSystem>
REM Location      : C:\Admin\Scripts
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2011-06-07: 1.0: First Build.
REM 2011-08-03: 1.1: Updated with a second backup location
REM 2011-09-26: 2.0: Merged multiple previous backup scripts.
REM 2011-09-28: 2.1: Modified script to work properly. Programming error: No % for SET variabels.
REM 2012-01-24: 2.2: Updated Backup2Tape Parameters
REM 2014-12-21: 2.0 New Structure
REM 2015-07-23: 2.0a New structure implemented
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------
TITLE %~n0
ECHO [INFO ] -- Backup Settings
SET strBackupType=NTBackup
SET strBackupTarget=D:\Backup-Config-Dump\
SET strBackupSecondary=\\TOLMM02\Backup$\
SET boolBackupToSecondary=True
SET intCopiesToKeep=7

ECHO [INFO ] Interbase Settings

ECHO [INFO ] Application Settings

ECHO [INFO ] Parameters: %*

IF %1' == /?' GOTO Help
IF %1' == /silent' GOTO Log
IF %1' == /Action' GOTO Action
GOTO AreYouSure

:GetDateTime
@FOR /F "tokens=1-9 delims=/ " %%A IN ('date /t') DO @FOR /F "tokens=1-9 delims=:. " %%a IN ('time /t') DO SET strDateTime=%%D%%C%%B[%%A]-%%c%%d%%a%%b&& SET strDate=%%D%%C%%B[%%A]&& SET strTime=%%c%%d%%a%%b
GOTO End

:PrintDateTime
ECHO [INFO ] -----------------------------------------------------------------------
@FOR /F "tokens=1-9 delims=/ " %%A IN ('date /t') DO @FOR /F "tokens=1-9 delims=:. " %%a IN ('time /t') DO ECHO [INFO ] -- DATE-TIME=%%D%%C%%B[%%A]-%%c%%d%%a%%b 
ECHO [INFO ] -----------------------------------------------------------------------
GOTO End

:AreYouSure
ECHO.
CHOICE /C YN /M "[QUESTION] Are you sure you want to "%~n0" (on %COMPUTERNAME%)?"
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
ECHO [INFO ] Start Logging
IF NOT EXIST "%~dp0..\LogFiles\." MKDIR "%~dp0..\LogFiles"
MOVE /Y "%~dp0..\LogFiles\%~n0.Log" "%~dp0..\LogFiles\%~n0.Old.Log"
CALL %0 /Action %2 >> "%~dp0..\LogFiles\%~n0.Log" 2>>&1
TYPE "%~dp0..\LogFiles\%~n0.Log" >> "%~dp0..\LogFiles\%~n0.History.Log"
GOTO End

:Action
ECHO.
ECHO [INFO ] ---------------- Start: %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime
CALL :GetDateTime
REM IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True

GOTO PreBackup

:PreBackup
ECHO.
ECHO [INFO ] Pre-Backup
"%SystemRoot%\system32\net.exe" stop InterbaseServer
GOTO MainBackup

:BackupToTape
ECHO.
ECHO -- Backup: Backup to Tape (True=%boolBackupToTape%)
IF NOT %boolBackupToTape%' == True' GOTO BackupToDisk
CALL :CleanupNTBackupLogs
START /wait "." "%SystemRoot%\system32\ntbackup.exe" backup "@%~dpn0.bks" /N "%COMPUTERNAME% - %strDate% [%~n0]" /D "%COMPUTERNAME% - %strDate% [%~n0]" /V:yes /R:no /RS:yes /HC:on /M normal /J "%COMPUTERNAME% - %strDate% [%~n0] (Tape)" /L:s /P "4mm DDS" /UM /SNAP:on
IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True
IF NOT %strSendEmail%' == True' ECHO [INFO ] Backup Completed without Errors.
IF %strSendEmail%' == True' CALL :PrintNTBackupLogs
GOTO BackupToDisk

:MainBackup
ECHO.
ECHO [INFO ] -- Backup: Backup to Target (%strBackupTarget%)
IF NOT EXIST "%strBackupTarget%%strBackupType%\." MKDIR "%strBackupTarget%%strBackupType%\"
CALL :CleanupNTBackupLogs
START /WAIT "." "%SystemRoot%\system32\ntbackup.exe" backup "@%~dpn0.bks" /N "%COMPUTERNAME% - %strDate% [%~n0]" /D "%COMPUTERNAME% - %strDate% [%~n0]" /V:yes /R:no /RS:no /HC:off /M normal /J "%COMPUTERNAME% - %strDate% [%~n0] (Disk)" /L:s /f "%strBackupTarget%NTBackup\%~n0.bkf"
IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True
IF NOT %strSendEmail%' == True' ECHO [INFO ] Backup Completed without Errors.
IF %strSendEmail%' == True' CALL :PrintNTBackupLogs
GOTO PostBackup

:PostBackup
ECHO [INFO ] -- Backup: Post-Backup
"%SystemRoot%\system32\net.exe" start InterbaseGuardian
IF %boolBackupToSecondary%' == True' GOTO SecondaryDiskBackup
GOTO DoEnd

:SecondaryDiskBackup
ECHO [INFO ] -- Backup: Secondary Copy (%strBackupSecondary%)
ECHO [INFO ] -- Start: Cleanup-SecondaryBackupFolder
IF NOT EXIST "%strBackupSecondary%%strBackupType%\%COMPUTERNAME%\." MKDIR "%strBackupSecondary%%strBackupType%\%COMPUTERNAME%\"
DIR /B /O-N "%strBackupSecondary%%strBackupType%\%COMPUTERNAME%\" > %~dp0..\LogFiles\%~n0-Previous.txt
MORE +%intCopiesToKeep% %~dp0..\LogFiles\%~n0-Previous.txt > %~dp0..\LogFiles\%~n0-Cleanup.txt
TYPE %~dp0..\LogFiles\%~n0-Cleanup.txt
FOR /F %%A IN (%~dp0..\LogFiles\%~n0-Cleanup.txt) DO ECHO RMDIR /S /Q "%strBackupSecondary%%strBackupType%\%COMPUTERNAME%\%%A"
ECHO [INFO ] -- Finish: Cleanup-SecondaryBackupFolder
IF NOT EXIST "%strBackupSecondary%%strBackupType%\%COMPUTERNAME%\%strDateTime%\." MKDIR "%strBackupSecondary%%strBackupType%\%COMPUTERNAME%\%strDateTime%\"
ROBOCOPY /r:1 /w:1 /np "%strBackupTarget%%strBackupType%\." "%strBackupSecondary%%strBackupType%\%COMPUTERNAME%\%strDateTime%\."
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
ECHO [INFO ] Email the logbook to IT Services on Error.
IF %strSendEmail%' == True' CALL "%~dp0..\Tools\SendMail.cmd" "%~n0 (%COMPUTERNAME%) - Completed with Errors" "%~dp0..\LogFiles\%~n0.Log"
IF NOT %strSendEmail%' == True' CALL "%~dp0..\Tools\SendMail.cmd" "%~n0 (%COMPUTERNAME%) - Completed Succesfully" "%~dp0..\LogFiles\%~n0.Log"
ECHO [INFO ] ---------------- End  : %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime
GOTO End

:Error
ECHO [ERROR] Error detected! [%ERRORLEVEL%]
ECHO [ERROR] Full Internal Server DNS name = %COMPUTERNAME%.%USERDNSDOMAIN%
GOTO End

:End
REM -----------------------------------------------------------------------

