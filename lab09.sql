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
GO
CREATE VIEW SALARIES AS
SELECT Branch, Average=AVG(Salary_base+ISNULL(Salary_extra, 0)), Salary_min=MIN(Salary_base+ISNULL(Salary_extra, 0)),
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