@ECHO OFF
REM Name          : Run-PreBackupTasks.cmd
REM Description   : Script used to run pre-backup tasks.
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Version       : 1.1e
REM Must be run as: Administrator
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2009-01-04: Version 1.1
REM 2009-03-05: v1.1c: Added MKDIR to Backup folders.
REM 2009-04-16: 1.1d: Changed the WSUS-v3 MOVE to a DELETE.
REM 2009-07-20: v1.1e: Updated date&time format.
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------

IF %1' == ' GOTO Log
IF %1' == /Action' GOTO Action
IF %1' == /GetDateTime' GOTO GetDateTime
IF %1' == /PrintDateTime' GOTO PrintDateTime
IF %1' == MSFW-DBS' GOTO MSFW-DBS
GOTO End

:GetDateTime
REM -----------------------------------------------------------------------
@FOR /F "tokens=1-9 delims=/ " %%A IN ('date /t') DO @FOR /F "tokens=1-9 delims=:. " %%a IN ('time /t') DO SET strDateTime=%%D%%C%%B[%%A]-%%c%%d%%a%%b && SET strDate=%%D%%C%%B[%%A] && SET strTime=%%c%%d%%a%%b 
REM -----------------------------------------------------------------------
GOTO End

:PrintDateTime
REM -----------------------------------------------------------------------
ECHO -----------------------------------------------------------------------
@FOR /F "tokens=1-9 delims=/ " %%A IN ('date /t') DO @FOR /F "tokens=1-9 delims=:. " %%a IN ('time /t') DO ECHO -- DATE-TIME=%%D%%C%%B[%%A]-%%c%%d%%a%%b 
ECHO -----------------------------------------------------------------------
GOTO End

:MSFW-DBS
"C:\Program Files\Microsoft SQL Server\90\Tools\Binn\OSQL.EXE" -E -S localhost\msfw -d master -Q "select name from sysdatabases where name like 'ISALOG%%' " |find "ISALOG"
GOTO End

:Log
REM Start Logging
REM -----------------------------------------------------------------
IF NOT EXIST "%~dp0LogFiles\." MKDIR "%~dp0LogFiles"
Move /Y "%~dp0LogFiles\%~n0.Log" "%~dp0LogFiles\%~n0.Old.Log"
Call %0 /Action >> "%~dp0LogFiles\%~n0.Log" 2>>&1
GOTO End

:Action
ECHO.
ECHO ---------------- Start: %~dpnx0 on %ComputerName% ----------------
CALL %0 /PrintDateTime
REM IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True
GOTO DoExchange

:DoExchange
ECHO.
ECHO ------- Backup Exchange
IF NOT EXIST "C:\Program Files\Exchsrvr\." GOTO DoInterbase
Del /q "%USERPROFILE%\Local Settings\Application Data\Microsoft\Windows NT\NTBackup\data\*.Log"
MKDIR "D:\Backup-Config-Dump\Exchange\"
Start /wait %SystemRoot%\system32\ntbackup.exe backup "@D:\Backup-Config-Dump\Exchange\FullExchange.bks" /J "Job: Full Exchange" /N "Media: Full Exchange" /F "D:\Backup-Config-Dump\Exchange\FullExchange.bkf" /V:yes /L:s /M normal /snap:on
FOR %%A IN ("%USERPROFILE%\Local Settings\Application Data\Microsoft\Windows NT\NTBackup\Data\*.*") DO Set BackupFile="%%A"
ECHO ------- Exchange Log: %BackupFile%
TYPE %BackupFile%
ECHO ------- Exchange Log: %BackupFile%
CALL %0 /PrintDateTime
GOTO DoInterbase

:DoInterbase
ECHO.
ECHO ------- Backup MedTech and Stop the service: InterBase
IF NOT EXIST D:\Medtech\MT32\. GOTO DoMedTech
CALL "%~dp0Backup-MedTech.cmd"
NET STOP InterBaseServer
NET STOP ManageMyHealthSMSCommunicator
CALL %0 /PrintDateTime
GOTO DoMedTech

