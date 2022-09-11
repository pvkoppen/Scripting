rem VMWare Installation script for Tuiora
rem Created by Hone Rata 25-05-2006
rem Last change date: 25-05-2006

net use i: \\tuiora-altiris\express /user:tuiora-altiris\altiris alt1r1s /persistent:No

i:
cd\
cd tovs02\CDS\VMWare




setlocal
set PATHTO=i:\tovs02\CDS\VMWare

:: Install VMWare

start /wait %PATHTO%\VMware-server-installer-e.x.p-23869.exe

echo wait
echo wait
echo wait