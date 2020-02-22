@ECHO OFF
REM FOR /L %%A IN (1,1,1024) DO telnet 192.168.1.2 %%A && ECHO %errorlevel%
REM FOR /L %%A IN (1024,1,4000) DO telnet 192.168.1.2 %%A
REM FOR /L %%A IN (4000,1,6000) DO telnet 192.168.1.2 %%A
REM FOR /L %%A IN (6000,1,8000) DO telnet 192.168.1.2 %%A
FOR /L %%A IN (8000,1,9000) DO telnet 192.168.1.2 %%A
REM FOR /L %%A IN (9000,1,10000) DO telnet 192.168.1.2 %%A
REM FOR /L %%A IN (10000,1,12000) DO telnet 192.168.1.2 %%A
REM -- for /L %A IN (1,1,1024) do Telnet 192.168.1.2 %A >> C:\Admin\LogFiles\Seagate.log 2>>&1