select a.employeeid, a.status,
 a.knownas, a.surname, a.fullname, 
 a.currentcompany, a.currentdepartment, a.currentjobtitle, a.currentlocation, 
 a.worktelephone, a.workmobile, a.workddi, 
 b.reportsto, b.costcode, b.companyid, 
 officephone = case when not e.departmentalphone is null then e.departmentalphone when not d.locationphone is NULL then d.locationphone else c.telephone end,
 officefax = case   when not e.departmentalfax is null   then e.departmentalfax  when not d.locationfax is NULL   then d.locationfax else c.fax end,
 c.website
from employees a left outer join jobhistory b on a.employeeid = b.employeeid and b.currentrecord = 1
  left outer join companies c on b.companyid = c.companyid 
  left outer join locations d on b.companyid = d.companyid and b.location = d.location
  left outer join departments e on b.companyid = e.companyid and b.department = e.department
where b.companyid = 1
and a.status = 'Active'
and a.currentjobtitle != 'Director'
order by 4,3

/*
select * from companies
go
select * from departments
go
select * from locations
*/
