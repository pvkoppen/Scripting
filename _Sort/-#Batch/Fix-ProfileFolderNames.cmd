@ECHO OFF
REM Name          : Fix-ProfileFolderNames.cmd
REM Description   : Script used to rename profile folders.
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
SET strBasePath=\\TOLFP01\D$\Users Shared Folders\

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

rem CALL :ProcessOrg AMC
rem CALL :ProcessOrg AUAHA
rem CALL :ProcessOrg BH
rem CALL :ProcessOrg HTPHO
rem CALL :ProcessOrg KOI
rem CALL :ProcessOrg MMAWT
rem CALL :ProcessOrg MOL
rem CALL :ProcessOrg PTO
rem CALL :ProcessOrg RHT
rem CALL :ProcessOrg System
rem CALL :ProcessOrg TAHL
rem CALL :ProcessOrg TAM
rem CALL :ProcessOrg THPH
rem CALL :ProcessOrg TIHI
rem CALL :ProcessOrg TIR
rem CALL :ProcessOrg TOL
rem CALL :ProcessOrg TRP
rem CALL :ProcessOrg YTS

ECHO ---------------- End  : %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime
GOTO End

:ProcessOrg
IF %1' == ' GOTO End
FOR /D %%A IN ("%strBasePath%%1\*.*") DO ECHO -- Processing folder: %%A&&Call :ProcessFolder "%%A"
GOTO End

:ProcessFolder
IF %1' == ' GOTO End
IF EXIST %1\tsprof         ren %1\tsprof          TSProfile
IF EXIST %1\tsprof.v2      ren %1\tsprof.v2       TSProfile.v2
IF EXIST %1\fatprof        ren %1\fatprof         Profile
IF EXIST %1\fatprof.v2     ren %1\fatprof.v2      Profile.V2
IF EXIST %1\prof           ren %1\prof            Profile
IF EXIST %1\prof.v2        ren %1\prof.v2         Profile.V2
IF EXIST %1\tshome         ren %1\tshome          TSProfile
IF EXIST %1\tshome\Windows Move %1\tshome\Windows TSProfile\.
IF EXIST %1\tshome         rmdir %1\tshome
dir /a /b /on %1\.
GOTO End

:PauseEnd
Pause
GOTO End

:End

