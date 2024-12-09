REM Set SOURCE TO CD or file path with SmartStart CD image
SET SOURCE=D:

SET OEM=J:\W2K3\CPQW2K3\$OEM$
SET TEXTMODE=%OEM%\TEXTMODE\*.*
SET SCSI=%OEM%\$1\DRIVERS\SCSI\*.*
SET NET=%OEM%\$1\DRIVERS\NET\*.*
SET NTCSP=%OEM%\$1\NTCSP\*.*

ECHO Updating OEM Boot Files: $OEM$\TEXTMODE
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\WNET\ADPU160M\*.* %TEXTMODE% /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\WNET\CPQARRY2\*.* %TEXTMODE% /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\WNET\CPQCISSM\*.* %TEXTMODE% /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\WNET\MEGAIDE\*.* %TEXTMODE% /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\WNET\CPQCISSE\*.* %TEXTMODE% /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\WNET\CMDIDE\*.* %TEXTMODE% /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\WNET\SYMMPI\*.* %TEXTMODE% /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\WNET\LSICSB6\*.* %TEXTMODE% /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\INSTALL\WNET\TXTSETUP.OEM %TEXTMODE% /C /F /H /R /K

ECHO Updating SCSI Drivers: $OEM$\$1\DRIVERS\SCSI
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\WNET\ADPU160M\*.* %SCSI% /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\WNET\CPQARRY2\*.* %SCSI% /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\WNET\CPQCISSM\*.* %SCSI% /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\WNET\MEGAIDE\*.* %SCSI% /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\WNET\CPQCISSE\*.* %SCSI% /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\WNET\CMDIDE\*.* %SCSI% /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\WNET\SYMMPI\*.* %SCSI% /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\WNET\LSICSB6\*.* %SCSI% /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\INSTALL\WNET\TXTSETUP.OEM %SCSI% /C /F /H /R /K

ECHO Updating NET Drivers: $OEM$\$1\DRIVERS\NET
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\WNET\N100\*.* %NET% /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\WNET\N1000\*.* %NET% /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\WNET\Q57XP32\*.* %NET% /S /E /C /F /H /R /K

ECHO Updating Windows 2003 Support Paq: $OEM$\$1\NTCSP
ECHO A | XCOPY %SOURCE%\COMPAQ\CSP\NT\*.* %NTCSP% /S /E /C /F /H /R /K

ECHO Updating Compaq Files: $OEM$\$1
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\WNET\ADPU160M\*.* %OEM%\$1\$WIN_NT$.~LS\ /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\WNET\CPQARRY2\*.* %OEM%\$1\$WIN_NT$.~LS\ /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\WNET\CPQCISSM\*.* %OEM%\$1\$WIN_NT$.~LS\ /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\WNET\MEGAIDE\*.* %OEM%\$1\$WIN_NT$.~LS\ /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\WNET\CPQCISSE\*.* %OEM%\$1\$WIN_NT$.~LS\ /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\WNET\CMDIDE\*.* %OEM%\$1\$WIN_NT$.~LS\ /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\WNET\SYMMPI\*.* %OEM%\$1\$WIN_NT$.~LS\ /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\WNET\LSICSB6\*.* %OEM%\$1\$WIN_NT$.~LS\ /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\INSTALL\WNET\TXTSETUP.OEM %OEM%\$1\$WIN_NT$.~LS\TXTSETUP.OEM /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\INSTALL\WNET\POSTINST\QUICKLCH\*.* %OEM%\$1\QUICKLCH\ /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\INSTALL\WNET\POSTINST\CMSISU.EXE %OEM%\$1\ /C /F /H /R /K 
ECHO A | XCOPY %SOURCE%\COMPAQ\INSTALL\WNET\POSTINST\CPQBFILE.EXE %OEM%\$1\ /C /F /H /R /K 
ECHO A | XCOPY %SOURCE%\COMPAQ\INSTALL\WNET\POSTINST\GUICMD.EXE %OEM%\$1\ /C /F /H /R /K 
ECHO A | XCOPY %SOURCE%\COMPAQ\INSTALL\WNET\POSTINST\REBOOT.INF %OEM%\$1\ /C /F /H /R /K 
ECHO A | XCOPY %SOURCE%\COMPAQ\INSTALL\WNET\POSTINST\CPQCLEAN.CMD %OEM%\$1\ /C /F /H /R /K 
REM ECHO A | XCOPY %SOURCE%\COMPAQ\INSTALL\WNET\POSTINST\CMDLINES.TXT %OEM%\ /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\INSTALL\WNET\POSTINST\COMPAQ.BMP %OEM%\ /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\INSTALL\MSDOS\DOSFILES\XMMZERO.EXE %OEM%\$1\ /C /F /H /R /K

ECHO A | XCOPY %SOURCE%\COMPAQ\INSTALL\WNET\CMD.TXT %OEM%\$1\ /C /F /H /R /K


