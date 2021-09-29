--1
SELECT MIN(Salary_base) AS Minimum, MAX(Salary_base) AS Maximum, MAX(Salary_base)-MIN(Salary_base) AS Difference
FROM Employees

--2
SELECT Position, AVG(Salary_base) AS Average
FROM Employees
GROUP BY Position

--3
SELECT COUNT(Position) AS Managers
FROM Employees
WHERE Position='KIEROWNIK'

--4
SELECT Branch, SUM(Salary_base)+SUM(Salary_extra) AS Total_salary
FROM Employees
GROUP BY Branch

--5
SELECT TOP 1 SUM(Salary_base)+SUM(Salary_extra) AS Max_total_salary
FROM Employees
GROUP BY Branch
ORDER BY Max_total_salary DESC

--6
SELECT Boss, MIN(Salary_base+ISNULL(Salary_extra,0)) AS Min_salary
FROM Employees
GROUP BY Boss
ORDER BY Min_salary DESC

--7
SELECT Branch, COUNT(ID) AS Total_employees
FROM Employees
GROUP BY Branch
ORDER BY Total_employees DESC

--8
SELECT Branch, COUNT(ID) AS Total_employees
FROM Employees
GROUP BY Branch
HAVING COUNT(ID)>3
ORDER BY Total_employees DESC

--9
SELECT ID, COUNT(ID)
FROM Employees
GROUP BY ID
HAVING COUNT(ID)>1

--10
SELECT Position, AVG(Salary_base+ISNULL(Salary_extra, 0)) AS Average, COUNT(ID) AS Total_employees
FROM Employees
GROUP BY Position

--11
SELECT Branch, Position, ROUND(AVG(Salary_base+ISNULL(Salary_extra, 0)),0) AS Average, MAX(Salary_base+ISNULL(Salary_extra, 0)) AS Maximum
FROM Employees
WHERE Position='BRYGADZISTA' OR Position='KIEROWNIK'
GROUP BY Branch, Position

--12
SELECT YEAR(Employed) AS Year, COUNT(ID) AS Hired_employees
FROM Employees
GROUP BY YEAR(Employed)

--13
SELECT LEN(Name) AS How_many_letters, COUNT(LEN(Name)) AS How_many_names
FROM Employees
GROUP BY LEN(Name)

--14
SELECT SUM(CASE WHEN CHARINDEX('A',Name)!=0 THEN 1 END) AS Names_with_A, SUM(CASE WHEN CHARINDEX('E',Name)!=0 THEN 1 END) AS Names_with_E
FROM Employees