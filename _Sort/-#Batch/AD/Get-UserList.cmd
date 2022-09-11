mkdir "%~dp0LogFiles\"
dsquery ou -limit 0 > "%~dp0LogFiles\%~n0.OU-List.txt"
for /f "tokens=*" %%a in (%~dp0LogFiles\%~n0.OU-List.txt) do for /f "tokens=2 delims=,=" %%A in (%%a) do dsquery user %%a -limit 0 | dsget user -dn -samid -fn -mi -ln -display -empid -office -desc -tel -email -hometel -mobile -fax -webpg -title -dept  -company -mgr -hmdir -hmdrv -profile -loscr -disabled > "%~dp0%~n0.user-%%A.txt" 
start %~dp0
pause
