rem Project 2003 script for Staples
rem Created by Angela Stewart @ Staples Rodway Ltd 25 November 2003
rem Last change date:
rem Contact +64 6 7580956
rem copyright Staples Rodway Ltd


net use f: \\staples-altiris\express /user:staples-altiris\altiris l3tm31n! /persistent:No

f:
cd\
cd Staples\CDS\ProJ2003

msiexec /i "prjpro.msi" /qb PIDKEY=KYTPQDBJC2KQ8FFMQHGKKHHWY


echo wait
echo wait
echo wait


