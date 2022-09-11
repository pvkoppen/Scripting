@ECHO OFF
REM Name          : Test-IPStack.cmd
REM Description   : Script used to Test the TCP/IP stack and setings on a computer.
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Must be run as: User
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2012-01-01; 1.1; Original Version
REM 2013-01-18: 1.2: Removed external calls
REM 2013-05-03: 1.3: Added some checks, Updated Parameters
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------

IF %1' == ' GOTO AreYouSure
IF %1' == /silent' GOTO Log
IF %1' == /Action' GOTO Action
GOTO End

:Log
IF NOT EXIST "%~dp0LogFiles\." MKDIR "%~dp0LogFiles"
CALL %0 /Action >> "%~dp0LogFiles\%~n0-%computername%.txt" 2>&1
START "" "%~dp0LogFiles\%~n0-%computername%.txt"
GOTO End

:GetDateTime
REM -----------------------------------------------------------------------
@FOR /F "tokens=1-9 delims=/ " %%A IN ('date /t') DO @FOR /F "tokens=1-9 delims=:. " %%a IN ('time /t') DO SET strDateTime=%%D%%C%%B[%%A]-%%c%%d%%a%%b && SET strDate=%%D%%C%%B[%%A] && SET strTime=%%c%%d%%a%%b 
REM -----------------------------------------------------------------------
GOTO End

:PrintDateTime
ECHO -----------------------------------------------------------------------
@FOR /F "tokens=1-9 delims=/ " %%A IN ('date /t') DO @FOR /F "tokens=1-9 delims=:. " %%a IN ('time /t') DO ECHO -- DATE-TIME=%%D%%C%%B[%%A]-%%c%%d%%a%%b 
ECHO -----------------------------------------------------------------------
GOTO End

:AreYouSure
ECHO.
CHOICE /C YN /M "Do '%~n0' (again)?"
IF %ERRORLEVEL% == 255 GOTO Error
IF %ERRORLEVEL% == 2 GOTO End
IF %ERRORLEVEL% == 1 GOTO Action
IF %ERRORLEVEL% == 0 GOTO Error
GOTO End

:Action
ECHO.
ECHO ---------------- Start: %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime
REM IF %ERRORLEVEL%' == 0' SET strSendEmail=True

ECHO.
ECHO [INFO ] Show Full IP Configuration
ipconfig /all

ECHO.
ECHO [INFO ] Show Routing Table
ROUTE PRINT

ECHO.
ECHO [INFO ] Show ARP Table
ARP -a

ECHO.
ECHO [INFO ] Show ?? Table
nbtstat -n

ECHO.
ECHO [INFO ] Show Network Status
net view

ECHO.
ECHO [INFO ] Show Server Config
net config server

ECHO.
ECHO [INFO ] Show Workstation Config
net config workstation

ECHO.
ECHO [INFO ] Test TCP/IP Stack
PING 127.0.0.1

ECHO.
ECHO [INFO ] Test Name Lookup
PING localhost

ECHO.
ECHO [INFO ] Ping to IP: Default-Gateway
FOR /F "tokens=1,2,* delims=:. " %%A IN ('ipconfig /all') DO IF %%A%%B' == DefaultGateway' CALL :PingMe %%C Default-Gateway

ECHO.
ECHO [INFO ] Ping to IP: DNS-Server
FOR /F "tokens=1,2,* delims=:. " %%A IN ('ipconfig /all') DO IF %%A%%B' == DNSServers' CALL :PingMe %%C DNS-Server

ECHO.
ECHO [INFO ] NSLookup: Public NTP server
nslookup nz.pool.ntp.org

ECHO.
ECHO [INFO ] Ping to IP: NTP-Server
FOR /F "tokens=1,* delims=: " %%A IN ('nslookup nz.pool.ntp.org') DO IF %%A' == Address'   CALL :PingMe %%B NTP-Server
FOR /F "tokens=1,* delims=: " %%A IN ('nslookup nz.pool.ntp.org') DO IF %%A' == Addresses' CALL :PingMe %%B NTP-Server

ECHO.
ECHO [INFO ] TraceRT: Public NTP server
TraceRT.exe nz.pool.ntp.org
GOTO DoEnd

:PingMe
ECHO [INFO ] Ping to IP: %2 (%1)
Ping %1
GOTO End

:DoEnd
REM Email the logbook to IT Services on Error.
REM -----------------------------------------------------------------------
IF %strSendEmail%' == True' CALL "%~dp0Tools\SendMail.cmd" "%~n0 (%COMPUTERNAME%)" "%~dp0LogFiles\%~n0.Log"
ECHO ---------------- End  : %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime
IF %1' == /silent' GOTO End
GOTO AreYouSure

:Error
ECHO Error detected!
GOTO End

:End