@ECHO OFF

set StrIP=192.168.1
set StrIP=10.203.100
set StrIP=10.203.240

FOR %%A in (.) DO For %%B in (0) DO For %%C  in (1 2 3 4 5 6 7 8 9) do CALL :PingMe %StrIP% %%A%%C
FOR %%A in (.) DO For %%B in (1 2 3 4 5 6 7 8 9) DO For %%C  in (0 1 2 3 4 5 6 7 8 9) do CALL :PingMe %StrIP% %%A%%B%%C
FOR %%A in (.1) DO For %%B in (0 1 2 3 4 5 6 7 8 9) DO For %%C  in (0 1 2 3 4 5 6 7 8 9) do CALL :PingMe %StrIP% %%A%%B%%C
FOR %%A in (.2) DO For %%B in (0 1 2 3 4) DO For %%C  in (0 1 2 3 4 5 6 7 8 9) do CALL :PingMe %StrIP% %%A%%B%%C
FOR %%A in (.2) DO For %%B in (5) DO For %%C  in (0 1 2 3 4) do CALL :PingMe %StrIP% %%A%%B%%C
pause
GOTO End

:PingMe
ping -w 2 %1%2 >nul
IF %ERRORLEVEL%' == 0' GOTO Success
GOTO FaileD

:Success
ECHO [INFO ] IP: %1%2
nslookup %1%2
GOTO End

:Failed
ECHO [ERROR] IP: %1%2
GOTO End

:End
