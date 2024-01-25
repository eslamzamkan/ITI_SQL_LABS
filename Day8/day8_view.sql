/*1-Create a view that displays student full name, course name if the student has a grade more than 50. */
create view data(fullname,course_name) as(
select St_Fname+' '+St_Lname as fullname,Course.Crs_Name from Student
inner join Stud_Course
on Stud_Course.St_Id=Student.St_Id 
inner join Course
on Course.Crs_Id=Stud_Course.Crs_Id
where Stud_Course.Grade>50
)
select * from data
/*2-Create an Encrypted view that displays manager names and the topics they teach */
create view info0 with encryption as(
select Instructor.Ins_Name as manger,Topic.Top_Name as Tobics_Name from Course
inner join Topic
on Topic.Top_Id=Course.Top_Id
inner join  Ins_Course
on Ins_Course.Crs_Id=Course.Crs_Id
inner join Instructor
on Instructor.Ins_Id=Ins_Course.Ins_Id
inner join Department
on Instructor.Ins_Id = Department.Dept_Manager
)
select * from info0
/*3. Create a view that will display Instructor Name, Department Name for the ‘SD’ or ‘Java’ Department.*/
create view inst as(
select Instructor.Ins_Name,Department.Dept_Name from Instructor
inner join Department
on Department.Dept_Id=Instructor.Dept_Id
where Department.Dept_Name='SD' or Department.Dept_Name='java'
)
select * from inst
/*4-Create a view “V1” that displays student data for student who lives in Alex or Cairo. 
--Note: Prevent the users to run the following query 
--Update V1 set st_address=’tanta’
--Where st_address=’alex’;
*/
create view V1
as
select * from Student 
where St_Address in ('alex','cairo')
with check option 

select * from V1

update  v1 set St_Address='tanta' where St_Address='Alex'

/*5-Create index on column (Hiredate) that allow u to cluster the data in table Department. What will happen?*/
create clustered index ini on department (manager_hiredate)

/*6-Create index that allow u to enter unique ages in student table. What will happen? */
create unique index iti on Student(St_Age)

/*7-Create a temporary table [Session based] on Company DB to save employee name and his today task.*/
create table #employee(
name varchar(50),
today_task varchar(250)
)

/*8-Create a view that will display the project name and the number of employees work on it. “Use SD database”*/
use Company_SD
create view i as
select pname,count(Employee.SSN)as num_of_employee from Company_SD.dbo.Project
inner join Company_SD.dbo.Departments
on Departments.Dnum=Project.Dnum
inner join Company_SD.dbo.Employee
on Employee.Dno=Departments.Dnum
group by Pname

select * from i

/*9-Using Merge statement between the following two tables [User ID, Transaction Amount]*/



/*part 2 use Company_SD*/
/*1-Create view named “v_clerk” that will display employee#,project#, the date of hiring of all the jobs of the type 'Clerk'*/
create view v_clerk as
select * from AdventureWorks2012.HumanResources.Employee

select * from Company_SD.dbo.Project
select * from Company_SD.dbo.Works_for
select * from Company_SD.dbo.Departments
select * from AdventureWorks2012.HumanResources.Department
select * from AdventureWorks2012.HumanResources.Employee
select * from AdventureWorks2012.HumanResources.EmployeeDepartmentHistory
select * from AdventureWorks2012.HumanResources.Shift
/*2-Create view named  “v_without_budget” that will display all the projects data without budget*/
