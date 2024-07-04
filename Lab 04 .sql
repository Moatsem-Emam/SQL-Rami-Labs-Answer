use Company_SD

--------------Q1--------------
--a--
select fname
from employee where sex='F'

select Dependent_name
from Dependent where sex='F'

select concat(fname , lname) name , sex
from employee where sex='F'
union
select Dependent_name, sex
from Dependent where sex='F'

--b--
select CONCAT_WS(' ',fname,lname)
from employee where sex='M'

select Dependent_name
from Dependent where sex='M'

select concat(fname , lname) name , e.sex
from employee e,Dependent d where e.sex='M' and d.sex='M' and e.ssn = d.Essn
union
select Dependent_name, sex
from Dependent where sex='M'

------------Q2----------
select concat(fname , lname) name , pnumber , w1.Hours
from employee join Works_for w1 on ssn=w1.essn
join project on pnumber=w1.pno

-----------Q3------------

SELECT Dname, COUNT(fname) AS employee_count
FROM Departments d
JOIN employee e ON d.Dnum = e.Dno
GROUP BY Dname
HAVING COUNT(fname) = (
    SELECT MIN(employee_count)
    FROM (
        SELECT COUNT(fname) AS employee_count
        FROM Departments d
        JOIN employee e ON d.Dnum = e.Dno
        GROUP BY Dname
    ) AS counts
)

------------Q4----------
select dname,min(salary) min_Sa, max(salary) max_Sa, avg(salary) avg_Sa
from employee left join Departments
on dno=dnum
group by dname

----------Q5------------

select ssn, CONCAT_WS(' ',fname,lname) as FullName
from employee join Departments
on SSN=MGRSSN

select ssn, CONCAT_WS(' ',fname,lname) as FullName,Dependent_name
from employee join Departments
on SSN=MGRSSN
full join Dependent on SSN=ESSN
where Dependent_name is null

select ssn, CONCAT_WS(' ',fname,lname) as FullName,count(Dependent_name) 
from employee join Departments
on SSN=MGRSSN
left join Dependent on SSN=ESSN
group by CONCAT_WS(' ',fname,lname),ssn
having count(Dependent_name)=0

--------Q6-----------
select Dno ,Dname,  avg(salary) as avg_salary,count(Dno) as no_of_emp
from Employee join Departments
on Dno=Dnum
group by Dno ,Dname
having avg(salary)< (select avg(salary) from employee)

-------------Q7----------
select CONCAT_WS(' ',fname,lname) as FullName ,d.dname, Pname
from Employee join Works_for 
on ssn=ESSn 
join project
on Pno=Pnumber 
join Departments d
on Dno=d.Dnum
order by dname,Fname,Lname

------------Q8------------
select max(e1.salary) , max(e2.salary)
from employee e1 , (
					select * from employee
					where salary != (select max(salary) from employee)
				    ) e2


select * 
from (
		select *, ROW_NUMBER()over(order by salary desc) as RN
				, DENSE_RANK()over(order by salary desc) as DR
				, NTILE(2)over(order by salary desc) as G
				, ROW_NUMBER()over(partition by dno order by salary desc) as RN_partition
				, DENSE_RANK()over(partition by dno order by salary desc) as DR_partition
		from employee
		
		) as New_table
where
RN<=2
--RN_partition =1






