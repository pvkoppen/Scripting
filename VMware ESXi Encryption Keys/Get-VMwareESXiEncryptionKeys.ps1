Connect-VIServer -Server [name]
#Connect-VIServer -Server [name2]

#
$VMHosts = Get-VMHost | Sort-Object
$VMHostKeys = @()
foreach ($VMHost in $VMHosts) {
    $esxcli = Get-EsxCli -VMHost $VMHost -V2
    try {
        $encryption = $esxcli.system.settings.encryption.get.Invoke()
        if ($encryption.Mode -eq "TPM")
        {
            $key = $esxcli.system.settings.encryption.recovery.list.Invoke()
            $hostKey = [pscustomobject]@{
                Host = $VMHost.Name
                EncryptionMode = $encryption.Mode
                RequireExecutablesOnlyFromInstalledVIBs = $encryption.RequireExecutablesOnlyFromInstalledVIBs
                RequireSecureBoot = $encryption.RequireSecureBoot
                RecoveryID = $key.RecoveryID
                RecoveryKey = $key.Key
            }
            $VMHostKeys += $hostKey
        }
        else
        {
            $hostKey = [pscustomobject]@{
                Host = $VMHost.Name
                EncryptionMode = $encryption.Mode
                RequireExecutablesOnlyFromInstalledVIBs = $encryption.RequireExecutablesOnlyFromInstalledVIBs
                RequireSecureBoot = $encryption.RequireSecureBoot
                RecoveryID = $null
                RecoveryKey = $null
            }
            $VMHostKeys += $hostKey
        }
    }
    catch {
        $VMHost.Name + $_
    }
}
$VMHostKeys

#
Disconnect-VIServer -Server * -Confirm:$False
