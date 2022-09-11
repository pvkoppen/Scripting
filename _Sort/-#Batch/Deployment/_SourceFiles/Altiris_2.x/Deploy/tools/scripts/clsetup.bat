@echo off
:: ==============================================================
:: CLSETUP.BAT - Sets up the cluster deployment environment 
::		 files and directories
:: 
:: Input:
::   AXSERVER= Name of the deployment server
::   SERVERNAME= Full name of the target server
::   CLUSTERNAME= Name of the cluster the target will join/form
::   CLUSTERID= Altiris database ID for the cluster group
::   clusterfile = name of of the cluster configuration file
::   storagefile = name of the shared storage configuration file
::
:: Output
::   noderole.bat = a batch file that sets the NODEID variable 
::		    for the target server
::   cl%CLUSTERID%.lis = a list on the deployment server containing 
::			 the names of members of the cluster
::   cluster.ini = a local copy of the cluster configuration file
::   storage.ini = a local copy of the shared storage configuration file    
::
:: ==============================================================
if not exist \\%SERVERNAME%\C$\$OEM$\clusters mkdir \\%SERVERNAME%\C$\$OEM$\clusters
if not exist \\%DSSERVER%\express\temp\clusters mkdir \\%DSSERVER%\express\temp\clusters
echo set NODEID=%NODEROLE% > \\%SERVERNAME%\C$\$OEM$\clusters\noderole.bat
echo ::This is the id for %SERVERNAME% >> \\%SERVERNAME%\C$\$OEM$\clusters\noderole.bat
copy %ROOTPATH%\configs\%clusterfile% \\%SERVERNAME%\C$\$OEM$\clusters\cluster.ini
copy %ROOTPATH%\configs\%storagefile% \\%SERVERNAME%\C$\$OEM$\clusters\storage.ini
