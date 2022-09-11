@ECHO OFF
GOTO Begin

:Documentation
GOTO End

:Begin
ECHO ---- Stopping all Services for: NtBackup

ECHO.
ECHO -- NtmsSvc "Removable Storage": Manual
SC stop NtmsSvc
SC config NtmsSvc start= disabled

ECHO ---- (Next) Starting all Services for: MsDPM 2007
Pause

ECHO.
ECHO -- MSSQL$MS$DPM2007$ "SQL Server (MS$DPM2007$)": Automatic
SC config MSSQL$MS$DPM2007$ start= auto
SC start MSSQL$MS$DPM2007$

ECHO.
ECHO -- SQLAgent$MS$DPM2007$ "SQL Server Agent (MS$DPM2007$)": Automatic
SC config SQLAgent$MS$DPM2007$ start= auto
SC start SQLAgent$MS$DPM2007$

ECHO.
ECHO -- MSDPM "PDM": Manual
SC config MSDPM start= demand

ECHO.
ECHO -- DPMAC "DPM Agent Coordinator": Manual
SC config DPMAC start= demand

ECHO.
ECHO -- DPMWriter "DPM Writer": Automatic
SC config DPMWriter start= auto
SC start DPMWriter

ECHO.
ECHO -- DPMLA "": Manual
SC config DPMLA start= demand

ECHO.
ECHO -- DPMRA "": Manual
SC config DPMRA start= demand

ECHO ---- Finished
GOTO End

:End
Pause
