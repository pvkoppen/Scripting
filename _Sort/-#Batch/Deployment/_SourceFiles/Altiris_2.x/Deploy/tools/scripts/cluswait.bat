@ECHO OFF
:: ==============================================================
::  CLUSWAIT.BAT - This script forces secondary nodes to wait in 
:: 		   DOS while the primary node configures the shared 
::		   storage and the cluster.
::
:: Input:
::   %CLUSTERID% = ID number for the cluster the target will join.
::      %NODEID% = the ID number for the target in the express DB.
:: ==============================================================

:: ==============================================================
:: Check for the required variables.
:: ==============================================================
if "%CLUSTERID%"=="" goto err6904

CLS
@ECHO Waiting for the primary node to deploy the storage and form the cluster...

:timer
F:\BOOTWIZ\BOOT\DosWait.exe 20
if exist f:\temp\clusters\CL%CLUSTERID%.ext goto finalwt
goto timer

:finalwt
:: ==============================================================
:: Increment the amount of time to wait by the nodeid for each 
:: successive node to join the cluster.
:: ==============================================================
if %NODEID%==1 set WAITTIME=10
if %NODEID%==2 set WAITTIME=20
if %NODEID%==3 set WAITTIME=30
if %NODEID%==4 set WAITTIME=40
if %NODEID%==5 set WAITTIME=50
if %NODEID%==6 set WAITTIME=60
if %NODEID%==7 set WAITTIME=70

F:\BOOTWIZ\BOOT\DosWait.exe %WAITTIME%
goto done

:: ==============================================================
:: Errors
:: ==============================================================
:err6904
SET SEVERITY=3
SET STATUS="Cluster ID variable is missing."
IF EXIST f:\LOGEVENT.EXE f:\LOGEVENT.EXE -c:6904 -l:%SEVERITY% -ss:"%STATUS%"

:done
