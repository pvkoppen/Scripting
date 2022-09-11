 @echo off
:: ==============================================================
::  CLUSW2K.BAT - This script deploys Microsoft Cluster Services 
::		  to nodes running Windows 2000.
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
if NOT exist C:\WINNT\CLUSTER goto err6908
%TOOLS%\sed.exe -e "/name=/s/CLUSNAME/%CLUSTERNAME%/" %CLUSTERFILE% > %TEMPPATH%\tempclus.ini
move %TEMPPATH%\tempclus.ini %CLUSTERFILE% 

%TOOLS%\sed.exe -n -e "/=Network Section/,$p" %CLUSTERFILE% > %TEMPPATH%\temp.txt
%TOOLS%\sed.exe -n -e "1d" -e "$d" -e "s/;/SET /p" %TEMPPATH%\temp.txt > %TEMPPATH%\temp2.txt
%TOOLS%\sed.exe -e "/SET ==/s/.*$/ /g" %TEMPPATH%\temp2.txt > %TEMPPATH%\nets.bat
call %TEMPPATH%\nets.bat

:: ==============================================================
:: Is this the primary node?
:: ==============================================================
if "%1"=="JOIN" goto join

:create
:: ==============================================================
:: Set the private interconnect network
:: ==============================================================
echo PRIVATE%NODEID% > %TEMPPATH%\TMP1.TXT
%TOOLS%\sed -n -e "s/^/set PRIVATEIP=%%/p" %TEMPPATH%\TMP1.TXT > %TEMPPATH%\TMP2.TXT
%TOOLS%\sed -e "s/                                                      $/%%/" %TEMPPATH%\TMP2.TXT > %TEMPPATH%\PRIVIP.BAT
call %TEMPPATH%\PRIVIP.bat
netsh interface ip SET address name="%ClusPrivateNet%" static %PRIVATEIP% 255.0.0.0

:: ==============================================================
:: Begin Cluster Creation / Configuration
:: ==============================================================
echo Forming the Cluster
C:\WINNT\CLUSTER\CLUSCFG.EXE -ACT FORM -u %CLUSTERFILE%
if NOT %ERRORLEVEL%==2 goto err6907
goto done

:join
:: ==============================================================
:: Set the private interconnect network
:: ==============================================================
echo PRIVATE%NODEID% > %TEMPPATH%\TMP1.TXT
%TOOLS%\sed -n -e "s/^/set PRIVATEIP=%%/p" %TEMPPATH%\TMP1.TXT > %TEMPPATH%\TMP2.TXT
%TOOLS%\sed -e "s/                                                      $/%%/" %TEMPPATH%\TMP2.TXT > %TEMPPATH%\PRIVIP.BAT
call %TEMPPATH%\PRIVIP.bat
netsh interface ip SET address name="%ClusPrivateNet%" static %PRIVATEIP% 255.0.0.0

:: ==============================================================
:: Begin Cluster Join
:: ==============================================================
echo Joining the Cluster
C:\WINNT\CLUSTER\CLUSCFG.EXE -ACT JOIN -u %CLUSTERFILE%
if NOT %ERRORLEVEL%==2 goto err6907
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
SET STATUS="Node %COMPUTERNAME% failed to deploy/join cluster %CLUSTERNAME%. Verify a domain, username, and password are supplied in the task."
IF EXIST c:\altiris\aclient\WLOGEVENT.EXE c:\altiris\aclient\WLOGEVENT.EXE -c:6907 -id:%ID% -l:%SEVERITY% -ss:"%STATUS%"
goto end

:err6908
SET SEVERITY=3
SET STATUS="Missing cluster binaries. Copy these files from a Windows 2000 distribution."
IF EXIST c:\altiris\aclient\WLOGEVENT.EXE c:\altiris\aclient\WLOGEVENT.EXE -c:6908 -id:%ID% -l:%SEVERITY% -ss:"%STATUS%"
goto end

:done
SET SEVERITY=1
SET STATUS="Cluster %CLUSTERNAME% deployed successfully."
IF EXIST c:\altiris\aclient\WLOGEVENT.EXE c:\altiris\aclient\WLOGEVENT.EXE -c:0 -id:%ID% -l:%SEVERITY% -ss:"%STATUS%"

:end