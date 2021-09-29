--1
IF OBJECT_ID('Staff','U') IS NOT NULL
DROP TABLE Staff
GO
SELECT * INTO Staff
FROM Employees
GO

--2,3
IF OBJECT_ID('Raise','P') IS NOT NULL
DROP PROCEDURE Raise
GO
CREATE PROCEDURE Raise (
@Branch INT,
@Percentage INT = 15)
AS
IF NOT EXISTS (SELECT Branch FROM Staff WHERE Branch=@Branch)
RAISERROR (N'Wrong branch code: %d ', 16, 1, @Branch)
ELSE
BEGIN
UPDATE Staff
SET Salary_base = Salary_base*(1+(CAST(@Percentage AS float)/CAST(100 AS float)))
WHERE Branch=@Branch
END
GO
--test 3
BEGIN TRAN 
SELECT TOP 5 Salary_base, * FROM Staff 
BEGIN TRY
EXEC Raise 97,50
SELECT TOP 5 Salary_base, * FROM Staff
END TRY
BEGIN CATCH
SELECT
 ErrorNumber = ERROR_NUMBER(),
 ErrorMessage = ERROR_MESSAGE();
END CATCH
ROLLBACK 

--4
IF OBJECT_ID('STAFF_NUMBER','P') IS NOT NULL
DROP PROCEDURE STAFF_NUMBER
GO
CREATE PROCEDURE STAFF_NUMBER (
@Branch INT, @Number INT OUTPUT)
AS BEGIN
IF NOT EXISTS (SELECT ID FROM Branches WHERE ID = @Branch)
RAISERROR (N'Wrong branch code: %d ', 16, 1, @Branch)
BEGIN TRY
SET @Number = (SELECT COUNT(ID) FROM Staff WHERE Branch = @Branch)
END TRY
BEGIN CATCH
SELECT
 ErrorNumber = ERROR_NUMBER(),
 ErrorMessage = ERROR_MESSAGE();
END CATCH
END
GO

--test 4
DECLARE @Branch INT
DECLARE @Number INT
SET @Branch=20
BEGIN TRY
EXEC STAFF_NUMBER @Branch, @Number OUTPUT
PRINT 'Number of employees in the branch: ' + CAST(@Branch as
VARCHAR(2)) + ' is equal to: ' + CAST(@Number AS VARCHAR(10))
END TRY
BEGIN CATCH
SELECT
 ErrorNumber = ERROR_NUMBER(),
 ErrorMessage = ERROR_MESSAGE(); -- Return error message
END CATCH

--5
IF OBJECT_ID('NEW_EMPLOYEE','P') IS NOT NULL
DROP PROCEDURE NEW_EMPLOYEE
GO
CREATE PROCEDURE NEW_EMPLOYEE (
	@Name VARCHAR(30),
	@Branch INT,
	@BossName VARCHAR(30),
	@Salary_base FLOAT,
	@Position VARCHAR(30) = 'MONTER'
) AS

DECLARE @Boss INT
DECLARE @ID INT
DECLARE @Employed DATETIME2
SET @Boss = (SELECT ID FROM Staff WHERE Name = @BossName)
SET @ID = (SELECT ISNULL(MAX(ID),0)+10 FROM Staff)
SET @Employed = GETDATE()


IF EXISTS (SELECT ID FROM Staff WHERE Name = @Name)
	BEGIN
		RAISERROR (N'The name already exists: %s', 16, 1, @Name)
		GOTO ProcEnd
	END
IF NOT EXISTS (SELECT ID FROM Staff WHERE Name = @BossName)
	BEGIN
		RAISERROR  (N'Wrong boss name: %s',16, 1, @BossName)
		GOTO ProcEnd
	END
IF NOT EXISTS (SELECT ID FROM Branches WHERE ID = @Branch)
	BEGIN
		RAISERROR (N'Wrong branch code: %d', 16, 1, @Branch)
		GOTO ProcEnd
	END

INSERT INTO Staff (ID, Name, Branch, Position, Boss, Employed, Salary_base)
VALUES (@ID, @Name, @Branch, @Position, @Boss, @Employed, @Salary_base)

ProcEnd:
GO

--test 5
BEGIN TRAN
SELECT TOP 5 * FROM Staff WHERE Name LIKE 'B%'
BEGIN TRY
 --EXEC NEW_EMPLOYEE 'BARTCZAK',99,'NOWAK',1200 --1. Name error
 --EXEC NEW_EMPLOYEE 'BANAS',99,'NOWAK',1200 --2. Boss error
 --EXEC NEW_EMPLOYEE 'BANAS',99,'BRZEZINSKI',1200 --3. Branch error
 EXEC NEW_EMPLOYEE 'BANAS',10,'BRZEZINSKI',1200 --4. Settings OK
