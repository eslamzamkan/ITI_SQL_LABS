-- 1. Create a scalar function that takes a date and returns the Month name of that date. Test with �1/12/2009�
CREATE OR ALTER FUNCTION GetMonthFromDate(@inDate date)
RETURNS varchar(15)
BEGIN
	DECLARE @monthName varchar(10)
	SELECT @monthName = DATENAME(MONTH, @inDate)
	RETURN @monthName
END

SELECT dbo.GetMonthFromDate('1/12/2009'); --------------------- DONE

-- 2. Create a multi-statements table-valued function that takes 2 integers and returns the values between them.
CREATE OR ALTER FUNCTION GetTableFromTwoInts(@firstVal int, @secondVal int)
RETURNS TABLE
AS
RETURN
(
	SELECT St_Id, St_Fname, St_Lname
	FROM Student
	WHERE St_Id BETWEEN @firstVal AND @secondVal
)

SELECT * FROM GetTableFromTwoInts(1, 6); -------------------- DONE

-- 3. Create a tabled valued function that takes Student No and returns Department Name with Student full name.
CREATE OR ALTER FUNCTION GetStudentFullNameAndDeptNameFromId(@stNo int)
RETURNS TABLE
AS
RETURN
(
	SELECT d.Dept_Name, CONCAT(s.St_Fname, ' ', s.St_Lname) AS FullName
	FROM Student s INNER JOIN Department d ON s.Dept_Id = d.Dept_Id
	WHERE s.St_Id = @stNo
)

SELECT * FROM GetStudentFullNameAndDeptNameFromId(3); -------------------- DONE

-- 4. Create a scalar function that takes Student ID and returns a message to the user (use Case statement)
-- a. If the first name and Last name are null then display 'First name & last name are null'
-- b. If the First name is null then display 'first name is null'
-- c. If the Last name is null then display 'last name is null'
-- d. Else display 'First name & last name are not null'
CREATE OR ALTER FUNCTION SendMessageToStudent(@stId int)
RETURNS varchar(50)
BEGIN
	DECLARE @firstName varchar(50), @lastName varchar(50), @result varchar(50)
	
	SELECT @firstName = St_Fname, @lastName = St_Lname 
	FROM Student 
	WHERE St_Id = @stId

	SELECT @result = CASE
		WHEN @firstName IS NULL AND @lastName IS NULL THEN 'First name & last name are null'
		WHEN @firstName IS NULL AND @lastName IS NOT NULL THEN 'First name is null'
		WHEN @firstName IS NOT NULL AND @lastName IS NULL THEN 'Last name is null'
		ELSE 'First name & last name are not null'
	END

	RETURN @result
END

SELECT dbo.SendMessageToStudent(15);

/*5.Create a function that takes integer which represents the format of the Manager hiring date
 and displays department name, Manager Name and hiring date with this format*/
create function dateform(@dateformat int)
returns table
as return
(
select d.Dept_Name,i.Ins_Name,convert(date,d.Manager_hiredate,@dateformat)as hiredate from Department d,Instructor i
where d.Dept_Manager=i.Ins_Id
)
select * from dateform(2)

/*6.Create multi-statements table-valued function that takes a string
If string='first name' returns student first name
If string='last name' returns student last name 
If string='full name' returns Full Name from student table 
Note: Use “ISNULL” function
*/
create function getstring(@name varchar(50))
returns @t table(result varchar(50))
as begin

if @name='first name' 
insert into @t
 select isnull(St_Fname,'first name is null') from Student

else if @name='last name' 
insert into @t
select isnull(St_Lname,'last name is null') from Student

else if @name='full name'
insert into @t
select concat(St_Fname,' ',St_Lname)from Student
return
end
select * from dbo.getstring('first name')
select * from dbo.getstring('last name')
select * from dbo.getstring('full name')

/*7.Write a query that returns the Student No and Student first name without the last char*/
select St_Id,
left(St_Fname,len(St_Fname)-1) from Student 
/*8.Write a query that takes the columns list and table name into variables and
 then return the result of this query “Use exec command”*/
 CREATE FUNCTION getstrings(@name VARCHAR(50))
RETURNS @t TABLE (result VARCHAR(50))
AS
BEGIN
    DECLARE @sqlQuery NVARCHAR(MAX);

    IF @name = 'first name'
        SET @sqlQuery = 'INSERT INTO @t SELECT ISNULL(St_Fname, ''first name is null'') FROM Student';
    ELSE IF @name = 'last name'
        SET @sqlQuery = 'INSERT INTO @t SELECT ISNULL(St_Lname, ''last name is null'') FROM Student';
    ELSE IF @name = 'full name'
        SET @sqlQuery = 'INSERT INTO @t SELECT ISNULL(CONCAT(St_Fname, '' '', St_Lname), ''full name is null'') FROM Student';
    ELSE
        RETURN;

    EXEC sp_executesql @sqlQuery;

    RETURN;
