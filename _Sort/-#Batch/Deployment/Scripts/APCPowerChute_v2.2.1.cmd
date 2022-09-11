REM Activity      : Install APC PowerChute Network Shutdown
REM Created by    : Peter van Koppen
REM Company       : Tui Ora Limited
REM Date Created  : 2006-08-08
REM Must be run as: An Administrator (Not LocalSystem)
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
"%SystemRoot%\System32\change.exe" user /install

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
cd "\_usr.lib\Software\APCPowerChute_v2.2.1"
start /wait pcns221win.exe -q "%USE_DRIVE%\_usr.lib\Software\APCPowerChute_v2.2.1\silentInstall.ini"

IF EXIST C:\Altiris\Tools\aWait.exe C:\Altiris\Tools\aWait.exe 300 "Waiting for 5 minute(s) to finalize Installs/Updates. Seconds remaining: %%d"
CALL C:\Altiris\Tools\Sendmail.cmd "Altiris: Check the APC Powerchute website on: http://%ComputerName%:3052"

goto PastComment
REM This section represents the parameters for the Setup package.
REM -----------------------------------------------------------------
C:\pcinstall\pcns221win.exe -q "C:\Program Files\InstallDir\silentInstall.ini"
C:\pcinstall\pcns221win.exe -q C:\InstallDir\silentInstall.ini
REM -----------------------------------------------------------------
REM For an installation on an IA-64 processor machine:
REM on a Windows machine running Windows Server 2003, Enterprise Edition:
REM -----------------------------------------------------------------
[#JavaHomeDir]/java -cp .;pcns221win64.jar;util.jar load -q C:\tmp\pcns22\silentInstall.ini
REM -----------------------------------------------------------------
:PastComment 

REM Set this user session in Execute mode (For Terminal Servers Only)
REM -----------------------------------------------------------------
"%SystemRoot%\System32\change.exe" user /execute

REM Make the server wait for a moment to finalize all installation processes.
REM -----------------------------------------------------------------
IF EXIST C:\Altiris\Tools\aWait.exe C:\Altiris\Tools\aWait.exe 30 "Waiting for 1/2 minute(s) to finalize Installs/Updates. Seconds remaining: %%d"

:END
for /f "tokens=*" %%a in ('date /t') do for /f "tokens=*" %%b in ('time /t') do echo DATE/TIME= %%a- %%b

