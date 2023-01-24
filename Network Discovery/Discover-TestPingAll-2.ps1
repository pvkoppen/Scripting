(1..254) | foreach {
    $result = Test-NetConnection -ComputerName 172.31.72.$_ -WarningVariable ResultWarn
    #$result | fl *
    if ($result.PingSucceeded) { Write-Host "[Success] 172.31.72.$_"
    } else {
        #$result.PingReplyDetails | fl *
        Write-Host "[Error] 172.31.72.$_ ($($result.PingReplyDetails.Status))"
    }
}

<#
[Success] 172.31.72.1
[Success] 172.31.72.2
[Success] 172.31.72.3
[Success] 172.31.72.4
[Success] 172.31.72.117
[Success] 172.31.72.118
[Success] 172.31.72.119
[Success] 172.31.72.120
[Success] 172.31.72.121
[Success] 172.31.72.122
[Success] 172.31.72.123
[Success] 172.31.72.125
[Success] 172.31.72.127
#>