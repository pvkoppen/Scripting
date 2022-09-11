@echo off
prompt $p$g
path=a:\;a:\Novell
mscdex /d:cpqcdrom /v /m:50 /l:f
@CALL a:\NOVELL\STARTNET
g:
login servername/user
map h:=vol1:
H:
cd cpq
call DL580_g2.bat
