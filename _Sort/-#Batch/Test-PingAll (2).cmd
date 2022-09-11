@ECHO OFF

GOTO Begin
CALL :Start 10.203.1
CALL :Start 10.203.10
CALL :Start 10.203.30
CALL :Start 10.203.200
CALL :Start 10.203.201
CALL :Start 10.203.202
CALL :Start 10.203.203
CALL :Start 10.203.235
CALL :Start 10.220.157 Fonterra-Kaponga
CALL :Start 192.168.1
CALL :Start 192.168.15
CALL :Start 192.168.50
GOTO End

:Begin
CALL :Start 10.220.157 Fonterra-Kaponga
GOTO End

:Start
ECHO.
ECHO [INFO ] ---- Start processing network: %1.x
FOR %%A IN (.) DO FOR %%B IN (0) DO FOR %%C IN (0 1 2 3 4 5 6 7 8 9) DO CALL :PingWS %1 %%A %%C 
FOR %%A IN (.) DO FOR %%B IN (1 2 3 4 5 6 7 8 9) DO FOR %%C IN (0 1 2 3 4 5 6 7 8 9) DO CALL :PingWS %1 %%A %%B %%C
FOR %%A IN (.1) DO FOR %%B IN (0 1 2 3 4 5 6 7 8 9) DO FOR %%C IN (0 1 2 3 4 5 6 7 8 9) DO CALL :PingWS %1 %%A %%B %%C
FOR %%A IN (.2) DO FOR %%B IN (0 1 2 3 4) DO FOR %%C IN (0 1 2 3 4 5 6 7 8 9) DO CALL :PingWS %1 %%A %%B %%C
FOR %%A IN (.2) DO FOR %%B IN (5) DO FOR %%C IN (0 1 2 3 4 5) DO CALL :PingWS %1 %%A %%B %%C
ECHO [INFO ] ---- Completed processing network: %1.x
ECHO.
GOTO DoEnd

:PingWS
IF %4' == 0' ECHO [INFO ] Testing: %1%2%3%4
IF %3%4' == 0' ECHO [INFO ] Testing: %1%2%3%4
IF %2%3%4' == 0' ECHO [INFO ] Testing: %1%2%3%4
Ping -w 2 %1%2%3%4 >nul
IF %ERRORLEVEL%' == 0' GOTO Success
GOTO Failed

:Success
ECHO [INFO ] Ping successful for WS: %1%2%3%4
NSLookup %1%2%3%4 | find "Name:"
GOTO End

:Failed
REM ECHO [ERROR] WS=%1%2%3%4
GOTO End

:DoEnd
pause
GOTO End

:End

