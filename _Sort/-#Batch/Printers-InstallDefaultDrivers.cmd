REM Activity      : Printer: Install default drivers
REM Created by    : Peter van Koppen
REM Company       : Tui Ora Limited
REM Date Created  : 2006-08-14
REM Must be run as: An Administrator (Not LOCALSYSTEM)
REM -----------------------------------------------------------------
IF EXIST %~dp0Tools\WhoAmI.exe %~dp0Tools\WhoAmI.exe
IF NOT "%ERRORLEVEL%" == "0"         ECHO Username=%UserName%
for /f "tokens=*" %%a in ('date /t') do for /f "tokens=*" %%b in ('time /t') do echo DATE/TIME= %%a- %%b

if %1' == ' GOTO RestartBatchWithLogging
goto ProcessBatch

:RestartBatchWithLogging
IF NOT EXIST %~dp0nul MD C:\Altiris
IF NOT EXIST %~dp0LogFiles\nul MD %~dp0LogFiles
ECHO ---------------- Start: %0 ---------------- >> %~dp0LogFiles\%~n0.LOG
CALL %0 ProcessBatch   >>%~dp0LogFiles\%~n0.LOG 2>>&1
ECHO ---------------- End  : %0 ---------------- >> %~dp0LogFiles\%~n0.LOG
GOTO End

:ProcessBatch
REM Set this user session in Install mode (For Terminal Servers Only)
REM -----------------------------------------------------------------
"%SystemRoot%\System32\change.exe" user /install

REM Make a drive mapping to the Altiris Resource Folder
REM -----------------------------------------------------------------
set USE_DRIVE=
for /d %%a in (M L K J I H G F) do if exist %%a:\_usr.lib\nul set USE_DRIVE=%%a:
if "%USE_DRIVE%" == "" for /d %%a in (M L K J I H G F) do if not exist %%a:\nul set USE_DRIVE=%%a:
if not exist %USE_DRIVE%\nul net use %USE_DRIVE% \\TOLDS01.tol.local\Express /User:Altiris alt1r1s /PERSISTENT:NO
if not "%ERRORLEVEL%" == "0" net use %USE_DRIVE% \\TOLDS01.tol.local\Express /PERSISTENT:NO

REM Locate the installation folder and run the Install(s)
REM -----------------------------------------------------------------
%USE_DRIVE%
echo. > %~dp0%~n0.vbs
echo ' Set Option Explicit and Global Variables >> %~dp0%~n0.vbs
echo ' ---------------------------------------------------------- >> %~dp0%~n0.vbs
echo Option Explicit >> %~dp0%~n0.vbs
echo Dim boolDebug >> %~dp0%~n0.vbs
echo boolDebug = False >> %~dp0%~n0.vbs
echo 'boolDebug = True >> %~dp0%~n0.vbs
echo If (boolDebug) Then On Error Goto 0 Else On Error Resume Next End If >> %~dp0%~n0.vbs
echo. >> %~dp0%~n0.vbs
echo ' Procedure: MapPrinter >> %~dp0%~n0.vbs
echo ' Does: Checks if the current user has the give printer installed. >> %~dp0%~n0.vbs
echo '     : If the printer is not installed an attempt will be made to install it. >> %~dp0%~n0.vbs
echo '     : The UNC printer name has to be the long name as listed in the  >> %~dp0%~n0.vbs
echo '       'printers and faxes' folder on the server! >> %~dp0%~n0.vbs
echo ' ---------------------------------------------------------- >> %~dp0%~n0.vbs
echo Public Sub MapPrinter(strUNCPrinter) >> %~dp0%~n0.vbs
echo   ' Declare Variables. >> %~dp0%~n0.vbs
echo   Dim objNetwork, objPrinters, intPrinter, boolAddPrinter >> %~dp0%~n0.vbs
echo   Dim strResult >> %~dp0%~n0.vbs
echo   ' Bind to Active Directory. >> %~dp0%~n0.vbs
echo   Set objNetwork  = CreateObject("WScript.Network") >> %~dp0%~n0.vbs
echo   Set objPrinters = objNetwork.EnumPrinterConnections >> %~dp0%~n0.vbs
echo   ' Here we check if the printer already exists. >> %~dp0%~n0.vbs
echo   objNetwork.AddWindowsPrinterConnection strUNCPrinter >> %~dp0%~n0.vbs
echo  WScript.Echo "Adding Printer:"^& strUNCPrinter ^&" ("^&strResult^&")." >> %~dp0%~n0.vbs
echo   ' Cleanup. >> %~dp0%~n0.vbs
echo   Set objPrinters = Nothing >> %~dp0%~n0.vbs
echo   Set objNetwork  = Nothing >> %~dp0%~n0.vbs
echo end Sub >> %~dp0%~n0.vbs

echo. >> %~dp0%~n0.vbs
echo ' Add configured printers from the login script to this generated VBS script. >> %~dp0%~n0.vbs
echo ' ---------------------------------------------------------- >> %~dp0%~n0.vbs
type \\tol.local\sysvol\tol.local\scripts\loginscript.vbs | find /i "MapPrinter(""\\" >> %~dp0%~n0.vbs
echo. >> %~dp0%~n0.vbs
echo ' Add printer comments from the login script to this generated VBS script. >> %~dp0%~n0.vbs
echo ' ---------------------------------------------------------- >> %~dp0%~n0.vbs
type \\tol.local\sysvol\tol.local\scripts\loginscript.vbs | find /i "'MapPrinter" >> %~dp0%~n0.vbs

echo. >> %~dp0%~n0.vbs
echo ' Final. >> %~dp0%~n0.vbs
echo ' ---------------------------------------------------------- >> %~dp0%~n0.vbs
echo Wscript.Quit >> %~dp0%~n0.vbs
echo. >> %~dp0%~n0.vbs

cscript %~dp0%~n0.vbs

REM Set this user session in Execute mode (For Terminal Servers Only)
REM -----------------------------------------------------------------
"%SystemRoot%\System32\change.exe" user /execute

REM Make the server wait for a moment to finalize all installation processes.
REM -----------------------------------------------------------------
IF EXIST %~dp0Tools\aWait.exe IF NOT %PROCESSOR_ARCHITECTURE%' == AMD64' %~dp0Tools\aWait.exe 30 "Waiting for 1/2 minute(s) to finalize Installs/Updates. Seconds remaining: %%d"

:END
for /f "tokens=*" %%a in ('date /t') do for /f "tokens=*" %%b in ('time /t') do echo DATE/TIME= %%a- %%b

