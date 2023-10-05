/*1.Create a cursor for Employee table that increases Employee salary by 10% if Salary <3000 and increases it by 20% if Salary >=3000. Use company DB*/
use Company_SD
declare c1 cursor
for 
select Salary from Employee
for update

declare @row int
open c1
fetch c1 into @row
while @@FETCH_STATUS=0
   begin
     if @row>=3000
	 update Employee set Salary=salary*.2
	 else
	update employee set Salary=salary*.1
	fetch c1 into @row
   end
 close c1
 deallocate c1

 /*2.Display Department name with its manager name using cursor. Use ITI DB*/
 use iti
 declare c2 cursor
 for
 select Ins_Name,Dept_Name from iti.dbo.Department d,iti.dbo.Instructor i
 where i.Ins_Id=d.Dept_Manager
 for update

 declare @dep varchar(50),@man varchar(50)
 open c2
 fetch c2 into @dep,@man
 while @@FETCH_STATUS=0
   begin
   select @dep,@man
   fetch c2 into @dep,@man
   end
close c2
deallocate c2

/*3.Try to display all students first name in one cell separated by comma. Using Cursor */
use iti
declare c3 cursor
for 
select St_Fname from Student
for read only

declare @first varchar(50),@first2 varchar(50)=''
open c3
fetch c3 into @first
while @@FETCH_STATUS=0
 begin
  set @first2=CONCAT(@first2,'',@first)
  fetch c3 into @first
 end
 close c3
 deallocate c3
 
 /*4.Create full, differential Backup for SD30_Company DB.*/
 /*done*/
 
 /*5.Use import export wizard to display students data (ITI DB) in excel sheet*/
 /*done*/


 /*6.Try to generate script from DB ITI that describes all tables and views in this DB*/
 /*done*/

 /*7.Create a sequence object that allow values from 1 to 10 without cycling in a specific column and test it*/
 create table #seq (vesq int)

create sequence seqq as int
start with 1 
increment by 1 
Minvalue 1 
maxvalue 10
cycle

drop seqq
declare @std int = 1 , @end int = 10 
	while @std > @end 
		begin
			INSERT into #seq values (next value for dbo.seqq)
				set @std +=1
		end 

/*2.In Company_SD in employee table Check if Gender='M' add 'Mr Befor Employee name    
else if Gender='F' add Mrs Befor Employee name  then display all names  
use cursor for update*/
declare c1 cursor
for 
select gender
from Employee
for update

declare @name varchar(10), @gender char

open c1

fetch c1 into @gender

while @@FETCH_STATUS = 0
begin
    if @gender ='M'
    begin 
		update Employee
		set Fname = CONCAT('Mr' , ' ' , Fname)
		where current of c1
    end
	else
	begin 
		update Employee
		set Fname = CONCAT('Mrs' , ' ' , Fname)
		where current of c1
    end
fetch c1 into @gender
end

close c1
deallocate c1

select * from Employee

/*In ITI database Count times that amr apper after ahmed in student table in st_Fname column (using the cursor)  A*/
declare c1 cursor 
for 
select Student.St_Fname
from Student

for read only

declare @name varchar(10), @counter int = 0, @container int = 0

open c1
fetch c1 into @name 

while @@FETCH_STATUS =0
begin
if @name = 'ahmed'
    set @container +=1
if @name = 'amr' and @container = 1
		begin 
			set @counter +=1
			set @container = 0
		end
fetch c1 into @name
end

select @counter

close c1
deallocate c1

select * from Student

---------------------------------or-------------------------

declare c1 cursor 
for 
select  Student.St_Fname, LEAD(St_Fname)over(order by St_id) as next_name
from Student
for read only

declare @stu_name varchar(10), @stu_next varchar(10), @count int = 0

open c1
fetch c1 into @stu_name , @stu_next

while @@FETCH_STATUS =0
begin
if @stu_name ='ahmed' and @stu_next = 'amr'
	set @count+=1

fetch c1 into @stu_name , @stu_next
end

select @count

close c1
deallocate c1

