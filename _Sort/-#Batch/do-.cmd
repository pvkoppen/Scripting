@ECHO OFF

:Choice
ECHO.
ECHO A: Attache,        C: RDP Console,    
ECHO E: End,            F: E-Pro Map,      G: GP,             
ECHO L: Logoff,         
ECHO M: Medtech-KOI,    N: Medtech-TAM,    P: PrinterInstall, 
ECHO R: RDP,            S: Set.
ECHO 2: Rerun-Printerinstall
Choice /C ACEFGLMNPRS2 /M "Select"
IF %ErrorLevel%' == 255' GOTO Choice
IF %ErrorLevel%' ==  0' GOTO Choice
IF %ErrorLevel%' ==  1' GOTO Attache
IF %ErrorLevel%' ==  2' GOTO RDP-COnsole
IF %ErrorLevel%' ==  3' GOTO DoEnd
IF %ErrorLevel%' ==  4' GOTO E-Pro
IF %ErrorLevel%' ==  5' GOTO GP
IF %ErrorLevel%' ==  6' GOTO Logoff
IF %ErrorLevel%' ==  7' GOTO MT-KOI
IF %ErrorLevel%' ==  8' GOTO MT-TAM
IF %ErrorLevel%' ==  9' GOTO PrinterInstall
IF %ErrorLevel%' == 10' GOTO RDP
IF %ErrorLevel%' == 11' GOTO Set
IF %ErrorLevel%' == 12' GOTO Printer-Rerun
IF %ErrorLevel%' == 13' GOTO ToDo
GOTO Choice

:Attache
ECHO.
ECHO -- Map Drive.
NET USE P: /DELETE
NET USE P: \\TOLFP01\Applications$
P:\Attache\Attache.exe
GOTO Choice

:RDP-Console
ECHO.
ECHO -- RDP Client - COnsole
MSTSC /admin 
mstsc /CONSOLE
GOTO Choice

:E-Pro
ECHO.
ECHO -- Map TIHI Application Drive to: M.
NET USE M: \\TIHIS01\Applications$
ECHO.
ECHO -- Start Events-Pro.
start "" "M:\EVENTWIN\Events.exe"
Goto Choice

:GP
ECHO.
ECHO -- GPUpdate.
GPUpdate.exe /Force
ECHO.
ECHO -- Del Report.
CD
IF EXIST "%~dp0GPReport.html" Del "%~dp0GPReport.html"
ECHO.
ECHO -- GPResult.
GPResult.exe /H "%~dp0GPReport.html"
ECHO.
ECHO -- Show Report or Log.
IF EXIST "%~dp0GPReport.html" start "" "%~dp0GPReport.html"
IF NOT EXIST "%~dp0GPReport.html" GPResult.exe /V
GOTO Choice

:Logoff
ECHO.
ECHO -- Logging off
Logoff
GOTO DoEnd

:MT-KOI
ECHO.
ECHO -- Map Drive.
NET USE M: /DELETE
NET USE M: \\KOIMT01\MT32
M:\Bin\MT32.exe
GOTO Choice

:MT-TAM
ECHO.
ECHO -- Map Drive.
NET USE M: /DELETE
NET USE M: \\TAMMT01\MT32$
M:\Bin\MT32.exe
GOTO Choice

:PrinterInstall
ECHO.
ECHO -- TS: Install All LoginScript Printers (And drivers)
Call "\\TOLOCS01\Software\Scripts\Printers-InstallDefaultDrivers.cmd"
GOTO Choice

:Printer-Rerun
ECHO.
ECHO -- TS: Install All LoginScript Printers (And drivers)
CScript "\\TOLOCS01\Software\Scripts\Printers-InstallDefaultDrivers.vbs"
GOTO Choice

:RDP
ECHO.
ECHO -- RDP Client
mstsc
GOTO Choice

:Set
ECHO.
ECHO -- Set
SET
GOTO Choice

:ToDo
ECHO.
ECHO -- Option not configure yet, returning to Menu
Pause
GOTO Choice

:DoEnd
Pause
GOTO End

:End

