
SET MedtechFolder=D:\mt32\
SET ProgramFolder=C:\Program Files\Borland\InterBase\bin\
SET BackupFolder=D:\mt32bak\

GOTO Restore

:Restore
SET filetime=0901pm
IF EXIST %BackupFolder%%filetime%-restore.log DEL %BackupFolder%%filetime%-restore.log
IF NOT EXIST %BackupFolder%%filetime%-mt32.bak GOTO FileMissing

REM Replace
ECHO Are you sure you want to restore Medtech with the OverWrite option?
ECHO Source: %BackupFolder%%filetime%-mt32.bak 
ECHO Target: localhost:%MedtechFolder%data\mt32.ib 
PAUSE
"%ProgramFolder%gbak.exe" -R -V -USER sysdba -PAS masterkey -Y %BackupFolder%%filetime%-restore.log %BackupFolder%%filetime%-mt32.bak localhost:%MedtechFolder%data\mt32.ib 
GOTO End

:FileMissing
ECHO The restore file is missing! 
PAUSE
GOTO End

:End