:DoMedtech
ECHO.
ECHO ------- Kill InterBase dependant processes: 
CScript.exe "%~dp0Kill-Process.vbs" MT32.exe MTInbox.exe NIRMsgTransfer.exe
RegEdit.exe /s "%~dp0Tools\SysInternals\AcceptEULA.reg"
"%~dp0Tools\SysInternals\pskill.exe" MT32
ECHO "%~dp0Tools\SysInternals\pskill.exe" MTInbox
ECHO "%~dp0Tools\SysInternals\pskill.exe" NIRMsgTransfer
CALL %0 /PrintDateTime
GOTO DoSQL

:DoSQL
:DoSQL-ISA
ECHO.
ECHO ------- Backup MSFW
IF NOT EXIST "C:\Program Files\Microsoft SQL Server\MSSQL$MSFW\Data\." GOTO DoSQL-PCBBNZ
MKDIR "D:\Backup-Config-Dump\ISA\"
REM "C:\Program Files\Microsoft SQL Server\90\Tools\Binn\osql.exe" -E -S localhost\MSFW -d master -Q "BACKUP DATABASE master TO DISK = N'D:\Backup-Config-Dump\ISA\MSFW.bak' WITH FORMAT "
REM "C:\Program Files\Microsoft SQL Server\90\Tools\Binn\osql.exe" -E -S localhost\MSFW -d master -Q "BACKUP DATABASE model  TO DISK = N'D:\Backup-Config-Dump\ISA\MSFW.bak' "
REM "C:\Program Files\Microsoft SQL Server\90\Tools\Binn\osql.exe" -E -S localhost\MSFW -d master -Q "BACKUP DATABASE msdb   TO DISK = N'D:\Backup-Config-Dump\ISA\MSFW.bak' "
FOR /F %%A IN ('%0 MSFW-DBS') DO "C:\Program Files\Microsoft SQL Server\90\Tools\Binn\osql.exe" -E -S localhost\MSFW -d master -Q "BACKUP DATABASE %%A  TO DISK = N'D:\Backup-Config-Dump\ISA\MSFW.bak' "
CALL %0 /PrintDateTime

:DoSQL-PCBBNZ
ECHO.
ECHO ------- Backup PC Banking
IF NOT EXIST "C:\Program Files\PC Banking\v7\Databases\." GOTO DoSQL-Mon
MKDIR "D:\Backup-Config-Dump\PCBanking\"
"C:\Program Files\Microsoft SQL Server\90\Tools\Binn\osql.exe" -E -S localhost\BNZPCBB -d master -Q "BACKUP DATABASE master   TO DISK = N'D:\Backup-Config-Dump\PCBanking\BNZPCBB.bak' WITH FORMAT "
"C:\Program Files\Microsoft SQL Server\90\Tools\Binn\osql.exe" -E -S localhost\BNZPCBB -d master -Q "BACKUP DATABASE model    TO DISK = N'D:\Backup-Config-Dump\PCBanking\BNZPCBB.bak' "
"C:\Program Files\Microsoft SQL Server\90\Tools\Binn\osql.exe" -E -S localhost\BNZPCBB -d master -Q "BACKUP DATABASE msdb     TO DISK = N'D:\Backup-Config-Dump\PCBanking\BNZPCBB.bak' "
"C:\Program Files\Microsoft SQL Server\90\Tools\Binn\osql.exe" -E -S localhost\BNZPCBB -d master -Q "BACKUP DATABASE NGARUAAA TO DISK = N'D:\Backup-Config-Dump\PCBanking\BNZPCBB.bak' "
CALL %0 /PrintDateTime

