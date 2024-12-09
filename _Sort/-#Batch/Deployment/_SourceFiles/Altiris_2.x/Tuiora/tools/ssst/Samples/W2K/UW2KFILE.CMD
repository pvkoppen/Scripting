REM Set SOURCE TO CD or file path with SmartStart CD image
SET SOURCE=D:

SET OEM=J:\W2K\CPQW2K\$OEM$
SET TEXTMODE=%OEM%\TEXTMODE\*.*
SET SCSI=%OEM%\$1\DRIVERS\SCSI\*.*
SET NET=%OEM%\$1\DRIVERS\NET\*.*
SET NTCSP=%OEM%\$1\NTCSP\*.*

ECHO Updating OEM Boot Files: $OEM$\TEXTMODE
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\W2K\ADPU160M\*.* %TEXTMODE% /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\W2K\CPQARRY2\*.* %TEXTMODE% /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\W2K\CPQCISSM\*.* %TEXTMODE% /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\W2K\MEGAIDE\*.* %TEXTMODE% /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\W2K\CPQCISSE\*.* %TEXTMODE% /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\W2K\CMDIDE\*.* %TEXTMODE% /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\W2K\SYMMPI\*.* %TEXTMODE% /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\W2K\LSICSB6\*.* %TEXTMODE% /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\INSTALL\W2K\TXTSETUP.OEM %TEXTMODE% /C /F /H /R /K

ECHO Updating SCSI Drivers: $OEM$\$1\DRIVERS\SCSI
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\W2K\ADPU160M\*.* %SCSI% /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\W2K\CPQARRY2\*.* %SCSI% /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\W2K\CPQCISSM\*.* %SCSI% /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\W2K\MEGAIDE\*.* %SCSI% /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\W2K\CPQCISSE\*.* %SCSI% /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\W2K\CMDIDE\*.* %SCSI% /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\W2K\SYMMPI\*.* %SCSI% /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\W2K\LSICSB6\*.* %SCSI% /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\INSTALL\W2K\TXTSETUP.OEM %SCSI% /C /F /H /R /K

ECHO Updating NET Drivers: $OEM$\$1\DRIVERS\NET
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\W2K\INT100\*.* %NET% /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\W2K\INT1000\*.* %NET% /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\W2K\Q57W2K\*.* %NET% /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\W2K\NETFLX3\*.* %NET% /S /E /C /F /H /R /K

ECHO Updating Windows 2000 Support Paq: $OEM$\$1\NTCSP
ECHO A | XCOPY %SOURCE%\COMPAQ\CSP\NT\*.* %NTCSP% /S /E /C /F /H /R /K

ECHO Updating Compaq Files: $OEM$\$1
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\W2K\ADPU160M\*.* %OEM%\$1\$WIN_NT$.~LS\ /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\W2K\CPQARRY2\*.* %OEM%\$1\$WIN_NT$.~LS\ /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\W2K\CPQCISSM\*.* %OEM%\$1\$WIN_NT$.~LS\ /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\W2K\MEGAIDE\*.* %OEM%\$1\$WIN_NT$.~LS\ /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\W2K\CPQCISSE\*.* %OEM%\$1\$WIN_NT$.~LS\ /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\W2K\CMDIDE\*.* %OEM%\$1\$WIN_NT$.~LS\ /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\W2K\SYMMPI\*.* %OEM%\$1\$WIN_NT$.~LS\ /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\DRIVERS\W2K\LSICSB6\*.* %OEM%\$1\$WIN_NT$.~LS\ /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\INSTALL\W2K\TXTSETUP.OEM %OEM%\$1\$WIN_NT$.~LS\TXTSETUP.OEM /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\INSTALL\W2K\POSTINST\QUICKLCH\*.* %OEM%\$1\QUICKLCH\ /S /E /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\INSTALL\W2K\POSTINST\CMSISU.EXE %OEM%\$1\ /C /F /H /R /K 
ECHO A | XCOPY %SOURCE%\COMPAQ\INSTALL\W2K\POSTINST\CPQBFILE.EXE %OEM%\$1\ /C /F /H /R /K 
ECHO A | XCOPY %SOURCE%\COMPAQ\INSTALL\W2K\POSTINST\GUICMD.EXE %OEM%\$1\ /C /F /H /R /K 
ECHO A | XCOPY %SOURCE%\COMPAQ\INSTALL\W2K\POSTINST\REBOOT.INF %OEM%\$1\ /C /F /H /R /K 
ECHO A | XCOPY %SOURCE%\COMPAQ\INSTALL\W2K\POSTINST\CPQCLEAN.CMD %OEM%\$1\ /C /F /H /R /K 
ECHO A | XCOPY %SOURCE%\COMPAQ\INSTALL\W2K\POSTINST\CMDLINES.TXT %OEM%\ /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\INSTALL\W2K\POSTINST\COMPAQ.BMP %OEM%\ /C /F /H /R /K
ECHO A | XCOPY %SOURCE%\COMPAQ\INSTALL\MSDOS\DOSFILES\XMMZERO.EXE %OEM%\$1\ /C /F /H /R /K

ECHO A | XCOPY %SOURCE%\COMPAQ\INSTALL\W2K\CMD.TXT %OEM%\$1\ /C /F /H /R /K



