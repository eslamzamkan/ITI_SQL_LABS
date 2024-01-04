/*1.Display (Using Union Function)*/
/*a.The name and the gender of the dependence that's gender is Female and depending on Female Employee.*/
/*b.And the male dependence that depends on Male Employee.*/
select * from Employee
select Fname+' '+Lname as emp_name ,Dependent_name from Dependent d
inner join  Employee e 
on d.ESSN=e.SSN
where  d.Sex='F' and e.Sex='F'
union all
select Fname+' '+Lname as emp_name ,Dependent_name from Dependent d
inner join  Employee e 
on d.ESSN=e.SSN
where  d.Sex='M' and e.Sex='M'

/*2.For each project, list the project name and the total hours per week (for all employees) spent on that project.*/
select Pname,sum(Hours) as total_hours from Project p
inner join Works_for w
on p.Pnumber=w.Pno
group by Pname,w.Pno

/*3.Display the data of the department which has the smallest employee ID over all employees' ID.*/
select d.* from Departments d
inner join Employee e
on d.Dnum=e.Dno
where SSN =(select min(SSN) from Employee)

/*4.For each department, retrieve the department name and the maximum, minimum and average salary of its employees.*/
select Dname, min(Salary)as minimum,max(Salary) as maximum,avg(isnull(salary,0)) as average from Departments d
inner join Employee e
on d.Dnum=e.Dno
group by Dname

/*5.List the last name of all managers who have no dependents.*/
select * from Employee e
inner join Departments d
on e.SSN=d.MGRSSN
where e.SSN not in (select ESSN from Dependent)

/*6.For each department-- if its average salary is less than the average salary of all employees
-- display its number, name and number of its employees.*/
select d.Dname,d.dnum,count(e.SSN) as number_employee,avg(Salary) as average_salary from Departments d
inner join Employee e
on d.Dnum=e.Dno
group by d.Dname,d.Dnum
having avg(salary)<(select avg(Salary) from Employee)

/*7.Retrieve a list of employees and the projects they are working on ordered by department and within each department, 
ordered alphabetically by last name, first name.*/
select Fname+' '+Lname as fullname,Pname,Dnum from Employee e
inner join Works_for w
on e.SSN=w.ESSn
inner join Project p
on w.Pno=p.Pnumber
order by dno,Fname,Lname
/*8.Try to get the max 2 salaries using subquery*/
select max(Salary) as max_salary from employee
where salary <(
select max(Salary) from Employee
)
union
select max(Salary) as max_salary from employee
where salary =(
select max(Salary) from Employee
)
/*9.Get the full name of employees that is similar to any dependent name*/
select distinct concat(Fname,Lname) as fullname from Employee e
inner join Dependent d
on e.SSN=d.ESSN
where Dependent_name like concat('%',e.Fname,'%') or d.Dependent_name like concat('%',e.Lname,'%')

/*10.Try to update all salaries of employees who work in Project ‘Al Rabwah’ by 30% */
update Employee set Salary=Salary*1.30
where ssn in(
select e.ssn from Employee e
right join  Works_for w
on e.SSN=w.ESSn
left join Project p
on w.Pno=p.Pnumber
and p.Pname='Al Rabwah'
)

/*11.Display the employee number and name if at least one of them have dependents (use exists keyword) self-study.*/
select ssn,Fname+' '+Lname as Fullname from Employee
where exists (select * from Employee e inner join Dependent d 
on e.SSN=d.ESSN )


/*
1.In the department table insert new department called "DEPT IT" , with id 100, employee with SSN = 112233 as a manager 
for this department. The start date for this manager is '1-11-2006'
*/
insert into Departments (Dname,dnum,MGRSSN,[MGRStart Date]) values ('DEPT IT',100,112233,'1-11-2006')

/*2.Do what is required if you know that : Mrs.Noha Mohamed(SSN=968574)
  moved to be the manager of the new department (id = 100), and they give you(your SSN =102672) her position (Dept. 20 manager)
a.First try to update her record in the department table*/
update Departments set MGRSSN=968574 where Dnum=100
/*b.Update your record to be department 20 manager.*/
update Departments set MGRSSN=102672 where Dnum=20
/*c.Update the data of employee number=102660 to be in your teamwork (he will be supervised by you) (your SSN =102672)*/
update Employee set Superssn=102672,dno=20 where ssn=102660

/*3.Unfortunately the company ended the contract with Mr. Kamel Mohamed (SSN=223344)
 so try to delete his data from your database in case you know that you will be temporarily in his position.
Hint: (Check if Mr. Kamel has dependents, works as a department manager, supervises
 any employees or works in any projects and handle these cases).
*/
delete Works_for where ESSn=223344
delete Dependent where ESSN=223344
update Employee set Superssn=102672 where Superssn=223344
update Departments set MGRSSN=102672 where MGRSSN=223344
delete Employee where SSN=223344