c:
cd "\Program Files\Microsoft SQL Server\80\Tools\Binn"
goto showServerDetails

:ShowServerDetails
osql.exe -E -S localhost -d ePO_TOLSE01 -Q "Select ComputerName, DNSName, LastKnownTCPIP from ServerInfo "
goto end

:SetServerIP
osql.exe -E -S localhost -d ePO_TOLSE01 -Q "Update ServerInfo set LastKnownTCPIP='10.203.30.81' where computername='TOLSE01' "
goto end

:end
pause
