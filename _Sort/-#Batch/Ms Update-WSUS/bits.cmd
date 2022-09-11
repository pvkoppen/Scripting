@echo off
if %1' == ' goto begin
if %1' == reset' goto Reset
if %1' == GetList' goto GetList
if %1' == DoCommand' goto DoCommand
goto end

:begin
Echo -- Start Pre-Processing BITS
bitsadmin /list /allusers
Echo -- Start Processing BITS
for /F "delims=}" %%A in ('call %0 GetList PEND') do call %0 DoCommand %%A}
for /F "delims=}" %%A in ('call %0 GetList ERRO') do call %0 DoCommand %%A}
for /F "delims=}" %%A in ('call %0 GetList CONN') do call %0 DoCommand %%A}
for /F "delims=}" %%A in ('call %0 GetList QUEU') do call %0 DoCommand %%A}
Echo -- Done Processing BITS
pause
goto end

:Reset
"C:\Program Files\Update Services\Tools\wsusutil.exe" reset
goto end

:GetList
bitsadmin /list /allusers |find "%2"
Goto end

:DoCommand
echo %2
bitsadmin /geterror %2
bitsadmin /SetNotifyCmdLine %2 notepad.exe NULL
goto end

:end
rem suspended
rem connecting
rem queued
rem ERROR FILE:    http://au.download.windowsupdate.com/msdownload/update/v3-19990518/cabpool/mainsp2ff_ecb460187e254225a3757163418cddf4ecdc313b.cab -> D:\WSUS\WsusContent\3B\ECB460187E254225A3757163418CDDF4ECDC313B.CAB