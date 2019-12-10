CREATE OR ALTER PROCEDURE RenewDatabase
AS
    DROP TABLE IF EXISTS PC_order_details
    DROP TABLE IF EXISTS PCs
    DROP TABLE IF EXISTS RAMs
    DROP TABLE IF EXISTS Power_supplies
    DROP TABLE IF EXISTS Motherboards
    DROP TABLE IF EXISTS CPUs
    DROP TABLE IF EXISTS HDDs
    DROP TABLE IF EXISTS Peripheral_order_details
    DROP TABLE IF EXISTS Peripherals
    DROP TABLE IF EXISTS Orders
    DROP TABLE IF EXISTS Employees
    DROP TABLE IF EXISTS Customers
    DROP TABLE IF EXISTS DatabaseVersion
    DROP TABLE IF EXISTS PC_descriptions
    DROP TABLE IF EXISTS Versions
    EXECUTE DropVersion10Elements
    EXECUTE DropTestTables

    CREATE TABLE Versions
    (
        version       INT
            CONSTRAINT UNIQUE_version UNIQUE,
        doProcedure   NVARCHAR(300),
        undoProcedure NVARCHAR(300)
    )

    CREATE TABLE CPUs
    (
        cpu_id    INT IDENTITY
            CONSTRAINT PK_cpu PRIMARY KEY,
        name      NVARCHAR(200) NOT NULL,
        socket    NVARCHAR(200) NOT NULL,
        price     INT,
        frequency FLOAT
    )
    CREATE TABLE Customers
    (
        customer_id     INT IDENTITY
            CONSTRAINT PK_customer PRIMARY KEY,
        name            NVARCHAR(200),
        fidelity_points INT
            CONSTRAINT DefaultFidelityPoints DEFAULT 0 NOT NULL,
        email           NVARCHAR(100)
    )
    CREATE TABLE DatabaseVersion
    (
        version INT NOT NULL
    )
    CREATE TABLE Employees
    (
        employee_id INT IDENTITY
            CONSTRAINT PK_employee PRIMARY KEY,
        name        NVARCHAR(200) NOT NULL,
        birthday    DATE,
        bonus_hours INT DEFAULT 0 NOT NULL,
        email       NVARCHAR(100)
    )
    CREATE TABLE HDDs
    (
        hdd_id        INT IDENTITY
            CONSTRAINT PK_hdd PRIMARY KEY,
        name          NVARCHAR(200) NOT NULL,
        type          NVARCHAR(200) NOT NULL,
        transfer_rate INT,
        capacity      INT,
        price         INT
    )
    CREATE TABLE Motherboards
    (
        motherboard_id INT IDENTITY
            CONSTRAINT PK_motherboard PRIMARY KEY,
        name           NVARCHAR(200) NOT NULL,
        cpu_socket     NVARCHAR(200) NOT NULL,
        price          INT
    )
    CREATE TABLE Orders
    (
        order_id           INT IDENTITY
            CONSTRAINT PK_order PRIMARY KEY,
        customer_id        INT                                   NOT NULL
            CONSTRAINT FK_customer REFERENCES Customers,
        date               DATETIME                              NOT NULL,
        employee_helper_id INT
            CONSTRAINT FK_employee_helper REFERENCES Employees,
        progress           NVARCHAR(200) DEFAULT 'not delivered' NOT NULL
            CONSTRAINT CHECK_progress CHECK ([progress] = 'not delivered' OR [progress] = 'delivered' OR
                                             [progress] = 'in progress')
    )
    CREATE TABLE Peripherals
    (
        peripheral_id INT IDENTITY
            CONSTRAINT PK_peripheral PRIMARY KEY,
        name          NVARCHAR(500) NOT NULL,
        price         INT
    )
    CREATE TABLE Peripheral_order_details
    (
        order_id      INT           NOT NULL
            CONSTRAINT FK_peripheral_order REFERENCES Orders ON DELETE CASCADE,
        peripheral_id INT           NOT NULL
            CONSTRAINT FK_peripheral REFERENCES Peripherals,
        amount        INT DEFAULT 1 NOT NULL
    )
    CREATE TABLE Power_supplies
    (
        power_supply_id INT IDENTITY
            CONSTRAINT PK_power_supply PRIMARY KEY,
        name            NVARCHAR(200) NOT NULL,
        voltage         INT,
        price           INT
    )
    CREATE TABLE RAMs
    (
        ram_id INT IDENTITY
            CONSTRAINT PK_ram PRIMARY KEY,
        name   NVARCHAR(200) NOT NULL,
        type   NVARCHAR(200),
        memory INT,
        price  INT
    )
    CREATE TABLE PCs
    (
        pc_id           INT IDENTITY
            CONSTRAINT PK_pc PRIMARY KEY,
        name            NVARCHAR(200),
        cpu_id          INT
            CONSTRAINT FK_cpu REFERENCES CPUs ON DELETE SET NULL,
        hdd_id          INT
            CONSTRAINT FK_hdd REFERENCES HDDs ON DELETE SET NULL,
        motherboard_id  INT
            CONSTRAINT FK_motherboard REFERENCES Motherboards ON DELETE SET NULL,
        ram_id          INT
            CONSTRAINT FK_ram REFERENCES RAMs ON DELETE SET NULL,
        power_supply_id INT
            CONSTRAINT FK_power_supply REFERENCES Power_supplies ON DELETE SET NULL
    )
    CREATE TABLE PC_order_details
    (
        order_id INT           NOT NULL
            CONSTRAINT FK_pc_order REFERENCES Orders ON DELETE CASCADE,
        pc_id    INT           NOT NULL
            CONSTRAINT FK_pc REFERENCES PCs,
        amount   INT DEFAULT 1 NOT NULL
    )


    SET IDENTITY_INSERT Electronics_Shop.dbo.CPUs ON;
