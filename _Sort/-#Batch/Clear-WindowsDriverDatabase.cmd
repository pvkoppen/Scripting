@ECHO OFF
REM Name          : Clear-WindowsDriverDatabase.cmd
REM Description   : Clear the Index files for Windows Driver Database.
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Must be run as: Administrator
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2010-07-31: 1.0: Initial version
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------

IF %1' == /silent' GOTO Log
IF %1' == /Action' GOTO Action
IF %1' == /Process' GOTO Process
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

TITLE Repairing Inf Cache
rem change to drive where windows runs
%SystemDrive%
rem change to the \windows\inf folder
cd %SystemRoot%\inf
GOTO CreateFolder

:CreateFolder
rem create random directory for backup
set FOLDERNAME=infbk-%RANDOM%
mkdir %FOLDERNAME%
ECHO %ERRORLEVEL%
IF NOT %ERRORLEVEL% == 0 GOTO CreateFolder

ECHO Process file for Windows: 9x/ME
CALL %0 /Process Drvdata.bin
CALL %0 /Process Drvidx.bin

ECHO Process file for Windows: NT/2k/XP/2k3/Vista/2k8/7
CALL %0 /Process INFPUB.DAT
CALL %0 /Process INFSTOR.DAT
CALL %0 /Process INFSTRNG.DAT
CALL %0 /Process INFCACHE.*
CALL %0 /Process SETUPAPI.*
ECHO Successfully moved all infcache related files to %FOLDERNAME%
GOTO DoEnd

:Process
ECHO Step1: Take ownership of the file(s) '%1'.
takeown /f %1
ECHO Step2: Grant FULL CONTROL to the file(s) '%1' to: 'administrators'.
icacls %1 /grant administrators:F /t
ECHO Step3: Move the file(s) '%1' to the backup folder '%FOLDERNAME%'.
Move %1 %FOLDERNAME%
GOTO End

:Original
rem list of files which need to be removed 
set FILE1=INFPUB.DAT
set FILE2=INFSTOR.DAT
set FILE3=INFSTRNG.DAT
set FILE4=INFCACHE.*
set FILE5=SETUPAPI.*

rem take ownership of the first file
takeown /f %FILE1%
rem grant full control to 'administrators'
icacls %FILE1% /grant administrators:F /t
rem move it to the backup folder
move %FILE1% %FOLDERNAME%

rem same for the other files
takeown /f %FILE2%
icacls %FILE2% /grant administrators:F /t
move %FILE2% %FOLDERNAME%

takeown /f %FILE3%
icacls %FILE3% /grant administrators:F /t
move %FILE3% %FOLDERNAME%

takeown /f %FILE4%
icacls %FILE4% /grant administrators:F /t
move %FILE4% %FOLDERNAME%

takeown /f %FILE5%
icacls %FILE5% /grant administrators:F /t
move %FILE5% %FOLDERNAME%

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

