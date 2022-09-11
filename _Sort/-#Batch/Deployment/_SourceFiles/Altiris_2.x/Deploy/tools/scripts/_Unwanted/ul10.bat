@echo on

:: ==============================================================
:: ul10.bat
:: United Linux 1.0 Scripted Install Script
::
:: Input:
::   %nfsserver%  = the ip address of the server where the support files and OS files are
::   %os%         = the name of the folder of which OS files to use
::   %ss%         = the name of the folder of which support files to use
::   %ctlfile%    = the name of the Yast control file
::   %ssos%       = (optional) the name of the subfolder in the %ss% folder to use
::   %initrdfile% = (optional) the name of the initrd image file to use
::   %acpi%       = (optional) the value for the boot command line for acpi usage
::   %debug%      = (optional) Allows for loadlin debugging. 
::                     =dos will exit to dos prior to loadlin =log will turn on enhanced logging
::   %pci%        = (optional) the value for the boot command line for pci parameters
::                     =noacpi will turn off some measure of acpi functionality
::
:: 11/19/03 - CGreen - Added pci var for UL sp3 hardware compatibility
::                   - Removed gateway work around - UL sp3 fixed
:: 10/16/02 - CGreen - Initial Version - Using cmdline.par for loadlin parameters
:: ==============================================================

if "%ssos%" == "" set ssos=%os%
if "%initrdfile%" == "" set initrdfile=initrd

set tools=F:\Resource.TOL\Deploy\tools
set ssst=F:\Resource.TOL\Deploy\tools\ssst
set sspath=F:\Resource.TOL\Deploy\cds\compaq\%ss%\%ssos%

if "%nfsserver%" == "" goto err1
if "%nfsserver%" == "0.0.0.0" goto err2
if "%os%" == "" goto err3
if "%ss%" == "" goto err4
if not exist %sspath%\dosutils\autoboot\*.* goto err5
if "%ctlfile%" == "" goto err6
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
copy /y %sspath%\dosutils\autoboot\linux c:\
copy /y %sspath%\dosutils\autoboot\%initrdfile% c:\
copy /y %sspath%\dosutils\sleep.com c:\

:: Create cmdline.par
:: NOTE: We are doing this convoluted script b'c of DOS line length limitations (128 characters in one line)
echo linux>> c:\cmdline.par
echo vga=0>> c:\cmdline.par
echo initrd=%initrdfile%>> c:\cmdline.par
echo autoyast=nfs://%nfsserver%/usr/cpqrdp/%ss%/%os%/control/%ctlfile%>> c:\cmdline.par
echo install=nfs://%nfsserver%/usr/cpqrdp/%os%>> c:\cmdline.par

echo textmode=1>> c:\cmdline.par
if "%debug%" == "log" echo y2debug>> c:\cmdline.par
if not "%acpi%" == "" echo acpi=%acpi%>> c:\cmdline.par
if not "%pci%" == "" echo pci=%pci%>> c:\cmdline.par
if "%serialconsole%" == "1" echo text console=ttyS0,115200n8>> c:\cmdline.par

:: Create autoexec.bat
echo cls>> c:\autoexec.bat
echo sleep 15>> c:\autoexec.bat
if not "%debug%" == "dos" echo loadlin @cmdline.par>> c:\autoexec.bat

:: Set the C: as active partition
%tools%\setactiv 0

set severity=1
set status="United Linux 1.0 Install: Started."
if exist f:\logevent.exe f:\logevent -l:%severity% -ss:%status%
goto done

:err1
set severity=3
set status="United Linux 1.0 Install: The NFSSERVER variable is not defined."
if exist f:\logevent.exe f:\logevent.exe -l:%severity% -ss:%status%
goto done

:err2
set severity=3
set status="United Linux 1.0 Install: The NFSSERVER variable is invalid. A valid NFS server address needs to be specified."
if exist f:\logevent.exe f:\logevent.exe -l:%severity% -ss:%status%
goto done

:err3
set severity=3
set status="United Linux 1.0 Install: The OS variable is not defined."
if exist f:\logevent.exe f:\logevent.exe -l:%severity% -ss:%status%
goto done

:err4
set severity=3
set status="United Linux 1.0 Install: The SS variable is not defined."
if exist f:\logevent.exe f:\logevent.exe -l:%severity% -ss:%status%
goto done

:err5
set severity=3
set status="United Linux 1.0 Install: The SS variable value is invalid."
if exist f:\logevent.exe f:\logevent.exe -l:%severity% -ss:%status%
goto done

:err6
set severity=3
set status="United Linux 1.0 Install: The CTLFILE variable is not defined."
if exist f:\logevent.exe f:\logevent.exe -l:%severity% -ss:%status%
goto done

:err7
set severity=3
set status="United Linux 1.0 Install: The INITRDFILE variable is invalid."
if exist f:\logevent.exe f:\logevent.exe -l:%severity% -ss:%status%
goto done

:err8
set severity=3
set status="United Linux 1.0 Install: Format failed."
if exist f:\logevent.exe f:\logevent.exe -l:%severity% -ss:%status%
goto done

:done
set status=
set severity=
set sspath=
set ssst=
set tools=

:end
