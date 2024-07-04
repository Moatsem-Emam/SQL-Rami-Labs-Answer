--------------Q1--------------
use ITI
if exists(select * from sys.objects where name='Dept_studs')
	drop proc Dept_studs

go
create proc Dept_studs
as
begin
	select dept_name , count(st_id) as number_of_studs
	from Department d join student s
	on d.Dept_Id=s.dept_id
	group by dept_name
end

go
Dept_studs

--------------Q2--------------
use Company_SD
go
if exists(select name from sys.objects where name='check_employees')
drop proc check_employees
go
create proc check_employees @p varchar(5)
as
		declare @count int
	begin
		select @count = students
		from(
			select count(ESSN) as students , Pno,ROW_NUMBER()over(order by pno) as RN
			from Works_for
			group by pno
			
			) as tab1
		where RN = @p
		if @count >3 
			begin
			select 'The number of employees in the project p' + @p +' is 3 or more'
			end
		else
			begin
			select *
			from(
				select CONCAT_WS(' ',fname,lname) as 'The following employees work for this project',pno,
					   DENSE_RANK()over(order by pno) as DR
				from Employee join Works_for
				on ssn = essn
				join project 
				on pno = pnumber) as tab2
			where DR = @p
			end
		select @count as studs_p
				
	end
go
check_employees 5

--------------Q3--------------
select * from Works_for

select* from Employee

go
if exists(select name from sys.objects where name='update_projectEmp')
drop proc update_projectEmp

go
create proc update_projectEmp @old int , @new int , @pno int
as
begin
	update Works_for
	set ESSn = @new
	where ESSn = @old and pno = @pno
	
end

go
create trigger updt
on Works_for
after update 
as
	select * from inserted
	select * from deleted
go
update_projectEmp 321654,112233,600

--------------Q4--------------
-- add budget column
alter table project
add budget int
select * from project
-- create Audit table
create table Audit(
			ProjectNo int,
			UserName  varchar(50),
			ModifiedDate datetime,
			Budget_Old int,
			Budget_New int
			)
go

create trigger upd_audit
on project
instead of update
as
declare @pnum int , @old int , @new int
	begin
		if update(budget)
		begin
			select @pnum = pnumber ,@old = budget from deleted
			select @new = budget from inserted

			insert into Audit
			values(@pnum,SUSER_NAME(),GETDATE(),@old,@new)

			select * from Audit
		end
	end

update project set budget =2000
where pnumber = 100
go
update project set budget =2000000
where pnumber = 400
go
select * from project

--------------Q5--------------
use ITI

go
create trigger noIns_dept
on Department
instead of insert
as
	select 'You can’t insert a new record in that table'

go
insert into Department(Dept_Name) values('lol')
select * from department

--------------Q6--------------
if exists(select * from sys.objects where name='noIns_emp' )
	drop trigger noIns_emp
go
create trigger noIns_emp
on Employee
instead of insert
as
declare @value int
	if (FORMAT( GETDATE(),'MMM')='Mar')
		select 'You can’t insert a new record in that table this month'
	else
		select @value=ssn from inserted
		insert into Employee(ssn) values(@value)
		select * from inserted

go
insert into Employee(ssn) values(40)
go
select * from employee

--------------Q7--------------
use ITI
create table InsStud_Audit(
			Server_User_Name varchar(50),
			Date datetime,
			Note varchar(500)
			)
go
alter trigger noIns_stud
on student
instead of insert
as
	declare @_id varchar(50),@_fname varchar(50),
	@_lname varchar(50),@_address varchar(50),
	@_age varchar(50),@_deptId varchar(50),
	@_super varchar(50)

	begin
		select @_id=st_id , @_fname=st_fname ,
		@_lname=st_lname , @_address=st_address,
		@_age=st_age , @_deptId=dept_id  ,
		@_super=st_super
		from inserted

		insert into InsStud_Audit values(
								SUSER_NAME(),GETDATE(),
								'INSERT INTO Student VALUES('
								+CONCAT_WS(' ','st_id:'+@_id,'st_fname:'+@_fname,'st_lname:'+@_lname,'st_address:'+@_address,'st_age:'+@_age,'dept_id:'+@_deptId,'st_super:'+@_super)
										+')'
										)
		select * from InsStud_Audit
	end

	insert into student(st_id,St_Fname) values(70,'mooooooooo')
