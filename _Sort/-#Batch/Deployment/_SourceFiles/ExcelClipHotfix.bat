rem Excel Cannot Copy to clipboard hotfix
rem Created by Aaron Gayton @ Staples Rodway Ltd 23 March 2005
rem Last change date:
rem Contact +64 6 7580956
rem copyright Staples Rodway Ltd


net use f: \\tuiora-altiris\express /user:staples-altiris\altiris l3tm31n! /persistent:No

f:
cd\
cd "tuiora\CDS\Excel Hotfixes"

WindowsServer2003-KB840872-x86-ENU.EXE /quiet 

echo wait
echo wait
echo wait






