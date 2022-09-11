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
Set Destination=G:\Backup-Config-Dump\WorkStations\

IF %1' == ' GOTO Log
IF %1' == /Action' GOTO Action
IF %1' == /PrintDateTime' GOTO PrintDateTime
IF %1' == /GetDateTime' GOTO GetDateTime
IF %1' == /RunPC' GOTO RunPC
IF %1' == /DriveDir' GOTO DriveDir
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
REM IF %ERRORLEVEL%' == 0' 
SET strSendEmail=True
GOTO DoEnd

:DriveDir
DIR /B /AD /ON %2\ | FIND /V /I "Windows" | FIND /V /I "Program Files" | FIND /V /I "Program Files (x86)" | FIND /V /I "System Volume Information" | FIND /V /I "RECYCLER" | FIND /V /I "$Recycle.Bin" | FIND /V /I "Documents and Settings" | FIND /V /I "Users" | FIND /V /I "inetpub" | FIND /V /I "ProgramData" | FIND /V /I "PerfLog"
GOTO End

:RUNPC
ECHO %~n0: Processing Workstation: %2
Ping -w 60 %2
IF NOT %ERRORLEVEL%' == 0' GOTO End
MKDIR "%Destination%%2\"

MKDIR "%Destination%%2\C\"
NET USE "\\%2\C$" /user:%2\ITServices Pa55word
NET USE "\\%2\C$" /user:%2\ITService Pa55word
dir /a /on "\\%2\C$" > "%Destination%%2\C\dir.txt"
"%~dp0Tools\RoboCopy.exe" /e /xjd /np /lev:32 /r:1 /w:3 "\\%2\C$\Documents and Settings" "%TargetPath%%2\C\Documents and Settings" /xd "*Temporary Internet Files*" "Cookies"
"%~dp0Tools\RoboCopy.exe" /e /xjd /np /lev:32 /r:1 /w:3 "\\%2\C$\Users" "%TargetPath%%2\C\Documents and Settings" /xd "*Temporary Internet Files*" "Cookies"
FOR /F %%A IN ('%0 /DriveDir \\%2\C$\') DO "%~dp0Tools\RoboCopy.exe" /e /xjd /np /lev:32 /r:1 /w:3 "\\%2\C$\%%A" "%TargetPath%%2\C\%%A" 
NET USE "\\%2\C$" /DELETE
RMDIR /q "%Destination%%2\C"

RMDIR /q "%Destination%%2\"
GOTO End

:Server
goto end
FOR /F %%A IN ('%0 /DriveDir \\BHServer\C$\') DO "%~dp0Tools\RoboCopy.exe" /e /xjd /np /lev:32 /r:1 /w:3 "\\BHServer\C$\%%A" "%TargetPath%%2\C\%%A" 
FOR /F %%A IN ('%0 /DriveDir \\BHServer\C$\') DO "%~dp0Tools\RoboCopy.exe" /e /xjd /np /lev:32 /r:1 /w:3 "\\BHServer\C$\%%A" "%TargetPath%%2\C\%%A" 
GOTO End

:DoEnd
REM Email the logbook to IT Services on Error.
REM -----------------------------------------------------------------------
IF %strSendEmail%' == True' CALL "%~dp0Tools\SendMail.cmd" "%~n0 (%COMPUTERNAME%)" "%~dp0LogFiles\%~n0.Log"
ECHO ---------------- End  : %~dpnx0 on %ComputerName% ----------------
CALL %0 /PrintDateTime
GOTO End

:End
REM -----------------------------------------------------------------------

