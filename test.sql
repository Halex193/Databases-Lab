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
    DELETE FROM TestRuns
    DELETE FROM TestRunTables
    DELETE FROM TestRunViews

    INSERT INTO Tables (Name) VALUES ('Posters'), ('Reservations'), ('Companies')
    INSERT INTO Views (Name) VALUES ('PC_prices'), ('ReservationsPerDay'), ('ShowcasedCompanies')

    EXECUTE CreateTest 'Test1',
                        'Reservations;Companies;Posters',
                        'PC_prices;ReservationsPerDay;ShowcasedCompanies'

GO

CREATE OR ALTER PROCEDURE Test (@TestName NVARCHAR(200))
AS
    INSERT INTO TestRuns (Description, StartAt) VALUES (@TestName, current_timestamp)
    DECLARE @TestRunID INT = @@IDENTITY

    DECLARE
    @Id INT,
    @Name   NVARCHAR(200),
    @NoOfRows INT,
    @StartAt DATETIME,
    @EndAt DATETIME;

    DECLARE TableCursor CURSOR FOR SELECT T2.TableID, T2.Name, TT.NoOfRows FROM Tests T JOIN TestTables TT ON T.TestID = TT.TestID JOIN Tables T2 ON TT.TableID = T2.TableID
        WHERE T.Name = @TestName
        ORDER BY Position

    OPEN TableCursor;

    FETCH NEXT FROM TableCursor INTO
        @Id,
        @Name,
        @NoOfRows;

    WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @StartAt = current_timestamp
            DECLARE @Statement NVARCHAR(4000)= N'DELETE FROM ' + @Name
            EXECUTE sp_executesql @Statement
            EXECUTE PopulateTable @Name, @NoOfRows
            SET @EndAt = current_timestamp

            INSERT INTO TestRunTables (TestRunID, TableID, StartAt, EndAt) VALUES (@TestRunID, @Id, @StartAt, @EndAt)

            FETCH NEXT FROM TableCursor INTO
                @Id,
                @Name,
                @NoOfRows;
        END;

    CLOSE TableCursor;
    DEALLOCATE TableCursor;

    DECLARE @Views TABLE(ViewId INT, Name NVARCHAR(200)) SELECT V.ViewID, V.Name FROM Tests T JOIN TestViews TV ON T.TestID = TV.TestID JOIN Views V ON TV.ViewID = V.ViewID
    WHERE T.Name = @TestName

    UPDATE TestRuns SET EndAt = current_timestamp WHERE TestRunID = @TestRunID
GO

CREATE OR ALTER PROCEDURE PopulateTable (@TableName NVARCHAR(200), @NoOfRows INT)
AS
    DECLARE @Columns TABLE(name NVARCHAR(200), type NVARCHAR(200), is_identity BIT, foreign_table NVARCHAR(200), foreign_column NVARCHAR(200))
    INSERT INTO @Columns SELECT C.name, TP.name AS type, C.is_identity, T2.name AS foreign_table, C2.name AS foreign_column
    FROM sys.tables T
         JOIN sys.schemas S ON T.schema_id = S.schema_id
         JOIN sys.columns C ON T.object_id = C.object_id
         JOIN sys.types TP ON C.user_type_id = TP.user_type_id
        LEFT JOIN sys.foreign_key_columns FC ON C.object_id = FC.parent_object_id AND C.column_id = FC.parent_column_id
    LEFT JOIN sys.columns C2 ON FC.referenced_column_id = C2.column_id AND FC.referenced_object_id = C2.object_id
    LEFT JOIN sys.tables T2 ON FC.referenced_object_id = T2.object_id
    WHERE S.name = 'dbo'
      AND T.name = @TableName

    DECLARE @NormalColumns NVARCHAR(4000)
    SELECT @NormalColumns = COALESCE(@NormalColumns + ', ', '') + name
    FROM @Columns
    WHERE foreign_column IS NULL AND is_identity = 0
    ORDER BY type, name

    PRINT @NormalColumns

    DECLARE @ForeignColumns NVARCHAR(4000)
    SELECT @ForeignColumns = COALESCE(@ForeignColumns + ', ', '') + name
    FROM @Columns
    WHERE foreign_column IS NOT NULL AND is_identity = 0
    ORDER BY type, name

    DECLARE @count INT = 0
    WHILE @count < @NoOfRows
    BEGIN
        DECLARE @IntValues NVARCHAR(4000) = N''
        SELECT @IntValues = COALESCE(@IntValues + ', ', '') + ROUND(400*RAND(), 0)
        FROM @Columns
        WHERE foreign_column IS NULL AND is_identity = 0 AND type = 'int'
        ORDER BY name

        DECLARE @StringValues VARCHAR(4000)
        SELECT @StringValues = COALESCE(@StringValues + ', ', '') + 'RANDOM_STRING'
        FROM @Columns
        WHERE foreign_column IS NULL AND is_identity = 0 AND type = 'nvarchar'
        ORDER BY name

        DECLARE @Result NVARCHAR(4000) = ''
        IF NOT @IntValues = ''
            BEGIN
                SET @Result = @Result + @IntValues
            END

        IF NOT @StringValues = ''
            BEGIN
                IF NOT @Result = ''
                    BEGIN
                        SET @Result = @Result + ',' + @StringValues
                    END
                 ELSE
                    BEGIN
                        SET @Result = @Result + @StringValues
                    END
            END

        DECLARE @Statement NVARCHAR(4000) = N'INSERT INTO '+@TableName+'('+ @NormalColumns +') VALUES ('+@Result+')'
        EXECUTE sp_executesql @Statement
        SET @count = @count + 1
    END

GO