@ECHO OFF
REM Name          : Show-NICInfo.cmd
REM Description   : On a Hyper-V server show the NIC Configuration.
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Must be run as: Administrator
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2011-09-21: 1.0: Initial version.
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------

IF %1' == /silent' GOTO Log
IF %1' == /Action' GOTO Action
IF %1' == /ProcessIPConfig' GOTO ProcessIPConfig
IF %1' == /ProcessFind'     GOTO ProcessFind
IF %1' == /ShowInfo'        GOTO ShowInfo
GOTO AreYouSure

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

:AreYouSure
ECHO.
CHOICE /C YN /M "Are you sure you want to: %~n0 (%COMPUTERNAME%) ?"
IF %ERRORLEVEL% == 255 GOTO Error
IF %ERRORLEVEL% == 2 GOTO End
IF %ERRORLEVEL% == 1 GOTO Action
IF %ERRORLEVEL% == 0 GOTO Error
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
REM IF %ERRORLEVEL%' == 0' SET strSendEmail=True

FOR /F "TOKENS=1,2 DELIMS=:" %%A IN ('IPConfig /all') DO CALL %0 /ProcessIPConfig "%%A" "%%B"
GOTO DoEnd

:ProcessIPConfig
FOR /F %%A IN ('%0 /ProcessFind Ethernet %2')    DO SET strConnection=%~2
FOR /F %%A IN ('%0 /ProcessFind Description %2') DO SET strInterface=%~3
FOR /F %%A IN ('%0 /ProcessFind Physical %2')    DO SET strMACAddress=%~3
FOR /F %%A IN ('%0 /ProcessFind IPv4 %2')        DO SET strIPAddress=%~3 && CALL %0 /ShowInfo
REM ECHO 1=%1, 2=%2, 3=%3
GOTO End

:ProcessFind
ECHO %3 | FIND /I "%2"
GOTO End

:ShowInfo
ECHO.
ECHO -- %strConnection%
ECHO Interface  =%strInterface%
ECHO MACAddress =%strMACAddress%
ECHO IPAddress  =%strIPAddress%
GOTO End

:DoEnd
REM Email the logbook to IT Services on Error.
REM -----------------------------------------------------------------------
IF %strSendEmail%' == True' CALL "%~dp0Tools\SendMail.cmd" "%~n0 (%COMPUTERNAME%)" "%~dp0LogFiles\%~n0.Log"
ECHO ---------------- End  : %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime
GOTO End

:Error
ECHO Error detected!
GOTO End

:End
REM -----------------------------------------------------------------------

