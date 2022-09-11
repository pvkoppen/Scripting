@ECHO OFF
REM Name          : Restart-TSServer.cmd
REM Description   : Terminal Server: Automated Weekly Restart.
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Version       : 1.6b
REM Must be run as: <No Preference: Administrators/LocalSystem>
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
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------

IF %1' == ' GOTO Log
IF %1' == /Action' GOTO Action
IF %1' == /GetDateTime' GOTO GetDateTime
IF %1' == /PrintDateTime' GOTO PrintDateTime
GOTO End

:GetDateTime
REM -----------------------------------------------------------------------
@FOR /F "tokens=1-9 delims=/ " %%A IN ('date /t') DO @FOR /F "tokens=1-9 delims=:. " %%a IN ('time /t') DO SET strDateTime=%%D%%C%%B[%%A]-%%c%%d%%a%%b && SET strDate=%%D%%C%%B[%%A] && SET strTime=%%c%%d%%a%%b 
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
REM IF %ERRORLEVEL%' == 0' SET strSendEmail=True

:DoCheckNotFirstUse
REM Check if this is First Use today
REM -----------------------------------------------------------------
CALL %0 /GetDateTime
FOR /F %%A IN (%~dp0LogFiles\%~n0.Date) DO FOR %%B IN (%strDate%) DO IF %%A' == %%B' SET strSendEmail=True
ECHO %strDate% > "%~dp0LogFiles\%~n0.Date"

:DoStopSessions
REM Log off all RDP sessions.
REM -----------------------------------------------------------------
ECHO y | "%SystemRoot%\System32\logoff.exe" RDP-tcp
IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True
IF EXIST "%~dp0Tools\aWait.exe" "%~dp0Tools\aWait.exe" 30 "Waiting for 1/2 minute(s) for RDP sessions to close. Seconds remaining: %%d." >nul

:DoProfiles
REM Remove all the Roaming Profiles
REM -----------------------------------------------------------------
REM DELPROF.EXE: Message: Delete inactive profiles on \\<ServerName>? (Yes/No)
IF NOT EXIST "C:\Program Files\Windows Resource Kits\Tools\DelProf.exe" GOTO DoPrinters
ECHO Y|"C:\Program Files\Windows Resource Kits\Tools\DelProf.exe" /q /i /r
IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True
DIR /a "%ALLUSERSPROFILE%\.."
IF EXIST "%~dp0Tools\aWait.exe" "%~dp0Tools\aWait.exe" 30 "Waiting for 1/2 minute(s) for profiles to be deleted. Seconds remaining: %%d." >nul

:DoPrinters
REM Stop the Spooler and remove all defined printers
REM -----------------------------------------------------------------
"%SystemRoot%\System32\Net.exe" stop Spooler
del /q "%systemroot%\system32\spool\printers\*.*"
IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True
IF EXIST "%~dp0Tools\aWait.exe" "%~dp0Tools\aWait.exe" 30 "Waiting for 1/2 minute(s) for printer definitions to be deleted. Seconds remaining: %%d." >nul

:DoMedTech
REM Backup Medtech Database and shutdown Interbase
REM -----------------------------------------------------------------
REM IF EXIST D:\Medtech\MT32\. CALL "%~dp0Medtech-Backup.cmd"
IF EXIST D:\Medtech\MT32\. NET STOP InterBaseServer
IF EXIST "%~dp0Tools\aWait.exe" "%~dp0Tools\aWait.exe" 30 "Waiting for 1/2 minute(s) for Interbase to shut down. Seconds remaining: %%d." >nul

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
"%SystemRoot%\System32\Shutdown.exe" /r /f /t 30 /d p:0:0 /c "%0: Weekly Restart of Terminal Server to clear cache."
IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True
ECHO ERRORLEVEL: %ERRORLEVEL%
ECHO -----------------------------------------------------------------

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

