c:
cd "\Program Files\Microsoft SQL Server\80\Tools\Binn"
@for /f "delims=/ tokens=1,2,3" %%A in ('date /t') do @for /f "delims=:. tokens=1,2,3" %%D in ('time /t') do @for /f "tokens=2-8" %%M in ('echo %%A %%B %%C %%D %%E %%F') do set DateStamp=%%O%%N%%M&& set DateTimeStamp=%%O%%N%%M-%%R%%S%%P%%Q
echo DATE=%DateStamp% and DATETIME=%DateTimeStamp%
goto DoBackup

:DoBackup
osql.exe -E -S localhost -d WebMarshal -Q "backup database WebMarshal to disk='D:\Backup-Config-Dump\WebMarshal\WebMarshal-%DateTimeStamp%.bak' "
goto end

:DoRestore
rem osql.exe -E -S localhost -d MailMarshal -Q "restore database MailMarshal from disk='D:\Backup-Config-Dump\MailMarshal\MMDBBackup-%DateTimeStamp%.bak' "
goto end

:DoPurge
rem osql.exe -E -S localhost -d MailMarshal -Q "exec dbo.PurgeMessages @PurgeDate = '%DateStamp%', @MaxRecords = 50000 "
goto end

:DoShrink
osql.exe -E -S localhost -d WebMarshal -Q "dbcc shrinkdatabase ('WebMarshal') "
goto end

:end
Pause
