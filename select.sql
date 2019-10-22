-- Compute the PC prices
SELECT PCs.pc_type_id,
       PCs.name,
       priceC.price +
       priceH.price +
       priceM.price +
       priceR.price +
       priceP.price
           AS price
FROM PC_types PCs, (SELECT C.price FROM CPU_types C WHERE C.cpu_type_id = PCs.cpu_type_id) priceC,
     (SELECT H.price FROM Hard_drive_types H WHERE H.hard_drive_type_id = PCs.hard_drive_id) priceH,
     (SELECT M.price FROM Motherboard_types M WHERE M.motherboard_type_id = PCs.motherboard_id) priceM,
     (SELECT R.price FROM Ram_types R WHERE R.ram_type_id = PCs.ram_type_id) priceR,
     (SELECT P.price FROM Power_supply_types P WHERE P.power_supply_type_id = PCs.power_supply_type_id) priceP

-- SELECT PCs.pc_type_id,
--        PCs.name,
--        priceC.price +
--        priceH.price +
--        priceM.price +
--        priceR.price +
--        priceP.price
--            AS price
-- FROM PC_types PCs, (SELECT C.price FROM CPU_types C WHERE C.cpu_type_id = PCs.cpu_type_id) priceC,
--      (SELECT H.price FROM Hard_drive_types H WHERE H.hard_drive_type_id = PCs.hard_drive_id) priceH,
--      (SELECT M.price FROM Motherboard_types M WHERE M.motherboard_type_id = PCs.motherboard_id) priceM,
--      (SELECT R.price FROM Ram_types R WHERE R.ram_type_id = PCs.ram_type_id) priceR,
--      (SELECT P.price FROM Power_supply_types P WHERE P.power_supply_type_id = PCs.power_supply_type_id) priceP

-- Party employee participants
SELECT E.employee_id, E.name
FROM Employees E
WHERE E.bonus_hours >= 5
   OR birthday = '1999-07-20'

-- Customers invited to the party
SELECT C.customer_id, C.name
FROM Customers C
WHERE fidelity_points > 5
UNION
SELECT C2.customer_id, C2.name
FROM Customers C2
WHERE C2.name = 'Monica'

-- Alexandru (id = 2) brags about selling mice to many customers... let's check'
SELECT C.customer_id, C.name
FROM Customers C
         JOIN Orders O ON C.customer_id = O.customer_id
         JOIN Employees E ON O.employee_helper_id = E.employee_id
WHERE E.employee_id = 2
INTERSECT
SELECT C.customer_id, C.name
FROM Customers C
         JOIN Orders O2 on C.customer_id = O2.customer_id
         JOIN Peripheral_order_details Pod on O2.order_id = Pod.order_id
         JOIN Peripherals P on Pod.peripheral_id = P.peripheral_id
WHERE LOWER(P.name) LIKE '%mouse%'

