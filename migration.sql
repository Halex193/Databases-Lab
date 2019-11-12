CREATE OR ALTER PROCEDURE FloatFidelityPoints
AS
    ALTER TABLE Customers
        DROP CONSTRAINT DefaultFidelityPoints
    ALTER TABLE Customers
        ALTER COLUMN fidelity_points FLOAT
    ALTER TABLE Customers
        ADD CONSTRAINT DefaultFidelityPoints DEFAULT 0 FOR fidelity_points
GO

CREATE OR ALTER PROCEDURE IntFidelityPoints
AS
    ALTER TABLE Customers
        DROP CONSTRAINT DefaultFidelityPoints
    ALTER TABLE Customers
        ALTER COLUMN fidelity_points INT
    ALTER TABLE Customers
        ADD CONSTRAINT DefaultFidelityPoints DEFAULT 0 FOR fidelity_points
GO

CREATE OR ALTER PROCEDURE AddOrderRating
AS
    ALTER TABLE Orders
        ADD rating INT
            CONSTRAINT CheckRating CHECK (rating BETWEEN 0 AND 5)
GO

CREATE OR ALTER PROCEDURE RemoveOrderRating
AS
    ALTER TABLE Orders
        DROP CONSTRAINT CheckRating
    ALTER TABLE Orders
        DROP COLUMN rating
GO

CREATE OR ALTER PROCEDURE AddDefaultFrequency
AS
    ALTER TABLE CPUs
        ADD CONSTRAINT DefaultFrequency DEFAULT '3.5' FOR frequency
GO

CREATE OR ALTER PROCEDURE RemoveDefaultFrequency
AS
    ALTER TABLE CPUs
        DROP CONSTRAINT DefaultFrequency
GO

CREATE OR ALTER PROCEDURE AddOrderDetailsPrimaryKeys
AS
    ALTER TABLE PC_order_details
        ADD CONSTRAINT PK_pc_order_details PRIMARY KEY (order_id, pc_id)
    ALTER TABLE Peripheral_order_details
        ADD CONSTRAINT PK_peripheral_order_details PRIMARY KEY (order_id, peripheral_id)
GO

CREATE OR ALTER PROCEDURE DropOrderDetailsPrimaryKeys
AS
    ALTER TABLE PC_order_details
        DROP CONSTRAINT PK_pc_order_details
    ALTER TABLE Peripheral_order_details
        DROP CONSTRAINT PK_peripheral_order_details
GO

CREATE OR ALTER PROCEDURE UniqueEmail
AS
    ALTER TABLE Customers
        ADD CONSTRAINT UNIQUE_customer_email UNIQUE (email)
    ALTER TABLE Employees
        ADD CONSTRAINT UNIQUE_employee_email UNIQUE (email)
GO

CREATE OR ALTER PROCEDURE NormalEmail
AS
    ALTER TABLE Customers
        DROP CONSTRAINT UNIQUE_customer_email
    ALTER TABLE Employees
        DROP CONSTRAINT UNIQUE_employee_email
GO

CREATE OR ALTER PROCEDURE CreateDescriptionTable
AS
    CREATE TABLE PC_descriptions
    (
        description_id INT IDENTITY PRIMARY KEY,
        description    TEXT,
        energy_rating  INT
    )
GO

CREATE OR ALTER PROCEDURE DropDescriptionTable
AS
    DROP TABLE PC_descriptions
GO

CREATE OR ALTER PROCEDURE AddDescriptionForeignKey
AS
    ALTER TABLE PCs
        ADD description_id INT
            CONSTRAINT FK_description REFERENCES PC_descriptions (description_id)
GO

CREATE OR ALTER PROCEDURE DropDescriptionForeignKey
AS
    ALTER TABLE PCs
        DROP CONSTRAINT FK_description
    ALTER TABLE PCs
        DROP COLUMN description_id
GO

CREATE OR ALTER PROCEDURE GetDatabaseVersion @Version INT OUTPUT
AS
SELECT @Version = DV.version
FROM DatabaseVersion DV
GO

CREATE OR ALTER PROCEDURE NextVersion @Version INT
AS
    SET @Version = @Version + 1
    DECLARE @DoProcedure NVARCHAR(500)
    SELECT @DoProcedure = doProcedure FROM Versions WHERE version = @Version
    SET @DoProcedure = N'EXECUTE ' + @DoProcedure
    EXECUTE sp_executesql @statement = @DoProcedure
GO

CREATE OR ALTER PROCEDURE PreviousVersion @Version INT
AS
    DECLARE @UndoProcedure NVARCHAR(500)
    SELECT @UndoProcedure = undoProcedure FROM Versions WHERE version = @Version
    SET @UndoProcedure = N'EXECUTE ' + @UndoProcedure
    EXECUTE sp_executesql @statement = @UndoProcedure
GO

CREATE OR ALTER PROCEDURE Migrate @Version INT
AS
DECLARE @OldVersion INT
    EXECUTE GetDatabaseVersion @OldVersion OUTPUT
    WHILE @OldVersion < @Version
        BEGIN
            EXECUTE NextVersion @OldVersion
            SET @OldVersion = @OldVersion + 1
        END
    WHILE @OldVersion > @Version
        BEGIN
            EXECUTE PreviousVersion @OldVersion
            SET @OldVersion = @OldVersion - 1
        END

UPDATE DatabaseVersion
SET version = @Version
GO

DELETE
FROM Versions
INSERT INTO Versions (version, doProcedure, undoProcedure)
VALUES (1, NULL, NULL)
INSERT INTO Versions (version, doProcedure, undoProcedure)
VALUES (2, 'FloatFidelityPoints', 'IntFidelityPoints')
INSERT INTO Versions (version, doProcedure, undoProcedure)
VALUES (3, 'AddOrderRating', 'RemoveOrderRating')
INSERT INTO Versions (version, doProcedure, undoProcedure)
VALUES (4, 'AddDefaultFrequency', 'RemoveDefaultFrequency')
INSERT INTO Versions (version, doProcedure, undoProcedure)
VALUES (5, 'AddOrderDetailsPrimaryKeys', 'DropOrderDetailsPrimaryKeys')
INSERT INTO Versions (version, doProcedure, undoProcedure)
VALUES (6, 'UniqueEmail', 'NormalEmail')
INSERT INTO Versions (version, doProcedure, undoProcedure)
VALUES (7, 'CreateDescriptionTable', 'DropDescriptionTable')
INSERT INTO Versions (version, doProcedure, undoProcedure)
VALUES (8, 'AddDescriptionForeignKey', 'DropDescriptionForeignKey')
GO