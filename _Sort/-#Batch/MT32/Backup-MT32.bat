
SET ProgramFolder=C:\Program Files\Borland\InterBase\bin\
SET MedtechFolder=D:\mt32\
SET BackupFolder=D:\Backup-Config-Dump\Medtech32\

GOTO Backup

:Backup
FOR /F "tokens=1-9 delims=:. " %%a IN ('time /t') DO SET filetime=%%c%%d%%a00
IF EXIST %BackupFolder%%filetime%.log DEL %BackupFolder%%filetime%.log
IF EXIST %BackupFolder%%filetime%-mt32.bak DEL %BackupFolder%%filetime%-mt32.bak

"%ProgramFolder%gbak.exe" -B -V -USER sysdba -PAS masterkey -Y "%BackupFolder%%filetime%.log" localhost:%MedtechFolder%data\mt32.ib "%BackupFolder%%filetime%-mt32.bak" 
GOTO End

:End
