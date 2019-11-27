CREATE OR ALTER PROCEDURE CreateTest(@Name NVARCHAR(200), @Tables NVARCHAR(1000), @Views NVARCHAR(1000))
AS
    INSERT INTO Tests (Name) VALUES (@Name)
    DECLARE @TestID INT = @@IDENTITY

    INSERT INTO TestTables (TestID, TableID, NoOfRows, Position)
            SELECT @TestID, T2.TableID, 200, T.position FROM (SELECT S.value AS name,
            row_number() OVER (ORDER BY current_timestamp) AS position
            FROM String_Split(@Tables, N';') S) T
            JOIN Tables T2 ON T2.Name = T.name

    INSERT INTO TestViews (TestID, ViewID)
            SELECT @TestID, V2.ViewID FROM String_Split(@Views, N';') S
            JOIN Views V2 ON V2.Name = S.value

GO

CREATE OR ALTER PROCEDURE InitTests
AS
    DELETE FROM TestTables
    DELETE FROM TestViews
    DELETE FROM Tests
    DELETE FROM Tables
    DELETE FROM Views

    INSERT INTO Tables (Name) VALUES ('Posters'), ('Reservations'), ('Companies')
    INSERT INTO Views (Name) VALUES ('PC_prices'), ('ReservationsPerDay'), ('ShowcasedCompanies')

    EXECUTE CreateTest 'Test1',
                        'Reservations;Companies;Posters',
                        'PC_prices;ReservationsPerDay;ShowcasedCompanies'

GO

CREATE OR ALTER PROCEDURE Test (@TestName NVARCHAR(200))
AS
    INSERT INTO TestRuns (Description) VALUES (@TestName)
    DECLARE @TestRunID INT = @@IDENTITY

    DECLARE
    @Id INT,
    @Name   NVARCHAR(200),
    @NoOfRows INT,
    @StartAt DATETIME,
    @EndAt DATETIME;

DECLARE @TableCursor CURSOR
FOR SELECT T2.TableID, T2.Name, TT.NoOfRows FROM Tests T JOIN TestTables TT ON T.TestID = TT.TestID JOIN Tables T2 ON TT.TableID = T2.TableID
    WHERE T.Name = @TestName
    ORDER BY Position

OPEN @TableCursor;

FETCH NEXT FROM @TableCursor INTO
    @Id,
    @Name,
    @NoOfRows;

WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @StartAt = current_timestamp
        -- TODO DELETE FROM sys.objects()
        FETCH NEXT FROM @TableCursor INTO
            @Id,
            @Name,
            @NoOfRows;
    END;

CLOSE @TableCursor;
DEALLOCATE @TableCursor;

    DECLARE @Views TABLE(ViewId INT, Name NVARCHAR(200)) SELECT V.ViewID, V.Name FROM Tests T JOIN TestViews TV ON T.TestID = TV.TestID JOIN Views V ON TV.ViewID = V.ViewID
    WHERE T.Name = @TestName
GO