SELECT TOP 5 * FROM Staff WHERE Name LIKE 'B%'
END TRY
BEGIN CATCH
SELECT
 ErrorNumber = ERROR_NUMBER(),
 ErrorMessage = ERROR_MESSAGE();
END CATCH
ROLLBACK

--6
IF OBJECT_ID('SALARY_NET','FN') IS NOT NULL
DROP FUNCTION SALARY_NET
GO
CREATE FUNCTION SALARY_NET (
@Salary_gross FLOAT,
@Tax_rate FLOAT
)
RETURNS FLOAT
AS BEGIN
DECLARE @Salary_net FLOAT
SET @Salary_net = @Salary_gross*(1-(CAST(@Tax_rate AS float)/CAST(100 AS float)))
RETURN @Salary_net
END;
GO

--test 6
USE DBADLI0_E
SELECT [LABS\s452496].SALARY_NET (120,30)

--7
IF OBJECT_ID('FACT','FN') IS NOT NULL
DROP FUNCTION FACT
GO
CREATE FUNCTION FACT (@n INT)
RETURNS INT
AS
BEGIN
	DECLARE @Result INT
	DECLARE @k INT
	SET @k=1
	WHILE @k <= @n
	BEGIN
		IF @k = 1
			SET @Result=1
		ELSE
			SET @Result = @Result*@k
			SET @k = @k + 1
	END
RETURN(@Result)
END
GO

--test 7
SELECT [LABS\s452496].FACT (1), [LABS\s452496].FACT (2), [LABS\s452496].FACT (3),
[LABS\s452496].FACT (4), [LABS\s452496].FACT (5), [LABS\s452496].FACT (6)

--8
IF OBJECT_ID('Seniority','FN') IS NOT NULL
DROP FUNCTION Seniority
GO

CREATE FUNCTION Seniority (@Date DATETIME)
RETURNS INT
BEGIN
	RETURN (DATEDIFF(YEAR,@Date,GETDATE()))
END
GO--

--test 8
SELECT Name, Employed, Seniority = [LABS\s452496].Seniority(Employed) FROM Staff

--9
IF OBJECT_ID('[LABS\s452496].CHIEF','TR') IS NOT NULL
DROP TRIGGER [LABS\s452496].CHIEF
GO

CREATE TRIGGER [LABS\s452496].CHIEF ON Staff
FOR DELETE
AS
BEGIN
	UPDATE Staff SET
	Boss = NULL
	WHERE Boss NOT IN (SELECT ID FROM Staff)
END
GO

BEGIN TRAN
	SELECT * FROM Staff
	WHERE Boss IS NULL OR Boss IN ('110', '120')
	DELETE FROM Staff WHERE ID='120';
	SELECT * FROM Staff
	WHERE Boss IS NULL OR Boss IN ('110', '120')
ROLLBACK

--10
IF OBJECT_ID('Staff','U') IS NOT NULL DROP TABLE Staff
GO
SELECT * INTO Staff
FROM Employees
GO

IF OBJECT_ID('[LABS\s452496].History','U') IS NOT NULL
DROP TABLE [LABS\s452496].History
GO

CREATE TABLE [LABS\s452496].History (
ID_his INT IDENTITY(1,1),
Type VARCHAR(1),
ID INT,
Name VARCHAR(20),
Salary_base FLOAT,
Position VARCHAR(20),
Branch VARCHAR(20),
Sysdate DATETIME DEFAULT GETDATE(),
[User] VARCHAR(30) DEFAULT SUSER_SNAME()
);
GO
-- Trigger creation
IF OBJECT_ID('[LABS\s452496].Trace','TR') IS NOT NULL
DROP TRIGGER [LABS\s452496].Trace
GO

CREATE TRIGGER [LABS\s452496].Trace ON Staff
FOR INSERT, UPDATE, DELETE
AS
BEGIN
	IF EXISTS (SELECT ID FROM inserted)
	BEGIN
		-- Old values
		IF EXISTS (SELECT ID FROM deleted)
		BEGIN
			INSERT INTO History
			(Type,ID,Name,Salary_base,Position,Branch)
			SELECT 'O', ID, Name, Salary_base, Position, Branch
			FROM deleted
		END
		-- New values
		INSERT INTO History(Type,ID,Name,Salary_base,Position,Branch)
		SELECT 'N', ID, Name, Salary_base, Position, Branch
		FROM inserted
	END
	ELSE BEGIN
		-- Removing….
		IF EXISTS (SELECT ID FROM deleted)
		BEGIN
			INSERT INTO History
			(Type,ID,Name,Salary_base,Position,Branch)
			SELECT 'D', ID, Name, Salary_base, Position, Branch
			FROM deleted
		END
	END
END
GO
-- Test script
BEGIN TRAN
	SELECT * FROM History;
	UPDATE Staff SET Salary_base = 3800 WHERE Name = 'KOWAL';
	DELETE FROM Staff WHERE Name = 'BOGULA';
	SELECT * FROM History;
ROLLBACK