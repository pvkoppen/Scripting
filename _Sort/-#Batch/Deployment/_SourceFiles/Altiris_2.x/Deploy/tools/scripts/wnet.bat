@echo on

:: ==============================================================
:: wnet.bat
:: Windows 2003 Scripted Install Script
::
:: Input:
::   %ss%           = the name of the folder of which support files to use
::   %os%           = the name of the folder of which OS files to use
::   %unattendfile% = the name of the unattend.txt file
::   %ssos%         = (optional) the name of the subfolder in the %ss% folder to use
::   %skipformat%   = (optional) whether or not to skip the format step
:: ==============================================================

if "%ssos%" == "" set ssos=%os%

set configs=F:\Resource.TOL\Deploy\configs
set tools=F:\Resource.TOL\Deploy\tools
set ssst=F:\Resource.TOL\Deploy\tools\ssst
set sspath=F:\Resource.TOL\Deploy\cds\compaq\%ss%\%ssos%
;set ospath=F:\Resource.TOL\Deploy\cds\windows\%os%
set ospath=F:\Resource.TOL\OS\%os%

if "%ss%" == "" goto err1
if not exist %sspath%\*.* goto err2
if "%os%" == "" goto err3
if not exist %ospath%\i386\*.* goto err4
if "%unattendfile%" == "" goto err5
if not exist %configs%\%unattendfile% goto err6

:: Format the hard drive
if "%skipformat%" == "yes" goto skipformat
REM ;default;%ssst%\cpqfmt.com c:
echo y|format.com c: /v:System
echo test > c:\test.txt
if not exist c:\test.txt goto err7
echo y | del c:\test.txt > nul
:skipformat

:: Copy OEM drivers and the Support Paq
%ssst%\filecopy.exe /s:%sspath% /d:c:\$oem$ /f:*.* /s /e
md c:\$oem$\Tools
copy /y %tools%\*.* c:\$oem$\Tools
copy /y %configs%\%unattendfile% c:\$oem$\unattend.txt
if "%computername%" == "" goto nameskip
%tools%\sed.exe -e "s/ComputerName=\*/ComputerName=%computername%/" c:\$oem$\unattend.txt > c:\$oem$\unattend.new
del c:\$oem$\unattend.txt
copy /y c:\$oem$\unattend.new c:\$oem$\unattend.txt
del c:\$oem$\unattend.new
:nameskip

:: Copy the AClient files
md c:\altiris
md c:\altiris\aclient
copy /y f:\aclient.exe c:\altiris\aclient
copy /y f:\aclient.inp c:\altiris\aclient
copy /y f:\sidgen.exe c:\altiris\aclient
copy /y f:\wlogev~1.exe c:\altiris\aclient

:: Set the C: as active partition
%tools%\setactiv 0

:: Run smartdrv so the the file copy goes faster
f:\bootwiz\dos\smartdrv /u /v

set severity=1
set status="Microsoft Windows 2003 Install: Started."
if exist f:\logevent.exe f:\logevent.exe -l:%severity% -ss:%status%
goto done

:err1
set severity=3
set status="Microsoft Windows 2003 Install: The SS variable is not defined."
if exist f:\logevent.exe f:\logevent.exe -l:%severity% -ss:%status%
goto done

:err2
set severity=3
set status="Microsoft Windows 2003 Install: The SS variable value is invalid."
if exist f:\logevent.exe f:\logevent.exe -l:%severity% -ss:%status%
goto done

:err3
set severity=3
set status="Microsoft Windows 2003 Install: The OS variable is not defined."
if exist f:\logevent.exe f:\logevent.exe -l:%severity% -ss:%status%
goto done

:err4
set severity=3
set status="Microsoft Windows 2003 Install: The OS variable value is invalid."
if exist f:\logevent.exe f:\logevent.exe -l:%severity% -ss:%status%
goto done

:err5
set severity=3
set status="Microsoft Windows 2003 Install: The UNATTENDFILE variable is not defined."
if exist f:\logevent.exe f:\logevent.exe -l:%severity% -ss:%status%
goto done

:err6
set severity=3
set status="Microsoft Windows 2003 Install: The UNATTENDFILE variable value is invalid."
if exist f:\logevent.exe f:\logevent.exe -l:%severity% -ss:%status%
goto done

:err7
set severity=3
set status="Microsoft Windows 2003 Install: Format failed."
if exist f:\logevent.exe f:\logevent.exe -l:%severity% -ss:%status%
goto done


:done
set status=
set severity=
set sspath=
set ssst=
set tools=


:end
