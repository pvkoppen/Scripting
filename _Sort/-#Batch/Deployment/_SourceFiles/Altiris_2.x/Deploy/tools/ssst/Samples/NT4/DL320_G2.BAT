@ECHO OFF
CLS

REM *** ----------------------------------------------------------------------
REM *** Ensure that the shared network directory is used and get
REM *** the current state
REM *** ----------------------------------------------------------------------

s:
cd \cpq
echo Retrieving State Information...
s:\cpq\statemgr /r phase

REM *** ----------------------------------------------------------------------
REM *** Remove this initial pause when the batch file has been full tested
REM *** and debugged
REM *** ----------------------------------------------------------------------
REM *** ----------------------------------------------------------------------
REM *** Establish DOS error levels and branching in declining order
REM *** ----------------------------------------------------------------------

IF ERRORLEVEL 10 GOTO State10
IF ERRORLEVEL 9 GOTO State9
IF ERRORLEVEL 8 GOTO State8
IF ERRORLEVEL 7 GOTO State7
IF ERRORLEVEL 6 GOTO State6
IF ERRORLEVEL 5 GOTO State5
IF ERRORLEVEL 4 GOTO State4
IF ERRORLEVEL 3 GOTO State3
IF ERRORLEVEL 2 GOTO State2
IF ERRORLEVEL 1 GOTO State1
IF ERRORLEVEL 0 GOTO State0

:State0

REM *** ----------------------------------------------------------------------
REM *** First state
REM *** Configure the target server hardware by reading the configuration
REM *** information in the script file S:\SERVERS\dl320_g2\dl320NT.HWR
REM *** Increment the state variable
REM *** ----------------------------------------------------------------------

ECHO Running Configuration Replication Utility...
S:\CPQ\CONREP -l S:\SERVERS\dl320_g2\dl320NT.HWR
ECHO Setting State Information...
S:\CPQ\STATEMGR /w Phase 1

REM *** ----------------------------------------------------------------------
REM *** No reboot is necessary
REM *** ----------------------------------------------------------------------

:State1

REM *** ----------------------------------------------------------------------
REM *** Second state
REM *** Configure the array controllers by reading the configuration
REM *** information in the script file S:\SERVERS\dl320_g2\dl320NT.ARY and
REM *** stamping it onto the array controllers of the target server
REM *** Increment the state variable and reboot
REM *** ----------------------------------------------------------------------

ECHO Configuring the Array Controllers...
S:\CPQ\ACR /i S:\SERVERS\dl320_g2\dl320NT.ARY /o

REM *** Configure the RAID controller by reading the configuration
REM *** information in the script file S:\SERVERS\dl320_g2\dl320NT.cfg and
REM *** stamping it onto the array controllers of the target server
REM *** Increment the state variable and reboot
REM *** ----------------------------------------------------------------------

ECHO Configuring the RAID Controllers...
S:\CPQ\hypercfg /s /l /@S:\SERVERS\dl320_g2\dl320nt.cfg

ECHO Setting State Information...
S:\CPQ\STATEMGR /w Phase 2

REM *** ----------------------------------------------------------------------
REM *** Reboot to drive A:
REM *** ----------------------------------------------------------------------

S:\CPQ\REBOOT a:
:State2

REM *** ----------------------------------------------------------------------
REM *** Third state
REM *** Create partition by reading content of the
REM *** S:\SERVERS\dl320_g2\dl320NT.PRT script file and stamping the
REM *** configuration onto the hard drive in the target server
REM *** Prepare for system partition population
REM *** Increment state variable and reboot
REM *** ----------------------------------------------------------------------

ECHO Creating Disk Partition...
S:\CPQ\CPQDISK /w S:\SERVERS\dl320_g2\dl320NT.PRT
S:\CPQ\STATEMGR /w Phase 3

REM *** ----------------------------------------------------------------------
REM *** Reboot to drive A:
REM *** ----------------------------------------------------------------------

S:\CPQ\REBOOT a:

:State3

REM *** ----------------------------------------------------------------------
REM *** Fourth State
REM *** Format the boot partition and populate
REM *** Increment the state variable
REM *** ----------------------------------------------------------------------

ECHO Formatting the First Disk Partition as DOS...
S:\CPQ\CPQFMT C:
S:
CD\
ECHO Copying Microsoft Windows NT 4.0 files to the hard drive.

REM *** ----------------------------------------------------------------------
REM *** Copy Microsoft Windows NT 4.0 files from the shared network drive to
REM *** the hard drive of the target server, creating directories as needed
REM *** ----------------------------------------------------------------------

S:\CPQ\FILECOPY /S:S:\I386 /D:C:\I386 /s /e /F:*.*

REM *** ----------------------------------------------------------------------
REM *** Copy drivers files from the shared network drive to the hard drive of
REM *** the target server, creating directories as needed
REM *** ----------------------------------------------------------------------

ECHO Copying Driver files to the hard drive.
S:\CPQ\FILECOPY /S:S:\CPQNT4\$OEM$ /D:C:\I386\$OEM$ /s /e /F:*.*

REM *** ----------------------------------------------------------------------
REM *** Copy the customized UNATTEND.TXT file from the shared network
REM *** drive to the root directory of the target server's hard drive
REM *** ----------------------------------------------------------------------

COPY S:\SERVERS\dl320_g2\UNATTEND.TXT C:\
ECHO Setting State Information...
S:\CPQ\STATEMGR /w Phase 4

:State4

REM *** ----------------------------------------------------------------------
REM *** Fifth state
REM *** Copy operating system files to the boot partition
REM *** Increment the state variable
REM *** ----------------------------------------------------------------------

ECHO Setting the state to allow diskette removal during the installation
S:\CPQ\STATEMGR /w Phase 5
ECHO Starting operating system installation…

REM *** ----------------------------------------------------------------------
REM *** The drive must be locked before running WINNT.EXE.
REM *** ----------------------------------------------------------------------

C:
CD \I386
ECHO y | LOCK C:\ > nul

REM *** ----------------------------------------------------------------------
REM *** Start installation of the operating system, reading unattended
REM *** installation instructions from the C:\UNATTEND.TXT file
REM *** ----------------------------------------------------------------------

WINNT /S:C:\I386 /U:C:\UNATTEND.TXT

:State5

REM *** ----------------------------------------------------------------------
REM *** Second Fifth state
REM *** Resets state variable to 5 to allow operating system reboot without
REM *** removing the diskette
REM *** ----------------------------------------------------------------------

S:\CPQ\STATEMGR /w Phase 5
ECHO The Windows NT installation will continue after the reboot...

REM *** ----------------------------------------------------------------------
REM *** Turn off the Virtual Floppy
REM *** ----------------------------------------------------------------------

S:\CPQ\VFLOP /b:never /p:off

REM *** ----------------------------------------------------------------------
REM *** Reboot to drive C:
REM *** ----------------------------------------------------------------------

S:\CPQ\REBOOT c:

REM *** ----------------------------------------------------------------------
REM *** Unused states
REM *** Installation of other utilities and agents may be placed here
REM *** ----------------------------------------------------------------------
:State10
:State9
:State8
:State7
:State6