INSERT INTO Electronics_Shop.dbo.CPUs (cpu_id, name, socket, price, frequency)
VALUES (1, 'INTEL® CORE™ i7-10510U', 'FCBGA1528', 1000, 3.3);
    SET IDENTITY_INSERT Electronics_Shop.dbo.CPUs OFF;
    SET IDENTITY_INSERT Electronics_Shop.dbo.CPUs ON;
INSERT INTO Electronics_Shop.dbo.CPUs (cpu_id, name, socket, price, frequency)
VALUES (2, 'INTEL® CORE™ i7-9700T', 'FCLGA1151', 700, 3.5);
    SET IDENTITY_INSERT Electronics_Shop.dbo.CPUs OFF;
    SET IDENTITY_INSERT Electronics_Shop.dbo.CPUs ON;
INSERT INTO Electronics_Shop.dbo.CPUs (cpu_id, name, socket, price, frequency)
VALUES (3, 'INTEL® CORE™ i7-9700T', 'FCLGA1151', 800, 3.7);
    SET IDENTITY_INSERT Electronics_Shop.dbo.CPUs OFF;
    SET IDENTITY_INSERT Electronics_Shop.dbo.Customers ON;
INSERT INTO Electronics_Shop.dbo.Customers (customer_id, name, fidelity_points, email)
VALUES (1, 'Monica', 0, 'monibanana21@gmail.com');
    SET IDENTITY_INSERT Electronics_Shop.dbo.Customers OFF;
    SET IDENTITY_INSERT Electronics_Shop.dbo.Customers ON;
INSERT INTO Electronics_Shop.dbo.Customers (customer_id, name, fidelity_points, email)
VALUES (2, 'Razvan', 5, 'razvanbolovan@me.com');
    SET IDENTITY_INSERT Electronics_Shop.dbo.Customers OFF;
    SET IDENTITY_INSERT Electronics_Shop.dbo.Customers ON;
INSERT INTO Electronics_Shop.dbo.Customers (customer_id, name, fidelity_points, email)
VALUES (3, 'Mirabela', 10, 'mirabela@yahoo.com');
    SET IDENTITY_INSERT Electronics_Shop.dbo.Customers OFF;
INSERT INTO Electronics_Shop.dbo.DatabaseVersion (version)
VALUES (1);
    SET IDENTITY_INSERT Electronics_Shop.dbo.Employees ON;
INSERT INTO Electronics_Shop.dbo.Employees (employee_id, name, birthday, bonus_hours, email)
VALUES (1, 'Horatiu', '1999-07-19', 10, 'horatiu@gmail.com');
    SET IDENTITY_INSERT Electronics_Shop.dbo.Employees OFF;
    SET IDENTITY_INSERT Electronics_Shop.dbo.Employees ON;
INSERT INTO Electronics_Shop.dbo.Employees (employee_id, name, birthday, bonus_hours, email)
VALUES (2, 'Alexandru', '1999-08-19', 12, 'alex99@hotmail.com');
    SET IDENTITY_INSERT Electronics_Shop.dbo.Employees OFF;
    SET IDENTITY_INSERT Electronics_Shop.dbo.Employees ON;
INSERT INTO Electronics_Shop.dbo.Employees (employee_id, name, birthday, bonus_hours, email)
VALUES (3, 'Mihaela', '1999-07-20', 5, 'mihapufi29@me.com');
    SET IDENTITY_INSERT Electronics_Shop.dbo.Employees OFF;
    SET IDENTITY_INSERT Electronics_Shop.dbo.HDDs ON;
