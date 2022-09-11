# get-eventlog -logname security -computername toldc01 -newest 100 -after -username mby | where {$_.EventID -eq 4624 -or $_.EventID -eq 4634}
# get-eventlog -logname security -computername toldv02 -username mby -after "2014-05-01"

#get-eventlog -logname security -computername toldv01 -username tol\mby -after "2014-05-01" | ConvertTo-HTML index,timegenerated,username,category,message > .\toldv01-mby.html
#get-eventlog -logname security -computername toldv02 -username tol\mby -after "2014-05-01" | ConvertTo-HTML index,timegenerated,username,category,message > .\toldv02-mby.html
#get-eventlog -logname security -computername toldc01 -username tol\mby -after "2014-05-01" | ConvertTo-HTML index,timegenerated,username,category,message > .\toldc01-mby.html
#get-eventlog -logname security -computername toldc02 -username tol\mby -after "2014-05-01" | ConvertTo-HTML index,timegenerated,username,category,message > .\toldc02-mby.html
#get-eventlog -logname security -computername tolrodc01 -username tol\mby -after "2014-05-01" | ConvertTo-HTML index,timegenerated,username,category,message > .\tolrodc01-mby.html
#get-eventlog -logname security -computername tahlrodc01 -username tol\mby -after "2014-05-01" | ConvertTo-HTML index,timegenerated,username,category,message > .\tahlrodc01-mby.html


# Vars 
  $strUsername = "mby"
  $domainUsername  = "tol\$strUsername"
  $strDateTime = "2014-05-01"
  $dtDateTime = [datetime]$strDateTime
  $listPCs = "toldv01","toldv02"

# Code
#foreach ($onePC in $listPCs) {
#  ECHO "'$listPCs' ($onePC), '$domainUsername' ($strUsername), $strDateTime"
#  get-eventlog -logname security -computername $onePC -username $domainUsername -after $strDateTime | ConvertTo-HTML index,timegenerated,username,category,EventID,message > .\"$onePC-$strUserName".html
#}

# Vars 
  $listPCs = "toldc01","toldc02","tolrodc01","tahlrodc01"

foreach ($onePC in $listPCs) {
  ECHO "'$listPCs' ($onePC), '$domainUsername' ($strUsername), $strDateTime"
#  get-winevent -computername $onePC -FilterHashTable @{Logname=security; } | ConvertTo-HTML index,timegenerated,username,category,EventID,message > .\"$onePC-$strUserName".html
  Get-WinEvent -computer $onePC -FilterHashTable @{logname="security"; starttime=$dtDateTime} | where {$_.message -like "*mby*"} | ConvertTo-HTML ID,TimeCreated,UserID,TaskDisplayName,Task,message > .\"$onePC-$strUserName".html
}
