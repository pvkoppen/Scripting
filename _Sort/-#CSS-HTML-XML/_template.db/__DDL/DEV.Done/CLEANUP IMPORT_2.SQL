use actools
go
select * from ac_person_tbl WHERE CONVERT(INTEGER, PERSID) > 1008
/*
BEGIN TRAN
DELETE from ac_person_tbl WHERE CONVERT(INTEGER, PERSID) > 1008
--COMMIT
ROLLBACK
*/
go
/*
select effdt, count(*) from ac_externalpersid  group by effdt
select effdt, count(*) from ac_persaddr_effdt  group by effdt
select effdt, count(*) from ac_persemail_effdt group by effdt
select effdt, count(*) from ac_persname_effdt  group by effdt
select effdt, count(*) from ac_persphone_effdt group by effdt
*/
GO
/*
select * from ac_externalpersid
select * from ac_persaddr_effdt
select * from ac_persemail_effdt
select * from ac_persname_effdt
select * from ac_persphone_effdt
*/
go
/*
delete from ac_externalpersid  where effdt > '2002-12-15'
delete from ac_persaddr_effdt  where effdt > '2002-12-15'
delete from ac_persemail_effdt where effdt > '2002-12-15'
delete from ac_persname_effdt  where effdt > '2002-12-15'
delete from ac_persphone_effdt where effdt > '2002-12-15'
*/
go
select * from acconfigbase
--UPDATE  acconfigbase SET PERSID_LAST = '1008'

