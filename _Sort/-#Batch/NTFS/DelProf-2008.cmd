@echo off
setlocal
set keep=$$$$$$$$
if {%1}=={} goto syntax
set older=%1
if "%older%" EQU "0" goto OK
if "%older:~0,1%" LEQ "0" goto syntax
if "%older:~0,1%" GTR "9" goto syntax
:OK
if not {%2}=={} set keep=%2
set bypass=N
set pipkey=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion
\ProfileListregedit /a %TEMP%\profilelist.reg "HKEY_LOCAL_MACHINE
\Software\Microsoft\Windows NT\CurrentVersion\ProfileList"
set today=%date%
if "%today:~0,1%" GTR "9" set today=%date:~4%
set today=%today:/=%
set today=%today:~4,4%%today:~0,4%
set todayyy=%today:~0,4%
set todaymm=%today:~4,2%
set todaydd=%today:~6,2%
call jsidatem %todayyy% %todaymm% %todaydd% - %older%
for /f "Skip=5 Tokens=7 Delims=\]" %%a in ('type %TEMP%
\profilelist.reg') do set sid=%%a&call :getpip
endlocal
goto :EOF
:syntax
@echo Syntax: DelProfile NNdays [KeepUserName]
endlocal
goto :EOF
:IIIS
set bypass=N
If /i %1 EQU "%keep%" set bypass=Y&goto :EOF
set param=%1
set param=%param:"=%
If "%param:~0,5%" EQU "IUSR_" set bypass=Y&goto :EOF
If "%param:~0,5%" EQU "IWAM_" set bypass=Y&goto :EOF
goto :EOF
:getpip
for /f "Tokens=8 Delims=-" %%b in ('@echo %sid%') do set admin=%%b
if "%admin%"=="" goto :EOF
if "%admin%"=="500" goto :EOF
for /f "Skip=3 Tokens=2*" %%b in ('reg QUERY "%pipkey%%sid%" /v
ProfileImagePath') do call set pip=%%c
for /f "Tokens=2-5 Delims=\" %%b in ('@echo %pip%') do set usr1=%
%b&set usr2=%%c&set usr3=%%d&set usr4=%%e
if not "%usr4%"=="" call :IIIS "%usr4%"&if "%bypass%" EQU "Y"
goto :EOF
if not "%usr3%"=="" call :IIIS "%usr3%"&if "%bypass%" EQU "Y"
goto :EOF
if not "%usr2%"=="" call :IIIS "%usr2%"&if "%bypass%" EQU "Y"
goto :EOF
if not "%usr1%"=="" call :IIIS "%usr1%"&if "%bypass%" EQU "Y"
goto :EOF
for /f "Tokens=1,4" %%b in ('dir "%pip%\ntuser.dat" /4 /a /tW ^|
Findstr /I /L "NTUSER.DAT"') do set dstring=%%b
set dstring=%dstring:/=%
set dstring=%dstring:~4,4%%dstring:~0,4%
if "%dstring%" GTR "%AYMD%" goto :EOF
@echo Delete "%pip%"
reg DELETE "%pipkey%%sid%" /f
RD "%pip%" /s /q