INSERT INTO Electronics_Shop.dbo.HDDs (hdd_id, name, type, transfer_rate, capacity, price)
VALUES (1, 'WD Blue', 'HDD', 64, 1000, 300);
    SET IDENTITY_INSERT Electronics_Shop.dbo.HDDs OFF;
    SET IDENTITY_INSERT Electronics_Shop.dbo.HDDs ON;
INSERT INTO Electronics_Shop.dbo.HDDs (hdd_id, name, type, transfer_rate, capacity, price)
VALUES (2, 'Toshiba P300', 'HDD', 64, 1000, 400);
    SET IDENTITY_INSERT Electronics_Shop.dbo.HDDs OFF;
    SET IDENTITY_INSERT Electronics_Shop.dbo.HDDs ON;
INSERT INTO Electronics_Shop.dbo.HDDs (hdd_id, name, type, transfer_rate, capacity, price)
VALUES (3, 'Kingston KS SSDNow A400', 'SSD', 550, 480, 600);
    SET IDENTITY_INSERT Electronics_Shop.dbo.HDDs OFF;
    SET IDENTITY_INSERT Electronics_Shop.dbo.Motherboards ON;
INSERT INTO Electronics_Shop.dbo.Motherboards (motherboard_id, name, cpu_socket, price)
VALUES (1, 'GIGABYTE B450M DS3H', 'AM4', 1000);
    SET IDENTITY_INSERT Electronics_Shop.dbo.Motherboards OFF;
    SET IDENTITY_INSERT Electronics_Shop.dbo.Motherboards ON;
INSERT INTO Electronics_Shop.dbo.Motherboards (motherboard_id, name, cpu_socket, price)
VALUES (2, 'ASUS TUF Z390-PLUS GAMING', '1151 v2', 1100);
    SET IDENTITY_INSERT Electronics_Shop.dbo.Motherboards OFF;
    SET IDENTITY_INSERT Electronics_Shop.dbo.Motherboards ON;
INSERT INTO Electronics_Shop.dbo.Motherboards (motherboard_id, name, cpu_socket, price)
VALUES (3, 'MSI MPG Z390 GAMING PLUS', '1151 v2', 1200);
    SET IDENTITY_INSERT Electronics_Shop.dbo.Motherboards OFF;
    SET IDENTITY_INSERT Electronics_Shop.dbo.Orders ON;
INSERT INTO Electronics_Shop.dbo.Orders (order_id, customer_id, date, employee_helper_id, progress)
VALUES (4, 1, '2019-10-15 08:00:29.000', 2, 'not delivered');
    SET IDENTITY_INSERT Electronics_Shop.dbo.Orders OFF;
    SET IDENTITY_INSERT Electronics_Shop.dbo.Orders ON;
INSERT INTO Electronics_Shop.dbo.Orders (order_id, customer_id, date, employee_helper_id, progress)
VALUES (5, 2, '2017-12-15 08:00:46.000', 3, 'delivered');
    SET IDENTITY_INSERT Electronics_Shop.dbo.Orders OFF;
    SET IDENTITY_INSERT Electronics_Shop.dbo.Orders ON;
INSERT INTO Electronics_Shop.dbo.Orders (order_id, customer_id, date, employee_helper_id, progress)
VALUES (6, 3, '2018-07-19 08:00:59.000', 1, 'in progress');
    SET IDENTITY_INSERT Electronics_Shop.dbo.Orders OFF;
    SET IDENTITY_INSERT Electronics_Shop.dbo.Power_supplies ON;
INSERT INTO Electronics_Shop.dbo.Power_supplies (power_supply_id, name, voltage, price)
VALUES (1, 'BFG Tech LS-550', 550, 300);
    SET IDENTITY_INSERT Electronics_Shop.dbo.Power_supplies OFF;
    SET IDENTITY_INSERT Electronics_Shop.dbo.Power_supplies ON;
INSERT INTO Electronics_Shop.dbo.Power_supplies (power_supply_id, name, voltage, price)
VALUES (2, 'Thermaltake Litepower', 600, 400);
    SET IDENTITY_INSERT Electronics_Shop.dbo.Power_supplies OFF;
    SET IDENTITY_INSERT Electronics_Shop.dbo.Power_supplies ON;
INSERT INTO Electronics_Shop.dbo.Power_supplies (power_supply_id, name, voltage, price)
VALUES (3, 'Super Flower Amazon', 500, 100);
    SET IDENTITY_INSERT Electronics_Shop.dbo.Power_supplies OFF;
    SET IDENTITY_INSERT Electronics_Shop.dbo.RAMs ON;
