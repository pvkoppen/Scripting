rem Banklink5 script for Staples
rem Created by Angela Stewart @ Staples Rodway Ltd 25 November 2003
rem Last change date:
rem Contact +64 6 7580956
rem copyright Staples Rodway Ltd


net use f: \\staples-altiris\express /user:staples-altiris\altiris l3tm31n! /persistent:No

f:
cd\
cd Staples\CDS\bk5

xcopy *.ini c:\windows


echo wait
echo wait
echo wait


