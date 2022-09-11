@ECHO OFF
REM Name          : Restart-RouterWhenInternetDown.cmd
REM Description   : Script used to Restart the local Cisco Router if two internet requests fail.
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Version       : 1.2b
REM Must be run as: <No Preference: Administrators/LocalSystem>
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2009-01-04: Version 1.1
REM 2009-01-13: v1.1c: Removed Rubish code of old telnet attempt.
REM 2009-04-15: v1.2: Rewrite with tool: tst10.exe
REM 2009-04-15: v1.2a: Changed the setup to check two external websites.
REM 2009-07-20: v1.2b: Updated date&time format.
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------
SET InternetTarget=www.tuiora.co.nz
SET InternetTarget1=www.google.co.nz
SET InternetTarget2=www.stuff.co.nz
SET DNSServer1=202.27.158.40
SET DNSServer2=202.27.156.72
SET LocalRouterIP=192.168.1.254
SET LocalRouterName=TOLIR

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

nslookup %InternetTarget1% %DNSServer1%
nslookup %InternetTarget1% %DNSServer2%
Ping %InternetTarget1%
"%~dp0Tools\wget\wget.exe" -t 2 --output-document="%~dp0LogFiles\%~n0.html" http://%InternetTarget1%
IF %ERRORLEVEL%' == 0' GOTO DoEnd

nslookup %InternetTarget2% %DNSServer1%
nslookup %InternetTarget2% %DNSServer2%
Ping %InternetTarget2%
"%~dp0Tools\wget\wget.exe" -t 2 --output-document="%~dp0LogFiles\%~n0.html" http://%InternetTarget2%
IF %ERRORLEVEL%' == 0' GOTO DoEnd

GOTO Error-TST

:Error-TST
ECHO %LocalRouterIP% 23> "%~dp0LogFiles\%~n0.telnet"
ECHO wait "Username:">> "%~dp0LogFiles\%~n0.telnet"
ECHO send "tuiora\m">> "%~dp0LogFiles\%~n0.telnet"
ECHO wait "Password:">> "%~dp0LogFiles\%~n0.telnet"
ECHO send "auahi1\m">> "%~dp0LogFiles\%~n0.telnet"
ECHO wait "%LocalRouterName%#">> "%~dp0LogFiles\%~n0.telnet"
ECHO send "show tech-support\m">> "%~dp0LogFiles\%~n0.telnet"
ECHO wait "%LocalRouterName%#">> "%~dp0LogFiles\%~n0.telnet"
ECHO send "reload\m\m">> "%~dp0LogFiles\%~n0.telnet"
ECHO wait "%LocalRouterName%#">> "%~dp0LogFiles\%~n0.telnet"
"%~dp0Tools\TelnetScriptingTool\tst10.exe" /r:"%~dp0LogFiles\%~n0.telnet" /o:"%~dp0LogFiles\%~n0.telnet.log" 
ECHO.
ECHO WGet Failed: Router restarted and sending a notification email.
ECHO -------------------------------------------------------------------------------------
IF %ERRORLEVEL%' == %ERRORLEVEL%' SET strSendEmail=True
GOTO DoEnd

:DoEnd
REM Email the logbook to IT Services on Error.
REM -----------------------------------------------------------------------
IF %strSendEmail%' == True' CALL "%~dp0Tools\SendMail.cmd" "%~n0 (%COMPUTERNAME%)" "%~dp0LogFiles\%~n0.Log"
ECHO ---------------- End  : %~dpnx0 on %ComputerName% ----------------
CALL %0 /PrintDateTime
GOTO End

:Error
ECHO Error detected!
GOTO End

:End
REM -----------------------------------------------------------------------

