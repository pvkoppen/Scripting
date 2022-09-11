@echo off
path=A:\;
mscdex /d:cpqcdrom /v /m:50 /l:f
prompt $p$g

@CALL a:\NOVELL\STARTNET

g:
login toolkit/overthenet < a:\psswd

map h:=vol1:

h:

cd \servers\dl380
DL380nw.bat