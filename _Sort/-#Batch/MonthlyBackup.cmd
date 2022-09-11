ECHO - Make a Backup
for /f "tokens=1,2,3,4 delims=/ " %%a in ('date /t') do echo %%a-%%b-%%c-%%d
for /f "tokens=1,2,3,4 delims=/ " %%a in ('date /t') do set BK_FileName=Backup-%%c.bkf

C:\WINDOWS\system32\ntbackup.exe backup "@C:\Scripts\Monthly Backup.bks" /a /d "Monthly" /v:yes /r:no /rs:no /hc:off /m normal /j "Monthly Backup" /l:s /f "E:\PCA\%BK_FileName%"

Shutdown /f /r /t 5 /c "%0: Automated monthly restart"


CALL "%~dp0Tools\sendmail.cmd" "Restarting %COMPUTERNAME% after backup. (%~n0)"