INSERT INTO Electronics_Shop.dbo.RAMs (ram_id, name, type, memory, price)
VALUES (1, 'HyperX Fury Black', 'DDR4', 8, 200);
    SET IDENTITY_INSERT Electronics_Shop.dbo.RAMs OFF;
    SET IDENTITY_INSERT Electronics_Shop.dbo.RAMs ON;
INSERT INTO Electronics_Shop.dbo.RAMs (ram_id, name, type, memory, price)
VALUES (2, 'Corsair Vengeance LPX Black', 'DDR4', 16, 200);
    SET IDENTITY_INSERT Electronics_Shop.dbo.RAMs OFF;
    SET IDENTITY_INSERT Electronics_Shop.dbo.RAMs ON;
INSERT INTO Electronics_Shop.dbo.RAMs (ram_id, name, type, memory, price)
VALUES (3, 'HyperX Fury Blue', 'DDR3', 8, 250);
    SET IDENTITY_INSERT Electronics_Shop.dbo.RAMs OFF;
    SET IDENTITY_INSERT Electronics_Shop.dbo.PCs ON;
INSERT INTO Electronics_Shop.dbo.PCs (pc_id, name, cpu_id, hdd_id, motherboard_id, ram_id, power_supply_id)
VALUES (1, 'Monster Buster', 2, 1, 3, 2, 1);
    SET IDENTITY_INSERT Electronics_Shop.dbo.PCs OFF;
    SET IDENTITY_INSERT Electronics_Shop.dbo.PCs ON;
INSERT INTO Electronics_Shop.dbo.PCs (pc_id, name, cpu_id, hdd_id, motherboard_id, ram_id, power_supply_id)
VALUES (2, 'Big Boy 13', 1, 1, 2, 3, 2);
    SET IDENTITY_INSERT Electronics_Shop.dbo.PCs OFF;
    SET IDENTITY_INSERT Electronics_Shop.dbo.PCs ON;
INSERT INTO Electronics_Shop.dbo.PCs (pc_id, name, cpu_id, hdd_id, motherboard_id, ram_id, power_supply_id)
VALUES (3, 'Andu Rantza', 2, 3, 3, 1, 2);
    SET IDENTITY_INSERT Electronics_Shop.dbo.PCs OFF;
    SET IDENTITY_INSERT Electronics_Shop.dbo.Peripherals ON;
INSERT INTO Electronics_Shop.dbo.Peripherals (peripheral_id, name, price)
VALUES (4, 'Enhanced Keyboard', 200);
    SET IDENTITY_INSERT Electronics_Shop.dbo.Peripherals OFF;
    SET IDENTITY_INSERT Electronics_Shop.dbo.Peripherals ON;
INSERT INTO Electronics_Shop.dbo.Peripherals (peripheral_id, name, price)
VALUES (5, 'Enhanced Mouse', 150);
    SET IDENTITY_INSERT Electronics_Shop.dbo.Peripherals OFF;
    SET IDENTITY_INSERT Electronics_Shop.dbo.Peripherals ON;
INSERT INTO Electronics_Shop.dbo.Peripherals (peripheral_id, name, price)
VALUES (6, 'Enhanced Monitor', 1000);
    SET IDENTITY_INSERT Electronics_Shop.dbo.Peripherals OFF;
INSERT INTO Electronics_Shop.dbo.Peripheral_order_details (order_id, peripheral_id, amount)
VALUES (4, 4, 1);
INSERT INTO Electronics_Shop.dbo.Peripheral_order_details (order_id, peripheral_id, amount)
VALUES (4, 5, 1);
INSERT INTO Electronics_Shop.dbo.Peripheral_order_details (order_id, peripheral_id, amount)
VALUES (4, 6, 1);
INSERT INTO Electronics_Shop.dbo.Peripheral_order_details (order_id, peripheral_id, amount)
VALUES (5, 5, 1);
INSERT INTO Electronics_Shop.dbo.Peripheral_order_details (order_id, peripheral_id, amount)
VALUES (5, 6, 1);
INSERT INTO Electronics_Shop.dbo.Peripheral_order_details (order_id, peripheral_id, amount)
VALUES (6, 4, 2);
INSERT INTO Electronics_Shop.dbo.Peripheral_order_details (order_id, peripheral_id, amount)
VALUES (6, 5, 1);
INSERT INTO Electronics_Shop.dbo.PC_order_details (order_id, pc_id, amount)
VALUES (4, 1, 1);
INSERT INTO Electronics_Shop.dbo.PC_order_details (order_id, pc_id, amount)
VALUES (5, 2, 1);
INSERT INTO Electronics_Shop.dbo.PC_order_details (order_id, pc_id, amount)
VALUES (6, 3, 2);

    EXECUTE CreateVersions
GO