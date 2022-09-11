@echo off 
cls
ECHO [ CONFIG SCRIPT FOR INSTALL OF REDHAT LINUX ON A DL380 w/Romflash]
S:

echo Retrieving State Information...
S:\CPQ\STATEMGR /R PHASE

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

REM *********************** STATE 0 **************************************************************************************
echo State 0
:State0
echo Setting State Information...
S:\CPQ\STATEMGR /W PHASE 1 
CD \CPQSUPSW\ROMPAQ\SYSC
echo Flashing Rom, Do Not Shutdown!
ROMPAQ /u CPQ15_06.CPU CPQP1701.168
S:\CPQ\REBOOT A: /COLD

REM *********************** STATE 1 **************************************************************************************
echo State 1
:State1
REM *** Configure the target server hardware by reading the configuration
REM *** information in the script file DL380.HWR
echo Running Configuration Replication Utility...
S:\CPQ\CONREP -L S:\SERVERS\DL380\DL380.HWR

REM *** Configure the array controllers by reading the configuration information
REM *** in the script file DL380.ARY and stamping it onto the array
REM *** controllers of the target server
echo Configuring the Array Controllers...
S:\CPQ\ACR /I S:\SERVERS\DL380\DL380.ARY /O
echo Setting State Information...
S:\CPQ\STATEMGR /W PHASE 2
S:\CPQ\REBOOT A:

REM *********************** STATE 2 **************************************************************************************
echo State 2
:State2
REM *** Create partition by reading content of the script file and
REM *** stamping the configuration onto the hard drive in the target server
REM *** Prepare for system partition population
echo Creating Disk Partition...
S:\CPQ\CPQDISK /W S:\SERVERS\DL380\DL380.PRT
S:\CPQ\SYSPART /UPDATE:ENABLE
echo Setting State Information...
S:\CPQ\STATEMGR /W PHASE 3
REM *** Reboot to drive A:
S:\CPQ\REBOOT A:

REM *********************** STATE 3 **************************************************************************************
echo State 3
:State3
REM *** Populate the system partition
echo Populating System Partition...
C:\
CD\
S:\CPQ\PSYSPART /S:S:
S:\CPQ\SYSPART /UPDATE:DISABLE
echo Setting State Information...
S:\CPQ\STATEMGR /W PHASE 4
REM *** Before this reboot, the system partition is C: and the DOS partition is D:
REM *** If you want to remove this reboot, use D: instead of C: when referring
REM *** to the DOS partition until a reboot is done
REM *** Reboot to drive A:
S:\CPQ\REBOOT A:

REM *********************** STATE 4 **************************************************************************************
echo State 4
:State4
C:
COPY A:\COMMAND.COM
REM *** REASSIGN THE COMSPEC ENVIRONMENT VARIABLE TO C:\
SET COMSPEC=C:\COMMAND.COM
REM *** COPY FILES IN THE SHARED NETWORK DIRECTORY TO THE RAMDRIVE
COPY S:\TOOLS\RAWRITE.EXE
COPY S:\SERVERS\DL380\DL380.IMG
REM *** THIS CREATES THE LINUX BOOTDISK USING RAWRITE
RAWRITE -f DL380.IMG -d A: -n
REM Virtual floppy test
S:\CPQ\VFLOP /B:ONCE /P:ON
S:\CPQ\REBOOT A:

REM *** UNUSED STATES
:State10
:State9
:State8
:State7
:State6
:State5
