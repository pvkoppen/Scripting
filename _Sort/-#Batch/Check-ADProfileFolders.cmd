@ECHO OFF
REM Name          : Check-ADProfileFolders.cmd
REM Description   : Script used to get AD information: SAMID, ProfileFolder, LoginScript, TSProfileFolder.
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Must be run as: Administrator
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2011-06-28: 1.0: First attempt
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------

IF %1' == ' GOTO Log
IF %1' == /Action' GOTO Action
GOTO End

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

:Log
REM Start Logging
REM -----------------------------------------------------------------
IF NOT EXIST "%~dp0LogFiles\." MKDIR "%~dp0LogFiles\."
CALL :GetDateTime
CALL %0 /Action >> "%~dp0LogFiles\%~n0-%strDateTime%.Log" 2>>&1
START "" "%~dp0LogFiles\%~n0-%strDateTime%.Log"
GOTO End

:Action
ECHO.
ECHO ---------------- Start: %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime

CALL :ProcessOrg AMC
CALL :ProcessOrg AUAHA
CALL :ProcessOrg BH
CALL :ProcessOrg HTPHO
CALL :ProcessOrg KOI
CALL :ProcessOrg MMAWT
CALL :ProcessOrg MOL
CALL :ProcessOrg PTO
CALL :ProcessOrg RHT
CALL :ProcessOrg System
CALL :ProcessOrg TAHL
CALL :ProcessOrg TAM
CALL :ProcessOrg THPH
CALL :ProcessOrg TIHI
CALL :ProcessOrg TIR
CALL :ProcessOrg TOL
CALL :ProcessOrg TRP
CALL :ProcessOrg YTS

ECHO ---------------- End  : %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime
GOTO End

:ProcessOrg
IF %1' == ' GOTO End
FOR /F "TOKENS=*" %%A IN ('dsquery.exe user "OU=%1,DC=tol,DC=local"') DO CALL :ProcessUser %%A %1
GOTO End

:ProcessUser
IF %1' == ' GOTO End
IF %2' == ' GOTO End
dsget.exe user %1 -samid -hmdir -hmdrv -profile -loscr |FIND /V "samid" | Find /V "dsget"
FOR /F %%A IN ('dsget.exe user %1 -samid') DO IF NOT %%A' == samid' IF NOT %%A' == dsget' "%~dp0Tools\SystemTools\tscmd.exe" TOLDV01 %%A TerminalServerProfilePath
rem FOR /F %%A IN ('dsget.exe user %1 -samid') DO IF NOT %%A' == samid' IF NOT %%A' == dsget' "%~dp0Tools\SystemTools\tscmd.exe" TOLDV01 %%A TerminalServerProfilePath \\TOLFP01\Users%2$\%%A\TSProfile 
rem FOR /F %%A IN ('dsget.exe user %1 -samid') DO IF NOT %%A' == samid' IF NOT %%A' == dsget' "%~dp0Tools\SystemTools\tscmd.exe" TOLDV01 %%A TerminalServerProfilePath
GOTO End

:PauseEnd
Pause
GOTO End

:End

