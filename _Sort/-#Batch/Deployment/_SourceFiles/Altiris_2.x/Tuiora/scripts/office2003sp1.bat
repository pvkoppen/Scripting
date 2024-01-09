rem Office 2003 SP3 script for Staples Rodway
rem Created by Aaron Gayton @ Staples Rodway Ltd 27 August 2004
rem Last change date:
rem Contact +64 6 7580956
rem copyright Staples Rodway Ltd


net use f: \\staples-altiris\express /user:Staples-altiris\altiris l3tm31n! /persistent:No

change User /install

echo wait
echo wait
echo wait
echo wait
echo wait




f:
cd\
cd \Staples\CDS\Office sP1

msiexec /p mainsp1ff.msp /qn /L*v C:\patch.log


echo wait
echo wait
echo wait

change User /execute

echo wait
echo wait
echo wait
echo wait
echo wait
