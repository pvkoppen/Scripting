@ECHO OFF
REM Name          : Inventory-RemovableStorage.cmd
REM Description   : Backup Server: Automated Weekly Restart.
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Version       : 1.0
REM Must be run as: Administrator
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2009-07-20: v1.0: Initial version
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------
set DEVICE="Hewlett Packard DDS4 drive"
set MEDIAPOOL="4mm dds"

IF %1' == ' GOTO Log
IF %1' == /Action' GOTO Action
IF %1' == /GetDateTime' GOTO GetDateTime
IF %1' == /PrintDateTime' GOTO PrintDateTime
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

:Log
REM Start Logging
REM -----------------------------------------------------------------
IF NOT EXIST "%~dp0LogFiles\." MKDIR "%~dp0LogFiles"
Move /Y "%~dp0LogFiles\%~n0.Log" "%~dp0LogFiles\%~n0.Old.Log"
Call %0 /Action >> "%~dp0LogFiles\%~n0.Log" 2>>&1
TYPE "%~dp0LogFiles\%~n0.Log" >> "%~dp0LogFiles\%~n0.History.Log"
GOTO End

:Action
ECHO.
ECHO ---------------- Start: %~dpnx0 on %ComputerName% ----------------
CALL %0 /PrintDateTime
REM IF %ERRORLEVEL%' == 0' SET strSendEmail=True

rsm.exe inventory /LF%DEVICE% /AFULL
GOTO DoEnd

:Original
set DEVICE="Compaq DDS4 20/40 GB DAT-station"
set BACKUPDEF=C:\cmd\backup.bks
set MEDIAPOOL="4mm dds"
set BACKUPMAIL=c:\cmd\mail.bks
c:
del "C:\Documents and Settings\Administrator\Local Settings\Application Data\Microsoft\Windows NT\NTBackup\data\*.log"
del c:\event\data\backup.bak
ren c:\event\data\backup.txt backup.bak
rsm.exe inventory /LF%DEVICE% /AFULL
sleep 30
for /f "Tokens=1-4 Delims=/ " %%i in ('date /t') do  set
dt=%%i-%%j-%%k-%%l
for /f "Tokens=1" %%i in ('time /t') do set tm=-%%i
set tm=%tm::=-%
set dtt=%dt%%tm%
ntbackup.exe backup "@%BACKUPDEF%" /n "%computername% %dtt%" /d
"%computername% %dtt%" /v:yes /r:no /rs:no /hc:on /m normal /j
"%computername% %dtt%" /l:s /p %MEDIAPOOL% /UM
ntbackup.exe backup "@%BACKUPMAIL%" /t "%computername% %dtt%" /d
"%computername% %dtt%" /v:yes /A /r:no /rs:no /hc:on /m normal /j
"%computername% %dtt%" /l:s
rsm.exe eject /PF"%computername% %dtt%" /astart
c:\cmd\sleep 30
cd "C:\Documents and Settings\Administrator\Local Settings\Application
Data\Microsoft\Windows NT\NTBackup\data"
copy *.* c:\event\data\backup.txt
GOTO End

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

