rem Amyuni script for Staples
rem Created by Angela Stewart @ Staples Rodway Ltd 23 November 2004
rem Last change date:
rem Contact +64 6 7580956
rem copyright Staples Rodway Ltd


net use f: \\staples-altiris\express /user:staples-altiris\altiris l3tm31n! /persistent:No

f:
cd\
cd Staples\CDS\amyuni\

regedit /s hklm.reg

regedit /s hkcurrusr.reg


echo wait
echo wait
echo wait






