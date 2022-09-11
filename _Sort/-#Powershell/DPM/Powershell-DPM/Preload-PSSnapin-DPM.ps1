if (!(Get-PSSnapin microsoft.dataprotectionmanager.powershell))
{
write-host "Adding PS Snapin for DPM." -Fore Green
add-PSSnapin Microsoft.DataProtectionManager.PowerShell
}
else
{
write-host "PS Snapin for DPM already loaded." -Fore Green
}
