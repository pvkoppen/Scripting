@ECHO OFF
REM Name          : Migrate-TOLFP01.cmd
REM Description   : Script used to migrate from TOLSS01 to TOLFP01.
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Must be run as: Administrator
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2008-12-00: 1.0: Ngati Ruanui (Hone)
REM 2009-10-00: 1.1: TuTamaWahine
REM 2009-12-18: 1.2: Added ProgFile(x86) and Users
REM 2011-06-22: 1.3: Migrate to TOLFP01.
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------
SET RoboPath=\\TOLFP01\C$\Scripts\Tools\
Set RoboParams=/E /XJ /R:1 /W:1 /NP
SET SourcePathRoot=\\TOLSS01\D$\
SET TargetPathRoot=\\TOLFP01\D$\

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

:Prepare
ECHO.
ECHO -- DO NOT: AMC, AUAHA, KAI, MMAWT, PAT
ECHO.
ECHO Prepare: Pre-Copy Snapshot
vssadmin create shadow /for=d:

:Common
REM ECHO.
REM ECHO -- Common: Apps
REM "%RoboPath%RoboCopy.exe" %RoboParams% "%SourcePathRoot%Applications\." "%TargetPathRoot%Applications\."
REM ECHO.
REM ECHO -- Common: TOL Shared
REM "%RoboPath%RoboCopy.exe" %RoboParams% /MIR "%SourcePathRoot%Shared\All\." "%TargetPathRoot%Company Shared Folders\TOL Providers\."
REM ECHO.
REM ECHO -- Shared: HTPHO & TOL
REM "%RoboPath%RoboCopy.exe" %RoboParams% "%SourcePathRoot%Shared\HT\." "%TargetPathRoot%Company Shared Folders\TOL\."
REM ECHO.
REM ECHO -- Common: Attache
REM "%RoboPath%RoboCopy.exe" %RoboParams% "\\TOLPT01\D$\Applications\Attache\." "%TargetPathRoot%Applications\Attache\." /XD "Winfred Pro 1.0.2.47"
REM ECHO.
REM ECHO -- Common: WinFred
REM "%RoboPath%RoboCopy.exe" %RoboParams% /MIR "\\TOLPT01\D$\Applications\Winfred Pro 1.0.2.47\." "%TargetPathRoot%Applications\Attache\Winfred Pro 1.0.2.47\."
REM ECHO.
REM ECHO -- Common: PAT
REM "%RoboPath%RoboCopy.exe" %RoboParams% /MIR "%SourcePathRoot%Shared\PAT\." "%TargetPathRoot%Company Shared Folders\TOL\Management\Provider Arm Transition\."
GOTO Orgs

:Orgs
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
GOTO Profiles

:Profiles
rem CALL :ProcessProf AMC
rem CALL :ProcessProf AUAHA
rem CALL :ProcessProf BH
rem CALL :ProcessProf HTPHO
rem CALL :ProcessProf KOI
rem CALL :ProcessProf MMAWT
rem CALL :ProcessProf MOL
rem CALL :ProcessProf PTO
rem CALL :ProcessProf RHT
rem CALL :ProcessProf System
rem CALL :ProcessProf TAHL
rem CALL :ProcessProf TAM
rem CALL :ProcessProf THPH
rem CALL :ProcessProf TIHI
rem CALL :ProcessProf TIR
rem CALL :ProcessProf TOL
rem CALL :ProcessProf TRP
rem CALL :ProcessProf YTS
GOTO HomeDirs

:HomeDirs
rem CALL :ProcessHome AMC
rem CALL :ProcessHome AUAHA
rem CALL :ProcessHome BH
rem CALL :ProcessHome HTPHO
rem CALL :ProcessHome KOI
rem CALL :ProcessHome MMAWT
rem CALL :ProcessHome MOL
rem CALL :ProcessHome PTO
rem CALL :ProcessHome RHT
rem CALL :ProcessHome System
rem CALL :ProcessHome TAHL
rem CALL :ProcessHome TAM
rem CALL :ProcessHome THPH
rem CALL :ProcessHome TIHI
rem CALL :ProcessHome TIR
rem CALL :ProcessHome TOL
rem CALL :ProcessHome TRP
rem CALL :ProcessHome YTS
GOTO Finalize

:Finalize
ECHO.
ECHO Finalize: Post-Copy Snapshot
vssadmin create shadow /for=d:

ECHO ---------------- End  : %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime
GOTO End

:ProcessOrg
IF %1' == ' GOTO End
ECHO.
ECHO -- Company Shared Folders: %1
"%RoboPath%RoboCopy.exe" %RoboParams% /MIR "%SourcePathRoot%Shared\%1\." "%TargetPathRoot%Company Shared Folders\%1\."
GOTO End

:ProcessProf
IF %1' == ' GOTO End
ECHO.
ECHO -- User Profile Folders: %1
"%RoboPath%RoboCopy.exe" %RoboParams% "%SourcePathRoot%Profiles\%1\." "%TargetPathRoot%Users Shared Folders\%1\."
GOTO End

:ProcessHome
IF %1' == ' GOTO End
ECHO.
ECHO -- User Home Folders: %1
FOR /F "TOKENS=*" %%A IN ('DIR /ON /A /B "%SourcePathRoot%HomeDirs\%1\."') DO "%RoboPath%RoboCopy.exe" %RoboParams% "%SourcePathRoot%HomeDirs\%1\%%A\." "%TargetPathRoot%Users Shared Folders\%1\%%A\Documents\."
GOTO End

:PauseEnd
Pause
GOTO End

:End

