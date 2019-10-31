INSERT INTO Electronics_Shop.dbo.CPUs (name, socket, price) VALUES ('INTEL® CORE™ i7-10510U', 'FCBGA1528', 1000);
INSERT INTO Electronics_Shop.dbo.CPUs (name, socket, price) VALUES ('INTEL® CORE™ i7-9700T', 'FCLGA1151', 700);
INSERT INTO Electronics_Shop.dbo.CPUs (name, socket, price) VALUES ('INTEL® CORE™ i7-9700T', 'FCLGA1151', 800);

INSERT INTO Electronics_Shop.dbo.Customers (name, fidelity_points, email) VALUES ('Monica', 0, 'monibanana21@gmail.com');
INSERT INTO Electronics_Shop.dbo.Customers (name, fidelity_points, email) VALUES ('Razvan', 5, 'razvanbolovan@me.com');
INSERT INTO Electronics_Shop.dbo.Customers (name, fidelity_points, email) VALUES ('Mirabela', 6, 'mirabela@yahoo.com');

INSERT INTO Electronics_Shop.dbo.Employees (name, birthday, bonus_hours, email) VALUES ('Horatiu', '1999-07-19', 10, 'horatiu@gmail.com');
INSERT INTO Electronics_Shop.dbo.Employees (name, birthday, bonus_hours, email) VALUES ('Alexandru', '1999-08-19', 12, 'alex99@hotmail.com');
INSERT INTO Electronics_Shop.dbo.Employees (name, birthday, bonus_hours, email) VALUES ('Mihaela', '1999-07-20', 5, 'mihapufi29@me.com');

INSERT INTO Electronics_Shop.dbo.Power_supplies (name, voltage, price) VALUES ('BFG Tech LS-550', 550, 300);
INSERT INTO Electronics_Shop.dbo.Power_supplies (name, voltage, price) VALUES ('Thermaltake Litepower', 600, 400);
INSERT INTO Electronics_Shop.dbo.Power_supplies (name, voltage, price) VALUES ('Super Flower Amazon', 450, 100);

INSERT INTO Electronics_Shop.dbo.RAMs (name, type, memory, price) VALUES ('HyperX Fury Black', 'DDR4', 8, 200);
INSERT INTO Electronics_Shop.dbo.RAMs (name, type, memory, price) VALUES ('Corsair Vengeance LPX Black', 'DDR4', 16, 200);
INSERT INTO Electronics_Shop.dbo.RAMs (name, type, memory, price) VALUES ('HyperX Fury Blue', 'DDR3', null, 250);

INSERT INTO Electronics_Shop.dbo.HDDs (name, type, transfer_rate, capacity, price) VALUES ('WD Blue', 'HDD', 64, 1000, 300);
INSERT INTO Electronics_Shop.dbo.HDDs (name, type, transfer_rate, capacity, price) VALUES ('Toshiba P300', 'HDD', 64, 1000, 400);
INSERT INTO Electronics_Shop.dbo.HDDs (name, type, transfer_rate, capacity, price) VALUES ('Kingston KS SSDNow A400', 'SSD', 550, 480, 600);

INSERT INTO Electronics_Shop.dbo.Motherboards (name, cpu_socket, price) VALUES ('GIGABYTE B450M DS3H', 'AM4', 1000);
INSERT INTO Electronics_Shop.dbo.Motherboards (name, cpu_socket, price) VALUES ('ASUS TUF Z390-PLUS GAMING', '1151 v2', 1100);
INSERT INTO Electronics_Shop.dbo.Motherboards (name, cpu_socket, price) VALUES ('MSI MPG Z390 GAMING PLUS', '1151 v2', 1200);

INSERT INTO Electronics_Shop.dbo.Orders (customer_id, date, employee_helper_id) VALUES (1, '2019-10-15 08:56:29.000', 2);
INSERT INTO Electronics_Shop.dbo.Orders (customer_id, date, employee_helper_id) VALUES (2, '2019-10-15 08:56:46.000', 3);
INSERT INTO Electronics_Shop.dbo.Orders (customer_id, date, employee_helper_id) VALUES (3, '2018-10-15 08:56:59.000', 1);

INSERT INTO Electronics_Shop.dbo.PCs (name, cpu_id, hdd_id, motherboard_id, ram_id, power_supply_id) VALUES ('Monster Buster', 2, 1, 3, 2, 1);
INSERT INTO Electronics_Shop.dbo.PCs (name, cpu_id, hdd_id, motherboard_id, ram_id, power_supply_id) VALUES ('Big Boy 13', 1, 1, 2, 3, 2);
INSERT INTO Electronics_Shop.dbo.PCs (name, cpu_id, hdd_id, motherboard_id, ram_id, power_supply_id) VALUES ('Andu Rantza', 2, 1, 3, 1, 2);

INSERT INTO Electronics_Shop.dbo.Peripherals (name, price) VALUES ('Basic Keyboard', 100);
INSERT INTO Electronics_Shop.dbo.Peripherals (name, price) VALUES ('Basic Mouse', 150);
INSERT INTO Electronics_Shop.dbo.Peripherals (name, price) VALUES ('Basic Monitor', 800);

INSERT INTO Electronics_Shop.dbo.PC_order_details (order_id, pc_id, amount) VALUES (1, 2, 1);
INSERT INTO Electronics_Shop.dbo.PC_order_details (order_id, pc_id, amount) VALUES (2, 1, 1);
INSERT INTO Electronics_Shop.dbo.PC_order_details (order_id, pc_id, amount) VALUES (3, 3, 1);

INSERT INTO Electronics_Shop.dbo.Peripheral_order_details (order_id, peripheral_id, amount) VALUES (1, 1, 1);
INSERT INTO Electronics_Shop.dbo.Peripheral_order_details (order_id, peripheral_id, amount) VALUES (1, 2, 1);
INSERT INTO Electronics_Shop.dbo.Peripheral_order_details (order_id, peripheral_id, amount) VALUES (1, 3, 1);
INSERT INTO Electronics_Shop.dbo.Peripheral_order_details (order_id, peripheral_id, amount) VALUES (2, 2, 1);
INSERT INTO Electronics_Shop.dbo.Peripheral_order_details (order_id, peripheral_id, amount) VALUES (2, 3, 1);
INSERT INTO Electronics_Shop.dbo.Peripheral_order_details (order_id, peripheral_id, amount) VALUES (3, 1, 2);
INSERT INTO Electronics_Shop.dbo.Peripheral_order_details (order_id, peripheral_id, amount) VALUES (3, 2, 1);

UPDATE CPUs SET frequency=3.3 WHERE cpu_id=1
UPDATE CPUs SET frequency=3.5 WHERE cpu_id=2
UPDATE CPUs SET frequency=3.7 WHERE cpu_id=3