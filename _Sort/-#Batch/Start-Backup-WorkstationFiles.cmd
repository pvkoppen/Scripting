@ECHO OFF
REM Name        : Backup-WorkstationFiles.cmd
REM Description : Script used to Copy folders from PC's for Backup purposes.
REM Author      : Peter van Koppen,  Tui Ora Limited
REM Version     : 1.1c
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2009-01-04: Version 1.1
REM 2009-01-04: 1.1c: Added Error Email.
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------
Set Destination=D:\Backup-Config-Dump\WorkStations\

IF %1' == ' GOTO Log
IF %1' == /Action' GOTO Action
IF %1' == /PrintDateTime' GOTO PrintDateTime
IF %1' == /GetDateTime' GOTO GetDateTime
IF %1' == /RunPC' GOTO RunPC
GOTO Action

:PrintDateTime
REM -----------------------------------------------------------------------
ECHO -----------------------------------------------------------------------
@FOR /F "tokens=1-9 delims=/ " %%A IN ('date /t') DO @FOR /F "tokens=1-9 delims=:. " %%a IN ('time /t') DO ECHO -- DATE-TIME=%%A%%B%%C%%D-%%a%%b%%c%%d 
ECHO -----------------------------------------------------------------------
GOTO End

:GetDateTime
REM -----------------------------------------------------------------------
@FOR /F "tokens=1-9 delims=/ " %%A IN ('date /t') DO @FOR /F "tokens=1-9 delims=:. " %%a IN ('time /t') DO SET strDateTime=%%A%%B%%C%%D-%%a%%b%%c%%d && SET strDate=%%A%%B%%C%%D && SET strTime=%%a%%b%%c%%d
REM -----------------------------------------------------------------------
GOTO End

:Log
IF NOT EXIST "%~dp0LogFiles\." MKDIR "%~dp0LogFiles"
Move /Y "%~dp0LogFiles\%~n0.Log" "%~dp0LogFiles\%~n0.Old.Log"
Call %0 /Action >> "%~dp0LogFiles\%~n0.Log" 2>>&1
TYPE "%~dp0LogFiles\%~n0.Log" >> "%~dp0LogFiles\%~n0.History.Log"
GOTO End

:Action
ECHO.
ECHO ---------------- Start: %~dpnx0 on %ComputerName% ----------------
CALL %0 /PrintDateTime
FOR /F %%A IN (%~dpn0.txt) DO CALL %0 /RunPC %%A
REM IF %ERRORLEVEL%' == 0' SET strSendEmail=True
GOTO DoEnd

:RUNPC
ECHO %~n0: Processing Workstation: %2
Ping -w 60 %2
IF NOT %ERRORLEVEL%' == 0' GOTO End
MKDIR "%Destination%%2\"
NET USE "\\%2\C$"
dir /a /on "\\%2\C$" > "%Destination%%2\dir.txt"
REM XCopy /E /V /C /H /Y "\\%2\C$\SWIS Database" "%Destination%%2\SWIS Database\"
REM XCopy /E /V /C /H /Y "\\%2\C$\CGC" "%Destination%%2\CGC\"
%~dp0Tools\RoboCopy.exe /s /r:1 /w:3 "\\%2\C$\SWIS Database" "%Destination%%2\SWIS Database" 
%~dp0Tools\RoboCopy.exe /s /r:1 /w:3 "\\%2\C$\CGC" "%Destination%%2\CGC" 
NET USE "\\%2\C$" /DELETE
RMDIR /q "%Destination%%2\"
GOTO End

:Doco
goto end
%~dp0Tools\RoboCopy.exe /s /r:1 /w:3 "\\TTWSBS\C$\Documents and Settings" "%TargetPath%TTWSBS\Documents and Settings" /xd "*Temporary Internet Files*" "Cookies"
%~dp0Tools\RoboCopy.exe /s /r:1 /w:3 "\\TTWSBS\C$\Program Files\Intrahealth" "%TargetPath%TTWSBS\Program Files\Intrahealth.C" 
Pause
goto end

:DoEnd
REM Email the logbook to IT Services on Error.
REM -----------------------------------------------------------------------
IF %strSendEmail%' == True' CALL "%~dp0Tools\SendMail.cmd" "%~n0 (%COMPUTERNAME%)" "%~dp0LogFiles\%~n0.Log"
ECHO ---------------- End  : %~dpnx0 on %ComputerName% ----------------
CALL %0 /PrintDateTime
GOTO End

:End
REM -----------------------------------------------------------------------

