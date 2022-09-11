Run the following script to change DNS on all network interfaces.

Import-Module ActiveDirectory
#New DNS Servers in order
$NewDNS = @("172.23.98.161","172.23.97.72")
$NewDNS | ForEach-Object -Begin { Write-Output "The following DNS servers in order will be set on the machines:" ; $index = 1} -Process { Write-Output "#$($index): $_" ; $index++ }
#Get all servers in active directory (excluding domain controllers)
$ServersToChange = (Get-ADComputer -Filter {name -like "mxnznpy*" -and enabled -eq $true}).Name
#Loop through all servers and change to the new DNS servers
foreach ($Server in $ServersToChange) {
    if (Test-Connection -ComputerName $Server -Count 1 -Quiet -ErrorAction Ignore -WarningAction Ignore) {
        try {
            $wmi = Get-WmiObject -Class win32_networkadapterconfiguration -Filter "ipenabled = 'true'" -ComputerName $Server
            $wmi.SetDNSServerSearchOrder($NewDNS) | Out-Null
            Write-Output "SUCCESS: Changed DNS on $Server"
        } catch {
            Write-Warning "Error changing DNS on $Server"
        }
    } else {
        Write-Warning "Error contacting $Server`r`nDoes it respond to ping/wmi?"
    }
}

After this script has been run, check servers which have dual NICs - MXNZNPY34 (commvault) and MXNZNPY66 (LPR) as these have NICs on different networks (Storage, remote printing firewall etc)