CREATE TABLE customers
(
    customer_id     INT IDENTITY PRIMARY KEY,
    name            VARCHAR(200),
    fidelity_points INT NOT NULL DEFAULT 0
)

CREATE TABLE employees
(
    employee_id INT IDENTITY PRIMARY KEY,
    name        VARCHAR(100)  NOT NULL,
    birthday    DATE,
    bonus_hours INT DEFAULT 0 NOT NULL
)

CREATE TABLE orders
(
    order_id    INT IDENTITY PRIMARY KEY,
    customer_id INT      NOT NULL REFERENCES customers (customer_id) ON DELETE NO ACTION,
    date        DATETIME NOT NULL,
    employee_helper_id INT REFERENCES employees(employee_id)
)

CREATE TABLE peripherals
(
    peripheral_id INT IDENTITY PRIMARY KEY,
    name          VARCHAR(500) NOT NULL
)

CREATE TABLE peripheral_order_details
(
    order_id      INT REFERENCES orders (order_id) ON DELETE CASCADE,
    peripheral_id INT REFERENCES peripherals (peripheral_id) ON DELETE NO ACTION,
    amount        INT NOT NULL DEFAULT 1
)

CREATE TABLE cpu_types
(
    cpu_type_id INT IDENTITY PRIMARY KEY,
    name        VARCHAR(200) NOT NULL,
    socket      VARCHAR(200) NOT NULL
)

CREATE TABLE hard_drive_types
(
    hard_drive_type_id INT IDENTITY PRIMARY KEY,
    name               VARCHAR(200) NOT NULL,
    type               VARCHAR(200) NOT NULL,
    transfer_rate      INT
)

CREATE TABLE motherboard_types
(
    motherboard_type_id INT IDENTITY PRIMARY KEY,
    name                VARCHAR(200) NOT NULL,
    cpu_socket          VARCHAR(200) NOT NULL
)

CREATE TABLE power_supply_types
(
    power_supply_type_id INT IDENTITY PRIMARY KEY,
    name                 VARCHAR(200) NOT NULL,
    voltage              INT
)

CREATE TABLE ram_types
(
    ram_type_id INT IDENTITY PRIMARY KEY,
    name        VARCHAR(200) NOT NULL,
    type        VARCHAR(200),
    memory      INT
)

CREATE TABLE pc_types
(
    pc_type_id           INT IDENTITY PRIMARY KEY,
    name                 VARCHAR(200),
    cpu_type_id          INT REFERENCES cpu_types (cpu_type_id) ON DELETE SET NULL,
    hard_drive_id        INT REFERENCES hard_drive_types (hard_drive_type_id) ON DELETE SET NULL,
    motherboard_id       INT REFERENCES motherboard_types (motherboard_type_id) ON DELETE SET NULL,
    ram_type_id          INT REFERENCES ram_types (ram_type_id) ON DELETE SET NULL,
    power_supply_type_id INT REFERENCES power_supply_types (power_supply_type_id) ON DELETE SET NULL
)

CREATE TABLE pc_type_order_details
(
    order_id   INT REFERENCES orders (order_id) ON DELETE CASCADE,
    pc_type_id INT REFERENCES pc_types (pc_type_id) ON DELETE NO ACTION,
    amount     INT NOT NULL DEFAULT 1
)

ALTER TABLE employees
    ALTER COLUMN name VARCHAR(200) NOT NULL
