Get-Service | where {($_.DisplayName -like '*lync*')} | Stop-Service
Get-Service | where {($_.DisplayName -like '*lync*')} | Stop-Service -force

Get-Service | where {($_.DisplayName -like '*sql*')} | Stop-Service
Get-Service | where {($_.DisplayName -like '*sql*')} | Stop-Service -force

robocopy /r:1 /w:1 /e /copyall /mir /sl d:\ f:\

Get-Service | where {($_.DisplayName -like '*sql*')} | Start-Service

Get-Service | where {($_.DisplayName -like '*lync*')} | Start-Service
