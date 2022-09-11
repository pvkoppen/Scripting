@echo on

:: ==============================================================
:: setimg.bat
:: Deploys a Linux disk image
::   NOTE: This is necessary b'c there is no Altiris AClient for Linux.
::
:: Input:
::   %imagefile% = an Altiris disk image
::   1) the specified files must be in the 'images' directory
:: ==============================================================

set images=f:\images

if "%imagefile%" == "" goto err2
if not exist %images%\%imagefile% goto err3

if exist f:\ibmaster.exe f:\ibmaster.exe -md -f%images%\%imagefile%
if errorlevel 1 goto err1
if errorlevel 0 goto err0

:err0
set severity=1
set status="Deploy Linux Image: Completed successfully."
if exist f:\logevent.exe f:\logevent.exe -l:%severity% -ss:%status%
goto done

:err1
set severity=3
set status="Deploy Linux Image: Unknown error."
if exist f:\logevent.exe f:\logevent.exe -l:%severity% -ss:%status%
goto done

:err2
set severity=3
set status="Deploy Linux Image: The IMAGEFILE variable is not defined."
if exist f:\logevent.exe f:\logevent.exe -l:%severity% -ss:%status%
goto done

:err3
set severity=3
set status="Deploy Linux Image: The IMAGEFILE variable value is invalid."
if exist f:\logevent.exe f:\logevent.exe -l:%severity% -ss:%status%
goto done

:done
set severity=
set status=

:end
