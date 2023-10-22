/*1.Display all the data from the Employee table (HumanResources Schema) 
As an XML document “Use XML Raw”. “Use Adventure works DB” 
A)Elements
B)Attributes
*/
/*A)Elements*/
select * from AdventureWorks2012.HumanResources.Employee
for xml raw('Employee'),elements,root('Employee')
/*B)Attributes*/
select * from AdventureWorks2012.HumanResources.Employee
for xml auto,root('Employee')
/*2.Display Each Department Name with its instructors. “Use ITI DB”
A)Use XML Auto
B)Use XML Path
*/
/*A)Use XML Auto*/
use iti
select Department.Dept_Name,Ins_Name from Department,Instructor
where Department.Dept_Id=Instructor.Dept_Id
for xml auto
/*B)Use XML Path*/
use iti
select Department.Dept_Name,Ins_Name from Department,Instructor
where Department.Dept_Id=Instructor.Dept_Id
for xml path ('data')
/*3.Use the following variable to create a new table “customers” inside the company DB.
 Use OpenXML
*/

declare @docs xml ='<customers>
              <customer FirstName="Bob" Zipcode="91126">
                     <order ID="12221">Laptop</order>
              </customer>
              <customer FirstName="Judy" Zipcode="23235">
                     <order ID="12221">Workstation</order>
              </customer>
              <customer FirstName="Howard" Zipcode="20009">
                     <order ID="3331122">Laptop</order>
              </customer>
              <customer FirstName="Mary" Zipcode="12345">
                     <order ID="555555">Server</order>
              </customer>
       </customers>'

declare @doc int 
	execute sp_xml_preparedocument @doc output, @docs 

select * from openxml (@doc, '//customer')
	with (FirstName varchar(20) '@FirstName', 
		  Zipcode int  '@Zipcode',
		  order_ varchar(20) '@order',
		  ID int '@ID')
		  
execute sp_xml_removedocument @doc

/*4.Create a stored procedure to show the number of students per department.[use ITI DB] */
use ITI
alter procedure p1 
as
select Dept_Name,count(St_Id) as number_student from Student,Department
where Student.Dept_Id=Department.Dept_Id
group by Dept_Name
p1

/*5.Create a stored procedure that will check for the # of employees in the project p1 
if they are more than 3 print message to the user “'The number of employees in the project p1 is 3 or more'” i
f they are less display a message to the user “'The following employees work for the project p1'” in
addition to the first name and last name of each one. [Company DB]*/


/*6.Create a stored procedure that will be used in case there is an old employee has left the project and a new one become instead of him. 
The procedure should take 3 parameters (old Emp. number, new Emp. number and the project number) 
and it will be used to update works_on table. [Company DB]*/
create procedure P4 @oldemps int , @newemps int, @pnum int 
as 
	update Company_SD.dbo.Works_for 
		set ESSn = @newemps
			where ESSn = @oldemps and Pno = @pnum


/*8.Create a trigger to prevent anyone from inserting a new record in the Department table [ITI DB]
“Print a message for user to tell him that he can’t insert a new record in that table”
*/
create trigger prevent
on department
instead of insert
as
select 'not inserted'

/*9.Create a trigger that prevents the insertion Process for Employee table in March [Company DB].*/
use Company_SD

alter trigger preve 
on Company_SD.dbo.Employee
after insert as if FORMAT(GETDATE(), 'MMMM') = 'March'
	begin
	select 'Prevented'
	delete from Company_SD.dbo.Employee where SSN= (select SSN from deleted)
	end

/*10.Create a trigger that prevents users from altering any table in Company DB.*/
create trigger users
on database
for alter_table
as
select 'prevent'
rollback
/*11.Create a trigger on student table after insert to add Row in Student Audit table (Server User Name , Date, Note)
 where note will be “[username] Insert New Row with Key=[Key Value] in table [table name]”*/
 create trigger pre
 on student
