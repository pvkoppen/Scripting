@ECHO OFF
REM Name          : Start-MedTech32Backup.cmd
REM Description   : Script used to run an Interbase backup of the MedTech database(s).
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Must be run as: <No Preference: Administrators/LocalSystem>
REM Location      : C:\Admin\Scripts
REM Tools Required: DPMBackup, SendMail.cmd
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
REM 2012-09-18: 1.5: Updated to IB11
REM 2014-12-21: 2.0 New Structure
REM 2015-07-24: 2.0a New Structure and Cleanup to just TOL
REM 2015-08-10: 2.0a New structure implemented
REM 2015-10-29: 2.0b Generalised Interbase Backup (Profile and Medtech)
REM 2015-12-10: 2.0c Add File removal to script (Report only at this stage)
REM 2015-12-15: 2.0c Add File removal to script - Action and Script cleanup
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------
TITLE %~n0
ECHO [INFO ] -- Backup Settings
SET strBackupType=MedTech32
SET strBackupTarget1=D:\Backup-Config-Dump\
SET strBackupTarget2=\\TOLMM02\Backup$\Data\
SET boolBackupToTarget2=False
SET intCopiesToKeep=7

ECHO [INFO ] Interbase Settings
SET strIBInstance=MedTech_IB11
SET strIBProgramFolder=C:\Embarcadero\Interbase2011-MedTech\
SET strIBFileExt=.IB

ECHO [INFO ] Application Settings
SET strApplicationPath=D:\Medtech\MT32\
SET strApplicationDBFolder=Data\
GOTO %COMPUTERNAME%.%USERDNSDOMAIN%

:TOLMT01.tol.local
GOTO Begin
:TOLMT02.tol.local
GOTO Begin

:Begin
IF %strIBInstance%' == ' SET IB_ServiceGuardian=InterBaseGuardian&&SET IB_ServiceServer=InterBaseServer&&SET IB_Connection=localhost
IF NOT %strIBInstance%' == ' SET IB_ServiceGuardian=IBG_%strIBInstance%&&SET IB_ServiceServer=IBS_%strIBInstance%&&SET IB_Connection=localhost/%strIBInstance%
ECHO [INFO ] Parameters: %*

IF %1' == /?' GOTO Help
IF %1' == /silent' GOTO Log
IF %1' == /Action' GOTO Action
IF %1' == /DoBackup' GOTO DoBackup
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
GOTO MainBackup

:MainBackup
ECHO.
ECHO [INFO ] Backup: Backup to Target1 (%strBackupTarget1%)
IF NOT EXIST "%strBackupTarget1%%strBackupType%\." MKDIR "%strBackupTarget1%%strBackupType%\"
IF NOT EXIST "%strBackupTarget1%%strBackupType%\Archive\." MKDIR "%strBackupTarget1%%strBackupType%\Archive\"
ECHO [INFO ] Remove previous Log and Dump files.
DEL /Q "%strBackupTarget1%%strBackupType%\*.IBK"
MOVE "%strBackupTarget1%%strBackupType%\*.*" "%strBackupTarget1%%strBackupType%\Archive\"

ECHO [INFO ] Ensure the InterBaseGuardian (and InterBaseServer) are running.
NET START %IB_ServiceGuardian%

ECHO [INFO ] Get all the .IB filenames for Backup
DIR /A/B "%strApplicationPath%%strApplicationDBFolder%*%strIBFileExt%" > "%~dp0..\LogFiles\%~n0.txt"
FOR /F %%A IN (%~dp0..\LogFiles\%~n0.txt) DO CALL %0 /DoBackup %%A
GOTO PostBackup

:PostBackup
ECHO [INFO ] Backup: Post-Backup
IF %boolBackupToTarget2%' == True' GOTO SecondaryDiskBackup
GOTO DoEnd

:SecondaryDiskBackup
ECHO [INFO ] Backup: Secondary Copy (%strBackupTarget2%)
ECHO [INFO ] Start: Cleanup-SecondaryBackupFolder
DIR /B /O-N "%strBackupTarget2%%strBackupType%\%COMPUTERNAME%\" > %~dp0..\LogFiles\%~n0-Previous.txt
MORE +%intCopiesToKeep% %~dp0..\LogFiles\%~n0-Previous.txt > %~dp0..\LogFiles\%~n0-Cleanup.txt
FOR /F %%A IN (%~dp0..\LogFiles\%~n0-Cleanup.txt) DO RMDIR /S /Q "%strBackupTarget2%%strBackupType%\%COMPUTERNAME%\%%A"&&ECHO [INFO ] Removed Backup: "%strBackupTarget2%%strBackupType%\%COMPUTERNAME%\%%A"
ECHO [INFO ] Finish: Cleanup-SecondaryBackupFolder
IF NOT EXIST "%strBackupTarget2%%strBackupType%\%COMPUTERNAME%\%strDateTime%\." MKDIR "%strBackupTarget2%%strBackupType%\%COMPUTERNAME%\%strDateTime%\"
RoboCopy /r:1 /w:1 /np "%strBackupTarget1%%strBackupType%\." "%strBackupTarget2%%strBackupType%\%COMPUTERNAME%\%strDateTime%\."
GOTO DoEnd

:DoBackup
ECHO [INFO ] Now we can start the Backup from Interbase using GBAK
START /wait "." "%strIBProgramFolder%bin\gbak.exe" -B -V -Z -USER sysdba -PAS masterkey -Y "%strBackupTarget1%%strBackupType%\%strTime%-%~n2.log" "%IB_Connection%:%strApplicationPath%%strApplicationDBFolder%%~n2%strIBFileExt%" "%strBackupTarget1%%strBackupType%\%strTime%-%~n2.ibk"
IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True
IF NOT %strSendEmail%' == True' ECHO [INFO ] Backup Completed without Errors.
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

