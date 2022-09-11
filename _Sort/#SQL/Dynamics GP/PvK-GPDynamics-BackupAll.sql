-- used to backup all company databases and system database (Dynamics)
-- can be run in any databases


DECLARE @name VARCHAR(50) -- database name 
DECLARE @path1 VARCHAR(256) -- path for backup files 
DECLARE @path VARCHAR(256) -- path for backup files 
DECLARE @fileName VARCHAR(256) -- filename for backup 
DECLARE @fileDate VARCHAR(20) -- used for file name

SET @path1 = 'E:\MSSQL\MSSQL10_50.DYNAMICSGP\MSSQL\Backup\' 

SELECT @fileDate = CONVERT(VARCHAR(20),GETDATE(),112)

SET @path = @path1 + @fileDate + '\' 

DECLARE db_cursor CURSOR FOR 
SELECT name 
FROM master.dbo.sysdatabases 
WHERE name in (select INTERID from Dynamics..sy01500) or name='DYNAMICS' 

OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @name  

WHILE @@FETCH_STATUS = 0  
BEGIN  
       SET @fileName = @path + @name + '_' + @fileDate + '.BAK' 
       BACKUP DATABASE @name TO DISK = @fileName 

       FETCH NEXT FROM db_cursor INTO @name  
END  

CLOSE db_cursor  
DEALLOCATE db_cursor