@ECHO OFF
REM Name          : Start-SBSBackup.cmd
REM Description   : Start the SBS Backup process manually.
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Must be run as: <No Preference: Administrators/LocalSystem>
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2009-05-11: v1.0.
REM 2009-07-20: v1.0a: First version.
REM 2009-10-23: v1.0b: Added a wait period.
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------

IF %1' == ' GOTO Log
IF %1' == /Action' GOTO Action
GOTO End

:GetDateTime
REM -----------------------------------------------------------------------
@FOR /F "tokens=1-9 delims=/ " %%A IN ('date /t') DO @FOR /F "tokens=1-9 delims=:. " %%a IN ('time /t') DO SET strDateTime=%%D%%C%%B[%%A]-%%c%%d%%a%%b&& SET strDate=%%D%%C%%B[%%A]&& SET strTime=%%c%%d%%a%%b
REM -----------------------------------------------------------------------
GOTO End

:PrintDateTime
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
CALL :PrintDateTime
CALL :GetDateTime
REM IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True
GOTO SBSBackup

:SBSBackup
ECHO.
ECHO -- Start backup: NTBackup
"%SystemRoot%\system32\NTBackup.exe" backup "@C:\Program Files\Microsoft Windows Small Business Server\Backup\Small Business Backup Script.bks" /d "Manual Backup" /v:yes /r:no /rs:no /hc:on /m normal /j "Manual Backup Job" /l:f /p "4mm DDS" /UM
IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True
IF NOT %strSendEmail%' == True' GOTO DoEnd
FOR /F %%A IN ('dir "%USERPROFILE%\Local Settings\Application Data\Microsoft\Windows NT\NTBackup\data\*.log" /OD /b') DO SET strBackupLogFile=%%A
IF NOT "%strBackupLogFile%" == "" TYPE "%USERPROFILE%\Local Settings\Application Data\Microsoft\Windows NT\NTBackup\data\%strBackupLogFile%"
GOTO DoEnd

:DoEnd
REM Email the logbook to IT Services on Error.
REM -----------------------------------------------------------------------
IF %strSendEmail%' == True' CALL "%~dp0Tools\SendMail.cmd" "%~n0 (%COMPUTERNAME%)" "%~dp0LogFiles\%~n0.Log"
ECHO ---------------- End  : %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime
GOTO End

:Error
ECHO [ERROR] Error detected!
GOTO End

:End
REM -----------------------------------------------------------------------

