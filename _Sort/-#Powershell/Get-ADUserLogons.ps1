
#Get-ADUser -Filter * -SearchBase "DC=tol,DC=Local" | Sort-Object | ForEach-Object -Process {
Get-ADUser administrator | Sort-Object | ForEach-Object -Process {
  $UserName = $_.SamAccountName
  $MsgQuery="*" + $UserName + "*"
  $EventID = $_.EventID
  $Events = Get-WinEvent -logname security -Message $MsgQuery   | ForEach-Object -Process {
    $SrcAddr = "Unknown"
    $idx = $_.message.IndexOf("Source Network Address:")
    if ($idx -gt 0) {$SrcAddr = $_.message.substring($idx+23,15).trim()}
    $UserName+","+$SrcAddr+","+$EventID+","+$_.TimeGenerated | Out-File -FilePath $UserName"_login_events.csv" -Append
  }
}


<QueryList>
  <Query Id="0" Path="Security">
    <Select Path="Security">*[System[Security[@UserID='S-1-5-21-3342921448-4045285656-940039359-1609']]]</Select>
  </Query>
</QueryList>

<QueryList>
  <Query Id="0" Path="Security">
    <Select Path="Security">*[System[Security[@UserID='S-1-5-21-2590517325-912123444-2856381530-500']]]</Select>
  </Query>
</QueryList>
<QueryList><Query Id="0" Path="Security"><Select Path="Security">*[System[Security[@UserID='S-1-5-21-3342921448-4045285656-940039359-500']]]</Select></Query></QueryList>

$WinEventDC01 = Get-WinEvent -ComputerName TOLDC01 -Credential $cred -FilterHashtable @{Logname='Security';Id=4624} | where {$_.Message -like '*Administrator*'}
$WinEventDC02 = Get-WinEvent -ComputerName TOLDC02 -Credential $cred -FilterHashtable @{Logname='Security';Id=4624} | where {$_.Message -like '*Administrator*'}
$WinEventRODC01 = Get-WinEvent -ComputerName TOLRODC01 -Credential $cred -FilterHashtable @{Logname='Security';Id=4624} | where {$_.Message -like '*Administrator*'}