/*
-- Get system tables
select a.name, b.name, b.colid 
from sysobjects a, syscolumns b 
where a.id = b.id 
order by a.name, b.colid
*/

select a.employeeid, a.fullname, a.surname, a.knownas, a.currentcompany, a.currentdepartment, a.currentjobtitle, a.currentlocation, a.dateofjoin, a.leavingdate
from employees a
where a.dateofjoin <= GETDATE() and ((a.leavingdate is null) or (a.leavingdate > GETDATE()))
order by 1

select a.fullname, count(*) as names
from employees a
group by a.fullname
having count(*) > 1
order by 1

select * from jobhistory 
select * from salaryhistory

select a.employeeid, a.knownas, a.surname, a.fullname, a.currentcompany, a.currentdepartment, a.currentjobtitle, a.currentlocation, a.dateofjoin, a.leavingdate, a.workemail, b.reportsto, b.costcode 
from employees a, jobhistory b
where a.employeeid = b.employeeid
and b.currentrecord = 1
and a.surname not like 'ZZ%'

select a.employeeid, a.knownas, a.surname, a.fullname, a.currentjobtitle, a.currentdepartment, a.workemail
 , b.reportsto, b.costcode 
from employees a, jobhistory b
where a.employeeid = b.employeeid
and b.currentrecord = 1
and a.surname not like 'ZZ%'


select a.employeeid, a.fullname, a.hometelephone, a.mobiletelephone, a.worktelephone, a.workmobile, b.companyid, b.jobtitle
/* select case when worktelephone is null
 then 'update employees set worktelephone = '''' where employeeid = '''+a.employeeid+''' and worktelephone is null ;go; -- name: '+a.fullname+', title: '+b.jobtitle
 else 'update employees set worktelephone = '''' where employeeid = '''+a.employeeid+''' and worktelephone = '''+a.worktelephone+''' ;go; -- name: '+a.fullname+', title: '+b.jobtitle
 end -- */
/* select case when workmobile is null
 then 'update employees set workmobile = '''' where employeeid = '''+a.employeeid+''' and workmobile is null ;go; -- name: '+a.fullname+', title: '+b.jobtitle
 else 'update employees set workmobile = '''' where employeeid = '''+a.employeeid+''' and workmobile = '''+a.workmobile+''' ;go; -- name: '+a.fullname+', title: '+b.jobtitle
 end -- */
from employees a, jobhistory b
where a.employeeid = b.employeeid
and b.currentrecord = 1
and b.companyid = 1
and a.surname not like 'ZZ%'
and a.currentjobtitle != 'Director'
order by fullname, 5,4

go
/*update employees set worktelephone = '6032', workmobile = '0275723262' where employeeid = '1030' and worktelephone is null
go
update employees set worktelephone = '6009' where employeeid = '130804' and worktelephone = '0276576579'
update employees set worktelephone = null where employeeid = '131006' and worktelephone = '0272569464'
*/

select employeeid, '-'+rtrim(knownas)+'-', fullname
from employees
--update employees
--set knownas = rtrim(knownas)
where knownas like '% '
order by 2

-- Departments
/*
select *
from departments


-- Get system tables
select a.name, b.name, b.colid 
select distinct a.name
from sysobjects a, syscolumns b 
where a.id = b.id 
and b.name like '%dep%'
order by a.name, b.colid

--select * from career
go
select * from departments
go
select * from employees
go
select * from jobhistory
go
select * from vacancies


*/

/*
Select SUBSTRING(department,1,3), department
from departments
where department not like '%)'

select b.department, (select c.department from departments c where c.department like '%('+SUBSTRING(b.department,1,3)+')')
from jobhistory b
where b.department in (Select d.department from departments d where d.department not like '%)')
*/

