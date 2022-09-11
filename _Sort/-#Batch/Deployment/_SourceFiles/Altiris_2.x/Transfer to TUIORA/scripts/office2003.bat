rem Office 2003 script for Staples Rodway
rem Created by Kelvin Brace @ Staples Rodway Ltd 9 June 2003
rem Last change date:
rem Contact +64 6 7580956
rem copyright Staples Rodway Ltd


net use f: \\Staples-altiris\express /user:staples-altiris\altiris l3tm31n! /persistent:No

f:
cd\
cd "Staples\CDS\office 2003"

setup.exe TRANSFORMS="F:\Staples\CDS\office 2003\office.MST" /qr /noreboot


echo wait
echo wait
echo wait
