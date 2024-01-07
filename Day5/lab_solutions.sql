/*1.Retrieve number of students who have a value in their age.*/
select count(St_Id) as student_numer from Student where St_Age is not null 
/*2.Get all instructors Names without repetition*/
select distinct Ins_Name from Instructor
/*3.Display student with the following Format (use isNull function)*/
select St_Id as 'Student ID',isnull(St_Fname,' ')+' '+isnull(St_Lname,' ') as 'Student Full Name',
isnull(Dept_Name,' ') as 'Department name' from Student,Department
where Student.Dept_Id=Department.Dept_Id
/*4.Display instructor Name and Department Name 
Note: display all the instructors if they are attached to a department or not
*/
select Ins_Name,Dept_Name from Instructor i
left join Department d
on i.Dept_Id=d.Dept_Id

/*5.Display student full name and the name of the course he is taking
For only courses which have a grade */
select St_Fname+' '+St_Lname as 'full name',Crs_Name from Stud_Course sc
inner join Course c 
on c.Crs_Id=sc.Crs_Id
inner join Student s
on s.St_Id=sc.St_Id
where sc.Grade> 0

/*6.Display number of courses for each topic name*/
select Top_Name,count(Crs_Id) courses_number from Topic t
inner join Course c
on t.Top_Id=c.Top_Id
group by Top_Name

/*7.Display max and min salary for instructors*/
select min(salary) as minimum_salary,max(Salary) as maximum_salary from Instructor

/*8.Display instructors who have salaries less than the average salary of all instructors*/
select Ins_Name from Instructor where Salary <(select avg(Salary) from Instructor)

/*9.Display the Department name that contains the instructor who receives the minimum salary*/
select Dept_Name from Department d
inner join Instructor i
on d.Dept_Id=i.Dept_Id
where i.Salary=(select min(Salary) from Instructor)

/*10.Select max two salaries in instructor table*/
select max(Salary) from Instructor 
where Salary < (select max(Salary) from Instructor)
union all
select max(Salary) from Instructor 
where Salary = (select max(Salary) from Instructor)

/*11.Select instructor name and his salary but if there is no salary display instructor bonus. “use one of coalesce Function”*/
select Ins_Name,coalesce(Salary,'bonus') as salary from Instructor 

/*12.Select Average Salary for instructors*/
select avg(salary) as salary from Instructor

/*13.Select Student first name and the data of his supervisor*/
select s.St_Fname,sub.* from Student s
inner join Student sub
on sub.St_Id=s.St_super

/*14.Write a query to select the highest two salaries in Each Department for instructors who have salaries.
 “using one of Ranking Functions”*/
 select Salary from ( select Salary,
 dense_rank()over(partition by dept_id order by salary desc) as rn
 from Instructor ) as high_salary
 where rn=2
  
 /*15.Write a query to select a random student from each department.  
 “using one of Ranking Functions*/
 select St_Fname,Dept_Id from(
 select *,ROW_NUMBER()over(partition by Dept_Id order by NEWID())as rn
  from Student 
 ) as random WHERE rn=1

 /*Use AdventureWorks DB*//*
1.	Display the SalesOrderID, ShipDate of the SalesOrderHearder table (Sales schema) to designate SalesOrders
 that occurred within the period ‘7/28/2002’ and ‘7/29/2014’
*/
use AdventureWorks2012
select SalesOrderID,ShipDate from Sales.SalesOrderHeader where OrderDate between  7/28/2002 and 7/29/2014 

/*2.Display only Products(Production schema) with a StandardCost below $110.00 (show ProductID, Name only)*/
select ProductID,Name,StandardCost  from Production.Product where StandardCost<110.00

/*3.Display ProductID, Name if its weight is unknown*/
select ProductID,name from Production.Product where Weight is null

/*4.Display all Products with a Silver, Black, or Red Color*/
select Name from Production.Product where Color in('Silver','Red','Black')

/*5.Display any Product with a Name starting with the letter B*/
select name from Production.Product where name like 'B%'

/*6.	Run the following Query
Then write a query that displays any Product description with underscore value in its description.
*/
UPDATE Production.ProductDescription
SET Description = 'Chromoly steel_High of defects'
WHERE ProductDescriptionID = 3

select name from Production.ProductDescription d ,Production.Product p  where
d.rowguid=p.rowguid
and Description like '%_%'

/*7.Calculate sum of TotalDue for each OrderDate in Sales.SalesOrderHeader table for the period
 between  '7/1/2001' and '7/31/2014'*/
 select sum(TotalDue) as 'Total Due',OrderDate from Sales.SalesOrderHeader where OrderDate between 7/1/2001 and 7/31/2014
 group by OrderDate

/*8.Display the Employees HireDate (note no repeated values are allowed)*/
select distinct HireDate from HumanResources.Employee

/*9.Calculate the average of the unique ListPrices in the Product table*/
select avg(distinct ListPrice) as AVG from Production.Product

/*10.Display the Product Name and its ListPrice within the values of 100 and 120 the list should has 
the following format "The [product name] is only! [List price]"
 (the list will be sorted according to its ListPrice value)*/
 select concat('the',name,'is only!',ListPrice)as p from Production.Product where ListPrice in(100,120)
 order by ListPrice 

/*11.a)Transfer the rowguid ,Name, SalesPersonID, Demographics from Sales.
Store table  in a newly created table named [store_Archive]
Note: Check your database to see the new table and how many rows in it?
*/
select rowguid ,Name, SalesPersonID, Demographics 
into store_Archive
from Sales.Store
select * from store_Archive
select * from Sales.Store

/*
b)Try the previous query but without transferring the data? 
*/
select rowguid ,Name, SalesPersonID, Demographics 
into store_Archive3
from Sales.Store
where 1=2

/*12.Using union statement, retrieve the today’s date in different styles*/
select CONVERT(varchar(50),getdate(),101)
union 
select CONVERT(varchar(20),getdate())
union
select format(getdate(),'mm-dd-yyy')
union 
select format(getdate(),'hh tt')

/*
Part-3: Bouns
Display results of the following two statements and explain what is the meaning of @@AnyExpression
*/
select @@VERSION as 'Version Name'
/*it display the version of sql server on our device*/
select @@SERVERNAME as 'Server Name'
/*it display the server of the device that sql server run on it*/
