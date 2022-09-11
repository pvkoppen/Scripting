@ECHO OFF
REM Name        : WSUSv2 Backup.cmd
REM Description : Script used to perform maintenance on the WSUS v2 database.
REM Author      : Peter van Koppen,  Tui Ora Limited
REM Version     : 1.0
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2009-01-20: v1.0
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------
SET SQLToolsDir=%SystemDrive%\Program Files\Microsoft SQL Server\90\Tools\Binn\
SET WSUSDir=C:\Program Files\Update Services\
SET WSUSToolsDir=D:\WSUS\Tools\

IF %1' == ' GOTO Log
IF %1' == Action' GOTO Action
IF %1' == PrintDateTime' GOTO PrintDateTime
IF %1' == GetDateTime' GOTO GetDateTime
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
Call %0 Action >> "%~dp0LogFiles\%~n0.Log" 2>>&1
TYPE "%~dp0LogFiles\%~n0.Log" >> "%~dp0LogFiles\%~n0.History.Log"
GOTO End

:Action
ECHO.
ECHO ---------------- Start: %~dpnx0 on %ComputerName% ----------------
CALL %0 PrintDateTime

"%SQLToolsDir%osql.exe" -E -S localhost\WSUS -d master -Q "backup database master to disk='C:\Backup-Config-Dump\WSUS\WSUS.bak' with format "
"%SQLToolsDir%osql.exe" -E -S localhost\WSUS -d master -Q "backup database model  to disk='C:\Backup-Config-Dump\WSUS\WSUS.bak' "
"%SQLToolsDir%osql.exe" -E -S localhost\WSUS -d master -Q "backup database msdb   to disk='C:\Backup-Config-Dump\WSUS\WSUS.bak' "
"%SQLToolsDir%osql.exe" -E -S localhost\WSUS -d master -Q "backup database SUSDB  to disk='C:\Backup-Config-Dump\WSUS\WSUS.bak' "
GOTO DoEnd

:Text
Database: Instance=WSUS
version= 8.0.2050 (MSDE 2000 SP4)
GOTO End

:DoEnd
ECHO ---------------- End  : %~dpnx0 on %ComputerName% ----------------
CALL %0 PrintDateTime
GOTO End

:End
REM -----------------------------------------------------------------------

