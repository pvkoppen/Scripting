@echo off 
cls
echo [ SCRIPT FOR REMOTE INSTALL OF W2K ON ml330 ]
s:
cd \cpq
echo Retrieving State Information...
s:\cpq\statemgr /r phase
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
s:\cpq\conrep /l s:\servers\ml330g3\ml330.hwr /p 
echo Setting State Information...
s:\cpq\statemgr /w Phase 1

:State1

REM *** Configure the array controllers by reading the configuration information
REM *** in the script file and stamping it onto the array
REM *** controllers of the target server

echo Configuring the Array Controllers...
s:\cpq\acr /i s:\servers\ml330g3\ml330.ary /o /p

REM ECHO Configuring the RAID Controllers...
REM S:\CPQ\hypercfg /s /l /@S:\SERVERS\ml330g3\ml330.cfg

echo Setting State Information...
s:\cpq\statemgr /w Phase 2

REM *** Reboot to drive A:

s:\cpq\reboot a:

:State2

REM *** Create partition by reading content of the script file and
REM *** stamping the configuration onto the hard drive in the target server

echo Creating Disk Partition...
s:\cpq\cpqdisk /w s:\servers\ml330g3\ml330.prt /p
echo Setting State Information...
s:\cpq\statemgr /w Phase 3

REM *** Reboot to drive A:

s:\cpq\reboot a:

:State3

REM *** Format the boot partition and populate

echo Formatting the First Disk Partition as DOS...
s:\cpq\cpqfmt c:

REM *** Copy Microsoft Windows 2000 OEM driver files to the 
REM *** hard drive of the target server, creating subdirectories as needed

echo Creating Driver Directory and Copying Drivers...
s:
s:\cpq\filecopy /s:s:\cpqw2k\$oem$ /d:c:\$oem$ /s /e /f:*.* /p

REM *** Copy the customized UNATTEND.TXT file from the system
REM *** configuration diskette to the root directory of the target server's
REM *** hard drive

copy s:\servers\ml330g3\unattend.txt c:\
echo Setting State Information...
s:\cpq\statemgr /w Phase 4

:State4

REM *** Copy operating system files to the boot partition

echo Setting the state to allow diskette removal during the installation of Windows 2000
s:\cpq\statemgr /w Phase 5
echo Starting operating system installation...
s:
cd \i386

REM *** Start installation of the operating system using the
REM *** unattended installation instructions from the C:\UNATTEND.TXT file

winnt /s:s:\i386 /u:c:\unattend.txt

:State5

REM *** Resets state variable to 5 to allow operating system reboot without
REM *** removing the diskette

s:\cpq\statemgr /w Phase 5
echo The Windows 2000 installation will continue after the reboot...
REM *** Turn off the Virtual Floppy
s:\cpq\vflop /b:never /p:off

REM *** Reboot to drive C:
s:\cpq\reboot c:
REM *** Unused states
REM *** Installation of other utilities and agents may be placed here

:State10
:State9
:State8
:State7
:State6