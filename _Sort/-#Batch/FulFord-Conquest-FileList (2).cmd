@ECHO OFF

CALL :SetDateTime

IF %COMPUTERNAME%' == FULFORDNAS03' GOTO %COMPUTERNAME%
IF %COMPUTERNAME%' == FULFORDNAS04' GOTO %COMPUTERNAME%
GOTO ERROR-Server

:SetDateTime
FOR /F "tokens=1,2,3,4 delims=/ "  %%A IN ('ECHO %DATE%') DO SET strDate=%%D-%%C-%%B&&SET strDayOfWeek=[%%A]
FOR /F "tokens=1,2,3,4 delims=:."  %%A IN ('ECHO %TIME%') DO SET strTime=%%A%%B.%%C%%D
GOTO End

:FULFORDNAS03
set strDrive=E
"%~dp0FileList.exe" /ATTRIBUTEFILTER * /COLUMNS DIRLEVEL,VERSION,ATTRIBUTES /ISO /LISTSEPARATOR ; "%strDrive%:\" > "%~dpn0-%COMPUTERNAME%-%strDrive%-%strDate%.csv"
set strDrive=F
"%~dp0FileList.exe" /ATTRIBUTEFILTER * /COLUMNS DIRLEVEL,VERSION,ATTRIBUTES /ISO /LISTSEPARATOR ; "%strDrive%:\" > "%~dpn0-%COMPUTERNAME%-%strDrive%-%strDate%.csv"
set strDrive=G
"%~dp0FileList.exe" /ATTRIBUTEFILTER * /COLUMNS DIRLEVEL,VERSION,ATTRIBUTES /ISO /LISTSEPARATOR ; "%strDrive%:\" > "%~dpn0-%COMPUTERNAME%-%strDrive%-%strDate%.csv"
set strDrive=H
"%~dp0FileList.exe" /ATTRIBUTEFILTER * /COLUMNS DIRLEVEL,VERSION,ATTRIBUTES /ISO /LISTSEPARATOR ; "%strDrive%:\" > "%~dpn0-%COMPUTERNAME%-%strDrive%-%strDate%.csv"
GOTO End

:FULFORDNAS04
set strDrive=D
"%~dp0FileList.exe" /ATTRIBUTEFILTER * /COLUMNS DIRLEVEL,VERSION,ATTRIBUTES /ISO /LISTSEPARATOR ; "%strDrive%:\" > "%~dpn0-%COMPUTERNAME%-%strDrive%-%strDate%.csv"
set strDrive=E
"%~dp0FileList.exe" /ATTRIBUTEFILTER * /COLUMNS DIRLEVEL,VERSION,ATTRIBUTES /ISO /LISTSEPARATOR ; "%strDrive%:\" > "%~dpn0-%COMPUTERNAME%-%strDrive%-%strDate%.csv"
GOTO End

:ERROR-Server
ECHO This server is not FULFORDNAS03 or FULFORDNAS04!
PAUSE
GOTO End

:End