SELECT * FROM Posters WHERE poster_id = 1 -- Clustered Index Seek
SELECT * FROM Posters -- Clustered Index Scan
SELECT * FROM Posters WHERE slot = 5 -- Index Seek
SELECT slot FROM Posters -- Index Scan
SELECT * FROM Posters WHERE slot = 5 -- Key Lookup

SELECT * FROM Companies WHERE bank_account = 5567