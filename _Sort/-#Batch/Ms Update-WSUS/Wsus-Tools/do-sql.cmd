rem Set the download to run on the foreground.
rem -------------------------------------------------
osql.exe -S localhost\WSUS -E -b -n -Q "USE SUSDB update tbConfigurationC set BitsDownloadPriorityForeground=1"

rem Select the EULA detail from the database.
rem -------------------------------------------------
rem osql.exe -S tolwu01\WSUS -E -b -n -Q "USE SUSDB select * FROM tbProperty where (EulaID IS NOT NULL)" -o wsusresult.txt
rem osql.exe -S tolwu01\WSUS -E -b -n -Q "USE SUSDB select * FROM tbProperty where (EulaID IS NOT NULL) and RequiresReacceptanceOfEula = '1'" -o wsusresult.txt

rem Extract the database table structure and then export the data.
rem -------------------------------------------------
rd /s /q DataExtract
md DataExtract
osql.exe -S tolwu01\WSUS -E -b -n -Q "USE SUSDB select name FROM sysobjects where type = 'U' and name <> 'tbXML' order by name " -o .\DataExtract\sysobjects-name.txt
for /f %A IN (.\DataExtract\sysobjects-name.txt) do osql.exe -S tolwu01\WSUS -E -b -n -s ; -Q "USE SUSDB select * FROM %A " -o .\DataExtract\data-%A.txt

pause