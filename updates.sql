UPDATE Power_supply_types SET voltage=500 WHERE voltage < 500
UPDATE Orders SET date = '2018-12-12' WHERE order_id IN (1,2)
DELETE FROM Orders WHERE date BETWEEN '2018-1-1' AND '2018-12-31'
DELETE FROM Peripherals WHERE name LIKE 'Basic %'
UPDATE Customers SET fidelity_points=10 WHERE name LIKE 'M%' AND fidelity_points >= 5
UPDATE Ram_types SET memory=8 WHERE memory IS NULL

INSERT INTO Electronics_Shop.dbo.Peripherals (name, price) VALUES ('Enhanced Keyboard', 200);
INSERT INTO Electronics_Shop.dbo.Peripherals (name, price) VALUES ('Enhanced Mouse', 150);
INSERT INTO Electronics_Shop.dbo.Peripherals (name, price) VALUES ('Enhanced Monitor', 1000);

INSERT INTO Electronics_Shop.dbo.Orders (customer_id, date, employee_helper_id) VALUES (1, '2019-10-15 08:00:29.000', 2);
INSERT INTO Electronics_Shop.dbo.Orders (customer_id, date, employee_helper_id) VALUES (2, '2017-12-15 08:00:46.000', 3);
INSERT INTO Electronics_Shop.dbo.Orders (customer_id, date, employee_helper_id) VALUES (3, '2018-10-15 08:00:59.000', 1);
-- INSERT INTO Electronics_Shop.dbo.Orders (customer_id, date, employee_helper_id) VALUES (3, '2018-10-15 08:00:59.000', 7);

INSERT INTO Electronics_Shop.dbo.PC_type_order_details (order_id, pc_type_id, amount) VALUES (4, 1, 1);
INSERT INTO Electronics_Shop.dbo.PC_type_order_details (order_id, pc_type_id, amount) VALUES (5, 2, 1);
INSERT INTO Electronics_Shop.dbo.PC_type_order_details (order_id, pc_type_id, amount) VALUES (6, 3, 2);