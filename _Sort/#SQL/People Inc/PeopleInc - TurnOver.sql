declare @dateStart varchar(1000)
declare @dateEnd varchar(1000)

set @dateStart = '2013-07-01'
set @dateEnd   = '2014-06-30'
/*
-- July to June
set @dateStart = '2012-07-01'
set @dateEnd   = '2013-06-30'
--January to December
set @dateStart = '2013-01-01'
set @dateEnd   = '2013-12-31'
*/

--Select b.companyid, fullname, b.startdate, b.enddate, a.leavingdate
  Select 'START' as Type, @dateStart as Date, b.companyid, count(a.fullname)
  from employees a, jobhistory b
  where a.employeeid = b.employeeid
  and b.startdate <= @dateStart
  and (b.enddate >= @dateStart 
    or (b.enddate is null 
    and (a.leavingdate >= @dateStart or a.leavingdate is null)))
  group by companyid
UNION
  Select 'END' as Type, @dateEnd as Date, b.companyid, count(a.fullname)
  from employees a, jobhistory b
  where a.employeeid = b.employeeid
  and b.startdate <= @dateEnd
  and (b.enddate >= @dateEnd 
    or (b.enddate is null 
    and (a.leavingdate >= @dateEnd or a.leavingdate is null)))
  group by companyid
UNION
  Select 'LEFT' as Type, @dateStart+' - '+@dateEnd as Date, b.companyid, count(a.fullname)
  from employees a, jobhistory b
  where a.employeeid = b.employeeid
  and a.leavingdate >= @dateStart
  and a.leavingdate <= @dateEnd
  group by companyid
order by 3,2,1

