REM Activity      : Printer: Install default drivers
REM Created by    : Peter van Koppen
REM Company       : Tui Ora Limited
REM Date Created  : 2006-08-14
REM Must be run as: An Administrator (Not LOCALSYSTEM)
REM -----------------------------------------------------------------
IF EXIST C:\Altiris\Tools\WhoAmI.exe C:\Altiris\Tools\WhoAmI.exe
IF NOT "%ERRORLEVEL%" == "0"         ECHO Username=%UserName%
for /f "tokens=*" %%a in ('date /t') do for /f "tokens=*" %%b in ('time /t') do echo DATE/TIME= %%a- %%b

if %1' == ' GOTO RestartBatchWithLogging
goto ProcessBatch

:RestartBatchWithLogging
IF NOT EXIST C:\Altiris\nul MD C:\Altiris
IF NOT EXIST C:\Altiris\LogFiles\nul MD C:\Altiris\LogFiles
ECHO ---------------- Start: %0 ---------------- >> C:\Altiris\LogFiles\AltirisAutomatedBuildProcess.LOG
CALL %0 ProcessBatch   >>C:\Altiris\LogFiles\AltirisAutomatedBuildProcess.LOG 2>>&1
ECHO ---------------- End  : %0 ---------------- >> C:\Altiris\LogFiles\AltirisAutomatedBuildProcess.LOG
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
echo. > c:\altiris\AddPrinterDrivers.vbs
echo ' Set Option Explicit and Global Variables >> c:\altiris\AddPrinterDrivers.vbs
echo ' ---------------------------------------------------------- >> c:\altiris\AddPrinterDrivers.vbs
echo Option Explicit >> c:\altiris\AddPrinterDrivers.vbs
echo Dim boolDebug >> c:\altiris\AddPrinterDrivers.vbs
echo boolDebug = False >> c:\altiris\AddPrinterDrivers.vbs
echo 'boolDebug = True >> c:\altiris\AddPrinterDrivers.vbs
echo If (boolDebug) Then On Error Goto 0 Else On Error Resume Next End If >> c:\altiris\AddPrinterDrivers.vbs
echo. >> c:\altiris\AddPrinterDrivers.vbs
echo ' Procedure: MapPrinter >> c:\altiris\AddPrinterDrivers.vbs
echo ' Does: Checks if the current user has the give printer installed. >> c:\altiris\AddPrinterDrivers.vbs
echo '     : If the printer is not installed an attempt will be made to install it. >> c:\altiris\AddPrinterDrivers.vbs
echo '     : The UNC printer name has to be the long name as listed in the  >> c:\altiris\AddPrinterDrivers.vbs
echo '       'printers and faxes' folder on the server! >> c:\altiris\AddPrinterDrivers.vbs
echo ' ---------------------------------------------------------- >> c:\altiris\AddPrinterDrivers.vbs
echo Public Sub MapPrinter(strUNCPrinter) >> c:\altiris\AddPrinterDrivers.vbs
echo   ' Declare Variables. >> c:\altiris\AddPrinterDrivers.vbs
echo   Dim objNetwork, objPrinters, intPrinter, boolAddPrinter >> c:\altiris\AddPrinterDrivers.vbs
echo   ' Bind to Active Directory. >> c:\altiris\AddPrinterDrivers.vbs
echo   Set objNetwork  = CreateObject("WScript.Network") >> c:\altiris\AddPrinterDrivers.vbs
echo   Set objPrinters = objNetwork.EnumPrinterConnections >> c:\altiris\AddPrinterDrivers.vbs
echo   ' Here we check if the printer already exists. >> c:\altiris\AddPrinterDrivers.vbs
echo   objNetwork.AddWindowsPrinterConnection strUNCPrinter >> c:\altiris\AddPrinterDrivers.vbs
echo   ' Cleanup. >> c:\altiris\AddPrinterDrivers.vbs
echo   Set objPrinters = Nothing >> c:\altiris\AddPrinterDrivers.vbs
echo   Set objNetwork  = Nothing >> c:\altiris\AddPrinterDrivers.vbs
echo end Sub >> c:\altiris\AddPrinterDrivers.vbs

echo. >> c:\altiris\AddPrinterDrivers.vbs
echo ' Add configured printers from the login script to this generated VBS script. >> c:\altiris\AddPrinterDrivers.vbs
echo ' ---------------------------------------------------------- >> c:\altiris\AddPrinterDrivers.vbs
type \\tol.local\sysvol\tol.local\scripts\loginscript.vbs | find /i "MapPrinter(""\\" >> c:\altiris\AddPrinterDrivers.vbs
echo. >> c:\altiris\AddPrinterDrivers.vbs
echo ' Add printer comments from the login script to this generated VBS script. >> c:\altiris\AddPrinterDrivers.vbs
echo ' ---------------------------------------------------------- >> c:\altiris\AddPrinterDrivers.vbs
type \\tol.local\sysvol\tol.local\scripts\loginscript.vbs | find /i "'MapPrinter" >> c:\altiris\AddPrinterDrivers.vbs

echo. >> c:\altiris\AddPrinterDrivers.vbs
echo ' Final. >> c:\altiris\AddPrinterDrivers.vbs
echo ' ---------------------------------------------------------- >> c:\altiris\AddPrinterDrivers.vbs
echo Wscript.Quit >> c:\altiris\AddPrinterDrivers.vbs
echo. >> c:\altiris\AddPrinterDrivers.vbs

cscript c:\altiris\AddPrinterDrivers.vbs

REM Set this user session in Execute mode (For Terminal Servers Only)
REM -----------------------------------------------------------------
"%SystemRoot%\System32\change.exe" user /execute

REM Make the server wait for a moment to finalize all installation processes.
REM -----------------------------------------------------------------
IF EXIST C:\Altiris\Tools\aWait.exe C:\Altiris\Tools\aWait.exe 30 "Waiting for 1/2 minute(s) to finalize Installs/Updates. Seconds remaining: %%d"

:END
for /f "tokens=*" %%a in ('date /t') do for /f "tokens=*" %%b in ('time /t') do echo DATE/TIME= %%a- %%b

