@echo off
:: ==============================================================
:: CLDEPSTG.BAT - Creates the shared arrays using ACUXE
::
:: Input:
::   storage.ini = Array configuration file for the shared storage
::   %AXSERVER% = deployment server name - need this to use 
::		  doswait.exe, if it cannot be copied during setup.
::
:: Output:
::   tempstrg = Three temporary files are used to capture the serial 
::		number, and comment the RaidArrayID from the array 
::		file if it is present.
::
::   1) storage file is located on the target in c:\$OEM$\clusters
::   2) ACUXE creates an error log file and places them on the target
:: ==============================================================
set TOOLS=c:\$OEM$
set WAIT=c:\$OEM$\doswait.exe
set ACU="c:\Program Files\compaq\cpqacuxe\bin\cpqacuxe.exe"
set STORAGEFILE=c:\$OEM$\clusters\storage.ini

set TEMPPATH=c:\$OEM$\clusters\temp
set TEMPSTRG=%TEMPPATH%\tempstrg.ini
set NEWSTRG1=%TEMPPATH%\newstrg1.ini
set NEWSTRG2=%TEMPPATH%\newstrg2.ini

::set TEMPSTRG=c:\$OEM$\clusters\tempstrg.ini
::set NEWSTRG1=c:\$OEM$\clusters\newstrg1.ini
::set NEWSTRG2=c:\$OEM$\clusters\newstrg2.ini

:: ==============================================================
:: Call ACUXE.EXE locally to capture the serial number for the SACS. 
:: Then use sed to extract the serial number, put it in the existing 
:: configuration file and comment the RaidArrayID line and then call 
:: ACU again to deploy the shared storage configuration with the 
:: updated storage file.
:: ==============================================================
%ACU% -c %TEMPSTRG%
%WAIT% 10
for /F "usebackq tokens=3 delims= " %%i in (`%TOOLS%\grep.exe SerialNumber %TEMPSTRG%`) do set SERIAL=%%i
%TOOLS%\sed.exe -e "/RaidArrayId=/s/^/;/g" %STORAGEFILE% > %NEWSTRG1%
%TOOLS%\sed.exe -e "/Controller= SerialNumber/s/.*$/Controller= SerialNumber %SERIAL%/g" %NEWSTRG1% > %NEWSTRG2%
del %STORAGEFILE%
move %NEWSTRG2% %STORAGEFILE%

%WAIT% 10
%ACU% -i %STORAGEFILE%
%WAIT% 30

:: ==============================================================
:: Verify storage deployment by looking for any error files.
:: ==============================================================
if exist "c:\winnt\system32\error.ini" goto err6910
if exist "c:\windows\system32\error.ini" goto err6910
if exist "c:\Program Files\Compaq\Cpqacuxe\Bin\error.ini" goto err6910
if exist "c:\error.ini" goto err6910
goto done 

:: ==============================================================
:: Errors
:: ==============================================================
:err6910
SET SEVERITY=3
SET STATUS="ACU encountered errors deploying the shared storage."
IF EXIST c:\altiris\aclient\WLOGEVENT.EXE c:\altiris\aclient\WLOGEVENT.EXE -c:6910 -id:%ID% -l:%SEVERITY% -ss:"%STATUS%"
goto end

:done
SET SEVERITY=1
SET STATUS="Successfully deployed the shared storage configuration."
IF EXIST c:\altiris\aclient\WLOGEVENT.EXE c:\altiris\aclient\WLOGEVENT.EXE -c:0 -id:%ID% -l:%SEVERITY% -ss:"%STATUS%"

 :end