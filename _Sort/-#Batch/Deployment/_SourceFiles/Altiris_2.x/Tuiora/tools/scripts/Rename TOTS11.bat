em Rename TOTS11 script for Tuiora
rem Created by Aaron Gayton @ Staples Rodway Ltd 27-04-2005
rem Last change date:
rem Contact +64 6 7580956
rem copyright Staples Rodway Ltd


net use f: \\tuiora-altiris\express /user:tuiora-altiris\altiris alt1r1s /persistent:No


f:
cd\
cd tuiora\CDS\netdom
netdom renamecomputer %computername% /newname:TOTS11 /force

