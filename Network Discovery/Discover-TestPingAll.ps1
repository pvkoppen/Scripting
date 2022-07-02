<#

CALL :Start 10.203.1
CALL :Start 10.203.10
CALL :Start 10.203.30
CALL :Start 10.203.200
CALL :Start 10.203.201
CALL :Start 10.203.202
CALL :Start 10.203.203
CALL :Start 10.203.235
CALL :Start 10.220.157 Fonterra-Kaponga
CALL :Start 172.23.42 MXNZ?-V1A
CALL :Start 172.23.43 MXNZ?-V1B
CALL :Start 172.23.45 MXNZPRT-Old
CALL :Start 172.23.48 MXNZWVL-OldData1
CALL :Start 172.23.49 MXNZWVL-OldData2
CALL :Start 172.23.50 MXNZAKL-Data
CALL :Start 172.23.62 MXNZAKL-Data
CALL :Start 172.23.63 MXNZAKL-..
CALL :Start 172.23.64 MXNZAKL-..
CALL :Start 172.23.88 MXNZWVL-88
CALL :Start 172.23.89 MXNZWVL-89
CALL :Start 172.23.90 MXNZWVL-90
CALL :Start 172.23.91 MXNZWVL-91
CALL :Start 172.23.96 MXNZNPY-WVL-..
CALL :Start 172.23.98 MXNZNPY-VLAN70-Servers
CALL :Start 172.23.99 MXNZNPY-..
CALL :Start 172.23.100 MXNZNPY-VPN
CALL :Start 172.23.105 MXNZNPY-?
CALL :Start 172.23.118 MXNZ-TA01-Data
CALL :Start 172.23.119 MXNZ-TA01-Voice
CALL :Start 172.23.124 MXNZPRT-All
CALL :Start 172.23.145 MXNZPRT-Old2
CALL :Start 172.23.148 MXNZWVL-OldVoice1
CALL :Start 172.23.149 MXNZWVL-OldVoice2
CALL :Start 172.23.200 MXEGDAM-V200
CALL :Start 172.23.192 MXEGDAM-Vxxx
CALL :Start 172.23.221 MXEGDAM-Vxxx
CALL :Start 192.168.1
CALL :Start 192.168.15
CALL :Start 192.168.50

ECHO [INFO ] ---- Start processing network: %1.x
FOR %%A IN (.) DO FOR %%B IN (0) DO FOR %%C IN (0 1 2 3 4 5 6 7 8 9) DO CALL :PingWS %1 %%A %%C 
FOR %%A IN (.) DO FOR %%B IN (1 2 3 4 5 6 7 8 9) DO FOR %%C IN (0 1 2 3 4 5 6 7 8 9) DO CALL :PingWS %1 %%A %%B %%C
FOR %%A IN (.1) DO FOR %%B IN (0 1 2 3 4 5 6 7 8 9) DO FOR %%C IN (0 1 2 3 4 5 6 7 8 9) DO CALL :PingWS %1 %%A %%B %%C
FOR %%A IN (.2) DO FOR %%B IN (0 1 2 3 4) DO FOR %%C IN (0 1 2 3 4 5 6 7 8 9) DO CALL :PingWS %1 %%A %%B %%C
FOR %%A IN (.2) DO FOR %%B IN (5) DO FOR %%C IN (0 1 2 3 4 5) DO CALL :PingWS %1 %%A %%B %%C
ECHO [INFO ] ---- Completed processing network: %1.x

:PingWS
IF %4' == 0' ECHO [INFO ] Testing: %1%2%3%4
IF %3%4' == 0' ECHO [INFO ] Testing: %1%2%3%4
IF %2%3%4' == 0' ECHO [INFO ] Testing: %1%2%3%4
Ping -w 2 %1%2%3%4 >nul
IF %ERRORLEVEL%' == 0' GOTO Success
GOTO Failed

:Success
ECHO [INFO ] Ping successful for WS: %1%2%3%4
NSLookup %1%2%3%4 | find "Name:"

:Failed
REM ECHO [ERROR] WS=%1%2%3%4

#>

$baseIP = "10.213.30"
$baseIP = "10.213.100"
(0..255) | foreach  {
    $FullIP = "$baseIP.$_"
    if ("$_" -like "*0") {Write-Host "$($FullIP): ... [$((Get-Date).ToString("HH:mm"))]"}
    $ping = Test-Connection -ComputerName "$FullIP" -Count 2 -Quiet -ErrorAction SilentlyContinue
    if ($ping) { Write-Host "$($FullIP): Success" } else { <#Write-Host "$($FullIP): Failed"#> }
}
