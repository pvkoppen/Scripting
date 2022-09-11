for /f "tokens=1-9 delims=/ " %%a in ('date /t') do for /f "tokens=1-9 delims=:. " %%A in ('time /t') do set DateTime=%%d%%c%%b-%%C%%D%%A%%B
rem dsquery user -limit 0 | dsget user -dn -samid -sid -upn -fn -mi -ln -display -empid -desc -office -tel -email -hometel -pager -mobile -fax -iptel -webpg -title -dept -company -mgr -hmdir -hmdrv -profile -loscr -disabled > "%0-%DateTime%.txt"
    dsquery user -limit 0 | dsget user                      -fn -mi -ln -display              -office -tel -email                 -mobile -fax -iptel -webpg -title       -company                                    -disabled > "%0-%DateTime%.txt"
rem dsquery user -limit 2 | dsget user -dn -samid -sid -upn -fn -mi -ln -display -empid -desc -office -tel -email -hometel -pager -mobile -fax -iptel -webpg -title -dept -company -mgr -hmdir -hmdrv -profile -loscr -disabled
rem pause
