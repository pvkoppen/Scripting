c:
cd "\Program Files\Microsoft SQL Server\80\Tools\Binn"
@for /f "delims=/ tokens=1,2,3" %%A in ('date /t') do @for /f "delims=:. tokens=1,2,3" %%a in ('time /t') do @for /f "tokens=2-8" %%M in ('echo %%A %%B %%C %%a %%b %%c') do set DateStamp=%%O%%N%%M&& set DateTimeStamp=%%O%%N%%M-%%R%%S%%P%%Q
echo DATE=%DateStamp% and DATETIME=%DateTimeStamp%
goto CleanupWSUS

:DoBackup
osql.exe -E -S localhost\wsus -d SUSDB -Q "backup database SUSDB to disk='D:\Backup-Config-Dump\WSUS\Backup-%DateTimeStamp%.bak' "
goto end

:DoRestore
osql.exe -E -S localhost -d SUSDB -Q "restore database SUSDB from disk='D:\Backup-Config-Dump\WSUS\Backup-%DateTimeStamp%.bak' "
goto end

:DoShrink
osql.exe -E -S tolwu01\wsus -d master -Q "dbcc shrinkdatabase ('SUSDB') "
goto end

:CleanupWSUS
ECHO. >> %0.log 2>>&1
ECHO ------------ %DateTimeStamp% ------------ >> %0.log 2>>&1
ECHO -- Stop WSUS Website >> %0.log 2>>&1
net stop w3svc >> %0.log 2>>&1
ECHO -- RemoveInactiveApprovals >> %0.log 2>>&1
"C:\Program Files\Update Services\Tools\wsusutil.exe" removeinactiveapprovals >> %0.log 2>>&1
ECHO -- DeleteUnneededRevisions >> %0.log 2>>&1
"C:\Program Files\Update Services\Tools\wsusutil.exe" deleteunneededrevisions >> %0.log 2>>&1
ECHO -- Start WSUS Website >> %0.log 2>>&1
net start w3svc >> %0.log 2>>&1
ECHO -- Debug: PurgeUnneededFiles >> %0.log 2>>&1
"D:\WSUS\Tools\wsusdebugtool.exe" /tool:PurgeUnneededFiles >> %0.log 2>>&1
ECHO -- Reset File Download Flags >> %0.log 2>>&1
"C:\Program Files\Update Services\Tools\wsusutil.exe" reset >> %0.log 2>>&1
ECHO -- MsSQL Shrink Database >> %0.log 2>>&1
"C:\Program Files\Microsoft SQL Server\80\Tools\Binn\osql.exe" -E -S tolwu01\wsus -d master -Q "dbcc shrinkdatabase ('SUSDB') " >> %0.log 2>>&1
ECHO -- Finished >> %0.log 2>>&1
goto End

:SQL
osql.exe -E -S tolwu01\wsus -d susdb -Q "select a.name, a.type, b.name, b.type, b.colid from sysobjects a,syscolumns b where a.id = b.id  and a.type not in ('FN','P','S','TF','V') order by a.name, b.colid"
goto End

:SQL2
GOTO End
C:\Program Files\Microsoft SQL Server\80\Tools\Binn>osql.exe -E -S tolwu01\wsus -d susdb -Q "select distinct a.type from sysobjects a,syscolumns b where a.id = b.id "
 type
 ----
 U
 S
 FN
 TF
 V
 P

(6 rows affected)


tbCategory
tbDeployment
tbFile
tbFileDownloadProgress
tbFileForRevision
tbFileOnServer
tbProperty
tbRevision
tbRevisionInCategory
tbSubscription
tbTarget
tbUpdate
GOTO End

:End
rem Pause
