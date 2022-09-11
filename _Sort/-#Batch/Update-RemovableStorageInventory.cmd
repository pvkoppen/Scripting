@ECHO OFF
REM Name          : Update-RemovableStorageInventory.cmd
REM Description   : Perform an Inventory process to check for Tapes.
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Must be run as: Administrator
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2009-07-20: 1.0: Initial version
REM 2011-09-21: 1.0a: Updated batch with common defaults
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------
set DEVICE="Hewlett Packard DDS4 drive"
set MEDIAPOOL="4mm dds"

IF %1' == /silent' GOTO Log
IF %1' == /Action' GOTO Action
GOTO AreYouSure

:GetDateTime
REM -----------------------------------------------------------------------
@FOR /F "tokens=1-9 delims=/ " %%A IN ('date /t') DO @FOR /F "tokens=1-9 delims=:. " %%a IN ('time /t') DO SET strDateTime=%%D%%C%%B[%%A]-%%c%%d%%a%%b&& SET strDate=%%D%%C%%B[%%A]&& SET strTime=%%c%%d%%a%%b
REM -----------------------------------------------------------------------
GOTO End

:PrintDateTime
REM -----------------------------------------------------------------------
ECHO -----------------------------------------------------------------------
@FOR /F "tokens=1-9 delims=/ " %%A IN ('date /t') DO @FOR /F "tokens=1-9 delims=:. " %%a IN ('time /t') DO ECHO -- DATE-TIME=%%D%%C%%B[%%A]-%%c%%d%%a%%b 
ECHO -----------------------------------------------------------------------
GOTO End

:AreYouSure
ECHO.
CHOICE /C YN /M "Are you sure you want to: %~n0 (%COMPUTERNAME%) ?"
IF %ERRORLEVEL% == 255 GOTO Error
IF %ERRORLEVEL% == 2 GOTO End
IF %ERRORLEVEL% == 1 GOTO Action
IF %ERRORLEVEL% == 0 GOTO Error
GOTO End

:Log
REM Start Logging
REM -----------------------------------------------------------------
IF NOT EXIST "%~dp0LogFiles\." MKDIR "%~dp0LogFiles"
MOVE /Y "%~dp0LogFiles\%~n0.Log" "%~dp0LogFiles\%~n0.Old.Log"
CALL %0 /Action >> "%~dp0LogFiles\%~n0.Log" 2>>&1
TYPE "%~dp0LogFiles\%~n0.Log" >> "%~dp0LogFiles\%~n0.History.Log"
GOTO End

:Action
ECHO.
ECHO ---------------- Start: %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime
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
CALL :PrintDateTime
GOTO End

:Error
ECHO Error detected!
GOTO End

:End
REM -----------------------------------------------------------------------

