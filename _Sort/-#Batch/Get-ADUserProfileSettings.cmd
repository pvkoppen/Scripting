@ECHO OFF
REM Name          : Get-ADUserProfileSettings.cmd
REM Description   : Script used to ...
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Must be run as: <No Preference: Administrators/LocalSystem>
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2009-05-11: v1.0: First edition.
REM 2009-01-04: Version 1.1
REM 2012-10-16: 2.0: Updated and Dynamic for Devon.
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------
SET strProfileServer=DMCSBS01
SET strProfileRoot=\Users\

IF %1' == ' GOTO Action
GOTO ProcessUser

:GetDateTime
REM -----------------------------------------------------------------------
@FOR /F "tokens=1-9 delims=/ " %%A IN ('date /t') DO @FOR /F "tokens=1-9 delims=:. " %%a IN ('time /t') DO SET strDateTime=%%D%%C%%B[%%A]-%%c%%d%%a%%b && SET strDate=%%D%%C%%B[%%A] && SET strTime=%%c%%d%%a%%b 
REM -----------------------------------------------------------------------
GOTO End

:PrintDateTime
REM -----------------------------------------------------------------------
ECHO -----------------------------------------------------------------------
@FOR /F "tokens=1-9 delims=/ " %%A IN ('date /t') DO @FOR /F "tokens=1-9 delims=:. " %%a IN ('time /t') DO ECHO -- DATE-TIME=%%D%%C%%B[%%A]-%%c%%d%%a%%b 
ECHO -----------------------------------------------------------------------
GOTO End

:Action
ECHO.
ECHO ---------------- Start: %~dpnx0 on %ComputerName% ----------------
CALL %0 /PrintDateTime
REM IF %ERRORLEVEL%' == 0' SET strSendEmail=True

dsquery user | dsget user -samid > "%~dp0LogFiles\%~n0.tmp"
start /wait notepad "%~dp0LogFiles\%~n0.tmp"
ECHO. > "%~dp0LogFiles\%~n0.log"
for /f %%a in (%~dp0LogFiles\%~n0.tmp) do Call %0 "%%a" >> "%~dp0LogFiles\%~n0.log"
GOTO DoEnd

:ProcessUser
ECHO ------------------------------------------------------
dsquery user -samid %1 | dsget user -samid -profile -loscr -L | Find ":"
REM -hmdir -hmdrv 
%~dp0Tools\SystemTools\tscmd.exe localhost %1 TerminalServerProfilePath
%~dp0Tools\SystemTools\tscmd.exe localhost %1 TerminalServerHomeDir
%~dp0Tools\SystemTools\tscmd.exe localhost %1 TerminalServerHomeDirDrive
GOTO End

:DoEnd
start notepad "%~dp0LogFiles\%~n0.log"
REM Email the logbook to IT Services on Error.
REM -----------------------------------------------------------------------
IF %strSendEmail%' == True' CALL "%~dp0Tools\SendMail.cmd" "%~n0 (%COMPUTERNAME%)" "%~dp0LogFiles\%~n0.Log"
ECHO ---------------- End  : %~dpnx0 on %ComputerName% ----------------
CALL %0 /PrintDateTime
GOTO End

:Error
ECHO Error detected!
GOTO End

:End
REM -----------------------------------------------------------------------

