@echo on

:: ==============================================================
:: getimg.bat
:: Captures a Linux disk image
::   NOTE: This event overwrites an existing image file.
::
:: Output:
::   %imagefile% = an Altiris disk image
::   1) the file is written to the 'images' directory
:: ==============================================================

if "%imagefile%" == "" set imagefile=cpqcap.img

set images=f:\images

echo y | del %images%\%imagefile% > nul
if exist f:\ibmaster.exe f:\ibmaster.exe -mu -p1-p2-p3-p4 -f%images%\%imagefile%
if errorlevel 1 goto err1
if errorlevel 0 goto err0

:err0
set severity=1
set status="Capture Linux Image: Completed successfully."
if exist f:\logevent.exe f:\logevent.exe -l:%severity% -ss:%status%
goto done

:err1
set severity=3
set status="Capture Linux Image: Unknown error."
if exist f:\logevent.exe f:\logevent.exe -l:%severity% -ss:%status%
goto done

:done
set severity=
set status=

:end
