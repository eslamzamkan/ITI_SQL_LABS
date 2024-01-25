/*1.Create a view that displays student full name, course name if the student has a grade more than 50*/
create view displaystudent as
select concat(St_Fname,' ',St_Lname)as 'full name',Crs_Name,Grade from Student s
inner join Stud_Course sc
on sc.St_Id=s.St_Id
inner join Course c
on c.Crs_Id=sc.Crs_Id
where Grade>50
select * from displaystudent

/*2.Create an Encrypted view that displays manager names and the topics they teach*/
create view manger_name with encryption as
select Top_Name,Ins_Name 
from Topic t,Course c,Instructor i,Ins_Course ic,Department d
where t.Top_Id=c.Top_Id
 and d.Dept_Manager=i.Ins_Id 
 and ic.Crs_Id=c.Crs_Id 
 and ic.Ins_Id=i.Ins_Id
 select * from manger_name
sp_helptext 'manger_name'

/*3.Create a view that will display Instructor Name, Department Name for the ‘SD’ or ‘Java’ Department “use Schema binding” 
and describe what is the meaning of Schema Binding*/
create view data2 
with schemabinding as
select Ins_Name,Dept_Name from Instructor i,Department d
where i.Dept_Id=d.Dept_Id and Dept_Name in('SD','Java')

/*4.Create a view “V1” that displays student data for student who lives in Alex or Cairo. 
Note: Prevent the users to run the following query 
Update V1 set st_address=’tanta’
Where st_address=’alex’;
*/ 
create view v1 as
select * from Student where St_Address in('Alex','Cairo')
with check option
update v1 set St_Address='tanta' where St_Address='alex'

/*5.Create index on column (Hiredate) that allow u to cluster the data in table Department. What will happen?*/
create clustered index os on Department(manager_hiredate)

/*6.Create index that allow u to enter unique ages in student table. What will happen?*/
create unique index i on student(St_Age)

/*7.Create temporary table [Session based] on Company DB to save employee name and his today task.*/
use Company_SD
create table #empoyee_data(
name varchar(50),
task varchar(50)
)
/*8.Create a view that will display the project name and the number of employees work on it. “Use Company DB”*/
use Company_SD
create view emp_data as
select Pname,count(e.SSN)as 'number of employees' from Project p,Employee e,Works_for w
where p.Pnumber=w.Pno and e.SSN=w.ESSn
group by Pname

/*9.Using Merge statement between the following two tables [User ID, Transaction Amount]*/
create table d_trans (user_id int, tamount int)
create table L_trans (user_id int, tamount int)

insert into d_trans values (1,1000),(2,2000),(3,1000)

merge into d_trans as target
using L_trans as source
on target.user_id=source.user_id
when matched then 
update set target.tamount=source.tamount
when not matched then
insert values(source.user_id, source.tamount)
;

/*Part 2: use CompanySD32_DB

1)	Create view named “v_clerk” that will display employee#,project#, the date of hiring of all the jobs of the type 'Clerk'.
*/
use [SD32-Company]
alter view v_clerk as
select e.EmpNo,p.ProjectNo ,Enter_Date from Works_on w,Human_Resource.Employee1 e,company.Project p
where p.ProjectNo=w.ProjectNo and e.EmpNo=w.EmpNo and Job='Clerk'

/*2)Create view named  “v_without_budget” that will display all the projects data 
without budget*/
create view v_without_budget as
select * from company.Project where Budget is null
select * from v_without_budget

/*3)Create view named  “v_count “ that will display the project name and the # of jobs in it*/
create view v_count as
select ProjectName,count(*) from company.Project p, Works_on w
where p.ProjectNo=w.ProjectNo
group by  ProjectName
select * from v_count

/*4)Create view named ” v_project_p2” that will display the emp# s for the project# ‘p2’
use the previously created view  “v_clerk”
*/
create view v_project_p2 as
select EmpNo from v_clerk

select * from v_project_p2

/*5)modifey the view named  “v_without_budget”  to display all DATA in project p1 and p2 */
alter view v_without_budget as
select * from company.Project where ProjectName in('p1','p2')
select * from v_without_budget

/*6)Delete the views  “v_clerk” and “v_count”*/
drop view v_clerk
go
drop view v_count

/*7)Create view that will display the emp# and emp lastname who works on dept# is ‘d2’*/
create view empo as
select EmpNo,Emp_Lname from Human_Resource.Employee1 e,company.Department d
where e.DeptNo=d.DeptNo and d.DeptName='d2'

/*8)Display the employee  lastname that contains letter “J”
Use the previous view created in Q#7
*/
select Emp_Lname from empo where Emp_Lname like '%j%'

/*9)Create view named “v_dept” that will display the department# and department name*/
create view v_dept as 
select DeptNo,DeptName from company.Department
select * from v_dept 

/*10)sing the previous view try enter new department data where dept# is ’d4’ and dept name is ‘Development’*/
insert into v_dept(DeptNo,DeptName) values('d4','Development')
select * from v_dept

/*11)Create view name “v_2006_check” that will display employee#, the project #where he works and
 the date of joining the project which must be from the first of January and the last of December 2006.
 this view will be used to insert data so make sure that the coming new data must match the condition*/
 create view v_2006_check as 
 select EmpNo,ProjectNo,Enter_Date from Works_on 
 where Enter_Date between '1-1-2006' and '31-12-2006'

 select * from v_2006_check