/******************************************************************************/
/*	Description:	*/
/*	Updates any table that contains a company ID or database name value	*/
/*	with the appropriate values as they are stored in the DYNAMICS.dbo.SY01500 table	*/
/*	*/
/******************************************************************************/

if not exists(select 1 from tempdb.dbo.sysobjects where name = '##updatedTables')
	 create table [##updatedTables] ([tableName] char(100))
truncate table ##updatedTables
declare @cStatement varchar(255)
declare G_cursor CURSOR for
select
case
when UPPER(a.COLUMN_NAME) in ('COMPANYID','CMPANYID')
	 then 'update '+a.TABLE_NAME+' set '+a.COLUMN_NAME+' = '+ cast(b.CMPANYID as char(3))
else
	 'update '+a.TABLE_NAME+' set '+a.COLUMN_NAME+' = '''+ db_name()+''''
end
from INFORMATION_SCHEMA.COLUMNS a, DYNAMICS.dbo.SY01500 b, INFORMATION_SCHEMA.TABLES c
where UPPER(a.COLUMN_NAME) in ('COMPANYID','CMPANYID','INTERID','DB_NAME','DBNAME', 'COMPANYCODE_I')
	 and b.INTERID = db_name() and a.TABLE_NAME = c.TABLE_NAME and c.TABLE_CATALOG = db_name() and c.TABLE_TYPE = 'BASE TABLE'
set nocount on
OPEN G_cursor
FETCH NEXT FROM G_cursor INTO @cStatement
WHILE (@@FETCH_STATUS <> -1)
begin
 		insert ##updatedTables select
substring(@cStatement,8,patindex('%set%',@cStatement)-9)
	 	Exec (@cStatement)
	 FETCH NEXT FROM G_cursor INTO @cStatement
end
DEALLOCATE G_cursor
select [tableName] as 'Tables that were Updated' from ##updatedTables