END

DECLARE @result TABLE (result VARCHAR(50));

INSERT INTO @result
EXEC('SELECT * FROM dbo.getstring(''first name'')');

SELECT * FROM @result;

INSERT INTO @result
EXEC('SELECT * FROM dbo.getstring(''last name'')');

SELECT * FROM @result;

INSERT INTO @result
EXEC('SELECT * FROM dbo.getstring(''full name'')');

SELECT * FROM @result;

/*Part 2: Use Company DB
1.Create function that takes project number and display all employees in this project
*/
CREATE FUNCTION GetAllEmployeesInProject(@projectNumber int)
RETURNS TABLE
AS
RETURN
(
	SELECT e.*
	FROM Employee e LEFT OUTER JOIN Works_for w ON w.ESSn = e.SSN
	INNER JOIN Project p ON p.Pnumber = w.Pno
	WHERE p.Pnumber = @projectNumber
)
select * from dbo.GetAllEmployeesInProject(100)

/*Bonus:
1.	Create a batch that inserts 3000 rows in the employee table. The values of the emp_no column should be unique and between 1 
and 3000. All values of the columns emp_lname, emp_fname, and dept_no should be set to 'Jane', ' Smith', and ' d1',
 respectively.”USE CompnayDB”
*/
CREATE OR ALTER FUNCTION ComputeIncrementInSalary(@empId int, @salaryAmountIncrease int)
RETURNS @res TABLE (SalaryBefore int, SalaryAfter int, PercentIncrease float)
AS
BEGIN
	DECLARE @salBefore int, @salAfter int, @percentageIncrease float
	
	SELECT @salBefore = Salary FROM Employee WHERE SSN = @empId
	SELECT @salAfter = Salary + @salaryAmountIncrease FROM Employee WHERE SSN = @empId
	SELECT @percentageIncrease = (@salaryAmountIncrease / @salBefore) * 100

	INSERT INTO @res
	VALUES(@salBefore, @salAfter, @percentageIncrease)

	RETURN
END

SELECT * FROM ComputeIncrementInSalary(112233, (SELECT FLOOR(RAND() * (3000 - 1000 + 1)) + 1000));

-- How to Generate Random Numbers between x and y, Where x = 1000, y = 3000
--SELECT FLOOR(RAND() * (3000 - 1000 + 1)) + 1000;



/*2.Give an example for Hierarch id Data type*/
-- Create a table with a hierarchyid column
CREATE TABLE EmployeeHierarchy
(
    EmployeeID INT PRIMARY KEY,
    EmployeeName NVARCHAR(50),
    DepartmentHierarchy HIERARCHYID
);

-- Insert sample data
INSERT INTO EmployeeHierarchy (EmployeeID, EmployeeName, DepartmentHierarchy)
VALUES
    (1, 'CEO', HIERARCHYID::GetRoot()),
    (2, 'CTO', HIERARCHYID::GetRoot().GetDescendant(NULL, NULL)),
    (3, 'CFO', HIERARCHYID::GetRoot().GetDescendant(NULL, NULL)),
    (4, 'Software Manager', HIERARCHYID::GetRoot().GetDescendant(NULL, NULL).GetDescendant(NULL, NULL)),
    (5, 'Finance Manager', HIERARCHYID::GetRoot().GetDescendant(NULL, NULL).GetDescendant(NULL, NULL)),
    (6, 'Software Developer 1', HIERARCHYID::GetRoot().GetDescendant(NULL, NULL).GetDescendant(NULL, NULL).GetDescendant(NULL, NULL)),
    (7, 'Software Developer 2', HIERARCHYID::GetRoot().GetDescendant(NULL, NULL).GetDescendant(NULL, NULL).GetDescendant(NULL, NULL)),
    (8, 'Accountant 1', HIERARCHYID::GetRoot().GetDescendant(NULL, NULL).GetDescendant(NULL, NULL).GetDescendant(NULL, NULL).GetDescendant(NULL, NULL)),
    (9, 'Accountant 2', HIERARCHYID::GetRoot().GetDescendant(NULL, NULL).GetDescendant(NULL, NULL).GetDescendant(NULL, NULL).GetDescendant(NULL, NULL));

-- Retrieve all employees under CTO
SELECT *
FROM EmployeeHierarchy
WHERE DepartmentHierarchy.IsDescendantOf((SELECT DepartmentHierarchy FROM EmployeeHierarchy WHERE EmployeeName = 'CTO')) = 1;
