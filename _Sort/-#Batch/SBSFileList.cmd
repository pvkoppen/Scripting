REM Get the current time to make Log and Dump files unique.
REM --------------------------------------------------------
for /f "tokens=1-9 delims=:. " %%a in ('time /t') do set filetime=%%a%%b%%c%%d
for /f "tokens=1-9 delims=/ " %%A in ('date /t') do set filedate=%%A%%B%%C%%D
echo drive-path-name-ext=%~dpnx0

c:
cd \
goto All

:JustSBS
dir *sbs* /s > %~dpn0.%filetime%.log 2>>&1
dir *small* /s >> %~dpn0.%filetime%.log 2>>&1
cd "\Program Files\Microsoft Windows Small Business Server"
dir /q /on /s /x /4 >> %~dpn0.%filetime%.log 2>>&1
cd "\Program Files\Windows for Small Business Server"
dir /q /on /s /x /4 >> %~dpn0.%filetime%.log 2>>&1
goto End

:All
c:
cd \
dir /q /on /s /x /4 >> %~dpn0.%filedate%.%filetime%.C.log 2>>&1
D:
cd \
dir /q /on /s /x /4 >> %~dpn0.%filedate%.%filetime%.D.log 2>>&1
U:
cd \
dir /q /on /s /x /4 >> %~dpn0.%filedate%.%filetime%.U.log 2>>&1
goto End

:End
pause
