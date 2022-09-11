
# -- Variables
# ----------------------------------------
# -- Email
$emailFrom    = "Tasks on $($env:computername) <noreply@methanex.com>"
$emailTo      = "Taranaki Monitoring <taranakimonitoring@datacom.co.nz>"
$emailCC      = ""
$smtpServer   = "smtp.dcsmot.mtx.co.nz"
$screenwidth  = 150
# -- Counters
$dayofMonth   = 1
# -- Selection
$tmpPath      = "D:\Admin\Temp\"
$wsusServer   = "dcsmotsv07"
$wsusPort     = 8530
# -- Filters (-Like)
# -- Exclusions (-contains)

# -- One Off settings.
# ----------------------------------------

# -- Debug
# ----------------------------------------
# uncomment this section for diagnostics, if you don't want to spam everyone:
<#
$emailTo      = "User <stum@datacom.co.nz>"
$emailCC      = ""
#>

# -- PrintKeyValues
# ----------------------------------------
Write-Output "From: $emailFrom"
Write-Output "To: $emailTo"
Write-Output "CC: $emailCC"
Write-Output "smtpServer: $smtpServer"
# ----------------------------------------

Write-Host "[INFO ] Report on all AD User Accounts"
if ( $(Get-Date -Format dd) -eq $dayofMonth) {
    Get-ADUser -filter * -Properties CanonicalName,Company,Description,Mail,Enabled,LockedOut,PasswordNeverExpires,PasswordExpired,AccountExpirationDate,msDS-UserPasswordExpiryTimeComputed | sort CanonicalName | Select CanonicalName,Enabled,GiveName,Surname,SamAccountName,Company,Description,Mail,LockedOut,PasswordNeverExpires,PasswordExpired,AccountExpirationDate,msDS-UserPasswordExpiryTimeComputed | Export-CSV -Path "$tmpPath\AD-Users.csv" -Force
    Send-MailMessage -from $emailFrom -to $EmailTo -subject "Tasks on $($env:computername) for $(Get-Date -Format MMMyyyy)" -body "See Attachment" -smtpServer $smtpServer -bodyashtml -Attachments "$tmpPath\AD-Users.csv"
}

Write-Host "[INFO ] Cleanup WSUS"
if ( $(Get-Date -Format dd) -eq $dayofMonth) {
	$Result = Get-WsusServer -Name $wsusServer -PortNumber $wsusPort | Invoke-WsusServerCleanup  -CleanupObsoleteComputers -CleanupObsoleteUpdates -CleanupUnneededContentFiles -CompressUpdates -DeclineExpiredUpdates -DeclineSupersededUpdates -Verbose
    Send-MailMessage -from $emailFrom -to $EmailTo -subject "Tasks on $($env:computername) for $(Get-Date -Format MMMyyyy)" -body "$Result" -smtpServer $smtpServer -bodyashtml -Attachments "$tmpPath\AD-Users.csv"
}

Write-Host "[INFO ] PuTTY"
if ( $(Get-Date -Format dd) -eq 10) {
    $cmd = @'
    CMD /C "C:\Program Files\PuTTY\plink.exe" a-switchconfig@192.168.8.11 -pw "MuavRn7xeI5oCPog78hL" sh run
'@
    Invoke-Expression -Command:$cmd | Out-File "$tmpPath\NexusA-Running.txt" -Force
    $cmd = @'
    CMD /C "C:\Program Files\PuTTY\plink.exe" a-switchconfig@192.168.8.11 -pw "MuavRn7xeI5oCPog78hL" dir
'@
    Invoke-Expression -Command:$cmd | Out-File "$tmpPath\NexusA-dir.txt" -Force
    $cmd = @'
    CMD /C "C:\Program Files\PuTTY\plink.exe" a-switchconfig@192.168.8.12 -pw "MuavRn7xeI5oCPog78hL" sh run
'@
    Invoke-Expression -Command:$cmd | Out-File "$tmpPath\NexusB-Running.txt" -Force
    $cmd = @'
    CMD /C "C:\Program Files\PuTTY\plink.exe" a-switchconfig@192.168.8.12 -pw "MuavRn7xeI5oCPog78hL" dir
'@
    Invoke-Expression -Command:$cmd | Out-File "$tmpPath\NexusB-dir.txt" -Force
    Send-MailMessage -from $emailFrom -to $EmailTo -subject "Tasks on $($env:computername) for $(Get-Date -Format MMMyyyy)" -body "See Attachment" -smtpServer $smtpServer -bodyashtml -Attachments "$tmpPath\NexusA-Running.txt","$tmpPath\NexusA-dir.txt","$tmpPath\NexusB-Running.txt","$tmpPath\NexusB-dir.txt"
  }
