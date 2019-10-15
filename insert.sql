INSERT INTO Electronics_Shop.dbo.CPU_types (name, socket) VALUES ('INTEL® CORE™ i7-10510U', 'FCBGA1528');
INSERT INTO Electronics_Shop.dbo.CPU_types (name, socket) VALUES ('INTEL® CORE™ i7-9700T', 'FCLGA1151');
INSERT INTO Electronics_Shop.dbo.CPU_types (name, socket) VALUES ('INTEL® CORE™ i7-9700T', 'FCLGA1151');

INSERT INTO Electronics_Shop.dbo.Customers (name, fidelity_points) VALUES ('Monica', 0);
INSERT INTO Electronics_Shop.dbo.Customers (name, fidelity_points) VALUES ('Razvan', 5);
INSERT INTO Electronics_Shop.dbo.Customers (name, fidelity_points) VALUES ('Mirabela', 6);

INSERT INTO Electronics_Shop.dbo.Employees (name, birthday, bonus_hours) VALUES ('Horatiu', '1999-07-19', 10);
INSERT INTO Electronics_Shop.dbo.Employees (name, birthday, bonus_hours) VALUES ('Alexandru', '1999-08-19', 12);
INSERT INTO Electronics_Shop.dbo.Employees (name, birthday, bonus_hours) VALUES ('Mihaela', '1999-07-20', 5);

INSERT INTO Electronics_Shop.dbo.Hard_drive_types (name, type, transfer_rate, capacity) VALUES ('WD Blue', 'HDD', 64, 1000);
INSERT INTO Electronics_Shop.dbo.Hard_drive_types (name, type, transfer_rate, capacity) VALUES ('Toshiba P300', 'HDD', 64, 1000);
INSERT INTO Electronics_Shop.dbo.Hard_drive_types (name, type, transfer_rate, capacity) VALUES ('Kingston KS SSDNow A400', 'SSD', 550, 480);

INSERT INTO Electronics_Shop.dbo.Motherboard_types (name, cpu_socket) VALUES ('GIGABYTE B450M DS3H', 'AM4');
INSERT INTO Electronics_Shop.dbo.Motherboard_types (name, cpu_socket) VALUES ('ASUS TUF Z390-PLUS GAMING', '1151 v2');
INSERT INTO Electronics_Shop.dbo.Motherboard_types (name, cpu_socket) VALUES ('MSI MPG Z390 GAMING PLUS', '1151 v2');

INSERT INTO Electronics_Shop.dbo.Orders (customer_id, date, employee_helper_id) VALUES (1, '2019-10-15 08:56:29.000', 2);
INSERT INTO Electronics_Shop.dbo.Orders (customer_id, date, employee_helper_id) VALUES (2, '2019-10-15 08:56:46.000', 3);
INSERT INTO Electronics_Shop.dbo.Orders (customer_id, date, employee_helper_id) VALUES (3, '2018-10-15 08:56:59.000', 1);

INSERT INTO Electronics_Shop.dbo.PC_type_order_details (order_id, pc_type_id, amount) VALUES (1, 2, 1);
INSERT INTO Electronics_Shop.dbo.PC_type_order_details (order_id, pc_type_id, amount) VALUES (2, 1, 1);
INSERT INTO Electronics_Shop.dbo.PC_type_order_details (order_id, pc_type_id, amount) VALUES (3, 3, 1);

INSERT INTO Electronics_Shop.dbo.PC_types (name, cpu_type_id, hard_drive_id, motherboard_id, ram_type_id, power_supply_type_id) VALUES ('Monster Buster', 2, 1, 3, 2, 1);
INSERT INTO Electronics_Shop.dbo.PC_types (name, cpu_type_id, hard_drive_id, motherboard_id, ram_type_id, power_supply_type_id) VALUES ('Big Boy 13', 1, 1, 2, 3, 2);
INSERT INTO Electronics_Shop.dbo.PC_types (name, cpu_type_id, hard_drive_id, motherboard_id, ram_type_id, power_supply_type_id) VALUES ('Andu Rantza', 2, 1, 3, 1, 2);

INSERT INTO Electronics_Shop.dbo.Peripheral_order_details (order_id, peripheral_id, amount) VALUES (1, 1, 1);
INSERT INTO Electronics_Shop.dbo.Peripheral_order_details (order_id, peripheral_id, amount) VALUES (1, 2, 1);
INSERT INTO Electronics_Shop.dbo.Peripheral_order_details (order_id, peripheral_id, amount) VALUES (1, 3, 1);
INSERT INTO Electronics_Shop.dbo.Peripheral_order_details (order_id, peripheral_id, amount) VALUES (2, 2, 1);
INSERT INTO Electronics_Shop.dbo.Peripheral_order_details (order_id, peripheral_id, amount) VALUES (2, 3, 1);
INSERT INTO Electronics_Shop.dbo.Peripheral_order_details (order_id, peripheral_id, amount) VALUES (3, 1, 2);
INSERT INTO Electronics_Shop.dbo.Peripheral_order_details (order_id, peripheral_id, amount) VALUES (3, 2, 1);

INSERT INTO Electronics_Shop.dbo.Peripherals (name) VALUES ('Basic Keyboard');
INSERT INTO Electronics_Shop.dbo.Peripherals (name) VALUES ('Basic Mouse');
INSERT INTO Electronics_Shop.dbo.Peripherals (name) VALUES ('Basic Monitor');

INSERT INTO Electronics_Shop.dbo.Power_supply_types (name, voltage) VALUES ('BFG Tech LS-550', 550);
INSERT INTO Electronics_Shop.dbo.Power_supply_types (name, voltage) VALUES ('Thermaltake Litepower', 600);
INSERT INTO Electronics_Shop.dbo.Power_supply_types (name, voltage) VALUES ('Super Flower Amazon', 450);

INSERT INTO Electronics_Shop.dbo.Ram_types (name, type, memory) VALUES ('HyperX Fury Black', 'DDR4', 8);
INSERT INTO Electronics_Shop.dbo.Ram_types (name, type, memory) VALUES ('Corsair Vengeance LPX Black', 'DDR4', 16);
INSERT INTO Electronics_Shop.dbo.Ram_types (name, type, memory) VALUES ('HyperX Fury Blue', 'DDR3', null);