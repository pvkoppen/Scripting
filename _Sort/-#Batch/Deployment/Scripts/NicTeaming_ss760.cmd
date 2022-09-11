REM Activity      : Compaq/HP NIC Teaming Script (The cqniccfg.cmd in installed in %SystemRoot%\System32).
REM Created by    : Peter van Koppen
REM Company       : Tui Ora Limited
REM Date Created  : 2006-11-27
REM Must be run as: A (Local) Administrator (Not LOCALSYSTEM)
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
REM Code to start this batch locally.
REM -----------------------------------------------------------------
if %2' == ' goto StartLocal
goto run

:StartLocal
REM Here we start this script that has been copied to the local server.
REM -----------------------------------------------------------------
c:\CPQSystem\NicTeaming_ss760.cmd %1 run
goto end
REM --------------------------------

:run
REM x64 SYstems: COpy the two required files from 
REM %SystemRoot%\SysWOW64 to %SystemRoot%\System32.
REM ------------------------------------------------------
rem copy \\localhost\admin$\System32\cqniccfg.cmd %SystemRoot%\System32\*.*
rem copy \\localhost\admin$\System32\Shutdown.exe %SystemRoot%\System32\*.*

REM Stop the DHCP Client to prevent the Preserved Address to be screwed up(BAD_ADDRESS).
REM ------------------------------------------------------
net stop "WinHTTP Web Proxy Auto-Discovery Service"
net stop "DHCP Client"
for %%a in (c:\CPQSystem\teamcfg-*.xml) do CALL %SystemRoot%\System32\cqniccfg.cmd /c %%a
if %ERRORLEVEL%==1 goto success
if %ERRORLEVEL%==0 goto success
goto exit

:success
set %ERRORLEVEL%=0
goto exit

:failure
echo failed
set %ERRORLEVEL%=0
rem  EXIT 1
goto exit

:exit

REM Make the server wait for a moment to finalize all installation processes.
REM -----------------------------------------------------------------
IF EXIST C:\Altiris\Tools\aWait.exe C:\Altiris\Tools\aWait.exe 30 "Waiting for 1/2 minute(s) to finalize Installs/Updates. Seconds remaining: %%d"
%SystemRoot%\System32\Shutdown.exe /r /d p:2:4 /c "Altiris: Automated Reboot after NIC Teaming." 
ECHO Now
set

:END
for /f "tokens=*" %%a in ('date /t') do for /f "tokens=*" %%b in ('time /t') do echo DATE/TIME= %%a- %%b

