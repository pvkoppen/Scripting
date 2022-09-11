@Echo Off
if %1' == ' goto New
if %2' == ' goto Perform
goto PerformSecond

:New
call %0 0
call %0 1
call %0 2
call %0 3
call %0 4
call %0 5
call %0 6
call %0 7
call %0 8
call %0 9
call %0 10
call %0 11
call %0 12
call %0 13
call %0 14
call %0 15
goto end

:Perform
call %0 %1 0
call %0 %1 1
call %0 %1 2
call %0 %1 3
call %0 %1 4
call %0 %1 5
call %0 %1 6
call %0 %1 7
call %0 %1 8
call %0 %1 9
goto end

:PerformSecond
ping 10.203.210.%1%2 >> %0.log 2>>&1
goto end

:end

