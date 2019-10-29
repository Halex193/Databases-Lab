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

CREATE TABLE CPU_types
(
    cpu_type_id INT IDENTITY PRIMARY KEY,
    name        NVARCHAR(200) NOT NULL,
    socket      NVARCHAR(200) NOT NULL
)

CREATE TABLE Hard_drive_types
(
    hard_drive_type_id INT IDENTITY PRIMARY KEY,
    name               NVARCHAR(200) NOT NULL,
    type               NVARCHAR(200) NOT NULL,
    transfer_rate      INT
)

CREATE TABLE Motherboard_types
(
    motherboard_type_id INT IDENTITY PRIMARY KEY,
    name                NVARCHAR(200) NOT NULL,
    cpu_socket          NVARCHAR(200) NOT NULL
)

CREATE TABLE Power_supply_types
(
    power_supply_type_id INT IDENTITY PRIMARY KEY,
    name                 NVARCHAR(200) NOT NULL,
    voltage              INT
)

CREATE TABLE Ram_types
(
    ram_type_id INT IDENTITY PRIMARY KEY,
    name        NVARCHAR(200) NOT NULL,
    type        NVARCHAR(200),
    memory      INT
)

CREATE TABLE PC_types
(
    pc_type_id           INT IDENTITY PRIMARY KEY,
    name                 NVARCHAR(200),
    cpu_type_id          INT REFERENCES CPU_types (cpu_type_id) ON DELETE SET NULL,
    hard_drive_id        INT REFERENCES hard_drive_types (hard_drive_type_id) ON DELETE SET NULL,
    motherboard_id       INT REFERENCES motherboard_types (motherboard_type_id) ON DELETE SET NULL,
    ram_type_id          INT REFERENCES ram_types (ram_type_id) ON DELETE SET NULL,
    power_supply_type_id INT REFERENCES power_supply_types (power_supply_type_id) ON DELETE SET NULL
)

CREATE TABLE PC_type_order_details
(
    order_id   INT REFERENCES orders (order_id) ON DELETE CASCADE,
    pc_type_id INT REFERENCES PC_types (pc_type_id),
    amount     INT NOT NULL DEFAULT 1
)

ALTER TABLE Employees
    ALTER COLUMN name NVARCHAR(200) NOT NULL

ALTER TABLE Hard_drive_types
ADD capacity INT

ALTER TABLE Orders
ADD progress NVARCHAR(200) NOT NULL DEFAULT 'not delivered'

ALTER TABLE Orders
ADD CONSTRAINT Progress_check CHECK (progress = 'not delivered' OR progress = 'delivered' OR progress = 'in progress')

ALTER TABLE CPU_types
ADD price INT

ALTER TABLE Motherboard_types
ADD price INT

ALTER TABLE Power_supply_types
ADD price INT

ALTER TABLE Peripherals
ADD price INT

ALTER TABLE Ram_types
ADD price INT

ALTER TABLE Hard_drive_types
ADD price INT


ALTER TABLE CPU_types
ADD frequency DOUBLE PRECISION