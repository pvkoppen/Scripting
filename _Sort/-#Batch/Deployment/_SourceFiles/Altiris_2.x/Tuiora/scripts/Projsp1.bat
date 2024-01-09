rem Project SP1 script for Staples
rem Created by Angela Stewart @ Staples Rodway Ltd 14 December 2004
rem Last change date:
rem Contact +64 6 7580956
rem copyright Staples Rodway Ltd


net use f: \\staples-altiris\express /user:staples-altiris\altiris l3tm31n! /persistent:No

change User /install

echo wait
echo wait
echo wait
echo wait
echo wait




f:
cd\
cd \Staples\CDS\project sp1\

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