:DoSQL-Mon
ECHO.
ECHO ------- Backup SBSMonitoring
IF NOT EXIST "C:\Program Files\Microsoft SQL Server\MSSQL$SBSMONITORING\." GOTO DoSQL-SharePoint
MKDIR "D:\Backup-Config-Dump\SBSMonitoring\"
"C:\Program Files\Microsoft SQL Server\90\Tools\Binn\osql.exe" -E -S localhost\SBSMonitoring -d master -Q "BACKUP DATABASE master        TO DISK = N'D:\Backup-Config-Dump\SBSMonitoring\SBSMonitoring.bak' WITH FORMAT "
"C:\Program Files\Microsoft SQL Server\90\Tools\Binn\osql.exe" -E -S localhost\SBSMonitoring -d master -Q "BACKUP DATABASE model         TO DISK = N'D:\Backup-Config-Dump\SBSMonitoring\SBSMonitoring.bak' "
"C:\Program Files\Microsoft SQL Server\90\Tools\Binn\osql.exe" -E -S localhost\SBSMonitoring -d master -Q "BACKUP DATABASE msdb          TO DISK = N'D:\Backup-Config-Dump\SBSMonitoring\SBSMonitoring.bak' "
"C:\Program Files\Microsoft SQL Server\90\Tools\Binn\osql.exe" -E -S localhost\SBSMonitoring -d master -Q "BACKUP DATABASE SBSMonitoring TO DISK = N'D:\Backup-Config-Dump\SBSMonitoring\SBSMonitoring.bak' "
CALL %0 /PrintDateTime

:DoSQL-SharePoint
ECHO.
ECHO ------- Backup SHAREPOINT
IF NOT EXIST "D:\Program Files\Microsoft SQL Server\MSSQL$SHAREPOINT\Data\." GOTO DoSQL-WSUS-v2
MKDIR "D:\Backup-Config-Dump\SharePoint\"
"C:\Program Files\Microsoft SQL Server\90\Tools\Binn\osql.exe" -E -S localhost\SHAREPOINT -d master -Q "BACKUP DATABASE master               TO DISK = N'D:\Backup-Config-Dump\SharePoint\SHAREPOINT.BAK' WITH FORMAT "
"C:\Program Files\Microsoft SQL Server\90\Tools\Binn\osql.exe" -E -S localhost\SHAREPOINT -d master -Q "BACKUP DATABASE model                TO DISK = N'D:\Backup-Config-Dump\SharePoint\SHAREPOINT.BAK' "
"C:\Program Files\Microsoft SQL Server\90\Tools\Binn\osql.exe" -E -S localhost\SHAREPOINT -d master -Q "BACKUP DATABASE msdb                 TO DISK = N'D:\Backup-Config-Dump\SharePoint\SHAREPOINT.BAK' "
"C:\Program Files\Microsoft SQL Server\90\Tools\Binn\osql.exe" -E -S localhost\SHAREPOINT -d master -Q "BACKUP DATABASE STS_Config           TO DISK = N'D:\Backup-Config-Dump\SharePoint\SHAREPOINT.BAK' "
"C:\Program Files\Microsoft SQL Server\90\Tools\Binn\osql.exe" -E -S localhost\SHAREPOINT -d master -Q "BACKUP DATABASE STS_%COMPUTERNAME%_1 TO DISK = N'D:\Backup-Config-Dump\SharePoint\SHAREPOINT.BAK' "
"%SystemDrive%\Program files\Common files\Microsoft shared\Web server extensions\60\Bin\Stsadm.exe" -o backup -url http://Companyweb -filename "D:\Backup-Config-Dump\SharePoint\STSADM-Backup-CompanyWeb.stsbackup" -overwrite
CALL %0 /PrintDateTime

:DoSQL-WSUS-v2
ECHO.
ECHO ------- Backup WSUS-v2
IF NOT EXIST "C:\Program Files\Microsoft SQL Server\MSSQL$WSUS\." GOTO DoSQL-WSUS-v3
MKDIR "D:\Backup-Config-Dump\WSUS\"
"C:\Program Files\Microsoft SQL Server\90\Tools\Binn\osql.exe" -E -S localhost\WSUS -d master -Q "BACKUP DATABASE master TO DISK = N'D:\Backup-Config-Dump\WSUS\WSUS-v2.bak' WITH FORMAT "
"C:\Program Files\Microsoft SQL Server\90\Tools\Binn\osql.exe" -E -S localhost\WSUS -d master -Q "BACKUP DATABASE model  TO DISK = N'D:\Backup-Config-Dump\WSUS\WSUS-v2.bak' "
"C:\Program Files\Microsoft SQL Server\90\Tools\Binn\osql.exe" -E -S localhost\WSUS -d master -Q "BACKUP DATABASE msdb   TO DISK = N'D:\Backup-Config-Dump\WSUS\WSUS-v2.bak' "
"C:\Program Files\Microsoft SQL Server\90\Tools\Binn\osql.exe" -E -S localhost\WSUS -d master -Q "BACKUP DATABASE SUSDB  TO DISK = N'D:\Backup-Config-Dump\WSUS\WSUS-v2.bak' "
CALL %0 /PrintDateTime

