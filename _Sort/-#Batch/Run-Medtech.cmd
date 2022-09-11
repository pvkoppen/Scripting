@ECHO OFF

ECHO [INFO ] Check M Drive
IF NOT EXIST M:\bin\MT32.exe GOTO NoMDrive

ECHO [INFO ] Check for RDS Session (%CLIENTNAME% on %COMPUTERNAME%)
IF %CLIENTNAME%' == ' GOTO NoRDS
GOTO RDS

:NoRDS
ECHO [INFO ] Set CLIENTNAME variable (No RDS)
SET CLIENTNAME=ITServices
GOTO Action

:RDS
ECHO [INFO ] Set CLIENTNAME variable (RDS)
SET CLIENTNAME=ITServices
GOTO Action

:Action
ECHO [INFO ] Launch Medtech
start "" "M:\bin\MT32.exe"
GOTO End

:NoMDrive
ECHO [ERROR] No M Drive Mapped
Pause
GOTO End

:End
