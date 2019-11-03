-- Compute the PC prices
CREATE VIEW PC_prices AS
SELECT PCs.pc_id,
       PCs.name,
       (SELECT C.price FROM CPUs C WHERE C.cpu_id = PCs.cpu_id) +
       (SELECT H.price FROM HDDs H WHERE H.hdd_id = PCs.hdd_id) +
       (SELECT M.price FROM Motherboards M WHERE M.motherboard_id = PCs.motherboard_id) +
       (SELECT R.price FROM RAMs R WHERE R.ram_id = PCs.ram_id) +
       (SELECT P.price FROM Power_supplies P WHERE P.power_supply_id = PCs.power_supply_id) AS price
FROM PCs

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
HAVING MAX(R.memory) <= (SELECT AVG(R2.memory) FROM RAMs R2)

-- Show the employees that have more orders in progress than not delivered
SELECT E.employee_id, E.name
FROM Employees E,
(SELECT O.employee_helper_id, COUNT(*) AS orders
FROM Orders O
WHERE O.progress = 'in progress'
GROUP BY O.employee_helper_id
HAVING COUNT(*) > (SELECT COUNT(*) FROM Orders O2 WHERE O2.employee_helper_id = O.employee_helper_id AND O2.progress = 'not delivered')) AS T
WHERE E.employee_id = T.employee_helper_id

-- See which employees helped at least one customer
SELECT E.employee_id, E.name
FROM Employees E
WHERE E.employee_id = ANY (SELECT O.employee_helper_id FROM Orders O)

SELECT E.employee_id, E.name
FROM Employees E
WHERE E.employee_id IN (SELECT O.employee_helper_id FROM Orders O)

-- See which PCs were not yet ordered
SELECT P.pc_id, P.name
FROM PCs P
WHERE P.pc_id != ALL (SELECT Pod.pc_id FROM PC_order_details Pod)

SELECT P.pc_id, P.name
FROM PCs P
WHERE P.pc_id NOT IN (SELECT Pod.pc_id FROM PC_order_details Pod)

-- See the cheapest RAM available
SELECT *
FROM RAMs R
WHERE R.price <= ALL (SELECT R2.price FROM RAMs R2)

SELECT *
FROM RAMs R
WHERE R.price = (SELECT MIN(R2.price) FROM RAMs R2)

-- See the most expensive power supplies
SELECT *
FROM Power_supplies P
WHERE P.price >= ALL (SELECT P.price FROM Power_supplies P)

SELECT *
FROM Power_supplies P
WHERE P.price = (SELECT MAX(P.price) FROM Power_supplies P)

-- Create a panel with all the customer names, sorted in alphabetical order
SELECT DISTINCT C.name
FROM Customers C
ORDER BY C.name


-- The company is throwing a party in the weekend!
-- We want to send the invitations by email
-- There are two types of invitations: normal and VIP
-- Who is invited? Well of course our dear employees
-- The ones that worked bonus hours deserve to have a VIP invitation (the HR department decided that it should be 10 or more)
-- What about inviting the customers as well? After all, they played a big role in the company's growth in the past years
-- Moreover, the ones with at least 5 fidelity points deserve a VIP invitation
-- It has been decided that there will be 1000 places for the other customers
-- The ones who have spent the most on our electronics are prioritised
SELECT T.name AS Name, T.email AS Email, T.invitation AS Invitation
FROM (SELECT E1.name, E1.email, 'VIP' AS invitation
      FROM Employees E1
      WHERE E1.bonus_hours >= 10
      UNION
      (SELECT E2.name, E2.email, 'normal' AS invitation FROM Employees E2 WHERE E2.bonus_hours < 10)
      UNION
      (SELECT C1.name, C1.email, 'VIP' AS invitation FROM Customers C1 WHERE C1.fidelity_points >= 5)
      UNION
      (SELECT
       TOP 1000 PC_buyers.name, PC_buyers.email, 'normal' AS invitation
       FROM Customers C,
            (SELECT C2.customer_id,
                    C2.name,
                    C2.email,
                    ISNULL(Pod.amount * ((SELECT CP.price FROM CPUs CP WHERE CP.cpu_id = PC2.cpu_id) +
                                         (SELECT H.price FROM HDDs H WHERE H.hdd_id = PC2.hdd_id) +
                                         (SELECT M.price
                                           FROM Motherboards M
                                           WHERE M.motherboard_id = PC2.motherboard_id) +
                                         (SELECT R.price FROM RAMs R WHERE R.ram_id = PC2.ram_id) +
                                         (SELECT P.price
                                           FROM Power_supplies P
                                           WHERE P.power_supply_id = PC2.power_supply_id)
                        ),0) AS total
             FROM Customers C2
                      LEFT JOIN Orders O ON C2.customer_id = O.customer_id
                      LEFT JOIN PC_order_details Pod ON O.order_id = Pod.order_id
                      LEFT JOIN PCs PC2 ON Pod.pc_id = PC2.pc_id) AS PC_buyers,
            (SELECT C3.customer_id, C3.name, C3.email, ISNULL((Pod2.amount * P3.price), 0) AS total
             FROM Customers C3
                      LEFT JOIN Orders O ON C3.customer_id = O.customer_id
                      LEFT JOIN Peripheral_order_details Pod2 ON O.order_id = Pod2.order_id
                      LEFT JOIN Peripherals P3 ON Pod2.peripheral_id = P3.peripheral_id) AS Peripheral_buyers
       WHERE C.customer_id = PC_buyers.customer_id
         AND C.customer_id = Peripheral_buyers.customer_id
         AND C.fidelity_points < 5
       ORDER BY (PC_buyers.total + Peripheral_buyers.total) DESC)) AS T
ORDER BY T.name