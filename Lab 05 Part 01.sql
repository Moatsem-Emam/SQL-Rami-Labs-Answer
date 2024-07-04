------------Lab05 Part01 Ans-------------
use iti
------Q1------
select count(st_age)
from student 
------Q2------
select distinct ins_name
from Instructor
------Q3------
select s.st_id, CONCAT_WS(' ', s.St_Fname,s.St_Lname) AS St_fullname ,d.dept_name
from Student s full join Department d
on s.Dept_Id=d.Dept_Id
------Q4------
select i.ins_name , i.dept_id
from Instructor i full join Department d
on i.Dept_Id=d.Dept_Id
------Q5------
select CONCAT_WS(' ', s.St_Fname,s.St_Lname) AS St_fullname,c.crs_name,sc.Grade
from student s full join Stud_Course sc
on s.St_Id=sc.St_Id
full join Course c
on c.Crs_Id=sc.Crs_Id
where sc.Grade is not null
------Q6------
select count(crs_name) crss,c.top_id,t.top_name
from Course c join topic t
on c.Top_Id=t.Top_Id
group by c.top_id,t.top_name
------Q7------
select MAX(salary) AS max_sa , MIN(salary) AS min_sa
from Instructor
where salary is not null
------Q8------
select distinct ins_name, salary
from Instructor
where salary < (select avg(salary) from Instructor)
------Q9------
--SubQuery--
select *
from
	(select d.dept_name,min(salary) as min_sa
	from Instructor i join Department d
	on i.dept_id=d.dept_id
	group by d.dept_name) as table1
	join (select ins_name,Salary from Instructor) as table2
	on min_sa = salary
--Ranking--
select *
from
(select i.ins_name,i.salary,d.dept_name, ROW_NUMBER()over(partition by i.dept_id order by i.salary) AS RN
									   , DENSE_RANK()over(partition by i.dept_id order by i.salary) AS DR
from Instructor i join Department d
on i.Dept_Id=d.Dept_Id) AS Tab1
where DR=1
------Q10------
select *
from
(select *, ROW_NUMBER()over(order by salary desc) AS RN
		 , DENSE_RANK()over(order by salary desc) AS DR 
from Instructor ) AS Tab1
where DR<=2
------Q11------
select ins_name, COALESCE(salary,0) as salary
from Instructor

--(Note)--
-- count : null مش بتعد ال 
--        بتعد الاصفار عادي

select  count(salary) as salary
from Instructor

------Q12------
select avg(COALESCE(salary,0)) AS Avg_sa
from instructor
------Q13------
select CONCAT_WS(' ', s1.St_Fname,s1.St_Lname) AS Student , CONCAT_WS(' ', s2.St_Fname,s2.St_Lname) AS Supervisor, s2.st_age AS Sup_age
from student s1 join student s2 
on s1.st_super = s2.st_id
------Q15------
--WITH RankedStudents AS (
--    SELECT
--		NEWID() as iddd,
--        s.st_id,
--        s.st_fname,
--        s.dept_id,
--        ROW_NUMBER() OVER (PARTITION BY s.dept_id ORDER BY NEWID()) AS rn
--    FROM
--        Student s
--)
--SELECT
--   *
--FROM
--    RankedStudents
--WHERE
--    rn = 1;

select *
from(
select *,ROW_NUMBER() OVER (PARTITION BY s.dept_id ORDER BY NEWID()) AS RN,NEWID() AS GUID
from student s) AS tab
where RN =1 and dept_id is not null