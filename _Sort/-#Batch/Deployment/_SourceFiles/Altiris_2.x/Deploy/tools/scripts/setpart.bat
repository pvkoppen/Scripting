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

set configs=F:\Resource.TOL\Deploy\configs
set scripts=F:\Resource.TOL\Deploy\tools\scripts
set ssst=F:\Resource.TOL\Deploy\tools\ssst

if not "%prtfile%" == "" call %scripts%\cpqdisk.bat /w %configs%\%prtfile%

set ssst=
set scripts=
set configs=
