@ECHO OFF
REM Name          : SQL-Maintenance.cmd
REM Description   : Script used to perform maintenance on SQL databases.
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Version       : 1.0a
REM Must be run as: <No Preference: Administrators/LocalSystem>
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2009-01-20: v1.0
REM 2009-07-20: v1.0a: First version.
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------
SET SQLToolsDir="%SystemDrive%\Program Files\Microsoft SQL Server\90\Tools\Binn\"

IF %1' == ' GOTO Log
IF %1' == /Action' GOTO Action
IF %1' == /GetDateTime' GOTO GetDateTime
IF %1' == /PrintDateTime' GOTO PrintDateTime
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
IF NOT EXIST "%~dp0LogFiles\." MKDIR "%~dp0LogFiles"
Move /Y "%~dp0LogFiles\%~n0.Log" "%~dp0LogFiles\%~n0.Old.Log"
Call %0 /Action >> "%~dp0LogFiles\%~n0.Log" 2>>&1
TYPE "%~dp0LogFiles\%~n0.Log" >> "%~dp0LogFiles\%~n0.History.Log"
GOTO End

:Action
ECHO.
ECHO ---------------- Start: %~dpnx0 on %ComputerName% ----------------
CALL %0 /PrintDateTime
REM IF %ERRORLEVEL%' == 0' SET strSendEmail=True

%SQLToolsDir%osql.exe -E -S localhost\BKUPEXEC -d master -Q "dbcc shrinkdatabase ('BEDB') "
REM %SQLToolsDir%osql.exe -E -S localhost\MSFW -d master -Q "dbcc shrinkdatabase ('') "
%SQLToolsDir%osql.exe -E -S localhost\SBSMonitoring -d master -Q "dbcc shrinkdatabase ('SBSMonitoring') "
%SQLToolsDir%osql.exe -E -S localhost\SHAREPOINT -d master -Q "dbcc shrinkdatabase ('STS_Config') "
%SQLToolsDir%osql.exe -E -S localhost\SHAREPOINT -d master -Q "dbcc shrinkdatabase ('STS_%COMPUTERNAME%_1') "
%SQLToolsDir%osql.exe -E -S localhost\WSUS -d master -Q "dbcc shrinkdatabase ('SUSDB') "
GOTO DoEnd

:DoEnd
REM Email the logbook to IT Services on Error.
REM -----------------------------------------------------------------------
IF %strSendEmail%' == True' CALL "%~dp0Tools\SendMail.cmd" "%~n0 (%COMPUTERNAME%)" "%~dp0LogFiles\%~n0.Log"
ECHO ---------------- End  : %~dpnx0 on %ComputerName% ----------------
CALL %0 /PrintDateTime
GOTO End

:Error
GOTO End

:End
REM -----------------------------------------------------------------------