/*
BEGIN TRAN PvK
-- select b.department, (select c.department from departments c where c.department like '%('+SUBSTRING(b.department,1,3)+')')
update b
set b.department = (select c.department from departments c where c.department like '%('+SUBSTRING(b.department,1,3)+')')
from jobhistory as b
where b.department in (Select d.department from departments d where d.department not like '%)')

select b.department, (select c.department from departments c where c.department like '%('+SUBSTRING(b.department,1,3)+')')
from jobhistory b
where b.department in (Select d.department from departments d where d.department not like '%)')

commit tran PvK

BEGIN TRAN PvK2
-- select b.department, (select c.department from departments c where c.department like '%('+SUBSTRING(b.department,1,3)+')')
update b
set b.currentdepartment = (select c.department from departments c where c.department like '%('+SUBSTRING(b.currentdepartment,1,3)+')')
from employees as b
where b.currentdepartment in (Select d.department from departments d where d.department not like '%)')

select b.currentdepartment, (select c.department from departments c where c.department like '%('+SUBSTRING(b.currentdepartment,1,3)+')')
from employees b
where b.currentdepartment in (Select d.department from departments d where d.department not like '%)')

commit tran PvK2

BEGIN TRAN PvK3
-- select b.department, (select c.department from departments c where c.department like '%('+SUBSTRING(b.department,1,3)+')')
update b
set b.department = (select c.department from departments c where c.department like '%('+SUBSTRING(b.department,1,3)+')')
from vacancies as b
where b.department in (Select d.department from departments d where d.department not like '%)')

select b.department, (select c.department from departments c where c.department like '%('+SUBSTRING(b.department,1,3)+')')
from vacancies b
where b.department in (Select d.department from departments d where d.department not like '%)')

commit tran PvK3


select distinct department from jobhistory
go
select a.fullname, b.* from employees a, jobhistory b where a.employeeid = b.employeeid and b.department is null

*/

-- Check Salary code as a sub of Job code.
-- Emp, Job, Sal: Job ID not Sal ID
select a.fullname, a.employeeid, b.jobhistoryid, b.startdate, c.jobhistoryid, c.salaryhistoryid, c.startdate
from employees a inner join jobhistory b on (a.employeeid = b.employeeid) 
  left outer join salaryhistory c on (b.employeeid = c.employeeid and b.startdate = c.startdate)
where b.jobhistoryid != c.jobhistoryid
order by a.surname, a.knownas, b.employeeid, c.salaryhistoryid

select a.fullname, a.employeeid, b.jobhistoryid, b.startdate, c.jobhistoryid, c.salaryhistoryid, c.startdate
from employees a inner join jobhistory b on (a.employeeid = b.employeeid) 
  left outer join salaryhistory c on (b.employeeid = c.employeeid and b.jobhistoryid = c.jobhistoryid and b.startdate = c.startdate)
where c.salaryhistoryid is null
order by a.surname, a.knownas, b.employeeid, c.salaryhistoryid


/*
-- Check Salary code as a sub of Job code.
-- Emp, Job, Sal: Job ID not Sal ID
select 'ERROR: JOBHISTORYID not equal.' as Reason, a.surname+', '+a.knownas as Name, a.employeeid, b.jobhistoryid, b.startdate, c.jobhistoryid, c.salaryhistoryid, c.startdate
from employees a inner join jobhistory b on (a.employeeid = b.employeeid) 
  left outer join salaryhistory c on (b.employeeid = c.employeeid and b.startdate = c.startdate)
where (b.jobhistoryid != c.jobhistoryid) or (c.jobhistoryid is null)
union
select 'ERROR: NO Salary record for JOB on startdate' as Reason, a.surname+', '+a.knownas as Name, a.employeeid, b.jobhistoryid, b.startdate, c.jobhistoryid, c.salaryhistoryid, c.startdate
from employees a inner join jobhistory b on (a.employeeid = b.employeeid) 
  left outer join salaryhistory c on (b.employeeid = c.employeeid and b.jobhistoryid = c.jobhistoryid and b.startdate = c.startdate)
where c.salaryhistoryid is null
order by Name, b.jobhistoryid, c.salaryhistoryid
*/
select * 
from employees 
where employeeid not in (select employeeid 
	from jobhistory)

