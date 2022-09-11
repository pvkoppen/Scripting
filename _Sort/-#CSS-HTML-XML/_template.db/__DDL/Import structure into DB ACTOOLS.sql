USE AC_WEB
GO

SELECT distinct A.name, B.* FROM sysobjects A join syscolumns B
  ON (A.id = B.id)
where A.type = 'U' and A.status > '0'
go

insert into ACRECFIELD
SELECT distinct A.name, B.name, B.colid, 'N', 'N', 'N'  FROM sysobjects A join syscolumns B
  ON (A.id = B.id)
where A.type = 'U' and A.status > '0'
and B.name not in (select FIELDNAME from ACRECFIELD B2 where B2.RECNAME = A.name)
go
SELECT * FROM ACRECFIELD
order by 1,3


go
SELECT distinct B.* FROM sysobjects A join syscolumns B
  ON (A.id = B.id)
where A.type = 'U' and A.status > '0'
go

insert into ACFIELDDEFN
SELECT distinct B.name, 0, B.usertype, length, 0, '','','','','1900-01-01','_AC'  FROM sysobjects A join syscolumns B
  ON (A.id = B.id)
where A.type = 'U' and A.status > '0'
and B.name not in (SELECT FIELDNAME FROM ACFIELDDEFN)
go
SELECT * FROM ACFIELDDEFN



go
SELECT * FROM sysobjects
where type = 'U' and status > '0'
go
insert into ACRECDEFN
SELECT name, 0, 'TBL', '','','','', '1900-01-01', '_AC', name FROM sysobjects
where type = 'U' and status > '0'
and name not in (select RECNAME from ACRECDEFN)
go
SELECT * FROM ACRECDEFN
go



-- -------------------------------------------------------------------------
USE ACTOOLS
GO
/*
select a.name, a.type, b.name, b.type, b.length, b.xprec, b.colid from sysobjects a join syscolumns b
	on (a.id = b.id)
where a.status >= 0
order by a.name, b.colid
*/
GO
/*
update ACFIELDDEFN
set VERSION = 0, 
	FIELDTYPE = CASE 
		WHEN b.type =  35 THEN 'TEXT' 
		WHEN b.type =  38 THEN 'INT' 
		WHEN b.type =  39 THEN 'CHAR' 
		WHEN b.type =  61 THEN 'DATE' 
		WHEN b.type = 111 THEN 'DATE' 
		ELSE CONVERT(CHAR,b.type) END, 
	FIELDSIZE = b.length, 
	DECIMALS = 0,
    DESCRSHORT = SUBSTRING(b.name,1,12), 
    DESCR = b.name, 
    DESCRTEXT = b.name,
    LASTUPDDTTM = '1900-01-01',
	LASTUPDOPRID= 'KPP' 
from sysobjects a join syscolumns b
	on (a.id = b.id) JOIN ACFIELDDEFN C
	ON (b.name = C.FIELDNAME)
where a.status >= 0
and a.name not like 'X%'
order by b.name
*/
--SELECT * FROM ACFIELDDEFN 
--SELECT * FROM ACRECDEFN 
--DELETE FROM ACRECDEFN
SELECT * FROM ACRECFIELD 
DELETE FROM ACRECFIELD
GO
/*
--INSERT INTO ACRECDEFN (RECNAME, VERSION, RECTYPE,LASTUPDDTTM,LASTUPDOPRID)
SELECT DISTINCT substring(a.name,3,17) as recname, 0 as version, 'TBL' as rectype, '1900-01-01', 'KPP'
from sysobjects a join syscolumns b
	on (a.id = b.id)
where a.status >= 0
and a.name not like 'X%'
*/
INSERT INTO ACRECFIELD 
SELECT DISTINCT substring(a.name,3,17) as recname, b.name, colid, 'N', 'N', 'N', 'N', 'N', NULL, NULL, NULL, '1900-01-01', 'KPP'
from sysobjects a join syscolumns b
	on (a.id = b.id)
where a.status >= 0
and a.name not like 'X%'
