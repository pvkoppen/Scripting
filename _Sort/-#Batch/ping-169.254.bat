@Echo off
if %1' == ' goto First
if %2' == ' goto Second
if %3' == ' goto First
if %4' == ' goto Second
goto DoPing

:First
call %0 0 %*
call %0 1 %*
call %0 2 %*
call %0 3 %*
call %0 4 %*
call %0 5 %*
call %0 6 %*
call %0 7 %*
call %0 8 %*
call %0 9 %*
goto end

:Second
call %0 0 %*
call %0 1 %*
call %0 2 %*
call %0 3 %*
call %0 4 %*
call %0 5 %*
call %0 6 %*
call %0 7 %*
call %0 8 %*
call %0 9 %*
call %0 10 %*
call %0 11 %*
call %0 12 %*
call %0 13 %*
call %0 14 %*
call %0 15 %*
call %0 16 %*
call %0 17 %*
call %0 18 %*
call %0 19 %*
call %0 20 %*
call %0 21 %*
call %0 22 %*
call %0 23 %*
call %0 24 %*
call %0 25 %*
goto end

:DoPing
ping -w 30 169.254.%4%3.%2%1 >> %0.log 2>>&1
goto end

:end