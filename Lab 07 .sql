use ITI

---------Q1---------- 
if exists(select name from sys.objects where name ='GetMonth')
begin drop function GetMonth
end

go
create function GetMonth (@date datetime)
returns varchar(10)

begin
declare @month varchar(10)
set @month = (SELECT DATENAME(month, @date) AS MonthName)
return @month
end

go
select dbo.GetMonth(CURRENT_TIMESTAMP)

---------Q2----------
if exists(select name from sys.objects where name ='InBetween')
begin
drop function InBetween
end

go
create function InBetween(@begin_no int,@end_no int)
returns @t table(range_no int)
as
begin
	while(@begin_no<@end_no-1)
	begin
		set @begin_no=@begin_no+1
		insert into @t
		select @begin_no
	end
	return 
end

go
select * from dbo.InBetween(4,20)

---OR---
--CREATE FUNCTION InBetween(@begin_no INT, @end_no INT)
--RETURNS @t TABLE (range_no INT)
--AS
--BEGIN
--    WHILE (@begin_no < @end_no-1)
--    BEGIN
--        SET @begin_no = @begin_no + 1;
--        INSERT INTO @t (range_no)
--        VALUES (@begin_no);
--    END
--    RETURN;
--END;

---------Q3----------
if exists(select name from sys.objects where name ='Student_info')
begin
drop function Student_info
end

go
create function Student_info(@id int)
returns table
as
return
(select CONCAT_WS(' ',st_fname,st_lname) as FullName, Dept_name
from student s join department d
on s.Dept_Id=d.Dept_Id
where s.st_id=@id)

go
select * from Student_info(3)

---------Q4----------
if exists(select name from sys.objects where name ='Student_check_name')
begin
drop function Student_name
end

go
create function Student_check_name(@id int)
returns varchar(70)
as
begin
	declare @fname varchar(30) , @lname varchar(30)
	select @fname=st_fname , @lname=st_lname 
	from student
	where st_id=@id

	if @fname is null And @lname is null
	begin
		return 'Full name is null'
	end

	else if @fname is null
	begin
		return 'First name is null'
	end

	else if @lname is null
	begin
		return 'Last name is null'
	end

	return 'name is not null'
end

---OR---

--if exists(select name from sys.objects where name ='Student_check_name')
--begin
--drop function Student_check_name
--end

--go
--create function Student_check_name(@id int)
--returns varchar(70)
--as
--begin
--	if not exists(select st_fname from student where st_id=@id)
--	begin
--	return 'first name is null'
--	end

--	if not exists(select st_fname,st_lname from student where st_id=@id )
--	begin
--	return 'Full name is null'
--	end

--	if not exists(select st_lname from student where st_id=@id)
--	begin
--	return 'first name is null'
--	end
	
--	return 'name is not null'
	
--end

--go
--select dbo.Student_check_name(3)


---------Q5----------
if exists(select name from sys.objects where name ='Manager_info')
begin
drop function Manager_info
end

go
create function Manager_info(@id int)
returns table 
as return
(select ins_name as manager_name,dept_name,manager_hiredate
from instructor join department
on ins_id=Dept_Manager
where Dept_Manager=@id
)

go
select * from Manager_info(7) --saly
go
select * from Manager_info(12) --null

select *  from Instructor
select *  from department

---------Q6----------
if exists(select name from sys.objects where name ='Student_name')
begin
drop function Student_name
end

go
create function Student_name(@format varchar(20))
returns @t table(name varchar(30))
as
begin
set @format = LOWER(@format)
	if @format='first name'
	insert into @t
		select isnull(st_fname,'first name') from student
	else if @format='last name'
	insert into @t
		select isnull(st_lname,'last name') from student
	else if @format='full name'
	insert into @t
		select isnull(CONCAT_WS(' ',st_fname,st_lname),'full name') from student
	return
end

go
select * from Student_name('first NAME')
select * from Student_name('lAst NAME')
select * from Student_name('fULl nAME')
