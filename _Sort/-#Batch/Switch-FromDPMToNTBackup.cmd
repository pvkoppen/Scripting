GOTO Begin

:Documentation
DPM
DPM Replication Agent
SQLAgent$MS$DPM2007$
MSSQL$MS$DPM2007$
Virtual Disk Service
Volume Shadow Copy
GOTO End

:Begin
ECHO ---- Stop: MsDPM 2007

ECHO.
ECHO -- MSDPM "DPM": Manual
SC stop MSDPM
SC config MSDPM start= disabled

ECHO.
ECHO -- DPMAC "DPM Agent Coordinator": Manual
SC stop DPMAC
SC config DPMAC start= disabled

ECHO.
ECHO -- DPMWriter "DPM Writer": Automatic
SC stop DPMWriter
SC config DPMWriter start= disabled

ECHO.
ECHO -- DPMLA "": Manual
SC stop DPMLA
SC config DPMLA start= disabled

ECHO.
ECHO -- DPMRA "": Manual
SC stop DPMRA
SC config DPMRA start= disabled

ECHO.
ECHO -- SQLAgent$MS$DPM2007$ "SQL Server Agent (MS$DPM2007$)": Automatic
SC stop SQLAgent$MS$DPM2007$
SC config SQLAgent$MS$DPM2007$ start= disabled

ECHO.
ECHO -- MSSQL$MS$DPM2007$ "SQL Server (MS$DPM2007$)": Automatic
SC stop MSSQL$MS$DPM2007$
SC config MSSQL$MS$DPM2007$ start= disabled

ECHO ----Services: DPM Stopped, Starting Removable Storage
PAUSE

ECHO.
ECHO -- NtmsSvc "Removable Storage": Manual
SC config NtmsSvc start= demand

ECHO ---- Finished
GOTO End

:End
ECHO ---- Start: NtBackup
PAUSE
NtBackup.exe
