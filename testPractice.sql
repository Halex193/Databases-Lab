IF OBJECT_ID('Orders', 'U') IS NOT NULL
    DROP TABLE Orders

IF OBJECT_ID('Contained', 'U') IS NOT NULL
    DROP TABLE Contained

IF OBJECT_ID('Shoes', 'U') IS NOT NULL
    DROP TABLE Shoes

IF OBJECT_ID('ShoeModels', 'U') IS NOT NULL
    DROP TABLE ShoeModels

IF OBJECT_ID('Women', 'U') IS NOT NULL
    DROP TABLE Women

IF OBJECT_ID('PresentationShops', 'U') IS NOT NULL
    DROP TABLE PresentationShops

CREATE TABLE PresentationShops
(
    PSID INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(500),
    City NVARCHAR(500)
)

CREATE TABLE ShoeModels
(
    SMID   INT IDENTITY PRIMARY KEY,
    Name   NVARCHAR(500),
    Season NVARCHAR(500),
)

CREATE TABLE Shoes
(
    SID   INT IDENTITY PRIMARY KEY,
    Price INT,
    SM    INT
        CONSTRAINT FK_Shoes_SM REFERENCES ShoeModels (SMID)
)

CREATE TABLE Contained
(
    SID  INT REFERENCES Shoes (SID),
    PSID INT REFERENCES PresentationShops (PSID),
    Nr   INT
        PRIMARY KEY (SID, PSID)
)

CREATE TABLE Women
(
    WID       INT IDENTITY PRIMARY KEY,
    Name      NVARCHAR(500),
    MaxAmount INT
)

CREATE TABLE Orders
(
    WID    INT REFERENCES Women (WID),
    SID    INT REFERENCES Shoes (SID),
    Nr     INT,
    Amount INT
        PRIMARY KEY (WID, SID)
)

GO

CREATE OR ALTER PROCEDURE AddShoeToShop(@ShoeId INT, @Shop NVARCHAR(500), @Nr INT)
AS
DECLARE
    @ShopId INT = (SELECT PSID
                   FROM PresentationShops
                   WHERE Name = @Shop)
    IF @ShopId IS NULL
        BEGIN
            RAISERROR ('SHop does not exist', 16, 1)
        END
    IF EXISTS(SELECT *
              FROM Contained
              WHERE SID = @ShoeId
                AND PSID = @ShopId)
        BEGIN
            UPDATE Contained
            SET Nr = Nr + @Nr
            WHERE SID = @ShoeId
              AND PSID = @ShopId
        END
    ELSE
        BEGIN
            INSERT INTO Contained (SID, PSID, Nr) VALUES (@ShoeId, @ShopId, @Nr)
        END
GO


CREATE OR ALTER VIEW WomenVIew
AS
SELECT W1.Name, W1.MaxAmount, W1.WID
FROM Women W1
WHERE W1.WID IN
      (
          SELECT W.WID
          FROM Women W
                   JOIN Orders O ON W.WID = O.WID
                   JOIN Shoes S ON O.SID = S.SID
                   JOIN ShoeModels SM ON S.SM = SM.SMID
          WHERE SM.Name = 'SomeModel'
          GROUP BY W.WID
          HAVING COUNT(O.SID) >= 2)
GO

CREATE OR ALTER FUNCTION uf_ShoesInShops(@T INT)
    RETURNS TABLE
        RETURN SELECT S1.SID, S1.Price
               FROM Shoes S1
               WHERE S1.SID IN (SELECT S.SID
                                FROM Shoes S
                                         JOIN Contained C ON S.SID = C.SID
                                WHERE C.Nr > 0
                                GROUP BY S.SID
                                HAVING COUNT(C.PSID) >= @T)
GO

INSERT INTO PresentationShops(Name, City) VALUES ('Magazin1', 'Oras1'), ('Magazin2', 'Oras2'), ('Magazin3', 'Oras3')
INSERT INTO ShoeModels(Name, Season) VALUES ('Adibas', 'Vara'), ('Pluma', 'Iarna'), ('Adibas Moar', 'Vara')
INSERT INTO Shoes(Price, SM) VALUES (200, 1), (300, 2), (400, 3)
INSERT INTO Contained(SID, PSID, Nr) VALUES (1, 1, 3), (2, 3, 3), (3, 2, 4)
INSERT INTO Women(Name, MaxAmount) VALUES ('W1', 300), ('W2', 900), ('W3', 1000)
INSERT INTO Orders(WID, SID, Nr, Amount) VALUES (1, 2, 3, 400), (3, 1, 3, 300), (2, 2, 3, 500)

SELECT * FROM PresentationShops
SELECT * FROM ShoeModels
SELECT * FROM Shoes
SELECT * FROM Contained
SELECT * FROM Women
SELECT * FROM Orders
EXECUTE AddShoeToShop 1, 'Magazin1', 10
SELECT * FROM WomenVIew
SELECT * FROM uf_ShoesInShops(3)