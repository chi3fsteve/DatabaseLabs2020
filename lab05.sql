--1
SELECT a.Name, a.Position, a.Branch, b.Name AS BranchName
FROM Employees a
INNER JOIN Branches b ON a.Branch = b.ID
ORDER BY Name

--2
SELECT a.Name, a.Position, a.Branch, b.Name AS BranchName
FROM Employees a
INNER JOIN Branches b ON a.Branch = b.ID
WHERE b.Name='WARSZAWA'
ORDER BY Name

--3
SELECT a.Name, b.Name AS BranchName,b.Addr AS BranchAddr, a.Position, a.Salary_base AS Salary
FROM Employees a
INNER JOIN Branches b ON a.Branch = b.ID
WHERE a.Salary_base>2500
ORDER BY Salary

--4
SELECT a.Name, a.Position, a.Salary_base, b.Salary_min, b.Salary_max
FROM Employees a
INNER JOIN Positions b ON a.Position = b.Position

--5
SELECT a.Name, a.Position, a.Salary_base, b.Salary_min, b.Salary_max
FROM Employees a
INNER JOIN Positions b ON a.Position = b.Position
WHERE Salary_base<Salary_min OR Salary_base>Salary_max

--6
SELECT a.Name, a.Position, b.Name AS BranchName, a.Salary_base
FROM Employees a
INNER JOIN Branches b ON a.Branch = b.ID
WHERE Position!='PRAKTYKANT'
ORDER BY Salary_base DESC

--7
SELECT a.Name, a.Position, b.Name AS BranchName, a.Salary_base*12 AS Min_annual_salary
FROM Employees a
INNER JOIN Branches b ON a.Branch = b.ID
WHERE a.Salary_base*12>15000
ORDER BY Name

--8
SELECT a.ID, a.Name, a.Boss, b.Name AS Boss_name
FROM Employees a
INNER JOIN Employees b ON a.Boss = b.ID

--9
SELECT a.ID, a.Name, CASE WHEN ISNULL(a.Boss,'')=0 THEN '' END AS Boss, ISNULL(b.Name,'') AS Boss_name
FROM Employees a
LEFT OUTER JOIN Employees b ON a.Boss = b.ID

--10
SELECT a.ID, a.Name, COUNT(b.ID) AS Total_empl, AVG(b.Salary_base) AS Average_salary
FROM Branches a
INNER JOIN Employees b ON b.Branch = a.ID
GROUP BY a.ID, a.Name

--11
SELECT b.Name, COUNT(a.Boss) AS Number
FROM Employees a
RIGHT OUTER JOIN Employees b ON a.Boss = b.ID
GROUP BY b.Name
HAVING COUNT(a.Boss)!=0
ORDER BY Number DESC

--12
SELECT a.Name, a.Employed, b.Name AS Boss_name, b.Employed AS Boss_employed, DATEDIFF(month,b.Employed,a.Employed) AS Month_diff
FROM Employees a
INNER JOIN Employees b ON a.Boss = b.ID
WHERE DATEDIFF(day,b.Employed,a.Employed)<3650

--13
SELECT Name, Employed
FROM Employees
WHERE YEAR(Employed)=1992
UNION
SELECT Name, Employed
FROM Employees
WHERE YEAR(Employed)=1993

--14
SELECT Name, Employed
FROM Employees
WHERE YEAR(Employed)=1992 OR YEAR(Employed)=1993

--15
SELECT ID
FROM Branches
EXCEPT
SELECT Branch
FROM Employees
GROUP BY Branch

--16
SELECT a.ID
FROM Branches a
LEFT JOIN Employees b ON a.ID = b.Branch
WHERE b.Branch IS NULL