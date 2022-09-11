REM Activity      : Windows Server 2003 Hotfixes script.
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
cd "\_usr.lib\Utilities\Patches\W52_32"
set PATHTO=%USE_DRIVE%\_usr.lib\Utilities\Patches\W52_32

REM Install the hotfixes
REM -----------------------------------------------------------------
start /wait %PATHTO%\WindowsServer2003-KB819696-x86-ENU.exe /Z /U
start /wait %PATHTO%\WindowsServer2003-KB823182-x86-ENU.exe /Z /U
start /wait %PATHTO%\WindowsServer2003-KB823559-x86-ENU.exe /Z /U
start /wait %PATHTO%\WindowsServer2003-KB824105-x86-ENU.exe /Z /U
start /wait %PATHTO%\WindowsServer2003-KB824141-x86-ENU.exe /Z /U
start /wait %PATHTO%\WindowsServer2003-KB825119-x86-ENU.exe /Z /U
start /wait %PATHTO%\WindowsServer2003-KB828035-x86-ENU.exe /Z /U
start /wait %PATHTO%\WindowsServer2003-KB828741-x86-ENU.EXE /Z /U
start /wait %PATHTO%\WindowsServer2003-KB832894-x86-ENU.EXE /Z /U
start /wait %PATHTO%\WindowsServer2003-KB835732-x86-ENU.EXE /Z /U
start /wait %PATHTO%\WindowsServer2003-KB837001-x86-ENU.EXE /Z /U
start /wait %PATHTO%\WindowsServer2003-KB839643-x86-ENU.EXE /Z /U
start /wait %PATHTO%\WindowsServer2003-KB840374-x86-ENU.EXE /Z /U
start /wait %PATHTO%\WindowsServer2003-KB828750-x86-ENU.EXE /Z /U

start /wait %PATHTO%\ENU_Q832483_MDAC_X86.EXE /C:"dahotfix.exe /q /n" /q:a
start /wait %PATHTO%\WindowsMedia9-KB819639-x86-ENU.exe /Z /U

REM Make the server wait for a moment to finalize all installation processes.
REM -----------------------------------------------------------------
IF EXIST C:\Altiris\Tools\aWait.exe C:\Altiris\Tools\aWait.exe 30 "Waiting for 1/2 minute(s) to finalize Installs/Updates. Seconds remaining: %%d"

:END
for /f "tokens=*" %%a in ('date /t') do for /f "tokens=*" %%b in ('time /t') do echo DATE/TIME= %%a- %%b

