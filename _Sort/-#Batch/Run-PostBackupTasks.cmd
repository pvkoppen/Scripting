@ECHO OFF
REM Name          : Run-PostBackupTasks.cmd
REM Description   : Script used to run post-backup clean-up tasks.
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Version       : 1.1e
REM Must be run as: Administrator
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2009-01-04: Version 1.1
REM 2009-10-10: v1.1c: Renamed Exchange Check scripts.
REM 2009-07-20: v1.1e: Updated date&time format.
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------

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
GOTO End

:Action
ECHO.
ECHO ---------------- Start: %~dpnx0 on %ComputerName% ----------------
CALL %0 /PrintDateTime
REM IF %ERRORLEVEL%' == 0' SET strSendEmail=True
GOTO DoExchange

:DoExchange
:DoExchange-IMF
ECHO.
ECHO ------- Cleanup MsExchange Intelligent Message Filter(IMF) filtered files.
IF NOT EXIST "C:\Program Files\Exchsrvr\Mailroot\vsi 1\UceArchive\." GOTO DoExchange-POP3
CScript "%~dp0Remove-MsExchangeIMFOldFiles.vbs"
CALL %0 /PrintDateTime
GOTO DoExchange-POP3

:DoExchange-POP3
ECHO.
ECHO ------- Alert about MsExchange - POP3 - Failed Mail.
IF NOT EXIST "C:\Program Files\Microsoft Windows Small Business Server\Networking\POP3\Failed Mail\." GOTO DoInterbase
CALL "%~dp0Report-MsExchangePOP3FailedMail.cmd"
CALL %0 /PrintDateTime
GOTO DoInterbase

:DoInterbase
ECHO.
ECHO ------- Start the service: InterBase
IF NOT EXIST D:\Medtech\MT32\. GOTO DoMedTech
NET START InterBaseGuardian
NET START ManageMyHealthSMSCommunicator
CALL %0 /PrintDateTime
GOTO DoMedTech

:DoMedtech
ECHO.
ECHO ------- Kill InterBase dependant processes: 
CScript.exe "%~dp0Kill-Process.vbs" MT32.exe MTInbox.exe NIRMsgTransfer.exe
CALL %0 /PrintDateTime
GOTO DoSQL

:DoSQL
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

