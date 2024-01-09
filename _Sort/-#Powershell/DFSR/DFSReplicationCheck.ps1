Set-Variable VERSION -Option Constant -Value 1.0 -Description "Version of this program, mainly used for display purposes"

Write-Host "DFSReplicationCheck script version " $VERSION
Write-Host

Write-Host "Checking replication inbound to Edgemont, this may take a few minutes, please wait ..."
$FrDenver_GIS = dfsrdiag backlog /rmem:EServer /smem:DServer /rgname:( domain name\DFS namespace\folder name )\gis /rfname:GIS
$FrDenver_CAD = dfsrdiag backlog /rmem:EServer /smem:DServer /rgname:( domain name\DFS namespace\folder name )\cad /rfname:CAD

Write-Host "Checking replication inbound to Denver, this may take a few minutes, please wait ..."
$ToDenver_GIS = dfsrdiag backlog /rmem:DServer /smem:EServer /rgname:( domain name\DFS namespace\folder name )\gis /rfname:GIS
$ToDenver_CAD = dfsrdiag backlog /rmem:DServer /smem:EServer /rgname:( domain name\DFS namespace\folder name )\cad /rfname:CAD

Write-Host
Write-Host "Replication Results:"
Write-Host

if ($FrDenver_GIS | select-string -pattern "No Backlog") {
  Write-Host -ForegroundColor Green "Support Files:  GIS"
  Write-Host -ForegroundColor Green "Replication is in sync from Denver to Edgemont"
}
Else {
  Write-Host -ForegroundColor Red "Support Files:  GIS"
  Write-Host -ForegroundColor Red "Replication from Denver to Edgemont is backlogged"
  Write-Host -ForegroundColor Red "   Files in backlog queue:" ($FrDenver_GIS | select-string -pattern "Backlog File Count").ToString().SubString(($FrDenver_GIS | select-string -pattern "Backlog File Count").ToString().IndexOf(':') + 2)
}

if ($ToDenver_GIS | select-string -pattern "No Backlog") {
  Write-Host -ForegroundColor Green "Replication is in sync from Edgemont to Denver"
}
Else {
  Write-Host -ForegroundColor Red "Replication from Edgemont to Denver is backlogged"
  Write-Host -ForegroundColor Red "   Files in backlog queue:" ($ToDenver_GIS | select-string -pattern "Backlog File Count").ToString().SubString(($ToDenver_GIS | select-string -pattern "Backlog File Count").ToString().IndexOf(':') + 2)
}

if ($FrDenver_CAD | select-string -pattern "No Backlog") {
  Write-Host -ForegroundColor Green "Support Files:  CAD"
  Write-Host -ForegroundColor Green "Replication is in sync from Denver to Edgemont"
}
Else {
  Write-Host -ForegroundColor Red "Support Files:  CAD"
  Write-Host -ForegroundColor Red "Replication from Denver to Edgemont is backlogged"
  Write-Host -ForegroundColor Red "   Files in backlog queue:" ($FrDenver_CAD | select-string -pattern "Backlog File Count").ToString().SubString(($FrDenver_CAD | select-string -pattern "Backlog File Count").ToString().IndexOf(':') + 2)
}

if ($ToDenver_CAD | select-string -pattern "No Backlog") {
  Write-Host -ForegroundColor Green "Replication is in sync from Edgemont to Denver"
}
Else {
  Write-Host -ForegroundColor Red "Replication from Edgemont to Denver is backlogged"
  Write-Host -ForegroundColor Red "   Files in backlog queue:" ($ToDenver_CAD | select-string -pattern "Backlog File Count").ToString().SubString(($ToDenver_CAD | select-string -pattern "Backlog File Count").ToString().IndexOf(':') + 2)
}

Write-Host
Write-Host "Operation Succeeded"