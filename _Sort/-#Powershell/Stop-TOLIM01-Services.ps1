Get-Service | where {($_.DisplayName -like '*lync*')} | Stop-Service
Get-Service | where {($_.DisplayName -like '*lync*')} | Stop-Service -force

Get-Service | where {($_.DisplayName -like '*sql*')} | Stop-Service
Get-Service | where {($_.DisplayName -like '*sql*')} | Stop-Service -force
