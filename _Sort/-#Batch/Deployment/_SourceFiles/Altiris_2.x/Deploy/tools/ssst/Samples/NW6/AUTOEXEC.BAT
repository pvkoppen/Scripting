@echo off
prompt $p$g
path=a:\;a:\Novell
@CALL a:\NOVELL\STARTNET
f:
login servername/user
map h:=vol2:
H:
cd cpq
call ML350_G3.bat