Select a.surname, a.knownas, 'Job' as type, b.employeeid, b.jobhistoryid, b.startdate, b.enddate, null as salaryhistoryid
from employees a, jobhistory b
where a.employeeid = b.employeeid
and b.jobhistoryid not in (select z.jobhistoryid 
	from salaryhistory z 
	where b.employeeid= z.employeeid 
	and b.startdate = z.startdate)
union
Select a.surname, a.knownas, 'Job' as type, b.employeeid, b.jobhistoryid, b.startdate, b.enddate, null as salaryhistoryid from employees a, jobhistory b
where a.employeeid = b.employeeid
and b.enddate is not null
and b.jobhistoryid not in (select z.jobhistoryid from salaryhistory z where b.employeeid= z.employeeid and b.enddate = z.enddate)
union
Select a.surname, a.knownas, 'Salary' as type, b.employeeid, b.jobhistoryid, b.startdate, b.enddate, b.salaryhistoryid
from employees a, salaryhistory b
where a.employeeid = b.employeeid
and b.enddate is not null
and b.jobhistoryid not in (select z.jobhistoryid 
	from jobhistory z 
	where b.employeeid= z.employeeid 
	and b.startdate >= z.startdate 
	and (b.enddate < z.startdate or b.enddate is null))
	
select a.surname+', '+a.knownas as name, a.employeeid, b.jobhistoryid, b.startdate, b.enddate, c.jobhistoryid, c.salaryhistoryid, c.startdate, c.enddate
from employees a full outer join jobhistory b 
  on ( a.employeeid = b.employeeid) 
full outer join salaryhistory c 
  on (a.employeeid = c.employeeid
  and c.startdate >= b.startdate
  and ((c.enddate <= b.enddate) or (b.enddate is null))
  and b.jobhistoryid = c.jobhistoryid)
where a.employeeid is null or b.employeeid is null or c.employeeid is null
order by 1,3,6

declare @EmplID varchar(1000)
declare @JobID varchar(1000)
declare @SalID varchar(1000)
declare @NewValue varchar(1000)

set @EmplID= '120804'
select a.surname+', '+a.knownas as name, b.employeeid, b.jobhistoryid, b.startdate, b.enddate from employees a, jobhistory b where a.employeeid = b.employeeid and b.employeeid = @EmplID order by 1,4
select a.surname+', '+a.knownas as name, b.employeeid, b.jobhistoryid, b.startdate, b.enddate, b.salaryhistoryid from employees a, salaryhistory b where a.employeeid = b.employeeid and b.employeeid = @EmplID order by 1,4

set @EmplID= '1025'
select a.surname+', '+a.knownas as name, b.employeeid, b.jobhistoryid, b.startdate, b.enddate from employees a, jobhistory b where a.employeeid = b.employeeid and b.employeeid = @EmplID order by 1,4
select a.surname+', '+a.knownas as name, b.employeeid, b.jobhistoryid, b.startdate, b.enddate, b.salaryhistoryid from employees a, salaryhistory b where a.employeeid = b.employeeid and b.employeeid = @EmplID order by 1,4

set @EmplID= '1030'
select a.surname+', '+a.knownas as name, b.employeeid, b.jobhistoryid, b.startdate, b.enddate from employees a, jobhistory b where a.employeeid = b.employeeid and b.employeeid = @EmplID order by 1,4
select a.surname+', '+a.knownas as name, b.employeeid, b.jobhistoryid, b.startdate, b.enddate, b.salaryhistoryid from employees a, salaryhistory b where a.employeeid = b.employeeid and b.employeeid = @EmplID order by 1,4

set @EmplID= '120725'
select a.surname+', '+a.knownas as name, b.employeeid, b.jobhistoryid, b.startdate, b.enddate from employees a, jobhistory b where a.employeeid = b.employeeid and b.employeeid = @EmplID order by 1,4
select a.surname+', '+a.knownas as name, b.employeeid, b.jobhistoryid, b.startdate, b.enddate, b.salaryhistoryid from employees a, salaryhistory b where a.employeeid = b.employeeid and b.employeeid = @EmplID order by 1,4

