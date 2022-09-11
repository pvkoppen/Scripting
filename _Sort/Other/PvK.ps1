
## Send-MailMessage
## ----------------
D:
CD \Admin\Scripts\Send-MailMessage
Send-MailMessage -Body "See Attachment" -BodyAsHtml -Encoding UTF8 -From "$($env:computername)@methanex.com" -SmtpServer smtp -Subject "See Attachment" -To "datacom@methanex.com" -Attachments D:\Admin\dcsmot-Admin.7z
PS C:\Users\A-itsupport> Send-MailMessage -From "$($env:computername)@$($env:userdnsdomain)" -SmtpServer smtp -Subject "Absolute Update" -To "petervan@datacom.co.nz" -body " ABSRADPC008, Powershell execution-policy, Installed Choco, Installed standard choco tools, Removed intelerad, installed intelerad x64, enabled dicom service, installed comrad test, installed comrad fw execption, installed intel support patches"

Send-MailMessage -Body "See Attachment" -BodyAsHtml -Encoding UTF8 -From "$($env:computername)@methanex.com" -SmtpServer smtp -Subject "See Attachment" -To "pvankoppen@methanex.com" -Attachments D:\Admin\Temp\dmzmot.7z

Send-MailMessage -Body "See Attachment" -BodyAsHtml -Encoding UTF8 -From "$($env:computername)@methanex.com" -SmtpServer smtp -Subject "See Attachment 1/3" -To "pvankoppen@methanex.com" -Attachments D:\Admin\Temp\dmzmot.7z.001


Send-MailMessage : Exceeded storage allocation. The server response was: 4.3.1 Session size exceeds fixed maximum
session size
At line:1 char:1
+ Send-MailMessage -Body "See Attachment" -BodyAsHtml -Encoding UTF8 -F ...
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : InvalidOperation: (System.Net.Mail.SmtpClient:SmtpClient) [Send-MailMessage], SmtpExcept
   ion
    + FullyQualifiedErrorId : SmtpException,Microsoft.PowerShell.Commands.SendMailMessage


## WSUS Cleanup
## ----------------
Get-WsusServer -Name dcsmotsv07 -PortNumber 8530 | Invoke-WsusServerCleanup  -CleanupObsoleteComputers -CleanupObsoleteUpdates -CleanupUnneededContentFiles -CompressUpdates -DeclineExpiredUpdates -DeclineSupersededUpdates -Verbose


## Cisco Switch CLI
## ----------------
UX-42301A# sh cli hist
term mon
term len 0
sh run
sh version
sh inv
dir
sh int status
sh cdp nei
sh lldp nei
sh ip int brief
sh ip route
conf t
cli alias name wrmem copy running-config startup-config
int vlan 18
shut
end
wrmem
sh cli hist


## AD Objects
## ----------------
get-aduser -filter * -properties * | sort CanonicalName | ft CanonicalName, SAMAccountName, PasswordNeverExpires, Enabled
get-adobject -Filter * -Properties * | Export-Csv -Path .\get-adobject.csv
get-adobject -Filter * -Properties * | Export-Csv -Path .\get-adobject.csv


## VMware Alert
## ----------------
This host is potentially vulnerable to issues described in CVE-2018-3646, please refer to https://kb.vmware.com/s/article/55636 for details and VMware recommendations. KB 55636


## VMware Drivers
## ----------------
esxcli software vib install -v file:/vmfs/volumes/dmzmot_nfs_systools/_Drivers/i40en-1.8.6-1OEM.650.0.0.4598673.x86_64.vib
esxcli software vib install -v file:/vmfs/volumes/dmzmot_nfs_systools/_Drivers/nenic-1.0.29.0-1OEM.650.0.0.4598673.x86_64.vib
esxcli software vib list

[root@UX-42352A:~] esxcli software vib list
Name                           Version                               Vendor              Acceptance Level  Install Date
-----------------------------  ------------------------------------  ------------------  ----------------  ------------
scsi-aacraid                   6.0.6.2.1.52011-1OEM.600.0.0.2494585  Adaptec_Inc         VMwareCertified   2018-04-16
lsi-msgpt35                    04.00.00.00-1OEM.650.0.0.4598673      Avago               VMwareCertified   2018-04-16
scsi-megaraid-sas              6.610.15.00-1OEM.600.0.0.2494585      Avago               VMwareCertified   2018-04-16
scsi-fnic                      1.6.0.34-1OEM.600.0.0.2494585         CSCO                VMwareCertified   2018-04-16
ucs-tool-esxi                  1.0.1-1OEM                            Cisco_Systems_Inc.  PartnerSupported  2018-04-16
nenic                          1.0.6.0-1OEM.650.0.0.4598673          Cisco               VMwareCertified   2018-04-16
i40en                          1.5.8-1OEM.650.0.0.4598673            INT                 VMwareCertified   2018-04-18
net-i40e                       2.0.7-1OEM.600.0.0.2494585            INT                 VMwareCertified   2018-04-18
net-ixgbe                      4.4.1-1OEM.600.0.0.2159203            INT                 VMwareCertified   2018-04-16
qlnativefc                     2.1.53.0-1OEM.600.0.0.2768847         QLogic              VMwareCertified   2018-04-16


# ForegroundColor: Black, DarkBlue, DarkGreen, DarkCyan, DarkRed, DarkMagenta, DarkYellow, Gray, DarkGray, Blue, Green, Cyan, Red, Magenta, Yellow, White

## ----------------
## ----------------
## ----------------
## ----------------

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
#
Send-MailMessage -to pvankoppen@methanex.com -from "$($env:computername)@methanex.com" -subject "See Attachment" -Body "See Attachment" -SmtpServer smtp -Attachments D:\Admin\Temp\dmzwvl.7z
#
Send-MailMessage -to pvankoppen@methanex.com -from "$($env:computername)@methanex.com" -subject "See Attachment 1/2" -Body "See Attachment" -SmtpServer smtp -Attachments D:\Admin\Temp\dmzwvl.7z.001
Send-MailMessage -to pvankoppen@methanex.com -from "$($env:computername)@methanex.com" -subject "See Attachment 2/2" -Body "See Attachment" -SmtpServer smtp -Attachments D:\Admin\Temp\dmzwvl.7z.002
#
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

Get-ADComputer -filter * -Properties Description,OperatingSystem | sort name | select Name,OperatingSystem,Description | Export-Csv -path D:\Admin\Scripts\Health\serverlist-new.csv


