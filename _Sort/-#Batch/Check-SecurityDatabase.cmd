@ECHO OFF
REM Name          : Check-SecurityDatabase.cmd
REM Description   : Script used to Check the Security Database.
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Version       : 1.0
REM Must be run as: <No Preference: Administrators/LocalSystem>
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2009-12-03: v1.0: Initial Version
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------

IF %1' == /GetDateTime' GOTO GetDateTime
IF %1' == /PrintDateTime' GOTO PrintDateTime
GOTO Action

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

:Action
ECHO.
ECHO ---------------- Start: %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime
REM IF %ERRORLEVEL%' == 0' SET strSendEmail=True

ECHO Security Database: CHECK INTEGRITY
ECHO ----------------------------------
esentutl /g %windir%\security\database\secedit.sdb

ECHO Security Database: DEFRAG
ECHO ----------------------------------
esentutl /d %windir%\security\database\secedit.sdb

ECHO.
CHOICE /C YN /M "Check for Errors... Do we need to Repair?"
IF %ERRORLEVEL% == 255 GOTO Error
IF %ERRORLEVEL% == 2 GOTO DoEnd
IF %ERRORLEVEL% == 1 GOTO Action2
IF %ERRORLEVEL% == 0 GOTO Error
GOTO DoEnd

:Action2
ECHO Security Database: REPAIR
ECHO ----------------------------------
esentutl /p %windir%\security\database\secedit.sdb
GOTO DoEnd

:DoEnd
GPUpdate /force
REM Email the logbook to IT Services on Error.
REM -----------------------------------------------------------------------
IF %strSendEmail%' == True' CALL "%~dp0Tools\SendMail.cmd" "%~n0 (%COMPUTERNAME%)" "%~dp0LogFiles\%~n0.Log"
ECHO ---------------- End  : %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime
Pause
GOTO End

:Error
ECHO Error detected!
GOTO End

:End
REM -----------------------------------------------------------------------

