@ECHO OFF
REM Name          : Restart-TSServer.cmd
REM Description   : Terminal Server: Automated Weekly Restart.
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Must be run as: <No Preference: Administrators/LocalSystem>
REM Location      : C:\Admin\Scripts
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2006-08-15: Script for rebooting the Terminal server on a weekly basis to clean up cache.
REM 2008-06-15: Added sendmail.
REM 2008-06-30: Added this ChangeLOG.
REM 2008-11-12: Dual Boot. Run this script twice to clear properly.
REM 2008-12-09: Don't email log on First Run.
REM 2009-01-06: v1.5b: Fixed an error in the Date check function, and Added Quotes to file paths.
REM 2009-01-12: v1.5c: Fixed another error in the Date check function.
REM 2009-01-19: v1.5d: Removed the repeated wait messages from aWait.
REM 2009-01-19: v1.5e: Reversed FirstRun logic to start with it not being the first run until proven otherwise.
REM 2009-01-19: v1.5f: Removed the repeated wait messages from aWait (v2).
REM 2009-01-19: v1.5g: Removed the repeated wait messages from aWait (v3).
REM 2009-02-16: v1.6: Changed the email to only happen on error.
REM 2009-02-16: v1.6a: Changed the email to only happen on error.
REM 2009-07-20: v1.6b: Updated date&time format.
REM 2014-12-21: 2.0 New Structure
REM 2015-07-24 2.0a Implemented new structure
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------

IF %1' == /?' GOTO Help
IF %1' == /silent' GOTO Log
IF %1' == /Action' GOTO Action
GOTO AreYouSure

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

:AreYouSure
ECHO.
CHOICE /C YN /M "Are you sure you want to "%~n0" (on %COMPUTERNAME%)?"
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
REM Start Logging
REM -----------------------------------------------------------------
IF NOT EXIST "%~dp0..\LogFiles\." MKDIR "%~dp0..\LogFiles"
MOVE /Y "%~dp0..\LogFiles\%~n0.Log" "%~dp0..\LogFiles\%~n0.Old.Log"
CALL %0 /Action %2 >> "%~dp0..\LogFiles\%~n0.Log" 2>>&1
TYPE "%~dp0..\LogFiles\%~n0.Log" >> "%~dp0..\LogFiles\%~n0.History.Log"
GOTO End

:Action
ECHO.
ECHO ---------------- Start: %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime
REM IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True

:DoCheckNotFirstUse
REM Check if this is First Use today
REM -----------------------------------------------------------------
CALL %0 /GetDateTime
FOR /F %%A IN (%~dp0..\LogFiles\%~n0.Date) DO FOR %%B IN (%strDate%) DO IF %%A' == %%B' SET strSendEmail=True
ECHO %strDate% > "%~dp0..\LogFiles\%~n0.Date"

:DoStopSessions
REM Log off all RDP sessions.
REM -----------------------------------------------------------------
ECHO y | "%SystemRoot%\System32\logoff.exe" RDP-tcp
IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True
IF EXIST "%~dp0..\Tools\aWait.exe" "%~dp0..\Tools\aWait.exe" 30 "Waiting for 1/2 minute(s) for RDP sessions to close. Seconds remaining: %%d." >nul

:DoProfiles
REM Remove all the Roaming Profiles
REM -----------------------------------------------------------------
REM DELPROF.EXE: Message: Delete inactive profiles on \\<ServerName>? (Yes/No)
IF NOT EXIST "C:\Program Files\Windows Resource Kits\Tools\DelProf.exe" GOTO DoPrinters
ECHO Y|"C:\Program Files\Windows Resource Kits\Tools\DelProf.exe" /q /i /r
IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True
DIR /a "%ALLUSERSPROFILE%\.."
IF EXIST "%~dp0..\Tools\aWait.exe" "%~dp0..\Tools\aWait.exe" 30 "Waiting for 1/2 minute(s) for profiles to be deleted. Seconds remaining: %%d." >nul

:DoPrinters
REM Stop the Spooler and remove all defined printers
REM -----------------------------------------------------------------
"%SystemRoot%\System32\Net.exe" stop Spooler
del /q "%systemroot%\system32\spool\printers\*.*"
IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True
IF EXIST "%~dp0..\Tools\aWait.exe" "%~dp0..\Tools\aWait.exe" 30 "Waiting for 1/2 minute(s) for printer definitions to be deleted. Seconds remaining: %%d." >nul

:DoMedTech
REM Backup Medtech Database and shutdown Interbase
REM -----------------------------------------------------------------
REM IF EXIST D:\Medtech\MT32\. CALL "%~dp0Medtech-Backup.cmd"
IF EXIST D:\Medtech\MT32\. NET STOP InterBaseServer
IF EXIST "%~dp0..\Tools\aWait.exe" "%~dp0..\Tools\aWait.exe" 30 "Waiting for 1/2 minute(s) for Interbase to shut down. Seconds remaining: %%d." >nul

:DoAutoLogon
REM Set AutoLogon Settings
REM -----------------------------------------------------------------
REM -- Make sure that the registry SubKey can only be read by Administrators and SYSTEM.
REM Windows Registry Editor Version 5.00
REM 
REM [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon]
REM "DefaultDomainName"="<Domainname>"
REM "DefaultUserName"="<Username>"
REM "DefaultPassword"="<Password>"
REM "LegalNoticeCaption"=""
REM "LegalNoticeText"=""
REM "AutoAdminLogon"="1"
REM "NOT-ForceAutoLogon"="1"
REM "NOT-AutoLogonCount"=dword:00000001
REM -----------------------------------------------------------------

:DoRestart
REM Now perform a restart to start up clean again.
REM -----------------------------------------------------------------
"%SystemRoot%\System32\Shutdown.exe" /f /r /t 30 /c "Scheduled Restart of Terminal Server to clear cache by batch: %~f0"
IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True
ECHO [INFO ] Completed.
GOTO DoEnd

:DoEnd
REM Email the logbook to IT Services on Error.
REM -----------------------------------------------------------------------
IF %strSendEmail%' == True' CALL "%~dp0..\Tools\SendMail.cmd" "%~n0 (%COMPUTERNAME%) - Completed with Errors" "%~dp0..\LogFiles\%~n0.Log"
REM IF NOT %strSendEmail%' == True' CALL "%~dp0..\Tools\SendMail.cmd" "%~n0 (%COMPUTERNAME%) - Completed Succesfully" "%~dp0..\LogFiles\%~n0.Log"
ECHO ---------------- End  : %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime
GOTO End

:Error
ECHO [ERROR] Error detected! [%ERRORLEVEL%]
ECHO [ERROR] Full Internal Server DNS name = %COMPUTERNAME%.%USERDNSDOMAIN%
GOTO End

:ErrorParam
ECHO Invalid Parameter 1: %*
GOTO End

:End
REM -----------------------------------------------------------------------

