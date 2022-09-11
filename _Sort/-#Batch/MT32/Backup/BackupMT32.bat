for /f "tokens=1-9 delims=:. " %%a in ('time /t') do set filetime=%%a00%%c%%d
if exist E:\MT32bak\%filetime%.log del E:\MT32bak\%filetime%.log
if exist E:\MT32bak\%filetime%-mt32.bak del E:\MT32bak\%filetime%-mt32.bak
C:
cd "C:\Program Files\Borland\InterBase\bin"
gbak.exe -B -V -USER sysdba -PAS masterkey -Y E:\MT32bak\%filetime%.log localhost:c:\mt32\data\mt32.ib E:\mt32bak\%filetime%-mt32.bak