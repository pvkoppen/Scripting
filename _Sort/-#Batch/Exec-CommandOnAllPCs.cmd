@ECHO OFF
REM Name          : Exec-CommandOnAllPCs.cmd
REM Description   : Script used to Execute a command on all PC's in the domain.
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Must be run as: Administrator
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2011-10-05: 1.0: Initial setup
REM 2011-10-11: 1.0a: Added parametes for security.
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------
SET strCommand="M:\Fix-Medtech32Objects.cmd" /silent
SET strAccount=scmt\administrator
SET strPassword=S0uthC@r3
SET strAccount=avenue\Administrator
SET strPassword=@killahhill32

IF %1' == ' GOTO AreYouSure
IF %1' == /silent' GOTO Log
IF %1' == /Action' GOTO Action
IF %1' == /ProcessWS' GOTO ProcessWS
GOTO End

:GetDateTime
REM -----------------------------------------------------------------------
@FOR /F "tokens=1-9 delims=/ " %%A IN ('date /t') DO @FOR /F "tokens=1-9 delims=:. " %%a IN ('time /t') DO SET strDateTime=%%D%%C%%B[%%A]-%%c%%d%%a%%b&& SET strDate=%%D%%C%%B[%%A]&& SET strTime=%%c%%d%%a%%b
REM -----------------------------------------------------------------------
GOTO End

:PrintDateTime
ECHO -----------------------------------------------------------------------
@FOR /F "tokens=1-9 delims=/ " %%A IN ('date /t') DO @FOR /F "tokens=1-9 delims=:. " %%a IN ('time /t') DO ECHO -- DATE-TIME=%%D%%C%%B[%%A]-%%c%%d%%a%%b 
ECHO -----------------------------------------------------------------------
GOTO End

:AreYouSure
ECHO.
CHOICE /C YN /M "Are you sure you want to do command: '%~n0' on this server (%COMPUTERNAME%) ?"
IF %ERRORLEVEL% == 255 GOTO Error
IF %ERRORLEVEL% == 2 GOTO End
IF %ERRORLEVEL% == 1 GOTO Action
IF %ERRORLEVEL% == 0 GOTO Error
GOTO End

:Log
ECHO -- Start Logging
ECHO -----------------------------------------------------------------------
IF NOT EXIST "%~dp0LogFiles\." MKDIR "%~dp0LogFiles"
Move /Y "%~dp0LogFiles\%~n0.Log" "%~dp0LogFiles\%~n0.Old.Log"
Call %0 /Action >> "%~dp0LogFiles\%~n0.Log" 2>>&1
GOTO End

:Action
ECHO.
ECHO ---------------- Start: %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime
REM IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True

FOR /F %%A IN (%~dpn0.txt) DO CALL %0 /ProcessWS %%A
GOTO DoEnd

:ProcessWS
PING -w 10 %2
IF NOT %ERRORLEVEL%' == 0' GOTO ErrorPing
"%~dp0Tools\SysInternals\PSExec.exe" \\%2 -u %strAccount% -p %strPassword% -c %strCommand%
IF NOT %ERRORLEVEL%' == 0' GOTO ErrorPsExec
ECHO [INFO ] Success: %2
GOTO End

:DoEnd
REM Email the logbook to IT Services on Error.
REM -----------------------------------------------------------------------
IF %strSendEmail%' == True' CALL "%~dp0Tools\SendMail.cmd" "%~n0 (%COMPUTERNAME%)" "%~dp0LogFiles\%~n0.Log"
ECHO ---------------- End  : %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime
GOTO End

:ErrorPing
ECHO [ERROR] Failed - WS Offline: %2
GOTO End

:ErrorPsExec
ECHO [ERROR] Failed - Remote Execute: %2
GOTO End

:Error
ECHO [ERROR] Wrong Choice!
GOTO End

:Help
----------------------------------------------------
C:\Scripts\Tools\SysInternals>psexec @..\..\pc.txt -u scmt\itservices -p Nak1Ora54 -c M:\Fix-Medtech32Objects.cmd /silent
\\LAP01:
Couldn't access LAP01:
\\Physio:
Couldn't access Physio:
\\SCLAP00:
Couldn't access SCLAP00:
\\WS10:
[ERROR] The REGSRV32 process failed. You need Local Admin permissions.
Fix-Medtech32Objects.cmd exited on WS10 with error code 0.
\\WS11:
Couldn't access WS11:
\\WS13:
[ERROR] The REGSRV32 process failed. You need Local Admin permissions.
Fix-Medtech32Objects.cmd exited on WS13 with error code 0.
\\WS14:
[ERROR] The REGSRV32 process failed. You need Local Admin permissions.
Fix-Medtech32Objects.cmd exited on WS14 with error code 0.
\\WS16:
[ERROR] The REGSRV32 process failed. You need Local Admin permissions.
Fix-Medtech32Objects.cmd exited on WS16 with error code 0.
\\WS2:
[ERROR] The REGSRV32 process failed. You need Local Admin permissions.
Fix-Medtech32Objects.cmd exited on WS2 with error code 0.
\\WS25:
Couldn't access WS25:
Logon Failure: The target account name is incorrect.
\\WS26:
[ERROR] The REGSRV32 process failed. You need Local Admin permissions.
Fix-Medtech32Objects.cmd exited on WS26 with error code 0.
\\WS29:
[ERROR] The REGSRV32 process failed. You need Local Admin permissions.
Fix-Medtech32Objects.cmd exited on WS29 with error code 0.
\\WS32:
Couldn't access WS32:
Access is denied.
\\WS5:
[ERROR] The REGSRV32 process failed. You need Local Admin permissions.
Fix-Medtech32Objects.cmd exited on WS5 with error code 0.
GOTO End

:End
REM -----------------------------------------------------------------------

