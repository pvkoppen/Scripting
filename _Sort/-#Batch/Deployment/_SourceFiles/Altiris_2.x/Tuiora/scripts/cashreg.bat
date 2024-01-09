rem Cashman script for Staples
rem Created by Aaron Gayton @ Staples Rodway Ltd 18 March 2005
rem Last change date:
rem Contact +64 6 7580956
rem copyright Staples Rodway Ltd


net use f: \\staples-altiris\express /user:staples-altiris\altiris l3tm31n! /persistent:No

f:
cd\
cd Staples\CDS\cashman

regedit /s licensekey.reg

net use W: \\NPL02\apps /user:iwayonline\tsadmin2003 termadm1n /persistent:No

f:
cd\
cd Staples\CDS\cashman
xcopy Cashwin.ini W:\CashWin8.0\cashwin.ini /r /y 
echo wait
echo wait
echo wait






