REM Activity      : Cleanup Desktop and Start menu Items
REM Created by    : Peter van Koppen
REM Company       : Tui Ora Limited
REM Date Created  : 2007-03-28
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

REM Cleanup Shortcuts: Administrator
REM -----------------------------------------------------------------
%SystemDrive%
CD "%ALLUSERSPROFILE%\.."
dir /ad /b |find /v "Service"|find /v "User" > %~nx0.txt
type %~nx0.txt
for /f %%A in (%~nx0.txt) DO xcopy /s /y "%%A\Desktop\*.*" "All Users\Desktop\" && del /s /q "%%A\Desktop\*.*"

for /f %%A in (%~nx0.txt) DO xcopy /s /y "%%A\Start Menu\Programs\*Backup Exec*"   "All Users\Start Menu\Programs\" && del /s /q "%%A\Start Menu\Programs\*Backup Exec*"
for /f %%A in (%~nx0.txt) DO xcopy /s /y "%%A\Start Menu\Programs\*Mcafee*"        "All Users\Start Menu\Programs\" && del /s /q "%%A\Start Menu\Programs\*Mcafee*"
for /f %%A in (%~nx0.txt) DO xcopy /s /y "%%A\Start Menu\Programs\*Network Ass*"   "All Users\Start Menu\Programs\" && del /s /q "%%A\Start Menu\Programs\*Network Ass*"
for /f %%A in (%~nx0.txt) DO xcopy /s /y "%%A\Start Menu\Programs\*PowerChute*"    "All Users\Start Menu\Programs\" && del /s /q "%%A\Start Menu\Programs\*PowerChute*.*"
for /f %%A in (%~nx0.txt) DO xcopy /s /y "%%A\Start Menu\Programs\*Windows*Tools*" "All Users\Start Menu\Programs\" && del /s /q "%%A\Start Menu\Programs\*Windows*Tools*"
del %~nx0.txt

REM Set this user session in Execute mode (For Terminal Servers Only)
REM -----------------------------------------------------------------

REM Make the server wait for a moment to finalize all installation processes.
REM -----------------------------------------------------------------
IF EXIST C:\Altiris\Tools\aWait.exe C:\Altiris\Tools\aWait.exe 30 "Waiting for 1/2 minute(s) to finalize Installs/Updates. Seconds remaining: %%d"

:END
for /f "tokens=*" %%a in ('date /t') do for /f "tokens=*" %%b in ('time /t') do echo DATE/TIME= %%a- %%b

