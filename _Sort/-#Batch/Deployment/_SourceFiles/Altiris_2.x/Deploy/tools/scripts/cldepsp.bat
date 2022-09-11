@echo off
:: ==============================================================
:: CLDEPSP.BAT - This script deploys the Windows partitions to the 
:: 	         shared storage.
::
:: Input:
::   skipfile.bat = a batch file that sets environment variables 
::    indicating the number of lines to skip in the disk and volume
::    output files duiring the diskp artitioning script cldepsp.bat.
::    This file is located in c:\OEM$\clusters on the target.
::
:: 1) All relevant temporary files are located in c:\$OEM$\clusters\temp
:: 2) The default number of internal disks is 1. (Windows 2000)
:: 3) The default number of volumes is 2. (Windows 2000)
:: ==============================================================
SET TOOLS=C:\$OEM$
SET DISKPATH=c:\$OEM$\clusters\temp
SET DPSCRIPT=%DISKPATH%\DPSCRIPT.txt
SET OUTFILE=%DISKPATH%\OUTFILE.txt
SET TEMPFILE=%DISKPATH%\TEMPFILE.txt
SET QUORUMFILE=%DISKPATH%\QDISK.txt
SET YESFILE=%DISKPATH%\YES.txt
SET FORMATSCRIPT=%DISKPATH%\FORMAT.bat
SET SKIPDISK=10
SET SKIPVOL=11

if "%WINDIR%"=="C:\WINDOWS" set DPART=c:\WINDOWS\SYSTEM32\DISKPART.EXE
if "%WINDIR%"=="C:\WINNT" set DPART=C:\$OEM$\DISKPART.EXE

:: ==============================================================
:: Check for the existence of the disk path directory
:: ==============================================================
if NOT exist %DISKPATH% md %DISKPATH%

:: ==============================================================
:: Get the number of lines to skip for the disk and volume lists
:: ==============================================================
echo Get the number of tokens to skip for the volume number
if NOT exist %DISKPATH%\skipfile.bat goto scan
call %DISKPATH%\skipfile.bat

:scan
:: ==============================================================
:: Create Partitions and assign drive letters 
:: The quorum drive is handled first.
:: ==============================================================
echo rescan > %DPSCRIPT%
echo Scanning for disks...
%DPART% -s %DPSCRIPT%

echo list disk> %DPSCRIPT%
echo Getting disk drive list...
%DPART% -s %DPSCRIPT%>%OUTFILE%

echo Fixing Disk file
move %OUTFILE% %TEMPFILE%
%TOOLS%\SED.EXE -n -e "p" %TEMPFILE% > %OUTFILE%
del %TEMPFILE%

echo Creating disk partitioning script...
SET /A SKIPDISK+=1
%TOOLS%\SED.EXE -n -e "%SKIPDISK%p" %OUTFILE% > %QUORUMFILE%

for /F "usebackq tokens=2" %%i IN (`type %QUORUMFILE%`) do (
	echo select disk %%i>%DPSCRIPT% 
	echo clean>>%DPSCRIPT%
	echo create partition primary>>%DPSCRIPT%
	echo assign letter=q>>%DPSCRIPT%
	)

:: ==============================================================
:: Create Partitions and assign drive letters
:: 2) Set all remaining partitions in DPSCRIPT
:: ==============================================================
for /F "usebackq skip=%SKIPDISK% tokens=2" %%i IN (`type %OUTFILE%`) do (
	echo select disk %%i>>%DPSCRIPT% 
	echo clean>>%DPSCRIPT%
	echo create partition primary>>%DPSCRIPT%
	echo assign>>%DPSCRIPT%
	)

echo Partitioning remaining shared drives...
%DPART% -s %DPSCRIPT%

:format
:: ==============================================================
:: Format Disks
:: 1) Look at the file containing the list of new volumes. 
:: 2) Format each new partition and assign a label and next
::    available letter.
:: ==============================================================
echo list volume> %DPSCRIPT%
echo Getting volume list...
%DPART% -s %DPSCRIPT%>%OUTFILE%

echo Fixing Volume file
move %OUTFILE% %TEMPFILE%
%TOOLS%\SED.EXE -n -e "p" %TEMPFILE% > %OUTFILE%
if exist %FORMATSCRIPT% del %FORMATSCRIPT%

echo Creating disk formatting script...
for /F "usebackq skip=%SKIPVOL% tokens=3" %%i IN (`type %OUTFILE%`) do (
	echo format %%i: /fs:ntfs /v:Disk%%i /q>>%FORMATSCRIPT%
	echo y>>%YESFILE%
	)
echo Formatting disks...
call %FORMATSCRIPT% < %YESFILE%

:done
SET SEVERITY=1
SET STATUS="Created and formatted partitions on shared disks."
IF EXIST c:\altiris\aclient\WLOGEVENT.EXE c:\altiris\aclient\WLOGEVENT.EXE -c:0 -l:%SEVERITY% -ss:"%STATUS%"