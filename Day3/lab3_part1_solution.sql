/*1.Display the Department id, name and id and the name of its manager.*/
select dnum,dname,Fname+' '+Lname as manger,MGRSSN from Departments,employee 
where Departments.MGRSSN=Employee.ssn
/*2.Display the name of the departments and the name of the projects under its control.*/
select Dname,pname from Departments,Project where Departments.Dnum=Project.Dnum
/*3.Display the full data about all the dependence associated with the name of the employee they depend on him/her.*/
select d.*,Fname from Dependent d,Employee where d.ESSN=Employee.SSN
/*4.Display the Id, name and location of the projects in Cairo or Alex city*/
select Pnumber,Pname,Plocation from Project where city in ('Cairo','Alex')
/*5.Display the Projects full data of the projects with a name starts with "a" letter.*/
select * from Project where Pname like'a%'
/*6.display all the employees in department 30 whose salary from 1000 to 2000 LE monthly*/
select Fname+' '+Lname as name,Salary from Employee where Dno=30 and Salary between 1000 and 2000 
/*7.Retrieve the names of all employees in department 10 who works more than or 
equal 10 hours per week on "AL Rabwah" project.*/
select e.* from Employee e
inner join Works_for w
on e.SSN=w.ESSn
inner join project p
on p.Pnumber=w.Pno
 where dno=10 and Pname='AL Rabwah' and Hours>=10
 /*8.Find the names of the employees who directly supervised with Kamel Mohamed.*/
 select Fname+' '+Lname as name from Employee where Superssn=223344
/*9.Retrieve the names of all employees and the names of the projects they are working on, sorted by the project name*/
select e.*,Pname from Employee e
inner join Works_for w
on w.ESSn=e.SSN
inner join project p 
on w.Pno=p.Pnumber
order by Pname
/*10.For each project located in Cairo City , find the project number, the controlling department name
 ,the department manager last name ,address and birthdate.*/
select Pnumber,Dname,Lname,Address,Bdate from Employee e
inner join Departments d
on d.MGRSSN=e.SSN
inner join Project p
on p.Dnum=d.Dnum
where city='Cairo'
/*11.Display All Data of the mangers*/
select * from Employee
select * from Departments
select e.* from Employee e
inner join Departments d
on e.SSN=d.MGRSSN
/*12.Display All Employees data and the data of their dependents even if they have no dependents*/
select e.*, d.Dependent_name
from Employee e inner join Dependent d
on e.SSN = d.ESSN
/*Data Manipulating Language:*/
/*1.Insert your personal data to the employee table as a new employee in department
 number 30, SSN = 102672, Superssn = 112233, salary=3000.*/
 insert into Employee (Fname,Lname,ssn,Superssn,salary,dno,sex) values('islam','gamal',102672,112233,3000,30,'M')
 /*2.Insert another employee with personal data your friend as new employee in 
 department number 30, SSN = 102660, but don’t enter any value for salary or manager number to him.*/
 insert into Employee (fname,lname,dno,SSN,sex) values ('ali','amr',30,102660,'M')
 /*3.Upgrade your salary by 20 % of its last value*/
 select * from Employee
 update Employee set Salary=Salary+Salary*.20 where Fname='islam'