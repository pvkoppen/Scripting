@echo off 
cls
echo [ SCRIPT FOR REMOTE INSTALL OF Windows Server 2003 ON ML530g2 ]

s:
cd \cpq
echo Retrieving State Information...
s:\cpq\statemgr /r phase
REM *** Remove this initial pause when the batch file has been fully tested
REM *** and debugged

if errorlevel 10 goto State10
if errorlevel 9 goto State9
if errorlevel 8 goto State8
if errorlevel 7 goto State7
if errorlevel 6 goto State6
if errorlevel 5 goto State5
if errorlevel 4 goto State4
if errorlevel 3 goto State3
if errorlevel 2 goto State2
if errorlevel 1 goto State1
if errorlevel 0 goto State0

:State0
REM *** Configure the target server hardware by reading the configuration
REM *** information in the script file

echo Running Configuration Replication Utility...
s:\cpq\conrep -l s:\servers\ML530g2\ML530.hwr 
echo Setting State Information...
s:\cpq\statemgr /w Phase 1

:State1
REM *** Configure the array controllers by reading the configuration information
REM *** in the script file and stamping it onto the array
REM *** controllers of the target server

echo Configuring the Array Controllers...
s:\cpq\acr /i s:\servers\ML530g2\ML530.ary /o
echo Setting State Information...
s:\cpq\statemgr /w Phase 2
REM *** Reboot to A:
s:\cpq\reboot A:

:State2
REM *** Create partition by reading content of the script file and
REM *** stamping the configuration onto the hard drive in the target server
REM *** Prepare for system partition population

echo Creating Disk Partition...
s:\cpq\cpqdisk /w s:\servers\ML530g2\ML530.prt
echo Setting State Information...
s:\cpq\statemgr /w Phase 3
REM *** Reboot to A:
s:\cpq\reboot A:

:State3
REM *** Format the boot partition and populate
echo Formatting the First Disk Partition as DOS...
s:\cpq\cpqfmt c:
REM *** Copy Microsoft Windows Server 2003 operating system files and
REM *** OEM driver files from the CD to the hard drive of the
REM *** target server, creating subdirectories as needed
echo Creating Driver Directory and Copying Drivers...
s:
s:\cpq\filecopy /s:s:\cpqw2k3\$oem$ /d:c:\$oem$ /s /e /f:*.*

REM *** Copy the customized UNATTEND.TXT file from the system
REM *** configuration diskette to the root directory of the target server's
REM *** hard drive

copy s:\servers\ML530g2\unattend.txt c:\

echo Setting State Information...
s:\cpq\statemgr /w Phase 4

:State4
REM *** Copy operating system files to the boot partition

echo Setting the state to allow diskette removal during the installation of Windows NT
s:\cpq\statemgr /w Phase 5
echo Starting operating system installation...
s:
cd \i386
REM *** Start installation of the operating system from the hard drive of the
REM *** target system, reading unattended installation instructions from the
REM *** C:\UNATTEND.TXT file
winnt /s:s:\i386 /u:c:\unattend.txt

:State5
REM *** Resets state variable to 5 to allow operating system reboot without
REM *** removing the diskette

s:\cpq\statemgr /w Phase 5
echo The Windows Server 2003 installation will continue after the reboot...
REM *** Turn off the Virtual Floppy
s:\cpq\vflop /b:never /p:off
REM *** Disable PXEBoot
s:\cpq\PXEBoot /disable
REM *** Reboot to drive C:
s:\cpq\reboot c:

REM *** Unused states
REM *** Installation of other utilities and agents may be placed here

:State10
:State9
:State8
:State7
:State6