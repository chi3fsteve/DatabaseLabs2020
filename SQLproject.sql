IF OBJECT_ID('DEBTORS','U') IS NOT NULL
DROP TABLE DEBTORS
IF OBJECT_ID('RESTOCK','U') IS NOT NULL
DROP TABLE RESTOCK
IF OBJECT_ID('TRANSACTIONS','U') IS NOT NULL
DROP TABLE TRANSACTIONS
IF OBJECT_ID('CUSTOMERS','U') IS NOT NULL
DROP TABLE CUSTOMERS
IF OBJECT_ID('PRODUCTS','U') IS NOT NULL
DROP TABLE PRODUCTS
IF OBJECT_ID('EMPLOYEES','U') IS NOT NULL
DROP TABLE EMPLOYEES
IF OBJECT_ID('SECTIONS','U') IS NOT NULL
DROP TABLE SECTIONS
GO

--CREATING TABLES

--sections
IF OBJECT_ID('SECTIONS', 'U') IS NULL
CREATE TABLE SECTIONS(
ID VARCHAR(1) NOT NULL PRIMARY KEY,
Name VARCHAR(30)
)

--employees
IF OBJECT_ID('EMPLOYEES', 'U') IS NULL
CREATE TABLE EMPLOYEES(
ID INT IDENTITY(10,10) NOT NULL PRIMARY KEY,
Name VARCHAR(30),
Position VARCHAR(30),
Salary FLOAT,
Employed DATE,
Section VARCHAR(1) FOREIGN KEY REFERENCES SECTIONS(ID)
)

--products
IF OBJECT_ID('PRODUCTS', 'U') IS NULL
CREATE TABLE PRODUCTS(
ID INT IDENTITY(100,50) NOT NULL PRIMARY KEY,
Name VARCHAR(30),
Price FLOAT,
Cost FLOAT,
Section VARCHAR(1) FOREIGN KEY REFERENCES SECTIONS(ID),
Quantity_in_stock INT,
Max_quantity INT
)

--customers
IF OBJECT_ID('CUSTOMERS', 'U') IS NULL
CREATE TABLE CUSTOMERS(
ID INT IDENTITY(10,10) NOT NULL PRIMARY KEY,
Name VARCHAR(30),
Spent FLOAT,
Last_purchase DATE,
Registered DATE
)

--transactions
IF OBJECT_ID('TRANSACTIONS', 'U') IS NULL
CREATE TABLE TRANSACTIONS(
ID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
Date DATE DEFAULT GETDATE(),
Product INT FOREIGN KEY REFERENCES PRODUCTS(ID),
Quantity INT DEFAULT 1,
Seller INT FOREIGN KEY REFERENCES EMPLOYEES(ID),
Buyer INT FOREIGN KEY REFERENCES CUSTOMERS(ID),
Paid CHAR,
Price FLOAT
)

--debtors
IF OBJECT_ID('DEBTORS', 'U') IS NULL
CREATE TABLE DEBTORS(
ID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
Customer_ID INT FOREIGN KEY REFERENCES CUSTOMERS(ID),
Debt FLOAT
)

--restock
IF OBJECT_ID('RESTOCK', 'U') IS NULL
CREATE TABLE RESTOCK(
ID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
Product_ID INT FOREIGN KEY REFERENCES PRODUCTS(ID),
Amount_needed INT,
Cost FLOAT
)


--INSERING DATA

--Sections
INSERT INTO SECTIONS
VALUES ('A', 'Garden'),
('B', 'Bathroom'),
('C', 'Kitchen'),
('D', 'Materials'),
('E', 'Tools'),
('F', 'Counters'),
('M', 'Management')

--Employees
INSERT INTO EMPLOYEES (Name, Position, Salary, Employed, Section) VALUES
('ADAMCZYK','Manager',4500.00,'2001-04-16','M'),
('ORZECHOWSKA','Cashier',2100.00,'2007-10-28','F'),
('SASIM','Cashier',2100.00 ,'2005-11-08','F'),
('KOREPTA','Cashier',2100.00 ,'2007-10-22','F'),
('OLSZEWSKA', 'Salesman',2500.00, '2002-09-01', 'A'),
('SMOLAREK','Salesman',2500.00,'2010-03-13','B'),
('NOWAK','Salesman',2500.00,'2012-05-14','C'),
('MIKULSKI','Salesman',2700.00,'2019-07-20','D'),
('MALINOWSKI','Salesman',2700.00,'2013-04-19','E')

