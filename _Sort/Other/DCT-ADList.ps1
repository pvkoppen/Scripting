
get-aduser -filter * -Properties * | sort CanonicalName | ft DistinguishedName
Get-ADComputer -filter * -Properties * | sort Name | ft DistinguishedName
Get-ADGroup -Filter * -Properties * | sort CanonicalName | ft DistinguishedName
Get-ADOrganizationalUnit

mkdir "D:\Admin\Backups\GPO" -ErrorAction Ignore
$tmpList = Get-GPO -all 
foreach ($tmpOne in $tmpList) {
  Get-GPOReport -guid $($tmpOne.id) -ReportType html -Path "D:\Admin\Backups\GPO\$($tmpOne.DisplayName.Replace("?","#")).html"
}

# dmzwvlsv06: VSC; dmzwvlsv16: PFSense; dmzwvlsv18: Forti-analyser.
wmic /node:dmzwvlsv01,dmzwvlsv02,dmzwvlsv03,dmzwvlsv04,dmzwvlsv05,dmzwvlsv07,dmzwvlsv08,dmzwvlsv12,dmzwvlsv15,dmzwvlsv17 nicconfig get Index,DNSHostName,IPAddress,IPSubnet,DefaultIPGateway,DHCPEnabled,DNSDomainSuffixSearchOrder


Send-MailMessage -body $(Get-Content D:\Admin\Scripts\Health\Invoke-WindowsHealthCheck.ps1).ToString -From pvankoppen@methanex.com -SmtpServer smtp.dmzwvl.mtx.co.nz -To pvankoppen@methanex.com -Subject Script
Send-MailMessage -Attachments D:\Admin\Scripts\Health\Invoke-WindowsHealthCheck.ps1 -Body "See Attachment" -BodyAsHtml -From pvankoppen@methanex.com -SmtpServer smtp.dmzwvl.mtx.co.nz -To pvankoppen@methanex.com -Subject Script
Send-MailMessage -Attachments D:\Admin\LogFiles\putty-10.100.35.13-20190114.log,D:\Admin\LogFiles\putty-10.100.35.14-20190114.log -Body "See Attachment" -BodyAsHtml -From pvankoppen@methanex.com -SmtpServer smtp.dmzwvl.mtx.co.nz -To pvankoppen@methanex.com
[STRING]$PvK =Get-Content D:\Admin\Scripts\Health\Invoke-WindowsHealthCheck.ps1
Send-MailMessage -body $PvK -From pvankoppen@methanex.com -SmtpServer smtp.dmzwvl.mtx.co.nz -To pvankoppen@methanex.com -Subject Script
Send-MailMessage -to pvankoppen@methanex.com -from "$($env:computername)@methanex.com" -subject "See Attachment" -Body "See Attachment" -SmtpServer smtp -Attachments D:\Admin\Scripts\Start-McAfeeDownload.zip

copy scp://anonymous@10.100.35.41/nxos/nxos.9.2.2.bin bootflash:///nxos.9.2.2.bin compact

#User List
get-aduser -filter * -properties Company,Description,Mail,Enabled,LockedOut,PasswordNeverExpires,AccountExpirationDate,msDS-UserPasswordExpiryTimeComputed | Select Company,Description,Mail,Enabled,LockedOut,PasswordNeverExpires,AccountExpirationDate,msDS-UserPasswordExpiryTimeComputed,UserPrincipalName,Name,GivenName,Surname | Export-Csv D:\Admin\LogFiles\ADUsers.csv
Send-MailMessage -Attachments D:\Admin\LogFiles\ADUsers.csv -Body "See Attachment" -BodyAsHtml -From pvankoppen@methanex.com -SmtpServer smtp.dmzwvl.mtx.co.nz -To datacom@methanex.com -Subject "Start of Month - User List"

# check for: Password Expiry
Write-Output "Sending Password Expiry Email"
$PWAccounts = get-aduser -filter {(Enabled -eq True)} -Properties Company,Description,Mail,Enabled,LockedOut,PasswordNeverExpires,AccountExpirationDate,msDS-UserPasswordExpiryTimeComputed | 
	Where-Object { ((-NOT [string]::IsNullOrEmpty($_.AccountExpirationDate)) -and ($_.AccountExpirationDate -lt (get-Date).AddDays($passwordAlertDays)) -and ($_.AccountExpirationDate -gt (get-Date).AddDays(-1))) `
	  -or (([datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed") -lt (Get-Date).AddDays($passwordAlertDays)) -and ([datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed") -gt (Get-Date).AddDays(-1)))}

foreach ( $account in $PWAccounts) {
  
  Select-Object Name,LockedOut,@{Name="PWNeverExpire";Expression={$_.PasswordNeverExpires}},AccountExpirationDate,@{Name="PWExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}},Company,mail,Description
Write-Output "datacomAccounts: $datacomAccounts"
if (-not $datacomAccounts) { $datacomAccounts = "...none found.`n" }
else { $problemFound = $true }
