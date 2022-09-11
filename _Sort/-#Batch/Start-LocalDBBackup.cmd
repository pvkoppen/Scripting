@ECHO OFF
REM Name          : Backup-LocalDB.cmd
REM Description   : Script used to backup the local MSSQL database.
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Must be run as: Administrator
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2009-12-xx: 1.0: Initial version copied from: Run-PreBackupTasks
REM 2009-12-xx: 1.0a: Made the Database backup more dynamic. (Always exclude TEMPDB)
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------
SET SQLPath=C:\MsSQL7\
SET strBackupTarget=C:\Backup-Config-Dump\
SET strSecondaryBackupTarget=C:\Backup-Config-Dump\Yesterday\

IF %1' == ' GOTO Log
IF %1' == /Action' GOTO Action
IF %1' == /Get-DBS' GOTO Get-DBS
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

:Get-DBS
"%SQLPath%Binn\OSQL.EXE" -E -S localhost -d master -Q "select name from sysdatabases where name NOT IN ('TEMPDB') " | find /v "name" | find /v "----------" | find /v "("
GOTO End

:Log
REM Start Logging
REM -----------------------------------------------------------------
IF NOT EXIST "%~dp0LogFiles\." MKDIR "%~dp0LogFiles"
Move /Y "%~dp0LogFiles\%~n0.Log" "%~dp0LogFiles\%~n0.Old.Log"
Call %0 /Action >> "%~dp0LogFiles\%~n0.Log" 2>>&1
GOTO End

:Action
ECHO.
ECHO ---------------- Start: %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime
REM IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True

ECHO.
ECHO -- Prepare Backup Target Locations
IF NOT EXIST "%strBackupTarget%LocalDB\." MKDIR  "%strBackupTarget%LocalDB\"
IF NOT EXIST "%strSecondaryBackupTarget%LocalDB\." MKDIR "%strSecondaryBackupTarget%LocalDB\"

ECHO.
ECHO -- Copy (old) Backup to Secondary location
XCOPY /E /Y "%strBackupTarget%LocalDB\*.*" "%strSecondaryBackupTarget%LocalDB\"

ECHO.
ECHO -- Backup: Local-DB's
IF NOT EXIST "%SQLPath%Data\." GOTO DoEnd
FOR /F %%A IN ('%0 /Get-DBS') DO "%SQLPath%Binn\osql.exe" -E -S localhost -d master -Q "BACKUP DATABASE %%A  TO DISK = N'%strBackupTarget%LocalDB\%%A.bak' "
GOTO DoEnd

:DoEnd
REM Email the logbook to IT Services on Error.
REM -----------------------------------------------------------------------
IF %strSendEmail%' == True' CALL "%~dp0Tools\SendMail.cmd" "%~n0 (%COMPUTERNAME%)" "%~dp0LogFiles\%~n0.Log"
ECHO ---------------- End  : %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime
GOTO End

:Error
ECHO [ERROR] Error detected!
GOTO End

:End
REM -----------------------------------------------------------------------

