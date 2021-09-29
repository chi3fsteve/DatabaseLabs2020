--1
IF OBJECT_ID('Staff', 'U') IS NOT NULL
DROP TABLE Staff
GO
SELECT * INTO Staff FROM Employees
GO

--2
IF OBJECT_ID('FOREMEN','V') IS NOT NULL DROP VIEW FOREMEN
GO
CREATE VIEW FOREMEN AS
SELECT ID, Name, Salary_base, Years_of_employment=DATEDIFF(year, Employed, GETDATE())
FROM Staff
GO

--3
IF OBJECT_ID('SALARIES','V') IS NOT NULL DROP VIEW SALARIES
GO
CREATE VIEW SALARIES AS
SELECT Branch, Average=AVG(Salary_base+ISNULL(Salary_extra, 0)), Salary_min=MIN(Salary_base+ISNULL(Salary_extra, 0)),
		Salary_max=MAX(Salary_base+ISNULL(Salary_extra, 0)), Fund=SUM(Salary_base+ISNULL(Salary_extra, 0)),
		Qty_salary_base=COUNT(Salary_base), Qty_salary_ext=COUNT(Salary_extra)
FROM Staff
GROUP BY Branch
GO

SELECT a.Name, a.Salary_base, b.Average
FROM Staff a
INNER JOIN (SELECT Branch, Average FROM SALARIES) b ON a.Branch=b.Branch
WHERE a.Salary_base<b.Average
GO

--4
IF OBJECT_ID('SALARIES_BASE','V') IS NOT NULL DROP VIEW SALARIES_BASE
GO
CREATE VIEW SALARIES_BASE AS
SELECT Branch, Name, Salary_base
FROM Staff
WHERE Salary_base IN
(SELECT MAX(Salary_base) FROM Staff GROUP BY Branch)
GO

--5
IF OBJECT_ID('SALARIES_MIN','V') IS NOT NULL DROP VIEW SALARIES_MIN
GO
CREATE VIEW SALARIES_MIN AS
SELECT Branch, Name, Salary_base
FROM Staff
WHERE Salary_base<1500
WITH CHECK OPTION;
GO

--6
UPDATE SALARIES_MIN
SET Salary_base = 1700
WHERE Name = 'URBANIAK'

--7
IF OBJECT_ID('EARNINGS','V') IS NOT NULL DROP VIEW EARNINGS
GO
CREATE VIEW EARNINGS WITH ENCRYPTION AS
SELECT A.ID, A.Name, A.Salary_base, A.Boss, Boss_name=B.Name, Boss_salary=B.Salary_base
FROM Staff A
INNER JOIN Staff B ON A.Boss=B.ID
GO