:DoSQL-WSUS-v3
ECHO.
ECHO ------- Backup WSUS-v3
IF NOT EXIST "C:\WINDOWS\SYSMSI\SSEE\MSSQL.2005\MSSQL\Data\." GOTO DoEnd
SET BackupTarget=D:\Backup-Config-Dump\
SET BackupTarget=\\scqm01\c$\Backup-Config-Dump\
MKDIR "%BackupTarget%WSUS\"
DEL /Q "%BackupTarget%WSUS\WSUS-v3*.bak"
REM "C:\Program Files\Microsoft SQL Server\90\Tools\Binn\sqlcmd.exe" -E -S \\.\pipe\mssql$microsoft##ssee\sql\query -d master -Q "BACKUP DATABASE master TO DISK = N'%BackupTarget%WSUS\WSUS-v3.bak' WITH DESCRIPTION=N'mssql$microsoft##ssee-master', NAME=N'mssql$microsoft##ssee-master', NOFORMAT, NOINIT, SKIP, NOREWIND, NOUNLOAD, STATS = 10 " 
"C:\Program Files\Microsoft SQL Server\90\Tools\Binn\sqlcmd.exe" -E -S \\.\pipe\mssql$microsoft##ssee\sql\query -d master -Q "BACKUP DATABASE master TO DISK = N'%BackupTarget%WSUS\WSUS-v3-master.bak' WITH DESCRIPTION=N'mssql$microsoft##ssee-master', NAME=N'mssql$microsoft##ssee-master', FORMAT "
"C:\Program Files\Microsoft SQL Server\90\Tools\Binn\sqlcmd.exe" -E -S \\.\pipe\mssql$microsoft##ssee\sql\query -d master -Q "BACKUP DATABASE model  TO DISK = N'%BackupTarget%WSUS\WSUS-v3-model.bak' WITH DESCRIPTION=N'mssql$microsoft##ssee-model', NAME=N'mssql$microsoft##ssee-model' "
"C:\Program Files\Microsoft SQL Server\90\Tools\Binn\sqlcmd.exe" -E -S \\.\pipe\mssql$microsoft##ssee\sql\query -d master -Q "BACKUP DATABASE msdb   TO DISK = N'%BackupTarget%WSUS\WSUS-v3-msdb.bak' WITH DESCRIPTION=N'mssql$microsoft##ssee-msdb', NAME=N'mssql$microsoft##ssee-msdb' "
IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True
"C:\Program Files\Microsoft SQL Server\90\Tools\Binn\osql.exe" -E -S np:\\.\pipe\mssql$microsoft##ssee\sql\query -d master -Q "BACKUP DATABASE [SUSDB] TO DISK = N'%BackupTarget%WSUS\WSUS-v3-SUSDB.bak' WITH DESCRIPTION=N'mssql$microsoft##ssee-SUSDB', NAME=N'mssql$microsoft##ssee-SUSDB' "
IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True
CALL %0 /PrintDateTime
GOTO DoEnd

:DoEnd
REM Email the logbook to IT Services on Error.
REM -----------------------------------------------------------------------
IF %strSendEmail%' == True' CALL "%~dp0Tools\SendMail.cmd" "%~n0 (%COMPUTERNAME%)" "%~dp0LogFiles\%~n0.Log"
ECHO ---------------- End  : %~dpnx0 on %ComputerName% ----------------
CALL %0 /PrintDateTime
GOTO End

:Error
ECHO Error detected!
GOTO End

:End
REM -----------------------------------------------------------------------

