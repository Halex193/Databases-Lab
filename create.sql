CREATE TABLE customers
(
    id   INT IDENTITY PRIMARY KEY,
    name VARCHAR(200)
)

CREATE TABLE orders
(
    id              INT IDENTITY PRIMARY KEY,
    customer_id     INT           NOT NULL FOREIGN KEY REFERENCES customers (id),
    fidelity_points INT DEFAULT 0 NOT NULL
)

CREATE TABLE employees
(
    id          INT IDENTITY PRIMARY KEY,
    name        VARCHAR(100)  NOT NULL,
    birthday    DATE,
    bonus_hours INT DEFAULT 0 NOT NULL
)

CREATE TABLE products
(
    id INT IDENTITY PRIMARY KEY
)

CREATE TABLE ordered
(
    order_id   INT NOT NULL FOREIGN KEY REFERENCES orders (id),
    product_id INT NOT NULL FOREIGN KEY REFERENCES products (id)
)

CREATE TABLE cpu_types
(
    id         INT IDENTITY PRIMARY KEY,
    product_id INT          NOT NULL FOREIGN KEY REFERENCES products (id),
    name       VARCHAR(200) NOT NULL,
    socket     VARCHAR(200) NOT NULL
)

CREATE TABLE hard_drive_types
(
    id            INT IDENTITY PRIMARY KEY,
    product_id    INT          NOT NULL FOREIGN KEY REFERENCES products (id),
    name          VARCHAR(200) NOT NULL,
    type          VARCHAR(200) NOT NULL,
    transfer_rate INT
)

CREATE TABLE keyboard_types
(
    id         INT IDENTITY PRIMARY KEY,
    product_id INT          NOT NULL FOREIGN KEY REFERENCES products (id),
    name       VARCHAR(200) NOT NULL
)

CREATE TABLE motherboard_types
(
    id         INT IDENTITY PRIMARY KEY,
    product_id INT          NOT NULL FOREIGN KEY REFERENCES products (id),
    name       VARCHAR(200) NOT NULL,
    cpu_socket VARCHAR(200) NOT NULL
)

CREATE TABLE power_supply_types
(
    id         INT IDENTITY PRIMARY KEY,
    product_id INT          NOT NULL FOREIGN KEY REFERENCES products (id),
    name       VARCHAR(200) NOT NULL,
    voltage    INT
)

CREATE TABLE ram_types
(
    id         INT IDENTITY PRIMARY KEY,
    product_id INT          NOT NULL FOREIGN KEY REFERENCES products (id),
    name       VARCHAR(200) NOT NULL,
    type       VARCHAR(200),
    memory     INT
)

CREATE TABLE pc_types
(
    id                   INT IDENTITY PRIMARY KEY,
    product_id           INT NOT NULL FOREIGN KEY REFERENCES products (id),
    name                 VARCHAR(200),
    cpu_type_id          INT FOREIGN KEY REFERENCES cpu_types (id),
    hard_drive_id        INT FOREIGN KEY REFERENCES hard_drive_types (id),
    motherboard_id       INT FOREIGN KEY REFERENCES motherboard_types (id),
    ram_type_id          INT FOREIGN KEY REFERENCES ram_types (id),
    power_supply_type_id INT FOREIGN KEY REFERENCES power_supply_types (id)
)

CREATE TABLE pc_tests
(
    employee_id  INT      NOT NULL FOREIGN KEY REFERENCES employees (id),
    pc_type_id   INT      NOT NULL FOREIGN KEY REFERENCES pc_types (id),
    rating       INT      NOT NULL,
    date         DATETIME NOT NULL,
    observations TEXT
)

ALTER TABLE employees
ALTER COLUMN name VARCHAR(200) NOT NULL