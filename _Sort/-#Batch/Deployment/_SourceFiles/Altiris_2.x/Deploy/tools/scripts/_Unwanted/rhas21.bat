@echo on

:: ==============================================================
:: rhas21.bat
:: Red Hat Enterprise Linux 2.1 AS Scripted Install Script
::
:: Input:
::   %nfsserver%  = the ip address of the server where the support files and OS files are
::   %os%         = the name of the folder of which OS files to use
::   %ss%         = the name of the folder of which support files to use
::   %ksfile%     = the name of the kickstart file
::   %ssos%       = (optional) the name of the subfolder in the %ss% folder to use
::   %initrdfile% = (optional) the name of the initrd image file to use
:: ==============================================================

if "%ssos%" == "" set ssos=%os%
if "%initrdfile%" == "" set initrdfile=initrd.img

set tools=F:\Resource.TOL\Deploy\tools
set ssst=F:\Resource.TOL\Deploy\tools\ssst
set sspath=F:\Resource.TOL\Deploy\cds\compaq\%ss%\%ssos%

if "%nfsserver%" == "" goto err1
if "%nfsserver%" == "0.0.0.0" goto err2
if "%os%" == "" goto err3
if "%ss%" == "" goto err4
if not exist %sspath%\dosutils\autoboot\*.* goto err5
if "%ksfile%" == "" goto err6
if not exist %sspath%\dosutils\autoboot\%initrdfile% goto err7

:: Format the hard drive
%ssst%\cpqfmt.com c:
echo test > c:\test.txt
if not exist c:\test.txt goto err8
echo y | del c:\test.txt > nul

:: Make the hard drive bootable
a:
cd \
f:\bootwiz\dos\sys.com c:
cd \net
f:

:: Copy the Linux boot files
copy /y %sspath%\dosutils\loadlin.exe c:\
copy /y %sspath%\dosutils\autoboot\vmlinuz c:\
copy /y %sspath%\dosutils\autoboot\%initrdfile% c:\

:: Create autoexec.bat
:: NOTE: We are doing this convoluted script b'c of DOS line length limitations (128 characters in one line)
echo set n=%nfsserver%> c:\autoexec.bat
echo set s=%ss%>> c:\autoexec.bat
echo set o=%os%>> c:\autoexec.bat
echo set k=%ksfile%>> c:\autoexec.bat
echo set i=%initrdfile%>> c:\autoexec.bat
echo set c1=tty0>> c:\autoexec.bat
echo set c2=ttyS0,115200n8>> c:\autoexec.bat
if not "%serialconsole%" == "1" goto scelse
echo loadlin vmlinuz ks=nfs:%%n%%:/usr/cpqrdp/%%s%%/%%o%%/%%k%% initrd=%%i%% text console=%%c1%% console=%%c2%% >> c:\autoexec.bat
goto scend
:scelse
echo loadlin vmlinuz ks=nfs:%%n%%:/usr/cpqrdp/%%s%%/%%o%%/%%k%% initrd=%%i%% >> c:\autoexec.bat
:scend

:: Set the C: as active partition
%tools%\setactiv 0

set severity=1
set status="Red Hat Enterprise Linux 2.1 AS Install: Started."
if exist f:\logevent.exe f:\logevent -l:%severity% -ss:%status%
goto done

:err1
set severity=3
set status="Red Hat Enterprise Linux 2.1 AS Install: The NFSSERVER variable is not defined."
if exist f:\logevent.exe f:\logevent.exe -l:%severity% -ss:%status%
goto done

:err2
set severity=3
set status="Red Hat Enterprise Linux 2.1 AS Install: The NFSSERVER variable is invalid. A valid NFS server address needs to be specified."
if exist f:\logevent.exe f:\logevent.exe -l:%severity% -ss:%status%
goto done

:err3
set severity=3
set status="Red Hat Enterprise Linux 2.1 AS Install: The OS variable is not defined."
if exist f:\logevent.exe f:\logevent.exe -l:%severity% -ss:%status%
goto done

:err4
set severity=3
set status="Red Hat Enterprise Linux 2.1 AS Install: The SS variable is not defined."
if exist f:\logevent.exe f:\logevent.exe -l:%severity% -ss:%status%
goto done

:err5
set severity=3
set status="Red Hat Enterprise Linux 2.1 AS Install: The SS variable value is invalid."
if exist f:\logevent.exe f:\logevent.exe -l:%severity% -ss:%status%
goto done

:err6
set severity=3
set status="Red Hat Enterprise Linux 2.1 AS Install: The KSFILE variable is not defined."
if exist f:\logevent.exe f:\logevent.exe -l:%severity% -ss:%status%
goto done

:err7
set severity=3
set status="Red Hat Enterprise Linux 2.1 AS Install: The INITRDFILE variable is invalid."
if exist f:\logevent.exe f:\logevent.exe -l:%severity% -ss:%status%
goto done

:err8
set severity=3
set status="Red Hat Enterprise Linux 2.1 AS Install: Format failed."
if exist f:\logevent.exe f:\logevent.exe -l:%severity% -ss:%status%
goto done

:done
set status=
set severity=
set sspath=
set ssst=
set tools=

:end
