@ECHO OFF
REM Name        : SharePoint-Backup-Restore.cmd
REM Description : Script used to Backup and Restore the CompanyWeb SharePoint site.
REM Author      : Peter van Koppen,  Tui Ora Limited
REM Version     : 1.0a
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2009-03-27: v1.0:
REM 2009-03-27: v1.0a: Added Closing commands
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------
SET BinPath=%SystemDrive%\Program Files\Common Files\Microsoft Shared\web server extensions\60\BIN\
SET TargetPath=D:\Backup-Config-Dump\SharePoint\
SET InternalDNSName=tol.local

IF %1' == ' GOTO Log
IF %1' == /Action' GOTO Action
IF %1' == /PrintDateTime' GOTO PrintDateTime
IF %1' == /GetDateTime' GOTO GetDateTime
GOTO Action

:PrintDateTime
REM -----------------------------------------------------------------------
ECHO -----------------------------------------------------------------------
@FOR /F "tokens=1-9 delims=/ " %%A IN ('date /t') DO @FOR /F "tokens=1-9 delims=:. " %%a IN ('time /t') DO ECHO -- DATE-TIME=%%A%%B%%C%%D-%%a%%b%%c%%d 
ECHO -----------------------------------------------------------------------
GOTO End

:GetDateTime
REM -----------------------------------------------------------------------
@FOR /F "tokens=1-9 delims=/ " %%A IN ('date /t') DO @FOR /F "tokens=1-9 delims=:. " %%a IN ('time /t') DO SET strDateTime=%%A%%B%%C%%D-%%a%%b%%c%%d && SET strDate=%%A%%B%%C%%D && SET strTime=%%a%%b%%c%%d
REM -----------------------------------------------------------------------
GOTO End

:Log
IF NOT EXIST "%~dp0LogFiles\." MKDIR "%~dp0LogFiles"
Move /Y "%~dp0LogFiles\%~n0.Log" "%~dp0LogFiles\%~n0.Old.Log"
Call %0 /Action >> "%~dp0LogFiles\%~n0.Log" 2>>&1
TYPE "%~dp0LogFiles\%~n0.Log" >> "%~dp0LogFiles\%~n0.History.Log"
GOTO End

:Action
ECHO.
ECHO ---------------- Start: %~dpnx0 on %ComputerName% ----------------
CALL %0 /PrintDateTime
GOTO DoBackup

:DoBackup
REM Backup Companyweb
"%BinPath%STSADM.exe" -o Backup -url http://companyweb/ -filename "%TargetPath%STSADM-Backup-CompanyWeb.stsbackup" -overwrite
GOTO DoEnd

:DoRestore
REM Create Restore Site and Restore.
"%BinPath%Stsadm.exe" -o createsiteinnewdb -url http://companyweb/sites/RestoredSite -ownerlogin <DOMAIN>\administrator -owneremail administrator@%InternalDNSName% -databasename STS_RESTORE 
"%BinPath%Stsadm.exe" -o restore -url http://companyweb/sites/restoredsite -filename "%TargetPath%STSADM-Backup-CompanyWeb.stsbackup" -overwrite 
start http://companyweb/sites/restoredsite
GOTO DoEnd

:DoCleanup
REM Remove RestoreSite
ECHO Open: -> Central Administration -> Virtual Server Configuration -> Configure Virtual Server Settings -> companyweb -> Virtual Server Management -> Delete site collection -> Type: http://companyweb/sites/restoredsite -> OK -> Delete.
REM Delete Restore Content database:
ECHO Open: -> .. -> Virtual Server Management -> Manage content databases -> STS_RESTORE -> Remove Content Database -> Select remove content database -> OK. 
ECHO You are about to delete the database, are you sure?
PAUSE
REM Open: -> Start -> Command Prompt -> type: osql -E -S localhost\SharePoint -Q "drop database sts_restore "
GOTO DoEnd

:DoEnd
ECHO ---------------- End  : %~dpnx0 on %ComputerName% ----------------
CALL %0 /PrintDateTime
GOTO End

:End
REM -----------------------------------------------------------------------

