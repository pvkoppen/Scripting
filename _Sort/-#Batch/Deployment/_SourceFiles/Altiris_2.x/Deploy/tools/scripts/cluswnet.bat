@echo on
:: ==============================================================
::  CLUSWNET.BAT - This script deploys Microsoft Cluster Services
::		   to nodes running Windows 2003.
::
:: Input:
::   %CLUSTERNAME% - the name of the cluster being created or 
::	   formed by this node. This value is captured from the 
::     	   deployment server as an environment variable.
::   %PRIVATENIC% - The network name of the private network card in 
::	   the node. This information is specified in the cluster.ini 
::	   file on the deployment server prior to deployment.
::   %PRIVATEIP% - The IP address of the private network card in 
::	   the node. This information is specified in the cluster.ini 
::	   file on the deployment server prior to deployment.
::   %PUBLICNIC% - The network name of the public network card in 
::	   the node. This information is specified in the cluster.ini 
::	   file on the deployment server prior to deployment.
:: ==============================================================
set TOOLS=c:\$OEM$
set SCRIPTS=c:\$OEM$\clusters\scripts
set CLUSTERFILE=c:\$OEM$\clusters\cluster.ini
set TEMPPATH=C:\$OEM$\clusters\temp

if not exist %TEMPPATH% mkdir %TEMPPATH%

:: ==============================================================
:: Check for required variables:
:: ==============================================================
if "%CLUSTERNAME%"=="" goto err6903

:: ==============================================================
:: Capture server values from cluster configuration file
:: ==============================================================
%TOOLS%\sed.exe -n -e "/\[Cluster\]/,$p" %CLUSTERFILE% > %TEMPPATH%\temp.txt
%TOOLS%\sed.exe -n -e "1d" -e "$d" -e "s/^/SET /p" %TEMPPATH%\temp.txt > %TEMPPATH%\temp2.txt
%TOOLS%\sed.exe -e "/SET ;==/d" %TEMPPATH%\temp2.txt > %TEMPPATH%\clus.bat
%TOOLS%\sed.exe -n -e "/=Network Section/,$p" %CLUSTERFILE% > %TEMPPATH%\temp.txt
%TOOLS%\sed.exe -n -e "1d" -e "$d" -e "s/;/SET /p" %TEMPPATH%\temp.txt > %TEMPPATH%\temp2.txt
%TOOLS%\sed.exe -e "/SET ==/s/.*$/ /g" %TEMPPATH%\temp2.txt > %TEMPPATH%\nets.bat
call %TEMPPATH%\clus.bat
call %TEMPPATH%\nets.bat

:: ==============================================================
:: Is this the primary node?
:: cluster.exe is located in c:\windows\system32\cluster.exe
:: ==============================================================
if "%1"=="JOIN" goto join

:create
:: ==============================================================
:: Set the private interconnect network for the primary node.
:: ==============================================================
echo PRIVATE%NODEID% > %TEMPPATH%\TMP1.TXT
%TOOLS%\sed -n -e "s/^/set PRIVATEIP=%%/p" %TEMPPATH%\TMP1.TXT > %TEMPPATH%\TMP2.TXT
%TOOLS%\sed -e "s/                                                      $/%%/" %TEMPPATH%\TMP2.TXT > %TEMPPATH%\PRIVIP.BAT
call %TEMPPATH%\PRIVIP.bat
netsh interface ip SET address name="%ClusPrivateNet%" static %PRIVATEIP% 255.0.0.0

:: ==============================================================
:: Begin Cluster Creation / Configuration
:: ==============================================================
C:\WINDOWS\SYSTEM32\cluster.exe /cluster:%CLUSTERNAME% /create /node:%COMPUTERNAME% /unattend /user:%account% /password:%password% /ipaddr:%ipaddr%,%subnet%,"%ClusPublicNet%"
if NOT %ERRORLEVEL%==0 goto err6907
goto done

:join
:: ==============================================================
:: Set the private interconnect network for the secondary node(s).
:: ==============================================================
echo PRIVATE%NODEID% > %TEMPPATH%\TMP1.TXT
%TOOLS%\sed -n -e "s/^/set PRIVATEIP=%%/p" %TEMPPATH%\TMP1.TXT > %TEMPPATH%\TMP2.TXT
%TOOLS%\sed -e "s/                                                      $/%%/" %TEMPPATH%\TMP2.TXT > %TEMPPATH%\PRIVIP.BAT
call %TEMPPATH%\PRIVIP.bat

netsh interface ip SET address name="%ClusPrivateNet%" static %PRIVATEIP% 255.0.0.0

:: ==============================================================
:: Begin Cluster Join
:: ==============================================================
C:\WINDOWS\SYSTEM32\cluster.exe /cluster:%CLUSTERNAME% /add:%COMPUTERNAME% /unattend /password:%password%
if NOT %ERRORLEVEL%==0 goto err6907
goto done

:: ==============================================================
:: Errors
:: ==============================================================
:err6903
SET SEVERITY=3
SET STATUS="Cluster name variable is missing."
IF EXIST c:\altiris\aclient\WLOGEVENT.EXE c:\altiris\aclient\WLOGEVENT.EXE -c:6903 -id:%ID% -l:%SEVERITY% -ss:"%STATUS%"
goto end

:err6907
SET SEVERITY=3
SET STATUS="Node %COMPUTERNAME% failed to deploy/join cluster %CLUSTERNAME%. Verify a domain, username, and password are supplied in the task. Refer to the log file at c:\WINDOWS\SYSTEM32\LOGFILES."
IF EXIST c:\altiris\aclient\WLOGEVENT.EXE c:\altiris\aclient\WLOGEVENT.EXE -c:6907 -id:%ID% -l:%SEVERITY% -ss:"%STATUS%"
goto end

:done
SET SEVERITY=1
SET STATUS="Cluster %CLUSTERNAME% deployed successfully."
IF EXIST c:\altiris\aclient\WLOGEVENT.EXE c:\altiris\aclient\WLOGEVENT.EXE -c:0 -id:%ID% -l:%SEVERITY% -ss:"%STATUS%"

:end