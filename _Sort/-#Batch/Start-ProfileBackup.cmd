@ECHO OFF
REM Name          : Start-ProfileBackup.cmd
REM Description   : Script used to run an Interbase backup of the Profile database(s).
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Must be run as: <No Preference: Administrators/LocalSystem>
REM Location      : C:\Admin\Scripts
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2008-10-06: 1.0: First Build.
REM 2015-08-10: 2.0a New structure implemented
REM 2015-10-29: 2.0b Generalised Interbase Backup (Profile and Medtech)
REM 2015-12-10: 2.0c Add File removal to script (Report only at this stage)
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------
TITLE %~n0
ECHO [INFO ] -- Backup Settings
SET strBackupType=Profile
SET strBackupTarget=D:\Backup-Config-Dump\
SET strBackupSecondary=\\TOLMM02\Backup$\Data\
SET boolBackupToSecondary=False
SET intCopiesToKeep=7

ECHO [INFO ] Interbase Settings
SET strIBInstance=
SET strIBProgramFolder=D:\Program Files\Borland\InterBase\
SET strIBFileExt=.GDB

ECHO [INFO ] Application Settings
SET strApplicationPath=D:\Program Files\Intrahealth\Profile\
SET strApplicationDBFolder=Database\
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
ECHO [INFO ] -- Backup: Backup to Target (%strBackupTarget%)
IF NOT EXIST "%strBackupTarget%%strBackupType%\." MKDIR "%strBackupTarget%%strBackupType%\"
IF NOT EXIST "%strBackupTarget%%strBackupType%\Archive\." MKDIR "%strBackupTarget%%strBackupType%\Archive\"
ECHO [INFO ] -- Remove previous Log and Dump files.
DEL /Q "%strBackupTarget%%strBackupType%\*.IBK"
MOVE "%strBackupTarget%%strBackupType%\*.*" "%strBackupTarget%%strBackupType%\Archive\"

ECHO [INFO ] -- Ensure the InterBaseGuardian (and InterBaseServer) are running.
NET START %IB_ServiceGuardian%

ECHO [INFO ] -- Get all the .IB filenames for Backup
DIR /A/B "%strApplicationPath%%strApplicationDBFolder%*%strIBFileExt%" > "%~dp0..\LogFiles\%~n0.txt"
FOR /F %%A IN (%~dp0..\LogFiles\%~n0.txt) DO CALL %0 /DoBackup %%A
GOTO PostBackup

:PostBackup
ECHO [INFO ] -- Backup: Post-Backup
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

:DoBackup
ECHO [INFO ] -- Now we can start the Backup from Interbase using GBAK
START /wait "." "%strIBProgramFolder%bin\gbak.exe" -B -V -Z -USER sysdba -PAS masterkey -Y "%strBackupTarget%%strBackupType%\%strTime%-%~n2.log" "%IB_Connection%:%strApplicationPath%%strApplicationDBFolder%%~n2%strIBFileExt%" "%strBackupTarget%%strBackupType%\%strTime%-%~n2.ibk"
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

