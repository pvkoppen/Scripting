@ECHO OFF
REM Name          : Start-PowerShell.cmd
REM Description   : Script used to start a PowerShell Console / Run a PowerShell script.
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Must be run as: Administrator
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2009-11-01: v1.1: Added documentation.
REM 2009-11-25: v1.2: Updated the Name and added support for Exchange Scripts.
REM 2013-04-26: 1.2a: Updated the Name.
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------

IF %1' == ' GOTO StartConsole
IF %1' == /?' GOTO Help
IF %1' == /Log' GOTO Log 
IF %1' == /GetDateTime' GOTO GetDateTime
IF %1' == /PrintDateTime' GOTO PrintDateTime
IF %1' == D' GOTO ConsoleDPM
IF %1' == E' GOTO ConsoleEx
GOTO RunScript

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

:Documentation
GOTO End
C:\WINDOWS\system32\windowspowershell\v1.0\powershell.exe 
	-PSConsoleFile "C:\Program Files\Microsoft DPM\DPM\bin\dpmshell.psc1" 
	-noexit 
	-command ".'C:\Program Files\Microsoft DPM\DPM\bin\dpmcliinitscript.ps1'"
GOTO End

:Help
GOTO End

:Log
if not exist %2 ECHO Script '%2' does not exist
mkdir "%~dp0LogFiles"
C:\WINDOWS\system32\windowspowershell\v1.0\powershell.exe -command %2 > "%~dp0LogFiles\%~n2.log" 2>>&1
GOTO End

:StartConsole
Choice /C DE /N /M "Open a PowerShell Console screen for: DPM2007(D) | Exchange2007(E)"
IF %ERRORLEVEL%' == 255' GOTO Error-Console
IF %ERRORLEVEL%' == 2' GOTO ConsoleEx
IF %ERRORLEVEL%' == 1' GOTO ConsoleDPM
IF %ERRORLEVEL%' == 0' GOTO Error-Console
GOTO End

:RunScript
if not exist %1 GOTO Error
C:\WINDOWS\system32\windowspowershell\v1.0\powershell.exe -command %1
GOTO End

:ConsoleEx
C:\WINDOWS\system32\WindowsPowerShell\v1.0\PowerShell.exe -PSConsoleFile "C:\Program Files\Microsoft\Exchange Server\bin\exshell.psc1" -noexit -command ". 'C:\Program Files\Microsoft\Exchange Server\bin\Exchange.ps1'"
GOTO End

:ConsoleDPM
C:\WINDOWS\system32\windowspowershell\v1.0\powershell.exe -PSConsoleFile "C:\Program Files\Microsoft DPM\DPM\bin\dpmshell.psc1" -noexit -command ".'C:\Program Files\Microsoft DPM\DPM\bin\dpmcliinitscript.ps1'"
GOTO End

:Error
ECHO Script '%1' does not exist
Pause
GOTO End

:Error-Console
ECHO Wrong Selection
Pause
GOTO End

:End
REM -----------------------------------------------------------------------

