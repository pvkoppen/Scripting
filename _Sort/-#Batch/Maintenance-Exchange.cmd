@ECHO OFF
REM Name          : Maintenance-Exchange.cmd
REM Description   : Script used to Run Exchange Maintenance Checks. (!!Mailbox Stores need to be taken offline for maintenance!!)
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Version       : 1.1c
REM Must be run as: <No Preference: Administrators/LocalSystem>
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2009-01-04: Version 1.1
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------

IF %1' == /silent' GOTO Action
IF %1' == /GetDateTime' GOTO GetDateTime
IF %1' == /PrintDateTime' GOTO PrintDateTime
GOTO AreYouSure

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

:AreYouSure
ECHO.
CHOICE /C YN /M "Do You want to run the Exchange Maintenance tools?"
IF %ERRORLEVEL% == 255 GOTO Error
IF %ERRORLEVEL% == 2 GOTO End
IF %ERRORLEVEL% == 1 GOTO Action
IF %ERRORLEVEL% == 0 GOTO Error
GOTO End

:Action
ECHO.
ECHO ---------------- Start: %~dpnx0 on %ComputerName% ----------------
CALL %0 /PrintDateTime
REM IF %ERRORLEVEL%' == 0' SET strSendEmail=True

D:
CD "\Program Files\Exchsrvr\MDBData"
ECHO. > "C:\Program Files\Exchsrvr\bin\eseutil.exe" /?
ECHO.

ECHO Dismount the mailbox and Public Folder store(s) before continuing
ECHO with Integrity check and Defrag!
Pause
"C:\Program Files\Exchsrvr\bin\eseutil.exe" /G .\priv1.edb
"C:\Program Files\Exchsrvr\bin\eseutil.exe" /G .\pub1.edb
ECHO.

REM "C:\Program Files\Exchsrvr\bin\eseutil.exe" /D .\priv1.edb
REM "C:\Program Files\Exchsrvr\bin\eseutil.exe" /D .\pub1.edb
ECHO.

REM "C:\Program Files\Exchsrvr\bin\IsInteg.exe" -s %COMPUTERNAME% -test alltests
REM "C:\Program Files\Exchsrvr\bin\IsInteg.exe" -s %COMPUTERNAME% -test alltests /fix
GOTO DoEnd

:DoEnd
REM Email the logbook to IT Services on Error.
REM -----------------------------------------------------------------------
IF %strSendEmail%' == True' CALL "%~dp0Tools\SendMail.cmd" "%~n0 (%COMPUTERNAME%)" "%~dp0LogFiles\%~n0.Log"
ECHO ---------------- End  : %~dpnx0 on %ComputerName% ----------------
CALL %0 /PrintDateTime
Pause
GOTO End

:Error
ECHO Error detected!
GOTO End

:End
REM -----------------------------------------------------------------------

