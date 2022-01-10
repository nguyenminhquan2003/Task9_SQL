Use AdventureWorks2019
GO

Create Procedure sp_DisplayEmployeesHireYear
   @HireYear int
As
Select * From HumanResources.Employee
Where DATEPART(yy,HireDate)=@HireYear
GO

Execute sp_DisplayEmployeesHireYear 2009
GO

Create Procedure sp_EmployeesHireYearCount
   @HireYear int,
   @Count int Output
As
Select @Count=Count(*) From HumanResources.Employee
Where DATEPART(yy,HireDate)=@HireYear
GO

Declare @Number int 
Execute sp_EmployeesHireYearCount 2009, @Number Output
Print @Number
GO

Create Procedure sp_EmployeesHireYearCount2
   @HireYear int
As
Declare @Count int 
Select @Count=Count(*) From HumanResources.Employee
Where DATEPART(yy,HireDate)=@HireYear
Return @Count
GO

Declare @Number int 
Execute @Number = sp_EmployeesHireYearCount2 2009
Print @Number
GO

--Tạo bảng tạm #Student
Create Table #Students(
   RollNo varchar(6) Constraint PK_Students Primary Key,
   FullName nvarchar(100),
   Birthday datetime Constraint DF_StudentsBirthday Default Dateadd(yy,-18,Getdate())
)
GO

--Tạo thủ tục lưu trữ tạm để chèn dữ liệu vào bảng tạm
Create Procedure #spInsertStudents 
   @RollNo varchar(6),
   @FullName nvarchar(100),
   @Birthday datetime
As Begin
   If(@Birthday is NULL)
     Set @Birthday=Dateadd(yy,-18,GETDATE())
   Insert into #Students(RollNo,FullName,Birthday)
      Values (@RollNo,@FullName,@Birthday)
End
GO

--Sử dụng thủ tục lưu trũ đề chèn dữ liệu vào bảng tạm
Exec #spStudents 'A12345', 'abc', NULL
Exec #spStudents 'A54321', 'bcd', '2010/9/1'
Select * From #Students
GO

--Tạo một thủ tục chuỗi sẵn 
Create Procedure sp_DisplayEmployees As
Select * From HumanResources.Employee
Where Gender = 'F'
GO

--Thay đổi thủ tục lưu trử sp_DisplayEmployee
Alter Procedure sp_DisplayEmployees As
Select * From HumanResources.Employee
Where Gender = 'F'
GO

--Chạy thủ tục lưu trữ sp_DisplayEmployee
Exec sp_DisplayEmployees
GO

