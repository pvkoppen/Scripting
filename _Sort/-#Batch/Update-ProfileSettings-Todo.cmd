goto end

dsquery User "OU=SBSUsers,OU=Users,OU=MyBusiness,DC=ruanui,DC=local" -upn "*user@ruanui.local" | dsmod user -profile "\\ruanuisbs\userprofiles\$username$\profile" 

d:
cd "\users shared folders"
for /d %%a in (*.*) do if not %%a' == administrator' %~dp0tscmd.exe . %%a terminalserverprofilepath "\\ruanuisbs\userprofiles\%%a\tsprofile"
%~d0
cd %~dp0

:end
pause