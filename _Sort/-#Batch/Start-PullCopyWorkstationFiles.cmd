@ECHO OFF
REM Name        : Start-PullCopyWorkstationFiles.cmd
REM Description : Script used to Copy folders from PC's for Backup purposes.
REM Author      : Peter van Koppen,  Tui Ora Limited
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2009-01-04: Version 1.1
REM 2009-01-04: 1.1c: Added Error Email.
REM 2013-03-06: 1.1d: Updated settings.
REM 2013-03-15: 1.3: Updated script for VogelTown
REM 2013-03-25: 1.4: Debug after vogeltown Migration.
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------
SET strTarget=D:\Backup-Config-Dump\%~n0\
SET strAuthentication=

SET strTarget=D:\Backup-Config-Dump\Migration\
SET strAuthentication=/USER:PreInstalled Pa55word

IF %1' == ' GOTO Log
IF %1' == /Action' GOTO Action
IF %1' == /ActionItems' GOTO ActionItems
IF %1' == /ProcessDrive' GOTO ProcessDrive
IF %1' == /ListDriveOnComputer' GOTO ListDriveOnComputer
IF %1' == /ListUsersOnDriveOnComputer' GOTO ListUsersOnDriveOnComputer
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
ECHO -- DATE-TIME.=%DATE%-%TIME%. 
ECHO -----------------------------------------------------------------------
GOTO End

:Log
REM Start Logging
REM -----------------------------------------------------------------
IF NOT EXIST "%~dp0LogFiles\." MKDIR "%~dp0LogFiles"
Move /Y "%~dp0LogFiles\%~n0.Log" "%~dp0LogFiles\%~n0.Old.Log"
CALL %0 /Action >> "%~dp0LogFiles\%~n0.Log" 2>>&1
TYPE "%~dp0LogFiles\%~n0.Log" >> "%~dp0LogFiles\%~n0.History.Log"
GOTO End

:Action
ECHO.
ECHO ---------------- Start: %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime
FOR /F "USEBACKQ" %%A IN ("%~dpn0.txt") DO CALL %0 /ActionItems %%A
REM IF %ERRORLEVEL%' == 0' SET strSendEmail=True
GOTO DoEnd

:ActionItems
ECHO [INFO ] %~n0: Starting \\%2
Ping -w 60 %2
IF NOT %ERRORLEVEL%' == 0' GOTO End
IF NOT EXIST "%strTarget%%2\." MKDIR "%strTarget%%2"

CALL %0 /ProcessDrive %2 C
CALL %0 /ProcessDrive %2 D

RMDIR /q "%strTarget%%2"
ECHO [INFO ] %~n0: Completed \\%2
GOTO End

:ProcessDrive
ECHO [INFO ] %~n0: Starting \\%2\%3$
NET USE "\\%2\%3$" %strAuthentication%
IF NOT %ERRORLEVEL%' == 0' GOTO End
DIR /A /ON "\\%2\%3$" > "%strTarget%%2\DIR-%3.txt"
FOR /F "TOKENS=*" %%A IN ('%0 /ListDriveOnComputer %2 %3') DO "%~dp0Tools\RoboCopy.exe" /E /XJD /NP /R:1 /W:1 "\\%2\%3$\%%A" "%strTarget%%2\%3\%%A" /xd "ReportArchive" "ReportQueue"
FOR /F "TOKENS=*" %%A IN ('%0 /ListUsersOnDriveOnComputer %2 %3 Users') DO "%~dp0Tools\RoboCopy.exe" /E /XJD /NP /R:1 /W:1 "\\%2\%3$\Users\%%A" "%strTarget%%2\%3\Users\%%A" /xd "Cookies" "Temporary Internet Files"
REM Must USE CALL when you use " twice!
FOR /F "TOKENS=*" %%A IN ('CALL %0 /ListUsersOnDriveOnComputer %2 %3 "Documents and Settings"') DO "%~dp0Tools\RoboCopy.exe" /E /XJD /NP /R:1 /W:1 "\\%2\%3$\Documents and Settings\%%A" "%strTarget%%2\%3\Documents and Settings\%%A" /xd "Cookies" "Temporary Internet Files"
NET USE "\\%2\%3$" /DELETE
ECHO [INFO ] %~n0: Completed \\%2\%3$
GOTO End

:ListDriveOnComputer
DIR /B /AD /ON "\\%2\%3$\." | FIND /V /I "$Recycle.Bin" | FIND /V /I "Config.Msi" | FIND /V /I "Documents and Settings" | FIND /V /I "MSOCache" | FIND /V /I "PerfLogs" | FIND /V /I "Program Files" | FIND /V /I "Program Files (x86)" | FIND /V /I "ProgramData" | FIND /V /I "Recovery" | FIND /V /I "RECYCLER" | FIND /V /I "swsetup" | FIND /V /I "System Volume Information" | FIND /V /I "Users" | FIND /V /I "Windows" 
GOTO End

:ListUsersOnDriveOnComputer
DIR /B /AD /ON "\\%2\%3$\%~4\." | FIND /V /I "admin-" | FIND /V /I "All Users" | FIND /V /I "Default" | FIND /V /I "Default User" | FIND /V /I "Public"
GOTO End

:DoEnd
REM Email the logbook to IT Services on Error.
REM -----------------------------------------------------------------------
IF %strSendEmail%' == True' CALL "%~dp0Tools\SendMail.cmd" "%~n0 (%COMPUTERNAME%)" "%~dp0LogFiles\%~n0.Log"
ECHO ---------------- End  : %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime
GOTO End

:End
REM -----------------------------------------------------------------------

