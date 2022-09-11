$domain = "dc=TOL,dc=local"
$dse = [adsi]"LDAP://$domain"
$filter = '(&(objectCategory=person)(objectSid=*)(!samAccountType:1.2.840.113556.1.4.804:=3))'
$searcher = New-Object DirectoryServices.DirectorySearcher ($dse, $filter)
$manager = $null
$searcher.findall() | 
ForEach-Object {
 [adsi]$_.path | 
 Where-Object { [string]::IsNullOrEmpty($_.properties.Item("Manager")) }
} |
Format-Table -AutoSize -Property name