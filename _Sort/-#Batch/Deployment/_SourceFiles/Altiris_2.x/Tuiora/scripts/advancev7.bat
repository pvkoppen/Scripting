rem Advance script for STDC
rem Created by Kelvin Brace @ Staples Rodway Ltd 16 June 2003
rem Last change date:
rem Contact +64 6 7580956
rem copyright Staples Rodway Ltd


net use f: \\staples-altiris\express /user:staples-altiris\altiris l3tm31n! /persistent:No

f:
cd\
cd Staples\CDS\Apsv7\access_97\r_and_U\r_and_u_for_sql\

xcopy *.mdb c:\adv2000 /e /y

xcopy adinv.dll c:\adv2000 /e /y

c:
cd\
cd adv2000

rename aps_a32.mdb xaps_a32.mdb
rename aps_r.mdb xaps_r.mdb
rem rename aps_t.mde xaps_t.mde
rename aps_u.mdb xaps_u.mdb

copy aacentral.exe xaacentral.exe

f:
cd\
cd staples\cds\apsv7\
copy apssp5.txt "c:\windows\application compatibility scripts\logon\"

echo wait
echo wait
echo wait






