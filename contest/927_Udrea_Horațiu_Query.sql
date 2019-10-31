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