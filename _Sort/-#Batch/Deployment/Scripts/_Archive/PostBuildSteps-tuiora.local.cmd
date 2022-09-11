REM Activity      : Post Build Steps (TUIORA.LOCAL)
REM Created by    : Peter van Koppen
REM Company       : Tui Ora Limited
REM Date Created  : 2006-08-08
REM Date Changed  : 2006-09-27 ("tuiora\Terminal Server Users" ipv Tuiora\TerminalServerUsers)
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

REM Predefine the External Groups.
REM -----------------------------------------------------------------
set GRP-DomainAdmins="CN=Domain Admins,CN=Users,DC=TUIORA,DC=LOCAL"

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

REM Add the user GPAdmin
REM -----------------------------------------------------------------
NET USER GPAdmin GPadm1n. /ADD /ACTIVE:yes /COMMENT:"Group Policy Administrator Account" /EXPIRES:NEVER /FULLNAME:"Group Policy Administrator" 

REM Make GPAdmin a member of the right groups
REM -----------------------------------------------------------------
NET LOCALGROUP Users GPAdmin /DELETE
NET LOCALGROUP Administrators GPAdmin /ADD

REM Copy the Group Policy files from Altiris to Local Machine
REM -----------------------------------------------------------------
%USE_DRIVE%
cd "\_usr.lib\Configs\TS\GroupPolicy"
XCOPY /s /e /y %USE_DRIVE%*.* %SYSTEMROOT%\System32\GroupPolicy\

REM Set rights for the %SystemRoot%\system32\GroupPolicy folder
REM -----------------------------------------------------------------
:: Add allow full: GPAdmin
:: add deny full: administator
:: add deny full: "TuiOra\domain admins"
:: replace rights on all child folders
C:\Altiris\Tools\xcacls.exe %SystemRoot%\system32\GroupPolicy /y /c /t /G GPAdmin:F 
C:\Altiris\Tools\xcacls.exe %SystemRoot%\system32\GroupPolicy /y /c /t /D Administrator:F
CALL C:\Altiris\Tools\GetDomGRPSID.cmd %GRP-DomainAdmins%
C:\Altiris\Tools\SetACL.exe %SystemRoot%\system32\GroupPolicy /dir /deny %GRPSID% /full /p:yes /sid

REM As administrator run: gpupdate /force
REM -----------------------------------------------------------------
gpupdate /force

REM Add group: TuiOra\Terminal Server Users to Terminal Services (Guest and USer access)
REM -----------------------------------------------------------------
NET LOCALGROUP "Remote Desktop Users" "TuiOra\Terminal Server Users" /ADD

REM Set this user session in Execute mode (For Terminal Servers Only)
REM -----------------------------------------------------------------
"%SystemRoot%\System32\change.exe" user /execute

REM Make the server wait for a moment to finalize all installation processes.
REM -----------------------------------------------------------------
IF EXIST C:\Altiris\Tools\aWait.exe C:\Altiris\Tools\aWait.exe 30 "Waiting for 1/2 minute(s) to finalize Installs/Updates. Seconds remaining: %%d"

:END
for /f "tokens=*" %%a in ('date /t') do for /f "tokens=*" %%b in ('time /t') do echo DATE/TIME= %%a- %%b

