@ECHO OFF
REM Name          : Set-ADUserProfileSettings.cmd
REM Description   : Script used to ...
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Must be run as: <No Preference: Administrators/LocalSystem>
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2009-05-11: v1.0: First edition.
REM 2012-10-16: 2.0: Updated and Dynamic for Devon.
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------
SET strProfileServer=DMCSBS01
SET strProfileRoot=Users\

IF %1' == /silent' GOTO Log
IF %1' == /Action' GOTO Action
IF %1' == /ProcessUser' GOTO ProcessUser
GOTO AreYouSure

:GetDateTime
REM -----------------------------------------------------------------------
@FOR /F "tokens=1-9 delims=/ " %%A IN ('date /t') DO @FOR /F "tokens=1-9 delims=:. " %%a IN ('time /t') DO SET strDateTime=%%D%%C%%B[%%A]-%%c%%d%%a%%b&& SET strDate=%%D%%C%%B[%%A]&& SET strTime=%%c%%d%%a%%b
REM -----------------------------------------------------------------------
GOTO End

:PrintDateTime
REM -----------------------------------------------------------------------
ECHO -----------------------------------------------------------------------
@FOR /F "tokens=1-9 delims=/ " %%A IN ('date /t') DO @FOR /F "tokens=1-9 delims=:. " %%a IN ('time /t') DO ECHO -- DATE-TIME=%%D%%C%%B[%%A]-%%c%%d%%a%%b 
ECHO -----------------------------------------------------------------------
GOTO End

:AreYouSure
ECHO.
CHOICE /C YN /M "Are you sure you want to: %~n0 (%COMPUTERNAME%) ?"
IF %ERRORLEVEL% == 255 GOTO Error
IF %ERRORLEVEL% == 2 GOTO End
IF %ERRORLEVEL% == 1 GOTO Action
IF %ERRORLEVEL% == 0 GOTO Error
GOTO End

:Log
REM Start Logging
REM -----------------------------------------------------------------
IF NOT EXIST "%~dp0LogFiles\." MKDIR "%~dp0LogFiles"
MOVE /Y "%~dp0LogFiles\%~n0.Log" "%~dp0LogFiles\%~n0.Old.Log"
CALL %0 /Action >> "%~dp0LogFiles\%~n0.Log" 2>>&1
TYPE "%~dp0LogFiles\%~n0.Log" >> "%~dp0LogFiles\%~n0.History.Log"
GOTO End

:Action
ECHO.
ECHO ---------------- Start: %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime
REM IF %ERRORLEVEL%' == 0' SET strSendEmail=True

dsquery user | dsget user -samid | find /i /v "svc" | find /i /v "admin" | find /v "_" | find /i /v "guest" | find /i /v "krbtgt" | find /i /v "test" > "%~dp0LogFiles\%~n0.tmp"
start /wait notepad "%~dp0LogFiles\%~n0.tmp"
for /f %%a in (%~dp0LogFiles\%~n0.tmp) do Call %0 /ProcessUser %%a
GOTO DoEnd

:ProcessUser
ECHO ------------------------------------------------------
dsquery user -samid %2 | dsmod user -profile \\%strProfileServer%\%strProfileRoot%%2\Profile
IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True
%~dp0Tools\SystemTools\tscmd.exe localhost %2 TerminalServerProfilePath \\%strProfileServer%\%strProfileRoot%%2\TSProfile
IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True
GOTO End

:DoEnd
REM Email the logbook to IT Services on Error.
REM -----------------------------------------------------------------------
IF %strSendEmail%' == True' CALL "%~dp0Tools\SendMail.cmd" "%~n0 (%COMPUTERNAME%)" "%~dp0LogFiles\%~n0.Log"
ECHO ---------------- End  : %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime
GOTO End

:Error
ECHO Error detected!
GOTO End

:End
REM -----------------------------------------------------------------------

