@ECHO OFF
REM Name          : Restart-Server.cmd
REM Description   : Script used to Restart the server (With a /silent option for scheduled operation).
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Must be run as: <No Preference: Administrators/LocalSystem>
REM Location      : C:\Admin\Scripts
REM Tools Required: shutdown, SendMail.cmd
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2009-12-09: 1.1: First published Edition
REM 2010-08-12: 1.2: When performing a silent run activate logging.
REM 2010-08-12: 1.2a Updated Date-Time
REM 2014-12-21: 2.0 New Structure
REM 2015-07-24: 2.0a Added...
REM 2015-12-09: 2.0b Added Exchange shutdown to server restart script.
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------
TITLE %~n0
ECHO [INFO ] Application Settings

ECHO [INFO ] Parameters: %*
IF %1' == /?' GOTO Help
IF %1' == /silent' GOTO Log
IF %1' == /Action' GOTO Action
GOTO AreYouSure

:GetDateTime
@FOR /F "tokens=1-9 delims=/ " %%A IN ('date /t') DO @FOR /F "tokens=1-9 delims=:. " %%a IN ('time /t') DO SET strDateTime=%%D%%C%%B[%%A]-%%c%%d%%a%%b&& SET strDate=%%D%%C%%B[%%A]&& SET strTime=%%c%%d%%a%%b
GOTO End

:PrintDateTime
ECHO [INFO ] -----------------------------------------------------------------------
@FOR /F "tokens=1-9 delims=/ " %%A IN ('date /t') DO @FOR /F "tokens=1-9 delims=:. " %%a IN ('time /t') DO ECHO [INFO ] -- DATE-TIME=%%D%%C%%B[%%A]-%%c%%d%%a%%b 
ECHO [INFO ] -----------------------------------------------------------------------
GOTO End

:AreYouSure
ECHO.
CHOICE /C YN /M "[QUESTION] Are you sure you want to "%~n0" (on %COMPUTERNAME%)?"
IF %ERRORLEVEL% == 255 GOTO Error
IF %ERRORLEVEL% == 2 GOTO End
IF %ERRORLEVEL% == 1 GOTO Action
IF %ERRORLEVEL% == 0 GOTO Error
GOTO End

:Documentation
GOTO End
...
GOTO End

:Help
GOTO End

:Log
ECHO [INFO ] Start Logging
IF NOT EXIST "%~dp0..\LogFiles\." MKDIR "%~dp0..\LogFiles"
MOVE /Y "%~dp0..\LogFiles\%~n0.Log" "%~dp0..\LogFiles\%~n0.Old.Log"
CALL %0 /Action %2 >> "%~dp0..\LogFiles\%~n0.Log" 2>>&1
TYPE "%~dp0..\LogFiles\%~n0.Log" >> "%~dp0..\LogFiles\%~n0.History.Log"
GOTO End

:Action
ECHO.
ECHO [INFO ] ---------------- Start: %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime
CALL :GetDateTime
REM IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True

IF EXIST "C:\Program Files\Microsoft\Exchange Server\bin\store.exe" CALL :Exchange

"%SystemRoot%\System32\Shutdown.exe" /f /r /t 30 /c "System: Server restart by batch: %~f0"
IF NOT %ERRORLEVEL%' == 0' SET strSendEmail=True
ECHO [INFO ] Completed.
GOTO DoEnd

:Exchange
NET STOP MsExchangeIS
NET STOP MsExchangeSA
GOTO End

:DoEnd
ECHO [INFO ] Email the logbook to IT Services on Error.
IF %strSendEmail%' == True' CALL "%~dp0..\Tools\SendMail.cmd" "%~n0 (%COMPUTERNAME%) - Completed with Errors" "%~dp0..\LogFiles\%~n0.Log"
REM IF NOT %strSendEmail%' == True' CALL "%~dp0..\Tools\SendMail.cmd" "%~n0 (%COMPUTERNAME%) - Completed Succesfully" "%~dp0..\LogFiles\%~n0.Log"
ECHO [INFO ] ---------------- End  : %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime
GOTO End

:Error
ECHO [ERROR] Error detected! [%ERRORLEVEL%]
ECHO [ERROR] Full Internal Server DNS name = %COMPUTERNAME%.%USERDNSDOMAIN%
GOTO End

:End
REM -----------------------------------------------------------------------

