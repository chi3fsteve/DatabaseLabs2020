IF OBJECT_ID('Staff') IS NOT NULL DROP TABLE Staff
SELECT * INTO Staff FROM dbo.Employees

--01
UPDATE Staff
SET Salary_base = 1600
WHERE ID = 170

--02
UPDATE Staff
SET Employed = DATEADD(month,1,Employed), Branch = 10
WHERE Name = 'ZABLOCKI' OR Name = 'KOPROWSKI'

--03
INSERT INTO Staff
VALUES (240, 'ADAMIAK', 'PRAKTYKANT', 120, '1994-04-16', 910.50, NULL, 20), 
(250, 'ZIELINSKI', 'BRYGADZISTA', 110, '1994-04-16', 910.50, NULL, 20)

--04
UPDATE Staff
SET Salary_base = Salary_base + (Average/10)
FROM Staff s
INNER JOIN (SELECT Branch, Average=AVG(Salary_base) FROM Staff GROUP BY Branch) z ON z.Branch = s.Branch

--5
UPDATE Staff
SET Salary_extra = (SELECT Average=AVG(Salary_base) FROM Staff WHERE Boss = 130)
WHERE Branch = 20

--6
UPDATE Staff
SET Salary_base =(SELECT Average=AVG(Salary_base) FROM Staff)
WHERE ID IN (SELECT ID FROM Staff WHERE Salary_base = (SELECT MIN(Salary_base) FROM Staff))
--7
UPDATE Staff
SET Salary_base = Salary_base*1.15
WHERE ID IN (SELECT ID FROM Staff WHERE DATEDIFF(year, Employed, GETDATE())>10)

--8
DELETE FROM Staff
WHERE ID IN (SELECT ID FROM Staff WHERE Branch = 10)

--9
DELETE FROM Staff
WHERE ID IN (SELECT ID FROM Staff WHERE Boss = 100 AND (Name = 'BRZEZINSKI' OR Name = 'MALINOWSKI'))
