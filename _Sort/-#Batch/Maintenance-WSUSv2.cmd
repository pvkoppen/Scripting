@ECHO OFF
REM Name        : WSUSv2 Maintenance.cmd
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
GOTO Action2

ECHO. 
ECHO -- IIS: Stop WSUS Website
net stop w3svc 
ECHO -- WSUSUtil: RemoveInactiveApprovals 
"%WSUSDir%Tools\wsusutil.exe" removeinactiveapprovals 
ECHO -- WSUSUtil: DeleteUnneededRevisions 
"%WSUSDir%Tools\wsusutil.exe" deleteunneededrevisions 
ECHO -- IIS: Start WSUS Website 
net start w3svc 
CALL %0 PrintDateTime

ECHO -- WSUSDebugTool: PurgeUnneededFiles 
"%WSUSToolsDir%wsusdebugtool.exe" /tool:PurgeUnneededFiles 
ECHO -- WSUSUtil: Reset File Download Flags 
"%WSUSDir%Tools\wsusutil.exe" reset 
CALL %0 PrintDateTime

ECHO -- MsSQL: Shrink Database 
"%SQLToolsDir%osql.exe" -E -S localhost\wsus -d master -Q "dbcc shrinkdatabase ('SUSDB') " 
"%SQLToolsDir%osql.exe" -E -S localhost\wsus -d master -Q "DBCC CHECKDB " 
"%SQLToolsDir%osql.exe" -E -S localhost\wsus -d model  -Q "DBCC CHECKDB " 
"%SQLToolsDir%osql.exe" -E -S localhost\wsus -d msdb   -Q "DBCC CHECKDB " 
"%SQLToolsDir%osql.exe" -E -S localhost\wsus -d SUSDB  -Q "DBCC CHECKDB " 
ECHO -- Finished 
GOTO DoEnd

:Action2
"%SQLToolsDir%osql.exe" -E -S localhost\wsus -d master -Q "DBCC CHECKDB " 
"%SQLToolsDir%osql.exe" -E -S localhost\wsus -d model  -Q "DBCC CHECKDB " 
"%SQLToolsDir%osql.exe" -E -S localhost\wsus -d msdb   -Q "DBCC CHECKDB " 
"%SQLToolsDir%osql.exe" -E -S localhost\wsus -d SUSDB  -Q "DBCC CHECKDB " 
GOTO DoEnd

:DoEnd
ECHO ---------------- End  : %~dpnx0 on %ComputerName% ----------------
CALL %0 PrintDateTime
GOTO End

:End
REM -----------------------------------------------------------------------