set @EmplID= '1048'
select a.surname+', '+a.knownas as name, b.employeeid, b.jobhistoryid, b.startdate, b.enddate from employees a, jobhistory b where a.employeeid = b.employeeid and b.employeeid = @EmplID order by 1,4
select a.surname+', '+a.knownas as name, b.employeeid, b.jobhistoryid, b.startdate, b.enddate, b.salaryhistoryid from employees a, salaryhistory b where a.employeeid = b.employeeid and b.employeeid = @EmplID order by 1,4

set @EmplID= '120735'
select a.surname+', '+a.knownas as name, b.employeeid, b.jobhistoryid, b.startdate, b.enddate from employees a, jobhistory b where a.employeeid = b.employeeid and b.employeeid = @EmplID order by 1,4
select a.surname+', '+a.knownas as name, b.employeeid, b.jobhistoryid, b.startdate, b.enddate, b.salaryhistoryid from employees a, salaryhistory b where a.employeeid = b.employeeid and b.employeeid = @EmplID order by 1,4

set @EmplID= '1041'
select a.surname+', '+a.knownas as name, b.employeeid, b.jobhistoryid, b.startdate, b.enddate from employees a, jobhistory b where a.employeeid = b.employeeid and b.employeeid = @EmplID order by 1,4
select a.surname+', '+a.knownas as name, b.employeeid, b.jobhistoryid, b.startdate, b.enddate, b.salaryhistoryid from employees a, salaryhistory b where a.employeeid = b.employeeid and b.employeeid = @EmplID order by 1,4

set @EmplID= '1015'
select a.surname+', '+a.knownas as name, b.employeeid, b.jobhistoryid, b.startdate, b.enddate from employees a, jobhistory b where a.employeeid = b.employeeid and b.employeeid = @EmplID order by 1,4
select a.surname+', '+a.knownas as name, b.employeeid, b.jobhistoryid, b.startdate, b.enddate, b.salaryhistoryid from employees a, salaryhistory b where a.employeeid = b.employeeid and b.employeeid = @EmplID order by 1,4

set @EmplID= '1059'
select a.surname+', '+a.knownas as name, b.employeeid, b.jobhistoryid, b.startdate, b.enddate from employees a, jobhistory b where a.employeeid = b.employeeid and b.employeeid = @EmplID order by 1,4
select a.surname+', '+a.knownas as name, b.employeeid, b.jobhistoryid, b.startdate, b.enddate, b.salaryhistoryid from employees a, salaryhistory b where a.employeeid = b.employeeid and b.employeeid = @EmplID order by 1,4

set @EmplID= '1031'
select a.surname+', '+a.knownas as name, b.employeeid, b.jobhistoryid, b.startdate, b.enddate from employees a, jobhistory b where a.employeeid = b.employeeid and b.employeeid = @EmplID order by 1,4
select a.surname+', '+a.knownas as name, b.employeeid, b.jobhistoryid, b.startdate, b.enddate, b.salaryhistoryid from employees a, salaryhistory b where a.employeeid = b.employeeid and b.employeeid = @EmplID order by 1,4

set @EmplID= '130204'
select a.surname+', '+a.knownas as name, b.employeeid, b.jobhistoryid, b.startdate, b.enddate from employees a, jobhistory b where a.employeeid = b.employeeid and b.employeeid = @EmplID order by 1,4
select a.surname+', '+a.knownas as name, b.employeeid, b.jobhistoryid, b.startdate, b.enddate, b.salaryhistoryid from employees a, salaryhistory b where a.employeeid = b.employeeid and b.employeeid = @EmplID order by 1,4

set @EmplID= '-'
set @JobID= '159'
set @SalID= '422'
set @NewValue = '158'
select employeeid,jobhistoryid, startdate, enddate, salaryhistoryid from salaryhistory where employeeid = @EmplID and jobhistoryid = @JobID and salaryhistoryid = @SalID
--update salaryhistory set jobhistoryid = @NewValue where employeeid = @EmplID and jobhistoryid = @JobID and salaryhistoryid = @SalID
