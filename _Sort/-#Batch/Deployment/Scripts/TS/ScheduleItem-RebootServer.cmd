REM Activity      : ScheduleTask: Automatic Weekly Reboot.
REM Created by    : Peter van Koppen
REM Company       : Tui Ora Limited
REM Date Created  : 2006-08-08
REM Must be run as: <No Preference: Administrators/LocalSystem>
REM -----------------------------------------------------------------
IF EXIST C:\Altiris\Tools\WhoAmI.exe C:\Altiris\Tools\WhoAmI.exe
IF NOT "%ERRORLEVEL%" == "0"         ECHO Username=%UserName%
for /f "tokens=*" %%a in ('date /t') do for /f "tokens=*" %%b in ('time /t') do echo DATE/TIME= %%a- %%b

if %1' == ' GOTO RestartBatchWithLogging
goto ProcessBatch

:RestartBatchWithLogging
IF NOT EXIST C:\Altiris\nul MD C:\Altiris
IF NOT EXIST C:\Altiris\LogFiles\nul MD C:\Altiris\LogFiles
ECHO ---------------- Start: %0 ---------------- >> C:\Altiris\LogFiles\AltirisAutomatedBuildProcess.LOG
CALL %0 ProcessBatch   >>C:\Altiris\LogFiles\AltirisAutomatedBuildProcess.LOG 2>>&1
ECHO ---------------- End  : %0 ---------------- >> C:\Altiris\LogFiles\AltirisAutomatedBuildProcess.LOG
GOTO End

:ProcessBatch
REM Set this user session in Install mode (For Terminal Servers Only)
REM -----------------------------------------------------------------

REM Locate the installation folder and run the Install(s)
REM -----------------------------------------------------------------
schtasks /create /RU "SYSTEM" /SC WEEKLY /MO 1 /D SUN /TN "Altiris TS Build - Automated Weekly Reboot" /TR "C:\Altiris\TS\Reboot.cmd" /ST 03:01:00
rem schtasks /create /RU "SYSTEM" /SC WEEKLY /MO 1 /D SUN /TN "_TOL Restart-TSServer - Step1" /TR "C:\Scripts\Restart-TSServer.cmd" /ST 03:01:00
rem schtasks /create /RU "SYSTEM" /SC WEEKLY /MO 1 /D SUN /TN "_TOL Restart-TSServer - Step2" /TR "C:\Scripts\Restart-TSServer.cmd" /ST 03:15:00

REM Set this user session in Execute mode (For Terminal Servers Only)
REM -----------------------------------------------------------------

REM Make the server wait for a moment to finalize all installation processes.
REM -----------------------------------------------------------------
IF EXIST C:\Altiris\Tools\aWait.exe C:\Altiris\Tools\aWait.exe 30 "Waiting for 1/2 minute(s) to finalize Installs/Updates. Seconds remaining: %%d"

:END
for /f "tokens=*" %%a in ('date /t') do for /f "tokens=*" %%b in ('time /t') do echo DATE/TIME= %%a- %%b

