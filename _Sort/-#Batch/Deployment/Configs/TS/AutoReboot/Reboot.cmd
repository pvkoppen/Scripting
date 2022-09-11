REM -----------------------------------------------------------------
REM Name          : reboot.cmd
REM Description   : Terminal Server: Automated Weekly Restart.
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Version       : 1.3
REM Must be run as: <No Preference: Administrators/LocalSystem>
REM -----------------------------------------------------------------

REM -----------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------
REM 2006-08-15: Script for rebooting the Terminal server on a weekly basis to clean up cache.
REM 2008-06-15: Added sendmail.
REM 2008-06-30: Added this ChangeLOG.
REM 2008-11-12: Dual Boot. Run this script twice to clear properly.
REM -----------------------------------------------------------------

if %1' == ' GOTO RestartBatchWithLogging
GOTO ProcessBatch

:RestartBatchWithLogging
IF NOT EXIST C:\Altiris\nul MD C:\Altiris
IF NOT EXIST C:\Altiris\LogFiles\nul MD C:\Altiris\LogFiles
ECHO ---------------- Start: %0 on %ComputerName% ---------------- > C:\Altiris\LogFiles\TerminalServer-AutomatedWeeklyRestart.LOG
@for /f "delims=#" %%a in ('date /t') do @for /f "delims=#" %%b in ('time /t') do echo DATE/TIME= %%a- %%b >> C:\Altiris\LogFiles\TerminalServer-AutomatedWeeklyRestart.LOG 2>>&1
%0 ProcessBatch   >> C:\Altiris\LogFiles\TerminalServer-AutomatedWeeklyRestart.LOG 2>>&1
ECHO ---------------- End  : %0 on %ComputerName% ---------------- >> C:\Altiris\LogFiles\TerminalServer-AutomatedWeeklyRestart.LOG
GOTO End

:ProcessBatch
REM Log off all RDP sessions.
REM -----------------------------------------------------------------
ECHO y | %SystemRoot%\System32\logoff.exe RDP-tcp
IF EXIST C:\Altiris\Tools\aWait.exe C:\Altiris\Tools\aWait.exe 30 "Waiting for 1/2 minute(s) for RDP sessions to close. Seconds remaining: %%d." >nul

REM Remove all the Roaming Profiles
REM -----------------------------------------------------------------
REM DELPROF.EXE: Message: Delete inactive profiles on \\<ServerName>? (Yes/No)
ECHO Y|"C:\Program Files\Windows Resource Kits\Tools\DelProf.exe" /q /i /r
DIR /a "%ALLUSERSPROFILE%\.."
IF EXIST C:\Altiris\Tools\aWait.exe C:\Altiris\Tools\aWait.exe 30 "Waiting for 1/2 minute(s) for profiles to be deleted. Seconds remaining: %%d." >nul

REM Stop the Spooler and remove all defined printers
REM -----------------------------------------------------------------
%SystemRoot%\System32\Net.exe stop Spooler
del /q %systemroot%\system32\spool\printers\*.*
IF EXIST C:\Altiris\Tools\aWait.exe C:\Altiris\Tools\aWait.exe 30 "Waiting for 1/2 minute(s) for printer definitions to be deleted. Seconds remaining: %%d." >nul

REM Backup Medtech Database and shutdown Interbase
REM -----------------------------------------------------------------
REM IF EXIST D:\MT32\Script\MT32-Backup.cmd CALL D:\MT32\Script\MT32-Backup.cmd
IF EXIST D:\MT32\. NET STOP InterBaseServer
IF EXIST C:\Altiris\Tools\aWait.exe C:\Altiris\Tools\aWait.exe 30 "Waiting for 1/2 minute(s) for Interbase to shut down. Seconds remaining: %%d." >nul

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
REM "NOT-NOT-ForceAutoLogon"="1"
REM "NOT-AutoLogonCount"=dword:00000001
REM -----------------------------------------------------------------

REM Now perform a restart to start up clean again.
REM -----------------------------------------------------------------
%SystemRoot%\System32\Shutdown.exe /r /f /t 30 /d p:0:0 /c "%0: Weekly Restart of Terminal Server to clear cache."
ECHO ERRORLEVEL: %ERRORLEVEL%
ECHO -----------------------------------------------------------------

REM Email this logbook to IT Services
REM -----------------------------------------------------------------
CALL C:\Altiris\Tools\sendmail.cmd "Weekly Reboot (%COMPUTERNAME%)" C:\Altiris\LogFiles\TerminalServer-AutomatedWeeklyRestart.LOG
GOTO end

:end
@for /f "delims=#" %%a in ('date /t') do @for /f "delims=#" %%b in ('time /t') do echo DATE/TIME= %%a- %%b

