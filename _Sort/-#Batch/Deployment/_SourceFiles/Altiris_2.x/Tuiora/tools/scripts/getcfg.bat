@echo on

:: ==============================================================
:: getcfg.bat
:: Captures a hardware configuration (hardware and array settings)
::   NOTE: This event overwrites any existing configuration files.
::
:: Output:
::   %hwrfile% = a CONREP file containing the hardware settings
::   %aryfile% = a ACR file containing the array settings
::   1) the files are written to the 'configs' directory
:: ==============================================================

if "%hwrfile%" == "" set hwrfile=cpqcap-h.ini
if "%aryfile%" == "" set aryfile=cpqcap-a.ini

set configs=f:\tuiora\configs
set scripts=f:\tuiora\tools\scripts

echo y | del %configs%\%hwrfile% > nul
call %scripts%\conrep.bat /sh %configs%\%hwrfile%

echo y | del %configs%\%aryfile% > nul
call %scripts%\acr.bat /c %configs%\%aryfile%

set scripts=
set configs=
