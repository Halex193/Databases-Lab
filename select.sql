-- Compute the PC prices
CREATE VIEW PC_prices AS
SELECT PCs.pc_id,
       PCs.name,
       (SELECT C.price FROM CPUs C WHERE C.cpu_id = PCs.cpu_id) +
       (SELECT H.price FROM HDDs H WHERE H.hdd_id = PCs.hdd_id) +
       (SELECT M.price FROM Motherboards M WHERE M.motherboard_id = PCs.motherboard_id) +
       (SELECT R.price FROM RAMs R WHERE R.ram_id = PCs.ram_id) +
       (SELECT P.price FROM Power_supplies P WHERE P.power_supply_id = PCs.power_supply_id) AS price
FROM PCs PCs

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

-- Show all orders of Răzvan (id = 2) helped by Mihaela (id = 3) to identify the dates
SELECT O.order_id, O.date, O.progress
FROM Orders O
         JOIN Customers C ON O.customer_id = C.customer_id
WHERE C.customer_id = 2
  AND O.customer_id IN (SELECT O.customer_id
                        FROM Orders O2
                                 JOIN Employees E ON O2.employee_helper_id = E.employee_id
                        WHERE E.employee_id = 3)

-- Let's see if people actually buy PC's with 16 GIGs of RAM

SELECT P.pc_id, P.name
FROM PCs P
         JOIN RAMs R ON P.ram_id = R.ram_id
WHERE R.memory = 16 EXCEPT
SELECT DISTINCT P.pc_id, P.name
FROM PCs P
         JOIN PC_order_details POD ON P.pc_id = POD.pc_id

-- See the customers that only ordered peripherals
SELECT C.customer_id, C.name
FROM Customers C
         JOIN Orders O ON C.customer_id = O.customer_id
WHERE O.order_id NOT IN (SELECT O.order_id
                         FROM Orders O
                                  JOIN PC_order_details Ptod ON O.order_id = Ptod.order_id)

-- Check how many peripherals were sold with each computer type in increasing order
SELECT P1.pc_id, P1.name, T.peripheral_count
FROM PCs P1
         JOIN (SELECT P.pc_id, COUNT(PR.name) AS peripheral_count
               FROM PCs P
                        LEFT JOIN PC_order_details Ptod ON P.pc_id = Ptod.pc_id
                        LEFT JOIN Orders O ON Ptod.order_id = O.order_id
                        LEFT JOIN Peripheral_order_details Pod ON O.order_id = Pod.order_id
                        LEFT JOIN Peripherals PR ON Pod.peripheral_id = PR.peripheral_id
               GROUP BY P.pc_id) T ON P1.pc_id = T.pc_id
ORDER BY T.peripheral_count

-- See all the recent orders

SELECT
TOP 10
O.order_id
,
O.progress
,
O.date
,
C.name AS customer_name
,
E.name AS helper_name
FROM Orders O
         JOIN Employees E ON O.employee_helper_id = E.employee_id
         RIGHT JOIN Customers C ON O.customer_id = C.customer_id
ORDER BY O.date DESC

-- See the interaction between customers and employees

SELECT DISTINCT C.name AS customer_name, E.name AS employee_name
FROM Orders O
         FULL JOIN Customers C ON O.customer_id = C.customer_id
         FULL JOIN Employees E ON O.employee_helper_id = E.employee_id

-- Let's see who worked on his/her birthday
SELECT E.employee_id, E.name
FROM Employees E
WHERE CONCAT(DAY(E.birthday), MONTH(E.birthday)) IN
      (SELECT CONCAT(DAY(O.date), MONTH(O.date)) FROM Orders O WHERE E.employee_id = O.employee_helper_id)

-- Show PCs that have ram that is more expensive than average
SELECT P.pc_id, P.name
FROM PCs P
WHERE P.ram_id IN (SELECT R.ram_id FROM RAMs R WHERE R.price > (SELECT AVG(R2.price) FROM RAMs R2))

-- Show customers that bought PCs with ASUS TUF Z390-PLUS GAMING motherboard (id = 2)
SELECT C.customer_id, C.name
FROM Customers C
WHERE EXISTS(SELECT *
             FROM Orders O
                      JOIN PC_order_details Ptod ON O.order_id = Ptod.order_id
                      JOIN PCs Pt ON Ptod.pc_id = Pt.pc_id
                      JOIN Motherboards Mt ON Pt.motherboard_id = Mt.motherboard_id
             WHERE Mt.motherboard_id = 2
               AND C.customer_id = O.customer_id)

-- Peripheral types on the shelve have been misplaced with CPU types with the same price.
-- Find the items in order to replace their types on the shelve.
SELECT P.peripheral_id, P.name, P.price
FROM Peripherals P
WHERE EXISTS(SELECT * FROM CPUs C WHERE C.price = P.price)

-- Show PCs that were bought in descending order of price
SELECT T.pc_id, T.name, Pr.price
FROM (SELECT P.pc_id, P.name
      FROM PCs P
               JOIN PC_order_details Ptod ON P.pc_id = Ptod.pc_id) AS T,
     PC_prices Pr
WHERE T.pc_id = Pr.pc_id
ORDER BY Pr.price DESC

-- Show the least expensive PCs with SSDs
SELECT
TOP 5
T.pc_id
,
T.name
FROM (SELECT P.pc_id, P.name
      FROM PCs P
               JOIN HDDs H ON P.hdd_id = H.hdd_id
      WHERE H.type = 'SSD') AS T,
     PC_prices Pr
WHERE T.pc_id = Pr.pc_id
ORDER BY Pr.price

-- For each CPU socket type, show the best frequency
SELECT C.socket, MAX(C.frequency)
FROM CPUs C
GROUP BY C.socket

-- Get the hard drive types that can easily be replaced at our shop (we have at least two products with different capacity)
SELECT H.type
FROM HDDs H
GROUP BY H.type
HAVING COUNT(H.capacity) > 1

-- Show all RAM types that have all memories below average
SELECT R.type
FROM RAMs R
GROUP BY R.type
HAVING MAX(R.memory) <= (SELECT AVG(R2.memory)
    FROM RAMs R2)