--Products
INSERT INTO PRODUCTS (Name, Price, Cost, Section, Quantity_in_stock, Max_quantity) VALUES
('Lawn mower',500,380,'A',29,50),
('String trimmer',400,320,'A',74,100),
('Shovel',59.99,35,'A',120,300),
('Hand shovel',29.99,10,'A',160,300),
('Rake',39.99,30,'A',158,300),
('Secateur',19.99,12,'A',29,200),
('Bathtub',2200,1500,'B',50,50),
('Bathroom sink',300,190,'B',15,50),
('Washing machine',1100,920,'B',49,50),
('Kitchen sink',320,210,'C',30,50),
('Oven',920,830,'C',92,100),
('Cupboard',500,420,'C',33,50),
('Brick',5.20,3.50,'D',3200,5000),
('Cement 5kg',24.99,21,'D',520,600),
('Paint 2,5l',49.99,39,'D',320,1000),
('Drill',189,110,'E',80,100),
('Ladder',289,250,'E',32,100),
('Yardstick',20,13,'E',99,200)

--Customers
INSERT INTO CUSTOMERS (Name, Registered) VALUES
('TOMBUD S.A.', '2010-03-13'),
('MIREX SP. Z.O.O.', '2003-04-03'),
('KANTECH', '2005-12-19'),
('ROBOKOP','2008-03-01'),
('ATOMIG','2009-01-05'),
('USUS','2011-02-23'),
('KRYSTALEX','2002-03-09'),
('UNITEX','2012-06-27'),
('MIXUS','2009-03-17'),
('WUNITEK','2010-05-13'),
('UNMUT','2005-02-19'),
('LIFTEX','2006-08-23')

--Transactions
INSERT INTO TRANSACTIONS (Date, Product, Quantity, Seller, Buyer, Paid) VALUES
('2010-03-13', 100, 4, 20, 10, 'Y'),
('2005-06-13', 150, 6, 30, 20, 'Y'),
('2011-07-13', 200, 2, 40, 30, 'N'),
('2010-08-13', 250, 1, 20, 40, 'N'),
('2011-09-13', 300, 9, 30, 50, 'Y'),
('2012-10-13', 350, 7, 40, 60, 'Y'),
('2006-11-13', 400, 12, 20, 70, 'N'),
('2005-12-13', 450, 19, 30, 80, 'Y'),
('2007-01-13', 500, 16, 40, 90, 'Y'),
('2010-03-19', 550, 2, 20, 100, 'N'),
('2005-12-13', 600, 19, 30, 110, 'Y'),
('2007-01-13', 650, 16, 40, 120, 'N'),
('2010-03-19', 550, 2, 20, 10, 'N'),
('2005-12-13', 600, 7, 30, 20, 'Y'),
('2007-01-13', 650, 6, 40, 30, 'Y'),
('2012-03-19', 700, 2, 20, 40, 'N'),
('2019-12-13', 750, 9, 30, 50, 'N'),
('2019-01-13', 800, 16, 40, 60, 'Y'),
('2010-03-19', 850, 8, 20, 70, 'N'),
('2005-12-13', 900, 9, 30, 80, 'Y'),
('2007-01-13', 950, 6, 40, 90, 'Y'),
('2019-03-19', 100, 21, 20, 100, 'N'),
('2019-12-13', 150, 19, 30, 110, 'Y'),
('2019-01-13', 200, 16, 40, 120, 'Y'),
('2019-05-17', 250, 19, 20, 10, 'N'),
('2019-10-15', 300, 1, 30, 20, 'N'),
('2009-02-10', 350, 6, 40, 20, 'Y')

--Update Transactions table with transaction value based on Products table
UPDATE TRANSACTIONS
SET TRANSACTIONS.Price = P.Price * T.Quantity
FROM TRANSACTIONS T
INNER JOIN PRODUCTS P ON T.Product=P.ID

