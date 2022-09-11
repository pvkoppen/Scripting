@ECHO OFF

ECHO.
ECHO [INFO ] Create Default folders
IF NOT EXIST D:\Backup-Config-Dump\             MKDir D:\Backup-Config-Dump\
IF NOT EXIST D:\Documentation-Drivers-Software\ MKDir D:\Documentation-Drivers-Software\
IF NOT EXIST %SystemDrive%\Scripts\Tools\       MKDir %SystemDrive%\Scripts\Tools\

ECHO.
ECHO [INFO ] Set Label C:
Set strLabel=System

FOR /F "tokens=1,2,*" %%A IN ('net accounts') DO IF %%A%%B' == Computerrole:' set strRole=%%C
FOR /F "tokens=4,5 delims=[]. " %%A IN ('ver') DO Set strVersion=%%A.%%B
IF %strVersion%-%strRole%' == 6.1-SERVER'      Set strLabel=%strLabel%-Win2k8R2
IF %strVersion%-%strRole%' == 6.1-WORKSTATION' Set strLabel=%strLabel%-Win7
IF %strVersion%-%strRole%' == 6.0-SERVER'      Set strLabel=%strLabel%-Win2k8
IF %strVersion%-%strRole%' == 6.0-WORKSTATION' Set strLabel=%strLabel%-WinVista
IF %strVersion%' == 5.2' Set strLabel=%strLabel%-Win2k3
IF %strVersion%' == 5.1' Set strLabel=%strLabel%-WinXP
IF %strVersion%' == 5.0' Set strLabel=%strLabel%-Win2k
IF %strVersion%' == 4.0' Set strLabel=%strLabel%-WinNT

IF %PROCESSOR_ARCHITECTURE%' == x86'   Set strLabel=%strLabel%-32
IF %PROCESSOR_ARCHITECTURE%' == AMD64' Set strLabel=%strLabel%-64
REM ECHO [INFO ] Details: Version=%strVersion%, Proc=%PROCESSOR_ARCHITECTURE%, Role=%strRole%
REM ECHO [INFO ] Result : Label=%strLabel%
label %SystemDrive% %strLabel%
label D: Data

ECHO.

