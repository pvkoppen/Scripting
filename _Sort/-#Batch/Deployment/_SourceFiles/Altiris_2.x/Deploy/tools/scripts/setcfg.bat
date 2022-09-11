@echo on

:: ==============================================================
:: setcfg.bat
:: Deploys a hardware configuration (hardware and array settings)
::
:: Input:
::   %osfile%  = a CONREP file containing just the OS settings
::   %hwrfile% = a CONREP file containing the rest of the hardware settings
::   %aryfile% = an ACR file containing array settings
::   1) the specified files must be in the 'configs' directory
::   2) if a file is not specified, then that step is skipped
::   3) if a file doesn't exist or is invalid, then the tool will catch that
:: ==============================================================

set configs=F:\Resource.TOL\Deploy\configs
set scripts=F:\Resource.TOL\Deploy\tools\scripts

if not "%osfile%" == "" call %scripts%\conrep.bat /l %configs%\%osfile%
if not "%hwrfile%" == "" call %scripts%\conrep.bat /l %configs%\%hwrfile%

if not "%aryfile%" == "" call %scripts%\acr.bat /i %configs%\%aryfile% /o

set scripts=
set configs=
