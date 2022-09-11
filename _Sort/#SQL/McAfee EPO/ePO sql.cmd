c:
cd "\Program Files\Microsoft SQL Server\80\Tools\Binn"
@for /f "delims=/ tokens=1,2,3" %%A in ('date /t') do @for /f "delims=:. tokens=1,2,3" %%D in ('time /t') do @for /f "tokens=2-8" %%M in ('echo %%A %%B %%C %%D %%E %%F') do set DateStamp=%%O%%N%%M&& set DateTimeStamp=%%O%%N%%M-%%R%%S%%P%%Q
echo DATE=%DateStamp% and DATETIME=%DateTimeStamp%
goto DoBackup
goto showServerDetails

:ShowServerDetails
REM osql.exe -E -S localhost -d ePO_TOLSE01 -Q "Select ComputerName, DNSName, LastKnownTCPIP from ServerInfo "
osql.exe -E -S localhost\SQLExpress -d ePO4_TOLSE02 -Q "Select ComputerName, DNSName, LastKnownTCPIP from EPOServerInfo "
goto end

:SetServerIP
REM osql.exe -E -S localhost -d ePO_TOLSE01 -Q "Update ServerInfo set LastKnownTCPIP='10.203.30.81' where computername='TOLSE01' "
osql.exe -E -S localhost\SQLExpress -d ePO4_TOLSE02 -Q "Update EPOServerInfo set LastKnownTCPIP='10.203.30.93' where computername='TOLSE02' "
goto end

:DoBackup
REM osql.exe -E -S localhost -d ePO_TOLSE01 -Q "backup database ePO_TOLSE01 to disk='D:\Backup-Config-Dump\McAfeeProtectionPilot\ePODB-%DateTimeStamp%.bak' "
MKDIR "D:\Backup-Config-Dump\McAfeeePolicyOrchestrator\"
IF NOT EXIST "D:\Backup-Config-Dump\McAfeeePolicyOrchestrator\." ECHO Backup Folder does not exist!
IF EXIST "D:\Backup-Config-Dump\McAfeeePolicyOrchestrator\." Osql.exe -E -S localhost\SQLExpress -d ePO4_TOLSE02 -Q "backup database ePO4_TOLSE02 to disk='D:\Backup-Config-Dump\McAfeeePolicyOrchestrator\ePODB-%DateTimeStamp%.bak' "
goto end

:end
pause
