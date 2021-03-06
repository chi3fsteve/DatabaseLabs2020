--1
IF OBJECT_ID('CLASSES','U') IS NOT NULL
DROP TABLE CLASSES
IF OBJECT_ID('TEACHERS','U') IS NOT NULL
DROP TABLE TEACHERS
IF OBJECT_ID('SCHOOLS','U') IS NOT NULL
DROP TABLE SCHOOLS
IF OBJECT_ID('STAFF','U') IS NOT NULL
DROP TABLE STAFF
IF OBJECT_ID('POSTS','U') IS NOT NULL
DROP TABLE POSTS
IF OBJECT_ID('AFFILIATES','U') IS NOT NULL
DROP TABLE AFFILIATES
GO

--2
IF OBJECT_ID('SCHOOLS', 'U') IS NULL
CREATE TABLE SCHOOLS(
ID_school INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
Name VARCHAR(30),
City VARCHAR(30))

--3
IF OBJECT_ID('TEACHERS', 'U') IS NULL
CREATE TABLE TEACHERS(
ID_teacher INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
LastName VARCHAR(30),
FirstName VARCHAR(30),
BirthDay DATE,
Rate TINYINT)

--4
IF OBJECT_ID('CLASSES', 'U') IS NULL
CREATE TABLE CLASSES(
ID_class INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
Name VARCHAR(30),
ID_school INT FOREIGN KEY REFERENCES SCHOOLS(ID_school),
ID_teacher INT FOREIGN KEY REFERENCES TEACHERS(ID_teacher))

--5
IF OBJECT_ID('AFFILIATES', 'U') IS NULL
CREATE TABLE AFFILIATES(
ID_aff INT NOT NULL PRIMARY KEY,
Name VARCHAR(30),
Address VARCHAR(30))

--6
IF OBJECT_ID('POSTS', 'U') IS NULL
CREATE TABLE POSTS(
ID_post VARCHAR(30) NOT NULL PRIMARY KEY,
Salary_min FLOAT,
Salary_max FLOAT,
CHECK (Salary_max > Salary_min))

--7
IF OBJECT_ID('STAFF', 'U') IS NULL
CREATE TABLE STAFF(
ID_empl INT NOT NULL PRIMARY KEY,
LastName VARCHAR(30),
ID_post VARCHAR(30) FOREIGN KEY REFERENCES POSTS(ID_post),
Chief VARCHAR(30),
Empl_date DATE,
ID_aff INT FOREIGN KEY REFERENCES AFFILIATES(ID_aff))

--8
IF OBJECT_ID('AFFILIATES', 'U') IS NOT NULL
	IF COL_LENGTH('AFFILIATES', 'PostCode') IS NULL
		ALTER TABLE AFFILIATES ADD PostCode VARCHAR(6)

--9
IF OBJECT_ID('STAFF', 'U') IS NOT NULL
	IF COL_LENGTH('STAFF', 'Pesel') IS NULL
		ALTER TABLE STAFF ADD Pesel VARCHAR(11)

--10
IF OBJECT_ID('STAFF','U') IS NOT NULL
	IF COL_LENGTH('STAFF','Pesel') IS NOT NULL
		IF OBJECT_ID('CT_Pesel','C') IS NULL
			ALTER TABLE STAFF ADD CONSTRAINT CT_Pesel 
			CHECK (Pesel LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')

--11
IF OBJECT_ID('STAFF','U') IS NOT NULL 
	IF COL_LENGTH('STAFF','PostCode') IS NOT NULL
	ALTER TABLE STAFF DROP PostCode

--12
INSERT INTO AFFILIATES (ID_aff, Name, Address)
SELECT ID, Name, Addr FROM BRANCHES
INSERT INTO POSTS (ID_post, Salary_min, Salary_max)
SELECT Position, Salary_min,Salary_max FROM POSITIONS
INSERT INTO STAFF (ID_empl, LastName, ID_post, Chief, Empl_date, ID_aff)
SELECT ID, Name, Position, Boss, Employed, Branch FROM EMPLOYEES