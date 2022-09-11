::@ECHO OFF

::SQL Server 2000 - TOLSE01
SET SQLPath=C:\Program Files\Microsoft SQL Server\80\Tools\Binn\
::SQL Server 2008 - TOLSE02
SET SQLPath=C:\Program Files\Microsoft SQL Server\100\Tools\Binn\
SET strSQLInstance=localhost\SQLEXPRESS
SET strSQLDB=MailMarshal
SET strBackup=D:\Backup-Config-Dump\


IF %1' == /Backup'  GOTO DoBackup
IF %1' == /Restore' GOTO DoRestore
IF %1' == /Purge'   GOTO DoPurge
IF %1' == /Shrink'  GOTO DoShrink
ECHO Invalid Parameter: %*
GOTO DoEnd

:GetDateTime
@FOR /f "delims=/ tokens=1,2,3" %%A IN ('date /t') DO @FOR /f "delims=:. tokens=1,2,3" %%D IN ('time /t') DO @FOR /f "tokens=2-8" %%M IN ('ECHO %%A %%B %%C %%D %%E %%F') DO SET DateStamp=%%O%%N%%M&& SET DateTimeStamp=%%O%%N%%M-%%R%%S%%P%%Q
ECHO DATE='%DateStamp%' and DATETIME='%DateTimeStamp%'
GOTO End

:DoBackup
CALL :GetDateTime
MKDIR %strBackup%MailMarshal\
"%SQLPath%osql.exe" -E -S %strSQLInstance% -d %MailMarshal% -Q "backup database %MailMarshal% to disk='%strBackup%MailMarshal\MMDBBackup-%DateTimeStamp%.bak' "
GOTO DoEnd

:DoRestore
IF %2' == ' GOTO RestoreFileMissing
IF NOT EXIST "%2" GOTO RestoreFileMissing
IF NOT %~e2' == .bak' GOTO RestoreFileType
"%SQLPath%osql.exe" -E -S %strSQLInstance% -d %MailMarshal% -Q "restore database %MailMarshal% from disk='%strBackup%MailMarshal\MMDBBackup-%DateTimeStamp%.bak' "
GOTO DoEnd

:DoPurge
CALL :GetDateTime
IF %2' == ' SET PurgeDate=%DateStamp%
IF NOT %2' == ' SET PurgeDate=%2
"%SQLPath%osql.exe" -E -S %strSQLInstance% -d %MailMarshal% -Q "exec dbo.PurgeMessages @PurgeDate = '%PurgeDate%', @MaxRecords = 50000 "
GOTO DoEnd

:DoShrink
"%SQLPath%osql.exe" -E -S %strSQLInstance% -d %MailMarshal% -Q "dbcc shrinkdatabase ('%MailMarshal%') "
GOTO DoEnd

:RestoreMissingFile
:RestoreFileType
ECHO Error
GOTO DoEnd

:DoEnd
Pause
GOTO End
:End

