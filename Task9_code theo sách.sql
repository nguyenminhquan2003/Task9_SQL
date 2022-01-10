USE AdventureWorks2019
GO
--Ex1
CREATE VIEW vwProductInfo AS
SELECT ProductID,ProductNumber,Name,SafetyStockLevel
FROM Production.Product;
GO
--Ex2
SELECT * FROM vwProductInfo
GO
--Ex3
CREATE VIEW vwPersonDetails AS
SELECT p.Title, p.FirstName, p.MiddleName, p.LastName, e.JobTitle
FROM HumanResources.Employee e
INNER JOIN Person.Person p ON p.BusinessEntityID = e.BusinessEntityID
GO
--Ex4
SELECT * FROM vwPersonDetails
--Ex5
CREATE VIEW vwPersonDetailsNew AS
SELECT COALESCE(p.Title,'')AS Title, 
p.FirstName, 
COALESCE(p.MiddleName,'')AS MiddleName,
p.LastName, e.JobTitle
FROM HumanResources.Employee e
INNER JOIN Person.Person p ON p.BusinessEntityID = e.BusinessEntityID
GO

SELECT * FROM vwPersonDetailsNew

--Ex6
CREATE VIEW vwSortedPersonDetails AS
SELECT TOP 10  COALESCE(p.Title,'')AS Title, 
p.FirstName, 
COALESCE(p.MiddleName,'')AS MiddleName,
p.LastName, e.JobTitle
FROM HumanResources.Employee e
INNER JOIN Person.Person p ON p.BusinessEntityID = e.BusinessEntityID
GO

SELECT * FROM vwSortedPersonDetails
GO
--Ex7
CREATE TABLE Employee_Personal_Details (
   EmpID int NOT NULL,
   FirstName varchar(30) NOT NULL,
   LastName varchar(30) NOT NULL,
   Address varchar(30)
)
GO
--Ex8
CREATE TABLE Employee_Salary_Details(
   EmpID int NOT NULL,
   Designation varchar(30),
   Salary int NOT NULL
)
GO
--Ex9
CREATE VIEW vwEmployee_Personal_Details
AS
SELECT e1.EmpID, FirstName, LastName, Designation, Salary
FROM Employee_Personal_Details e1
JOIN Employee_Salary_Details e2
ON e1.EmpID=e2.EmpID
GO
--Ex10
INSERT INTO vwEmployee_Personal_Details VALUES(2,'Jack','Wilson','Software Developer',16000)
GO
--Ex11
CREATE VIEW vwEmpDetails AS
SELECT FirstName, Address
FROM Employee_Personal_Details
GO
--Ex12
INSERT INTO vwEmpDetails VALUES ('Jack','NYC')
GO
--Ex13
CREATE TABLE Product_Details(
   ProductID int,
   ProductName varchar(30),
   Rate money
)
GO
--Ex14
CREATE VIEW vwProduct_Details AS
SELECT ProductName, Rate FROM Product_Details
GO
--Ex15
UPDATE vwProduct_Details SET Rate = 3000
WHERE ProductName='DVD Writer'
GO
--Ex16
CREATE VIEW vwProduct_Details AS
SELECT ProductName, Description, Rate 
FROM Product_Details
GO
--Ex17
UPDATE vwProduct_Details SET Description.WRITE(N'EX',0,2)
WHERE ProductName='PortableHardDrive'
GO
--Ex18
DELETE FROM vwCustDetails WHERE CustID = 'C0004'
GO
--Ex19
ALTER VIEW vwProductInfo AS
SELECT ProductID, ProductNumber, Name, SafetyStockLevel, ReOrderPoint
FROM Production.Product
GO
--Ex20
DROP VIEW vwProductInfo
GO
--Ex21
EXEC sp_helptext vwEmployee_Personal_Details
GO
--Ex22
CREATE VIEW vwProduct_Details AS
SELECT ProductName, AVG(Rate) AS
AverageRate FROM Product_Details 
GROUP BY ProductName
GO
--Ex23
CREATE VIEW vwProductInfo AS
SELECT ProductID, ProducNumber, Name, SafetyStockLevel, ReOrderPoint
FROM Production.Product
WHERE SafetyStockLevel <= 1000
WITH CHECK OPTION
GO
--Ex24
UPDATE vwProductInfo SET SafetyStockLevel=2500
WHERE ProductID = 321
GO
--Ex25
CREATE VIEW vwNewProductInfo WITH SCHEMABINDING AS
SELECT ProductID, ProductNumber, Name, SafetyStockLevel
FROM Production.Product
GO
--Ex26
CREATE TABLE Customers(
   CustID int,
   CustName varchar(50),
   Address varchar(60)
)
GO
--Ex27
CREATE VIEW vwCustomers AS
SELECT * FROM Customers
GO
--Ex28
SELECT * FROM vwCustomers
GO
--Ex29
ALTER TABLE Customers ADD Age int
GO
--Ex30
SELECT * FROM vwCustomers
GO
--Ex31
EXEC sp_refreshview'vwCustomers'
GO
--Ex32
ALTER TABLE Production.Product ALTER COLUMN ProductID varchar(7)
GO
--Ex33
EXECUTE xp_fileexist 'c:\MyTest.txt\'
GO
--Ex34
CREATE PROCEDURE uspGetCustTerritory
AS
SELECT TOP 10 CustomerID,Customer.TerritoryID,Sales.SalesTerritory.Name
FROM Sales.Customer JOIN Sales.SalesTerritory ON Sales.Customer.TerritoryID=
Sales.SalesTerritory.TerritoryID
GO
--Ex35
EXEC uspGetCustTerritory
GO
--Ex36
CREATE PROCEDURE uspGetSales 
   @Territory varchar(40) 
AS
SELECT BusinessEntityID, B.SalesYTD, B.SalesLastYear 
FROM Sales.SalesPerson A
JOIN Sales.SalesTerritory B
ON A.TerritoryID=B.TerritoryID 
WHERE B.Name = @Territory;
EXEC uspGetSales 'Northwest'
GO
--Ex37
CREATE PROCEDURE uspGetTotalSales
   @Territory varchar(40),
   @sum int OUTPUT AS
SELECT @sum=SUM(B.SalesYTD) 
FROM Sales.SalesPerson A
JOIN Sales.SalesTerritory B
ON A.TerritoryID = B.TerritoryID
WHERE B.Name = @Territory
GO
--Ex38
DECLARE @sumsalesmoney 
EXEC uspGetTotalSales 'Northwest', @sumsales OUTPUT
PRINT 'The year-to-date sales figure for this territory is' +convert(varchar(100), @sumsales);
GO
--Ex39
ALTER PROCEDURE [dbo].[uspGetTotals]
   @territory varchar=40
AS
   SElECT BusinessEntityID, B.SalesYTD, B.CostYTD, B.SalesLastYear FROM
   Sales.SalesPerson A JOIN Sales.SalesTerritory B
   ON A.TerritoryID = B.TerritoryID
   WHERE B.Name = @territory
GO
--Ex40
DROP PROCEDURE uspGetTotals
GO
--Ex41
CREATE PROCEDURE NestedProcedure AS
BEGIN
EXEC uspGetCustTerritory
EXEC uspGetSales 'France'
END
GO
--Ex42
SELECT name, object_id, type, type_desc
FROM sys.tables;
--Ex43
SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES
GO
--Ex44
SELECT SERVERPROPERTY('EDITION') AS EditionName;
GO
--Ex45
SELECT session_id, login_time, program_name FROM sys.dm_exec_sessions
WHERE login_name = 'sa' and is_user_process = 1;
GO