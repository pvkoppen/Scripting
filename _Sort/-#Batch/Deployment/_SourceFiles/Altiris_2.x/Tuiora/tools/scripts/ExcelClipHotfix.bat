rem Excel Cannot Copy to clipboard hotfix
rem Created by Aaron Gayton @ Staples Rodway Ltd 23 March 2005
rem Last change date:
rem Contact +64 6 7580956
rem copyright Staples Rodway Ltd


if not exist f:\nul net use f: \\tuiora-altiris\express /user:tuiora-altiris\altiris alt1r1s /persistent:No

f:
cd "\tuiora\CDS\Excel Hotfixes"

WindowsServer2003-KB840872-x86-ENU.EXE /quiet 

echo wait
echo wait
echo wait






