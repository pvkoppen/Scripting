REM Activity      : Install VMWare Server v1.0.2
REM Created by    : Hone Rata
REM Company       : Tui Ora Limited
REM Date Created  : 25-05-2006
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

REM Make a drive mapping to the Altiris Resource Folder
REM -----------------------------------------------------------------
set USE_DRIVE=
for /d %%a in (M L K J I H G F) do if exist %%a:\_usr.lib\nul set USE_DRIVE=%%a:
if "%USE_DRIVE%" == "" for /d %%a in (M L K J I H G F) do if not exist %%a:\nul set USE_DRIVE=%%a:
if not exist %USE_DRIVE%\nul net use %USE_DRIVE% \\TOLDS01.tol.local\Express /User:Altiris alt1r1s /PERSISTENT:NO
if not "%ERRORLEVEL%" == "0" net use %USE_DRIVE% \\TOLDS01.tol.local\Express /PERSISTENT:NO

REM Locate the installation folder and run the Install(s)
REM -----------------------------------------------------------------
%USE_DRIVE%
cd "\_usr.lib\Software\VMWareServer_v1.0.2\VMware-server-installer-1.0.2-39867"
start /wait MSIExec /i "VMware Server Standalone.msi"    /qn ADDLOCAL=ALL REMOVE=DHCP,NAT SERIALNUMBER=90XMD-YU86J-17305-4VKC8 /Lv* C:\Altiris\LogFiles\VMWareStandaloneServer.log
REM start /wait MSIExec /i "VMware Server.msi"               /qn /Lv* C:\Altiris\LogFiles\VMWareServer.log
REM start /wait MSIExec /i "VMware Management Interface.msi" /qn /Lv* C:\Altiris\LogFiles\VMWareManagement.log
REM start /wait MSIExec /i "VMware VmCOM Scripting API.msi"  /qn /Lv* C:\Altiris\LogFiles\VMWareVmCOMScript.log
REM start /wait MSIExec /i "VMware VmPerl Scripting API.msi" /qn /Lv* C:\Altiris\LogFiles\VMWareVmPerlScript.log

REM Set this user session in Execute mode (For Terminal Servers Only)
REM -----------------------------------------------------------------

REM Make the server wait for a moment to finalize all installation processes.
REM -----------------------------------------------------------------
IF EXIST C:\Altiris\Tools\aWait.exe C:\Altiris\Tools\aWait.exe 30 "Waiting for 1/2 minute(s) to finalize Installs/Updates. Seconds remaining: %%d"

:END
for /f "tokens=*" %%a in ('date /t') do for /f "tokens=*" %%b in ('time /t') do echo DATE/TIME= %%a- %%b

