SELECT * FROM Posters WHERE poster_id = 1 -- Clustered Index Seek
SELECT * FROM Posters -- Clustered Index Scan
SELECT slot FROM Posters WHERE slot > 5 -- Index Seek
SELECT slot FROM Posters -- Index Scan
SELECT * FROM Posters WHERE slot = 5 -- Key Lookup

SELECT * FROM Companies WHERE bank_account = 42 -- Clustered Index Scan: 0.0033073

CREATE NONCLUSTERED INDEX IDX_bank_account
ON Companies(bank_account)

SELECT * FROM Companies WHERE bank_account = 42 -- Index Seek: 0.0032831

CREATE OR ALTER VIEW CompanySlots
AS
    SELECT C.company_id, COUNT(P.slot) AS number FROM Companies C
        JOIN Reservations R2 ON C.company_id = R2.company_id
        JOIN Posters P ON R2.poster_id = P.poster_id
        WHERE P.slot > 3 AND bank_account > 5
        GROUP BY C.company_id


SELECT * FROM CompanySlots -- 0.0230778

CREATE NONCLUSTERED INDEX IDX_Reservations_Company_id
ON Reservations(company_id)

SELECT * FROM CompanySlots -- 0.0161204