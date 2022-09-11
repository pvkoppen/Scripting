--Step0A:
select a.surname, a.status, a.employeeid, a.payrollinsert, a.payrollmodify, a.leavingdate, b.jobhistoryid, b.enddate, c.jobhistoryid, c.enddate
from employees a, jobhistory b, salaryhistory c
where (a.surname like 'ZZ%'
  or a.status = 'Inactive'
  or a.leavingdate is not null)
and a.employeeid = b.employeeid
and b.employeeid = c.employeeid
and b.currentrecord = 1
and c.currentrecord = 1
order by 2, 3, 6

-- ,'1062','121003','130205','130601'

--Step0B:
select a.employeeid, a.surname, a.status, a.payrollinsert, a.payrollmodify, a.leavingdate, b.jobhistoryid, b.currentrecord, b.enddate, c.jobhistoryid, c.salaryhistoryid, c.currentrecord, c.enddate
from employees a, jobhistory b, salaryhistory c
where a.employeeid in ('1003','1005','1020','1034','1052','1062','1064','1067','1074','1076','2044','2053','2054','2057','2058','2060','2072','2077','2078','14016','14017','120601','120704','120708','120711','120712','120713','120715','120716','120717','120728','120732','120733','120737','120738','120739','120741','120742','120743','120750','120751','120802','121003','121103','121201','130201','130202','130204','130205','130401','130402','130501','130502','130601','130701','130702','130809','131008','131110','131203')
and a.employeeid = b.employeeid
and b.employeeid = c.employeeid
and b.startdate = (select MAX(b1.startdate) from jobhistory b1 where b.employeeid = b1.employeeid)
and c.startdate = (select MAX(c1.startdate) from salaryhistory c1 where c.employeeid = c1.employeeid)
order by 3,2,1

--Step2:
begin transaction hrupdate

--Step3:
update employees
set payrollmodify = 0
where employeeid in ('1003','1005','1020','1034','1052','1062','1064','1067','1074','1076','2044','2053','2054','2057','2058','2060','2072','2077','2078','14016','14017','120601','120704','120708','120711','120712','120713','120715','120716','120717','120728','120732','120733','120737','120738','120739','120741','120742','120743','120750','120751','120802','121003','121103','121201','130201','130202','130204','130205','130401','130402','130501','130502','130601','130701','130702','130809','131008','131110','131203')
and payrollmodify = 1

--Step4:
update salaryhistory
set enddate = (select a.leavingdate from employees a where a.employeeid = salaryhistory.employeeid)
where employeeid in ('1003','1005','1020','1034','1052','1062','1064','1067','1074','1076','2044','2053','2054','2057','2058','2060','2072','2077','2078','14016','14017','120601','120704','120708','120711','120712','120713','120715','120716','120717','120728','120732','120733','120737','120738','120739','120741','120742','120743','120750','120751','120802','121003','121103','121201','130201','130202','130204','130205','130401','130402','130501','130502','130601','130701','130702','130809','131008','131110','131203')
and enddate is null

--Step5:
update salaryhistory
set currentrecord = 0
where employeeid in ('1003','1005','1020','1034','1052','1062','1064','1067','1074','1076','2044','2053','2054','2057','2058','2060','2072','2077','2078','14016','14017','120601','120704','120708','120711','120712','120713','120715','120716','120717','120728','120732','120733','120737','120738','120739','120741','120742','120743','120750','120751','120802','121003','121103','121201','130201','130202','130204','130205','130401','130402','130501','130502','130601','130701','130702','130809','131008','131110','131203')
and currentrecord = 1

--Step6:
update jobhistory
set enddate = (select a.leavingdate from employees a where a.employeeid = jobhistory.employeeid)
where employeeid in ('1003','1005','1020','1034','1052','1062','1064','1067','1074','1076','2044','2053','2054','2057','2058','2060','2072','2077','2078','14016','14017','120601','120704','120708','120711','120712','120713','120715','120716','120717','120728','120732','120733','120737','120738','120739','120741','120742','120743','120750','120751','120802','121003','121103','121201','130201','130202','130204','130205','130401','130402','130501','130502','130601','130701','130702','130809','131008','131110','131203')
and enddate is null

--Step7:
update jobhistory
set currentrecord = 0
where employeeid in ('1003','1005','1020','1034','1052','1062','1064','1067','1074','1076','2044','2053','2054','2057','2058','2060','2072','2077','2078','14016','14017','120601','120704','120708','120711','120712','120713','120715','120716','120717','120728','120732','120733','120737','120738','120739','120741','120742','120743','120750','120751','120802','121003','121103','121201','130201','130202','130204','130205','130401','130402','130501','130502','130601','130701','130702','130809','131008','131110','131203')
and currentrecord = 1

--Step8:
select a.employeeid, a.surname, a.status, a.payrollinsert, a.payrollmodify, a.leavingdate, b.jobhistoryid, b.currentrecord, b.enddate, c.jobhistoryid, c.salaryhistoryid, c.currentrecord, c.enddate
from employees a, jobhistory b, salaryhistory c
where a.employeeid in ('1003','1005','1020','1034','1052','1062','1064','1067','1074','1076','2044','2053','2054','2057','2058','2060','2072','2077','2078','14016','14017','120601','120704','120708','120711','120712','120713','120715','120716','120717','120728','120732','120733','120737','120738','120739','120741','120742','120743','120750','120751','120802','121003','121103','121201','130201','130202','130204','130205','130401','130402','130501','130502','130601','130701','130702','130809','131008','131110','131203')
and a.employeeid = b.employeeid
and b.employeeid = c.employeeid
and b.startdate = (select MAX(b1.startdate) from jobhistory b1 where b.employeeid = b1.employeeid)
and c.startdate = (select MAX(c1.startdate) from salaryhistory c1 where c.employeeid = c1.employeeid)
order by 2,1

--Step9A: Success - Commit
commit transaction hrupdate

--Step9B: Failure - Rollback
rollback transaction hrupdate