--Update Customers table with last purchase date and total money spent in the store based on Transactions table 
UPDATE CUSTOMERS
SET Last_purchase = F.Last_date , Spent = F.TotalSpent
FROM (SELECT C.ID, MAX(T.Date) AS Last_date, SUM(T.Price) AS TotalSpent FROM TRANSACTIONS T
INNER JOIN CUSTOMERS C ON C.ID=T.Buyer
GROUP BY C.ID) F
WHERE F.ID = CUSTOMERS.ID

--Debtors; Inserting values into table based on transactions table
INSERT INTO DEBTORS (Customer_ID, Debt)
SELECT Buyer, SUM(Price) AS Debt FROM TRANSACTIONS WHERE Paid = 'N' GROUP BY Buyer

--Restock; Inserting values into table based on products table
INSERT INTO RESTOCK (Product_ID, Amount_needed, Cost)
SELECT ID, Max_quantity-Quantity_in_stock, Cost*(Max_quantity-Quantity_in_stock) FROM PRODUCTS WHERE Quantity_in_stock<Max_quantity

--VIEWS

--What are the products that bring company the most profits?
IF OBJECT_ID('TopProducts','V') IS NOT NULL
DROP VIEW TopProducts
GO

CREATE VIEW TopProducts AS (
SELECT TOP 5 P.Name, SUM(T.Price-P.Cost*T.Quantity) AS TotalEarned FROM PRODUCTS P
INNER JOIN TRANSACTIONS T ON T.Product = P.ID
GROUP BY P.Name
ORDER BY TotalEarned DESC
)
GO

--What are the categories that bring company the most profits?
IF OBJECT_ID('TopCategory','V') IS NOT NULL
DROP VIEW TopCategory
GO

CREATE VIEW TopCategory AS (
SELECT TOP 5 S.Name, SUM(T.Price-P.Cost*T.Quantity) AS Profit FROM PRODUCTS P
INNER JOIN SECTIONS S ON P.Section=S.ID
INNER JOIN TRANSACTIONS T ON T.Product = P.ID
GROUP BY S.Name
ORDER BY Profit DESC
)
GO

--Which customers visit store the most?
IF OBJECT_ID('TopVisitors','V') IS NOT NULL
DROP VIEW TopVisitors
GO

CREATE VIEW TopVisitors AS (
SELECT TOP 5 C.Name, COUNT(T.ID) AS NumberOfVisits FROM CUSTOMERS C
INNER JOIN TRANSACTIONS T ON C.ID=T.Buyer
GROUP BY C.Name
ORDER BY NumberOfVisits DESC
)
GO

--Average moneyspent by customer
IF OBJECT_ID('AvgMoneySpent', 'P') IS NOT NULL
DROP PROCEDURE AvgMoneySpent
GO

CREATE PROCEDURE AvgMoneySpent (
@name VARCHAR (20)
) AS (
SELECT @name AS Customer, AVG(T.Price) AS AverageSpent 
FROM CUSTOMERS C LEFT JOIN TRANSACTIONS T ON C.ID=T.Buyer
WHERE C.name = @name
)
GO

--Select debtors with debt bigger then (number)
IF OBJECT_ID('TopDebtors', 'P') IS NOT NULL
DROP PROCEDURE TopDebtors
GO

CREATE PROCEDURE TopDebtors (
@debt_number INT
) AS
SELECT C.Name, D.Debt FROM DEBTORS D
INNER JOIN CUSTOMERS C ON D.Customer_ID=C.ID
WHERE D.Debt>@debt_number
ORDER BY D.Debt DESC
GO

--REPORTS
PRINT 'Products that bring company the most profits'
SELECT * FROM TopProducts

PRINT 'Categories that bring company the most profits'
SELECT * FROM TopCategory

PRINT 'Customers that visit store the most'
SELECT * FROM TopVisitors

PRINT 'Average money spent by customer (MIREX SP. Z.O.O.)'
EXEC AvgMoneySpent'MIREX SP. Z.O.O.';

PRINT 'Debtors with debt bigger then 1000'
EXEC TopDebtors '1000'