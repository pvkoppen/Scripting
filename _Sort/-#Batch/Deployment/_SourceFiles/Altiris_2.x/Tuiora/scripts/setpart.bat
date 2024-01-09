@echo on

:: ==============================================================
:: setpart.bat
:: Deploys the disk partition configuration
::
:: Input:
::   %prtfile% = a CPQDISK file containing partitioning settings
::   1) the specified file must be in the 'configs' directory
::   2) if a file is not specified, then that step is skipped
::   3) if a file doesn't exist or is invalid, then the tool will catch that
:: ==============================================================

set configs=f:\staples\configs
set scripts=f:\staples\tools\scripts
set ssst=f:\deploy\tools\ssst

if not "%prtfile%" == "" call %scripts%\cpqdisk.bat /w %configs%\%prtfile%

set ssst=
set scripts=
set configs=
