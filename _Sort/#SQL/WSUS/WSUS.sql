"c:\Program Files\Microsoft SQL Server\80\Tools\Binn\OSQL.EXE" -S tolwu01\WSUS -E -d SUSDB -Q "select name,type from sysobjects where type in ('U','V') and name like '%file%' " -Q "select a.name, b.name, b.colid from sysobjects a, syscolumns b where a.id = b.id and a.type in ('U','V') and (a.name like '%file%' or b.name like '%file%') order by a.name, b.colid"

-Q "select name,type from sysobjects where type in ('U','V') and name like '%file%' " 
-Q "select a.name, b.name, b.colid from sysobjects a, syscolumns b where a.id = b.id and a.type in ('U','V') and (a.name like '%file%' or b.name like '%file%') order by a.name, b.colid"
-Q "select top 5  FileDigest, FileName, Modified, Size, IsEula, IsExternalCab from tbFile where isEULA = 0 " 
-Q "select top 2 * from tbFileOnServer "
-Q "select a.FileDigest, a.FileName, b.DesiredState, b.ActualState from tbFile a, tbFileOnServer b where a.FileDigest = b.FileDigest and b.DesiredState <> b.ActualState and not (DesiredState=3 and ActualState=12) "