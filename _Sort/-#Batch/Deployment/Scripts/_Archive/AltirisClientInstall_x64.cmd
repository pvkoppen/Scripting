REM Activity      : Install the Altiris Client.
REM Created by    : Peter van Koppen
REM Company       : Tui Ora Limited
REM Date Created  : 2006-11-27
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
REM Make a drive mapping to the Altiris Resource Folder
REM -----------------------------------------------------------------
set USE_DRIVE=
for /d %%a in (M L K J I H G F) do if exist %%a:\_usr.lib\nul set USE_DRIVE=%%a:
if "%USE_DRIVE%" == "" for /d %%a in (M L K J I H G F) do if not exist %%a:\nul set USE_DRIVE=%%a:
if not exist %USE_DRIVE%\nul net use %USE_DRIVE% \\TOLDS01.tuiora.local\Express /User:Altiris alt1r1s /PERSISTENT:NO
if not "%ERRORLEVEL%" == "0" net use %USE_DRIVE% \\TOLDS01.tuiora.local\Express /PERSISTENT:NO

REM Locate the installation folder and run the Install(s)
REM -----------------------------------------------------------------
%USE_DRIVE%
cd "\lib\bin32\WinPE"
set configfile=5000013.inp

REM error checking
if "%configfile%" == "" ECHO ConfigFile set parameter not set!
if not exist %USE_DRIVE%\lib\osoem\altiris\%configfile% ECHO ConfigFile (%ConfigFile%) does not exist!

REM delete preexisting agent configuration file
del c:\aclient.cfg

REM make directory
mkdir c:\$oem$
mkdir c:\$oem$\aclient

REM copy agent configuration file
copy %USE_DRIVE%\lib\osoem\altiris\%configfile% c:\$oem$\aclient\aclient.inp /y

REM copy agent binary
REM copy %USE_DRIVE%\aclient.exe c:\$oem$\aclient\aclient.exe /y
copy %USE_DRIVE%\lib\osoem\altiris.x64\aclient.exe c:\$oem$\aclient\aclient.exe /y

REM copy wlogevent.exe
copy %USE_DRIVE%\wlogevent.exe c:\$oem$\aclient\wlogevent.exe /y

REM copy sidgen.exe
copy %USE_DRIVE%\sidgen.exe c:\$oem$\aclient\sidgen.exe /y

REM copy post-oem script
copy %USE_DRIVE%\lib\osoem\altiris\postoem.cmd c:\$oem$\aclient\postoem.cmd /y

REM hookup post-oem script
echo call c:\$oem$\aclient\postoem.cmd>>c:\$oem$\runonce.cmd

START /wait call c:\$oem$\runonce.cmd

REM Make the server wait for a moment to finalize all installation processes.
REM -----------------------------------------------------------------
IF EXIST C:\Altiris\Tools\aWait.exe C:\Altiris\Tools\aWait.exe 30 "Waiting for 1/2 minute(s) to finalize Installs/Updates. Seconds remaining: %%d"

:END
for /f "tokens=*" %%a in ('date /t') do for /f "tokens=*" %%b in ('time /t') do echo DATE/TIME= %%a- %%b

