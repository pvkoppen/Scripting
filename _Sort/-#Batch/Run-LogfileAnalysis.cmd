@ECHO OFF
REM Name          : Run-LogfileAnalysis.cmd
REM Description   : Script used to analyse the IIS website logfiles.
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Version       : 1.0
REM Must be run as: Administrator
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2009-01-04: Version 1.1
REM 2009-07-20: v1.1e: Updated date&time format.
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------
SET TargetFolder=\\tolws01\d$\InetPub\wwwroot\webalizer\
ECHO RunParams= %0 %*

IF %1' == ' GOTO Log
IF %1' == /GetDateTime' GOTO GetDateTime
IF %1' == /PrintDateTime' GOTO PrintDateTime
IF %1' == /Action' GOTO Action
IF %1' == /ProcessLogFolder' GOTO FindTempFolder
IF %1' == /HasSubFolder' GOTO Convert
IF %1' == /Converted' GOTO GetConfig
IF %1' == /WebAlize' GOTO WebalizeFiles
GOTO Error

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

REM ---------------------------------------------------------------
REM -- Remove previous run data. (Dev Only!)
REM ---------------------------------------------------------------
 del /q %TargetFolder%tolws01-tuiora.www\*.*
 del /q %TargetFolder%tolws01-iisadmin\*.*
 del /q %TargetFolder%tolws01-tuiora\*.*
 del /q %TargetFolder%tolws01-tuioraremote\*.*
 del /q %TargetFolder%tolws01-teraupani\*.*
 del /q %TargetFolder%tolws01-wwwroot\*.*

REM ---------------------------------------------------------------
REM -- Run Webalizer for the <Server>\W3SVC* folders.
REM ---------------------------------------------------------------
ECHO.
ECHO ------------- Beginning Process Run -------------
IF NOT EXIST "%~dpn0.txt" GOTO Error
FOR /F %%A IN ("%~dpn0.txt") DO FOR /D %%B IN ("%%A\W3SVC*") DO CALL %0 /ProcessLogFolder %%B
ECHO ------------- Finished Process Run -------------

:FindTempFolder
REM ---------------------------------------------------------------
REM -- %2=W3SVC folder
REM ---------------------------------------------------------------
ECHO # Processing Folder: %2
FOR /d %%A IN (%2\*) DO CALL %0 /HasSubFolder %2 %%A
GOTO End

:Convert
REM ---------------------------------------------------------------
REM -- %2=W3SVC folder, %3=ConvertedData folder
REM ---------------------------------------------------------------
ECHO ## Removing old converted files: %2\*.ncsa.dns*
DEL /Q %3\*.ncsa.dns*
ECHO ## Rebuilding NCSA Common Log Format Files.
REM v1= Convert Using: ConvLog
REM FOR %%A IN (%2\ex*.log) DO "%~dp0Tools\LogfileConversion\ConvLog.exe" -ie -t ncsa:+1200 -o %3 %%A
REM v2= Convert Using: RConvLog
"%~dp0Tools\LogfileConversion\RConvLog.exe" -d -t ncsa:+1200 -o %3 %2\ex*.log
ECHO ## Correcting NCSA file with Timezone.
FOR %%A IN (%3\*.ncsa.dns) DO "%~dp0Tools\LogfileConversion\DateCorrection.vbs" %%A
CALL %0 /Converted %2 %3
GOTO End

:GetConfig
REM ---------------------------------------------------------------
REM -- %2=W3SVC folder, %3=ConvertedData folder
REM ---------------------------------------------------------------
REM -- Run Webalizer for all *.nz.conf config files.
REM ---------------------------------------------------------------
FOR %%A IN (%3\*.conf) DO CALL %0 /WebAlize %2 %3 %%A
GOTO End

:WebalizeFiles
REM ---------------------------------------------------------------
REM -- %2=W3SVC folder, %3=ConvertedData folder, %4=ConfigFile
REM ---------------------------------------------------------------
REM -- Run Webalizer for all *.nz.conf config files.
REM ---------------------------------------------------------------
ECHO ### Run Webalizer for folder: %2.
FOR %%A IN (%3\*.timezonecorrected) DO "%~dp0Tools\webalizer-2.21-02-cygwin\webalizer.exe -c %4 %%A
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
ECHO - Either there was a wrong parameter passed or 
ECHO - Or the WebLocation list was not found
GOTO End

:End
REM -----------------------------------------------------------------------

