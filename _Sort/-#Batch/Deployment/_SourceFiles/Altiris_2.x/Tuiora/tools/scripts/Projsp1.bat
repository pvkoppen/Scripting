rem Project 2003 SP1
rem Created by Aaron Gayton @ Staples Rodway Ltd 23 March 2005
rem Last change date:
rem Contact +64 6 7580956
rem copyright Staples Rodway Ltd


net use f: \\tuiora-altiris\express /user:staples-altiris\altiris l3tm31n! /persistent:No

change User /install

echo wait
echo wait
echo wait
echo wait
echo wait




f:
cd\
cd \tuiora\CDS\project sp1\

msiexec /p project2003-kb837240-fullfile-enu.msp /qn /L*v C:\patch.log


echo wait
echo wait
echo wait

change User /execute

echo wait
echo wait
echo wait
echo wait
echo wait
