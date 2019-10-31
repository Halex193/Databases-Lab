CREATE TABLE Customers
(
    customer_id     INT IDENTITY PRIMARY KEY,
    name            NVARCHAR(200),
    fidelity_points INT NOT NULL DEFAULT 0
)

CREATE TABLE Employees
(
    employee_id INT IDENTITY PRIMARY KEY,
    name        NVARCHAR(100)  NOT NULL,
    birthday    DATE,
    bonus_hours INT DEFAULT 0 NOT NULL
)

CREATE TABLE Orders
(
    order_id    INT IDENTITY PRIMARY KEY,
    customer_id INT      NOT NULL REFERENCES customers (customer_id),
    date        DATETIME NOT NULL,
    employee_helper_id INT REFERENCES employees(employee_id)
)

CREATE TABLE Peripherals
(
    peripheral_id INT IDENTITY PRIMARY KEY,
    name          NVARCHAR(500) NOT NULL
)

CREATE TABLE Peripheral_order_details
(
    order_id      INT REFERENCES orders (order_id) ON DELETE CASCADE,
    peripheral_id INT REFERENCES peripherals (peripheral_id),
    amount        INT NOT NULL DEFAULT 1
)

CREATE TABLE CPUs
(
    cpu_id INT IDENTITY PRIMARY KEY,
    name        NVARCHAR(200) NOT NULL,
    socket      NVARCHAR(200) NOT NULL
)

CREATE TABLE HDDs
(
    hdd_id INT IDENTITY PRIMARY KEY,
    name               NVARCHAR(200) NOT NULL,
    type               NVARCHAR(200) NOT NULL,
    transfer_rate      INT
)

CREATE TABLE Motherboards
(
    motherboard_id INT IDENTITY PRIMARY KEY,
    name                NVARCHAR(200) NOT NULL,
    cpu_socket          NVARCHAR(200) NOT NULL
)

CREATE TABLE Power_supplies
(
    power_supply_id INT IDENTITY PRIMARY KEY,
    name                 NVARCHAR(200) NOT NULL,
    voltage              INT
)

CREATE TABLE RAMs
(
    ram_id INT IDENTITY PRIMARY KEY,
    name        NVARCHAR(200) NOT NULL,
    type        NVARCHAR(200),
    memory      INT
)

CREATE TABLE PCs
(
    pc_id           INT IDENTITY PRIMARY KEY,
    name                 NVARCHAR(200),
    cpu_id          INT REFERENCES CPUs (cpu_id) ON DELETE SET NULL,
    hdd_id        INT REFERENCES HDDs (hdd_id) ON DELETE SET NULL,
    motherboard_id       INT REFERENCES Motherboards (motherboard_id) ON DELETE SET NULL,
    ram_id          INT REFERENCES rams (ram_id) ON DELETE SET NULL,
    power_supply_id INT REFERENCES power_supplies (power_supply_id) ON DELETE SET NULL
)

CREATE TABLE PC_order_details
(
    order_id   INT REFERENCES orders (order_id) ON DELETE CASCADE,
    pc_id INT REFERENCES PCs (pc_id),
    amount     INT NOT NULL DEFAULT 1
)

ALTER TABLE Employees
    ALTER COLUMN name NVARCHAR(200) NOT NULL

ALTER TABLE HDDs
ADD capacity INT

ALTER TABLE Orders
ADD progress NVARCHAR(200) NOT NULL DEFAULT 'not delivered'

ALTER TABLE Orders
ADD CONSTRAINT Progress_check CHECK (progress = 'not delivered' OR progress = 'delivered' OR progress = 'in progress')

ALTER TABLE CPUs
ADD price INT

ALTER TABLE Motherboards
ADD price INT

ALTER TABLE Power_supplies
ADD price INT

ALTER TABLE Peripherals
ADD price INT

ALTER TABLE RAMs
ADD price INT

ALTER TABLE HDDs
ADD price INT


ALTER TABLE CPUs
ADD frequency DOUBLE PRECISION