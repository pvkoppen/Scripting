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
REM 2014-12-21: 2.0 New Structure
REM 2015/07/24: 2.0a New Structure and Cleanup to just TOL
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------
TITLE %~n0
:General
SET IB_Instance=MedTech_IB11
SET IB_ProgramFolder=C:\Embarcadero\Interbase2011-MedTech\
SET MT32_BackupFolder=D:\Backup-Config-Dump\MedTech32\
SET MT32_InstallFolder=D:\Medtech\MT32\
GOTO %COMPUTERNAME%.%USERDNSDOMAIN%

:TAMMT01.tol.local
SET MT32_InstallFolder=D:\MT32\
GOTO Begin
:TOLMT01.tol.local
GOTO Begin

:Begin
IF NOT %IB_Instance%' == ' SET IB_ServiceGuardian=IBG_%IB_Instance%&&SET IB_ServiceServer=IBS_%IB_Instance%&&SET IB_Connection=localhost/%IB_Instance%
ECHO [INFO] Parameters: %*

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

ECHO [INFO ] -- Create Backup Folder.
IF NOT EXIST "%MT32_BackupFolder%." MKDIR "%MT32_BackupFolder%"

ECHO [INFO ] -- Stop Services
NET STOP MedtechSS
NET STOP %IB_ServiceServer%

ECHO [INFO ] -- Start Backup.
"%~dp0..\Tools\RoboCopy.exe" /E /R:1 /W:3 /NP "%MT32_InstallFolder%..\MT32\."  "%MT32_BackupFolder%MT32\." /xd "Attachments"
"%~dp0..\Tools\RoboCopy.exe" /E /R:1 /W:3 /NP "%MT32_InstallFolder%..\IDIOM\." "%MT32_BackupFolder%IDIOM\."
IF EXIST "%MT32_InstallFolder%..\MedtechCAT\." "%~dp0..\Tools\RoboCopy.exe" /E /R:1 /W:3 /NP "%MT32_InstallFolder%..\MedtechCAT\." "%MT32_BackupFolder%MedtechCAT\."
IF EXIST "%SystemDrive%\InetPub\."             "%~dp0..\Tools\RoboCopy.exe" /E /R:1 /W:3 /NP "%SystemDrive%\InetPub\."             "%MT32_BackupFolder%InetPub\."
IF EXIST "C:\ACCSend\."    "%~dp0..\Tools\RoboCopy.exe" /E /R:1 /W:3 /NP "C:\ACCSend\."    "%MT32_BackupFolder%C-ACCSend\."
IF EXIST "C:\HLINK\."      "%~dp0..\Tools\RoboCopy.exe" /E /R:1 /W:3 /NP "C:\HLINK\."      "%MT32_BackupFolder%C-HLINK\."
IF EXIST "C:\IDIOM\."      "%~dp0..\Tools\RoboCopy.exe" /E /R:1 /W:3 /NP "C:\IDIOM\."      "%MT32_BackupFolder%C-IDIOM\."
IF EXIST "C:\MedtechCAT\." "%~dp0..\Tools\RoboCopy.exe" /E /R:1 /W:3 /NP "C:\MedtechCAT\." "%MT32_BackupFolder%C-MedtechCAT\."
IF EXIST "C:\RESEARCH\."   "%~dp0..\Tools\RoboCopy.exe" /E /R:1 /W:3 /NP "C:\RESEARCH\."   "%MT32_BackupFolder%C-RESEARCH\."

ECHO [INFO ] -- Start Services
NET START %IB_ServiceGuardian%
NET START MedtechSS
IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True
GOTO DoEnd

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

