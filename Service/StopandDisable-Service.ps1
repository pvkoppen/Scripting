$servers = Get-ADComputer -filter {(OperatingSystem -Like '*Windows Server*') -and (Enabled -eq $true)} | where-object {$_.name -like '*motsv034'} | Sort-Object Name
$servers | foreach {
    try {
        $service = Get-Service -ComputerName $_.Name -name "Spooler"
		$service | Stop-Service
        $service | Set-Service -StartupType Disabled
        Write-Host "[INFO ] Server Completed: $($_.Name), Status was $($service.status), startuptype: $($service.StartupType)."
    } catch {
        Write-Host "[ERROR] Server Failed: $($_.Name)"
    }
}