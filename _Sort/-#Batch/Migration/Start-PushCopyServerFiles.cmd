@ECHO OFF
REM Name          : Start-PushCopyServerFiles.cmd
REM Description   : Script used to Copy all relevant folders during a server migration.
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Must be run as: Administrator
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2008-12-00: 1.0: Ngati Ruanui (Hone)
REM 2009-10-00: 1.1: TuTamaWahine
REM 2009-12-18: 1.2: Added ProgFile(x86) and Users
REM 2013-03-15: 1.3: Updated script for VogelTown
REM 2013-03-25: 1.4: Debug after vogeltown Migration.
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------
SET strNewServer=VMCSRV01
SET strTools=\\%strNewServer%\D$\Backup-Config-Dump\Migration\Scripts\Tools\
SET strTarget=\\%strNewServer%\D$\Backup-Config-Dump\Migration\
SET ProcessMeName=%ComputerName%

IF %1' == ' GOTO Log
IF %1' == /Action' GOTO Action
IF %1' == /ProcessDrive' GOTO ProcessDrive
IF %1' == /ListDrive' GOTO ListDrive
IF %1' == /ListUsersOnDrive' GOTO ListUsersOnDrive
GOTO End

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

:Log
REM Start Logging
REM -----------------------------------------------------------------
CALL :GetDateTime
IF NOT EXIST "%strTarget%%ProcessMeName%\." MKDIR "%strTarget%%ProcessMeName%"
CALL %0 /Action >> "%strTarget%%ProcessMeName%\%~n0-%strDateTime%.Log" 2>>&1
START "Log" "%strTarget%%ProcessMeName%\%~n0-%strDateTime%.Log"
GOTO DoEnd

:Action
ECHO.
ECHO ---------------- Start: %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime

ECHO [INFO ] %~n0: Starting \\%ProcessMeName%
IF NOT EXIST "%strTarget%%ProcessMeName%\." MKDIR "%strTarget%%ProcessMeName%"
CALL %0 /ProcessDrive C
CALL %0 /ProcessDrive D
CALL %0 /ProcessDrive E

RMDIR /q "%strTarget%%ProcessMeName%"
ECHO [INFO ] %~n0: Completed \\%ProcessMeName%
GOTO End

:ProcessDrive
ECHO [INFO ] %~n0: Starting \\%ProcessMeName%\%2:
DIR /A /ON "%2:\."
FOR /F "TOKENS=*" %%A IN ('%0 /ListDrive %2') DO "%strTools%RoboCopy.exe" /E /XJD /NP /R:1 /W:1 "%2:\%%A" "%strTarget%%ProcessMeName%\%2\%%A" /xd "ReportArchive" "ReportQueue"
FOR /F "TOKENS=*" %%A IN ('%0 /ListUsersOnDrive %2 Users') DO "%strTools%RoboCopy.exe" /E /XJD /NP /R:1 /W:1 "%2:\Users" "%strTarget%%ProcessMeName%\%2\Users" /xd *Temporary Internet File*" "Cookies"
REM Must USE CALL when you use " twice!
FOR /F "TOKENS=*" %%A IN ('CALL %0 /ListUsersOnDrive %2 "Documents and Settings"') DO "%strTools%RoboCopy.exe" /E /XJD /NP /R:1 /W:1 "%2:\Documents and Settings" "%strTarget%%ProcessMeName%\%2\Documents and Settings" /xd "Temporary Internet File*" "Cookies"
ECHO [INFO ] %~n0: Completed \\%ProcessMeName%\%2:
GOTO End

:ListDrive
DIR /B /AD /ON "%2:\." | FIND /V /I "$Recycle.Bin" | FIND /V /I "Config.Msi" | FIND /V /I "Documents and Settings" | FIND /V /I "MSOCache" | FIND /V /I "PerfLogs" | FIND /V /I "Program Files" | FIND /V /I "Program Files (x86)" | FIND /V /I "ProgramData" | FIND /V /I "Recovery" | FIND /V /I "RECYCLER" | FIND /V /I "swsetup" | FIND /V /I "System Volume Information" | FIND /V /I "Users" | FIND /V /I "Windows" 
GOTO End

:ListUsersOnDrive
DIR /B /AD /ON "%2:\%~3\." | FIND /V /I "admin-" | FIND /V /I "All Users" | FIND /V /I "Default" | FIND /V /I "Default User" | FIND /V /I "Public"
GOTO End

:DoEnd
ECHO ---------------- End  : %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime
Pause
GOTO End

:End
REM -----------------------------------------------------------------------

