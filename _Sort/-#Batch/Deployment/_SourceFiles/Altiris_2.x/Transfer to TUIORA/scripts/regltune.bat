rem Registry tune script for Staples
rem Created by Aaron Gayton @ Staples Rodway Ltd 22 March 2005
rem Last change date: 
rem Contact +64 6 7580956
rem copyright Staples Rodway Ltd


net use f: \\staples-altiris\express /user:staples-altiris\altiris l3tm31n! /persistent:No

f:
cd\
cd Staples\CDS\Final Tune

cscript "Final tune.vbs"

