-- Compute the PC prices
SELECT PCs.pc_type_id,
       PCs.name,
       (SELECT C.price FROM CPU_types C WHERE C.cpu_type_id = PCs.cpu_type_id) +
       (SELECT H.price FROM Hard_drive_types H WHERE H.hard_drive_type_id = PCs.hard_drive_id) +
       (SELECT M.price FROM Motherboard_types M WHERE M.motherboard_type_id = PCs.motherboard_id) +
       (SELECT R.price FROM Ram_types R WHERE R.ram_type_id = PCs.ram_type_id) +
       (SELECT P.price FROM Power_supply_types P WHERE P.power_supply_type_id = PCs.power_supply_type_id) AS price
FROM PC_types PCs

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

-- Alexandru (id = 2) brags about selling mice to many customers... let's check
SELECT C.customer_id, C.name
FROM Customers C
         JOIN Orders O ON C.customer_id = O.customer_id
         JOIN Employees E ON O.employee_helper_id = E.employee_id
WHERE E.employee_id = 2
INTERSECT
SELECT C.customer_id, C.name
FROM Customers C
         JOIN Orders O2 ON C.customer_id = O2.customer_id
         JOIN Peripheral_order_details Pod ON O2.order_id = Pod.order_id
         JOIN Peripherals P ON Pod.peripheral_id = P.peripheral_id
WHERE LOWER(P.name) LIKE '%mouse%'

-- Let's see who worked on his/her birthday
SELECT E.employee_id, E.name
FROM Employees E
WHERE CONCAT(DAY(E.birthday), MONTH(E.birthday)) IN
      (SELECT CONCAT(DAY(O.date), MONTH(O.date)) FROM Orders O WHERE E.employee_id = O.employee_helper_id)

-- Let's see if people actually buy PC's with 16 GIGs of RAM

SELECT P.pc_type_id, P.name
FROM PC_types P
         JOIN Ram_types R ON P.ram_type_id = R.ram_type_id
WHERE R.memory = 16
    EXCEPT
SELECT DISTINCT P.pc_type_id, P.name
FROM PC_types P
         JOIN PC_type_order_details POD ON P.pc_type_id = POD.pc_type_id

-- See the customers that only ordered peripherals
SELECT C.customer_id, C.name
FROM Customers C
         JOIN Orders O ON C.customer_id = O.customer_id
WHERE O.order_id NOT IN
      (SELECT O.order_id
       FROM Orders O
                JOIN PC_type_order_details Ptod ON O.order_id = Ptod.order_id)

-- Check how many peripherals were sold with each computer type in increasing order
SELECT P1.pc_type_id, P1.name, T.peripheral_count
FROM PC_types P1
         JOIN
     (SELECT P.pc_type_id, COUNT(PR.name) AS peripheral_count
      FROM PC_types P
               LEFT JOIN PC_type_order_details Ptod ON P.pc_type_id = Ptod.pc_type_id
               LEFT JOIN Orders O ON Ptod.order_id = O.order_id
               LEFT JOIN Peripheral_order_details Pod ON O.order_id = Pod.order_id
               LEFT JOIN Peripherals PR ON Pod.peripheral_id = PR.peripheral_id
      GROUP BY P.pc_type_id) T ON P1.pc_type_id = T.pc_type_id
ORDER BY T.peripheral_count

-- See all the recent orders

SELECT TOP 10 O.order_id,O.progress,O.date,C.name AS customer_name,E.name AS helper_name
FROM Orders O
         JOIN Employees E ON O.employee_helper_id = E.employee_id
         RIGHT JOIN Customers C ON O.customer_id = C.customer_id
ORDER BY O.date DESC

-- See the interaction between customers and employees

SELECT DISTINCT C.name AS customer_name, E.name AS employee_name
FROM Orders O
         FULL JOIN Customers C ON O.customer_id = C.customer_id
         FULL JOIN Employees E ON O.employee_helper_id = E.employee_id

