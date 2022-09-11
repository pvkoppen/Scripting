@ECHO OFF
cls
echo --------------------------------------------------------------------------
echo	Get the Current State

echo Retrieving State Information....
h:\cpq\statemgr /r Phase
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


echo ----- First State Configure System Hardware -----
:State0

echo Running Hardware Configuration Utility...
h:\cpq\conrep -l h:\servers\ml310\ml310nw.hwr 
echo Setting State Information...
h:\cpq\statemgr /w Phase 1

echo ----- Second State Configure Array  -----
:State1


echo Configuring the Array Controllers...
h:\cpq\acr /i h:\servers\ml310\ml310nw.ARY /o

echo Running Hypercfg...
h:\cpq\hypercfg /s /@h:\servers\ml310\hypercfg.cfg

echo Setting State Information...
h:\cpq\statemgr /w Phase 2
h:\cpq\reboot a:

echo ----- Third State Create Disk Partition. -----
:State2

echo Creating Disk Partition...
h:\cpq\cpqdisk /w h:\servers\ml310\ml310nw.PRT

echo Setting State Information...
h:\cpq\statemgr /w Phase 3
h:\cpq\reboot a:

echo ----- Fourth State Format/Populate Boot Partition as DOS. -----
:State3

echo formating the Boot Partition as DOS ... Use Format from Caldera DOS 7.02
a:
cd\
format c: /x /s /quiet /v:

c:
cd\
copy h:\cpq\rootc\*.* c:\

md license
cd license
copy h:\cpq\license\*.*

c:
cd\
md dos
cd dos
copy h:\cpq\dos\*.*

echo Create Driver Directory and Copy Drivers...
c:
cd\
md nwupdate
cd nwupdate
copy h:\compaq\drivers\nw6\*.*

c:
cd\
md compaq
cd compaq
copy h:\cpq\script\extra.ics
copy h:\compaq\csp\nw\*.*

echo Setting State Information...
h:\cpq\statemgr /w Phase 4

REM ***Turn off the Virtual Floppy
REM ***----------------------------------------------
h:\cpq\vflop /b:never /p:off

echo ----- Fifth State execute NetWare install. -----
:State4

echo Setting State Information...
h:\cpq\statemgr /w Phase 5
copy h:\servers\ml310\response.txt c:\nwupdate\response.txt
h:
cd\
cd\nw60
install /rf=c:\nwupdate\response.txt

echo ----- Rebooting to OS. -----
:State5

h:\cpq\reboot c:

:State6
:State7
:State8
:State9
:State10