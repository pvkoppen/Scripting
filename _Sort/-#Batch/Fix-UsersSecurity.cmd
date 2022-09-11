@ECHO OFF
REM Name          : Fix-UsersSecurity.cmd
REM Description   : Script used to add the right security to the users folders.
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
ECHO ---------------- Start: %~dpnx0 on  %ComputerName% ----------------
CALL :PrintDateTime
GOTO Users

:Users
FOR /D %%A IN ("%strBasePath%*.*") DO ECHO -- Processing folder: %%A&&FOR /F "TOKENS=*" %%B IN ('dir /AD /B /ON "%%A\*.*"') DO CALL :User "%%A" "%%B"
GOTO Orgs

:User
IF %1' == ' GOTO End
IF %2' == ' GOTO End
Icacls %1\\%2 /grant:r %2@tol.local:(OI)(CI)(M) /inheritance:e /q >nul
IF NOT %ERRORLEVEL%' == 0' GOTO UserError
ECHO INFO : Processing user folder succeeded %1\%2
GOTO End
:UserError
ECHO ERROR: Processing user folder failed %1\%2
GOTO End

:Orgs
GOTO Next
Icacls.exe "%strBasePath%AMC"    /inheritance:e /deny everyone:(wd) /remove administrators /grant "Avenue Medical Center (AMC) Users":(r)
Icacls.exe "%strBasePath%AUAHA"  /inheritance:e /deny everyone:(wd) /remove administrators /grant "Auaha Ltd (AUAHA) Users":(r)
Icacls.exe "%strBasePath%BH"     /inheritance:e /deny everyone:(wd) /remove administrators /grant "Better Homes (BH) Users":(r)
Icacls.exe "%strBasePath%HTPHO"  /inheritance:e /deny everyone:(wd) /remove administrators /grant "Hauora Taranaki PHO (HTPHO) Users":(r)
Icacls.exe "%strBasePath%KOI"    /inheritance:e /deny everyone:(wd) /remove administrators /grant "Karangaora Inc (KOI) Users":(r)
Icacls.exe "%strBasePath%MMAWT"  /inheritance:e /deny everyone:(wd) /remove administrators /grant "Mahia Mai A Whai Tara (MMAWT) Users":(r)
Icacls.exe "%strBasePath%MOL"    /inheritance:e /deny everyone:(wd) /remove administrators /grant "Manaaki Oranga Ltd (MOL) Users":(r)
Icacls.exe "%strBasePath%PTO"    /inheritance:e /deny everyone:(wd) /remove administrators /grant "Piki Te Ora (PTO) Users":(r)
Icacls.exe "%strBasePath%RHT"    /inheritance:e /deny everyone:(wd) /remove administrators /grant "Raumano Health Trust (RHT) Users":(r)
Icacls.exe "%strBasePath%System" /inheritance:e /deny everyone:(wd) /remove administrators /grant "System (SYS) Users":(r)
Icacls.exe "%strBasePath%TAHL"   /inheritance:e /deny everyone:(wd) /remove administrators /grant "Te Atiawa Holdings Ltd (TAHL) Users":(r)
Icacls.exe "%strBasePath%TAM"    /inheritance:e /deny everyone:(wd) /remove administrators /grant "Te Aroha Medcare (TAM) Users":(r)
Icacls.exe "%strBasePath%THPH"   /inheritance:e /deny everyone:(wd) /remove administrators /grant "Te Hauora Pou Heretanga (THPH) Users":(r)
Icacls.exe "%strBasePath%TIHI"   /inheritance:e /deny everyone:(wd) /remove administrators /grant "Tihi Ltd (TIHI) Users":(r)
Icacls.exe "%strBasePath%TIR"    /inheritance:e /deny everyone:(wd) /remove administrators /grant "Te Ihi Rangi (TIR) Users":(r)
Icacls.exe "%strBasePath%TOL"    /inheritance:e /deny everyone:(wd) /remove administrators /grant "Tui Ora Ltd (TOL) Users":(r)
Icacls.exe "%strBasePath%TRP"    /inheritance:e /deny everyone:(wd) /remove administrators /grant "Te Rau Pani (TRP) Users":(r)
Icacls.exe "%strBasePath%YTS"    /inheritance:e /deny everyone:(wd) /remove administrators /grant "Youth Transition Service (YTS) Users":(r)
GOTO Next

:Next
ECHO ---------------- End  : %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime
GOTO End

:PauseEnd
Pause
GOTO End

:End

