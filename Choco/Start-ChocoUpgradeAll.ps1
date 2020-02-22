## -------------------------------------
## Date: 20190809
## Author: Peter van Koppen
## -------------------------------------
## Installed: Centrally, to be run on all PC's
## User: RunAs Admin
## -------------------------------------

choco upgrade all -y

## All PC's
#choco upgrade adobereader dotnetfx googlechrome intel-dsa microsoft-teams -y

## Radiologist, Nurse Station
#choco upgrade adobereader citrix-workspace dotnetfx googlechrome intel-dsa microsoft-teams -y

## Remote Radiologist
#choco upgrade adobereader citrix-workspace dotnetfx forticlientvpn googlechrome intel-dsa microsoft-teams -y

## Uninstall
#choco uninstall citrix-receiver -y
