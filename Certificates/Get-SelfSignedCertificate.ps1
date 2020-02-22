$mypwd = ConvertTo-SecureString -String "YOUR_PFX_PASSWD" -Force -AsPlainText
$cert = New-SelfSignedCertificate -Subject *.my.domain -DnsName my.domain, *.my.domain -CertStoreLocation Cert:\LocalMachine\My -NotAfter (Get-Date).AddYears(10)
$cert | Export-PfxCertificate -FilePath "$env:temp\DMZ.pfx" -Password $mypwd -Force

