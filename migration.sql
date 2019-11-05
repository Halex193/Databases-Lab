CREATE OR ALTER PROC FloatFidelityPoints
AS
    ALTER TABLE Customers
        DROP CONSTRAINT DefaultFidelityPoints
    ALTER TABLE Customers
        ALTER COLUMN fidelity_points FLOAT
    ALTER TABLE Customers
        ADD CONSTRAINT DefaultFidelityPoints DEFAULT 0 FOR fidelity_points
GO

CREATE OR ALTER PROC IntFidelityPoints
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
        ADD CONSTRAINT PK_PC_order_details PRIMARY KEY (order_id, pc_id)
    ALTER TABLE Peripheral_order_details
        ADD CONSTRAINT PK_Peripheral_order_details PRIMARY KEY (order_id, peripheral_id)
GO

CREATE OR ALTER PROCEDURE AddOrderDetailsPrimaryKeys
AS
    ALTER TABLE PC_order_details
        DROP CONSTRAINT PK_PC_order_details
    ALTER TABLE Peripheral_order_details
        DROP CONSTRAINT PK_Peripheral_order_details
GO

CREATE OR ALTER PROCEDURE UniqueEmail
AS
    ALTER TABLE Customers
        ADD CONSTRAINT UniqueEmail UNIQUE (email)
    ALTER TABLE Employees
        ADD CONSTRAINT UniqueEmail UNIQUE (email)
GO

CREATE OR ALTER PROCEDURE NormalEmail
AS
    ALTER TABLE Customers
        DROP CONSTRAINT UniqueEmail
    ALTER TABLE Employees
        DROP CONSTRAINT UniqueEmail
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

CREATE OR ALTER PROCEDURE CreateDescriptionTable
AS
    DROP TABLE PC_descriptions
GO

CREATE OR ALTER PROCEDURE AddDescriptionForeignKey
AS
    ALTER TABLE PCs
        ADD description_id INT CONSTRAINT FK_description REFERENCES PC_descriptions (description_id)
GO

CREATE OR ALTER PROCEDURE AddDescriptionForeignKey
AS
    ALTER TABLE PCs
        ADD description_id INT REFERENCES PC_descriptions (description_id)
GO