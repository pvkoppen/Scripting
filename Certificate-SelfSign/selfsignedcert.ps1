$cert = new-selfsignedcert -certstore cert:\localmachine\my -dnzmane testcert.techsnip.io
$cert

$secpassword = convertto-securestring -string 'password' -force -asplaintext

$certpath = "cert:\localmachine\my\$($cert.thumprint)"

export-pfxcertificta -cert $certpath -filepat c:\selfcert.pfx -password $secpassword
Import-pfxcertificate -password $secpassword -filepath c:\selfcert.pfx -certstorelocation 'Cert:\currentuser\my'
