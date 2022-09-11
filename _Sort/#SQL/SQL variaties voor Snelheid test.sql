USE AC_WEB
go
/*select * from sysobjects so join syscolumns sc
  on (so.id = sc.id)
where so.type = 'U'
*/
go
select *
from acrefvalue a

select *, (select z.descr from acrefvalue_lng z 
	where a.fieldname = z.fieldname and a.fieldvalue = z.fieldvalue and a.effdt = z.effdt) 
from acrefvalue a

select a.*, z.descr from acrefvalue a, acrefvalue_lng z 
where a.fieldname = z.fieldname and a.fieldvalue = z.fieldvalue and a.effdt = z.effdt

select a.*, z.descr from acrefvalue a left outer join acrefvalue_lng z 
on (a.fieldname = z.fieldname and a.fieldvalue = z.fieldvalue and a.effdt = z.effdt)
