--1
SELECT Name, Position, Branch
FROM Employees
WHERE Branch IN (SELECT Branch FROM Employees WHERE Name = 'KOWAL')

--2
SELECT Name, Position, Employed
FROM Employees
WHERE Employed = (SELECT MIN(Employed) FROM Employees WHERE Position = 'KIEROWNIK')

--3
SELECT e.Branch, e.Name, e.Employed 
FROM Employees e
INNER JOIN (SELECT Branch, MinEmpl = MIN(Employed) 
			FROM Employees GROUP BY Branch) a ON a.Branch=e.Branch
WHERE e.Employed=a.MinEmpl

--4
SELECT b.ID, b.Name
FROM Branches b
LEFT JOIN (SELECT DISTINCT Branch FROM Employees) a ON b.ID=a.Branch 
WHERE a.Branch IS NULL

--5
SELECT e.Name,e.Position, e.Salary_base, a.Average
FROM Employees e
INNER JOIN (SELECT Position, Average =AVG(Salary_base) 
			FROM Employees GROUP BY Position) a ON e.Position= a.Position
WHERE e.Salary_base > a.Average

--6
SELECT e.Name, e.Position, e.Salary_base, e.Boss, b.Salary_base
FROM Employees e
INNER JOIN (SELECT ID, Name, Position, Salary_base FROM Employees) b ON e.Boss = b.ID AND e.Salary_base > b.Salary_base*0.75

--7
SELECT e.Name, e.Position
FROM Employees e
WHERE e.ID NOT IN (SELECT ID FROM Employees WHERE Position='PRAKTYKANT') AND e.Position = 'KIEROWNIK'

--8
SELECT b.ID, b.Name
FROM Branches b
WHERE NOT EXISTS (SELECT Branch, count(*) FROM Employees WHERE Branch=b.ID GROUP BY Branch)

--9
SELECT a.Branch, b.Name, a.Salary
FROM (SELECT Branch, Salary=SUM(Salary_base+ISNULL(Salary_extra,0)) FROM Employees GROUP BY Branch) a
INNER JOIN(SELECT ID, Name FROM Branches) b ON a.Branch=b.ID
ORDER BY Salary DESC

--10
SELECT x.Year, x.Number
FROM (SELECT Year=YEAR(Employed), Number=COUNT(ID) FROM Employees GROUP BY YEAR(Employed)) x

--11
SELECT TOP 1 x.Year, x.Number
FROM (SELECT Year=YEAR(Employed), Number=COUNT(ID) FROM Employees GROUP BY YEAR(Employed)) x
ORDER BY x.Number DESC

--12
SELECT a.Name, a.Position, a.Salary_base, b.Average
FROM Employees a
INNER JOIN (SELECT Position, Average=AVG(Salary_base) FROM Employees GROUP BY Position) b ON a.Position=b.Position
WHERE a.Salary_base<b.Average

--13
SELECT a.Name, b.Subordinates, c.Branch
FROM Employees a
LEFT JOIN (SELECT Boss, Subordinates=COUNT(Boss) FROM Employees GROUP BY Boss) b ON a.ID=b.Boss
INNER JOIN (SELECT ID, Branch=Name FROM Branches) c ON a.Branch=c.ID
WHERE b.Subordinates IS NOT NULL

--14
SELECT a.Name, a.Branch,c.Name, b.Average, b.Maximum
FROM Employees a
INNER JOIN (SELECT Branch, Average=AVG(Salary_base), Maximum=MAX(Salary_base) FROM Employees GROUP BY Branch) b ON a.Branch=b.Branch
INNER JOIN (SELECT ID, Name FROM Branches) c ON a.Branch=c.ID
WHERE a.Position='KIEROWNIK'

--15
SELECT b.ID, b.Name, b.Boss, Boss_direct_level=1
FROM (SELECT ID, Name FROM Employees) a
INNER JOIN (SELECT ID, Boss, Name FROM Employees) b ON a.ID=b.Boss
WHERE a.Name='BRZEZINSKI'
UNION
SELECT b.ID, b.Name, b.Boss, Boss_direct_level=2
FROM (SELECT ID, Name FROM Employees) a
INNER JOIN (SELECT ID, Boss, Name FROM Employees) b ON a.ID=b.Boss
WHERE a.Name IN (SELECT Name FROM Employees WHERE ID IN (SELECT ID FROM Employees WHERE Boss IN (SELECT ID FROM Employees WHERE Name='BRZEZINSKI')))