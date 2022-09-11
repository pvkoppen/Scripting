@ECHO OFF
REM Name          : Load-CopiedHyper-VChild.cmd
REM Description   : Script used to manually load copied Hyper-V definition files
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Must be run as: <No Preference: Administrators/LocalSystem>
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2009-12-03: 1.0: Initial Version
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------
SET strHyperVHome=D:\ProgramData\Microsoft\Windows\Hyper-V\
SET striSCSIHome=D:\iSCSI-LUN\

IF %1' == ' GOTO Help
GOTO Action

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

:Action
ECHO.
ECHO ---------------- Start: %~dpnx0 on %ComputerName% ----------------
CALL :PrintDateTime
REM IF %ERRORLEVEL%' == 0' SET strSendEmail=True

SET strSRVFolder=
SET strVMCode=
FOR /D %%A IN (%strHyperVHome%%1*) DO SET strSRVFolder=%%A\
IF %strSRVFolder%' == ' GOTO ErrorNotFound
FOR /F %%A IN ('DIR /AD /B "%strSRVFolder%Virtual Machines"') DO SET strVMCode=%%A
IF %strVMCode%' == ' GOTO ErrorNoVMCode

IF NOT EXIST "%SystemDrive%\ProgramData\Microsoft\Windows\Hyper-V\Virtual Machines\%strVMCode%.xml" mklink "%SystemDrive%\ProgramData\Microsoft\Windows\Hyper-V\Virtual Machines\%strVMCode%.xml" "%strSRVFolder%Virtual Machines\%strVMCode%.xml"
ECHO.
icacls "%SystemDrive%\ProgramData\Microsoft\Windows\Hyper-V\Virtual Machines\%strVMCode%.xml" /grant "NT VIRTUAL MACHINE\%strVMCode%":(F) /L
ECHO.
icacls "%strSRVFolder%." /T /grant "NT VIRTUAL MACHINE\%strVMCode%":(F)
ECHO.
GOTO DoEnd

:ErrorNotFound
ECHO [ERROR] ErrorNotFound
GOTO End

:ErrorNoVMCode
ECHO [ERROR] ErrorNoVMCode
GOTO End

:Help
ECHO [INFO ] Launch this batch with the name of the server you want to fix.
ECHO [INFO ] eg: %0 TOLTSxx
ECHO.
GOTO DoEnd

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

