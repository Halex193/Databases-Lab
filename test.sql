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

    EXECUTE CreateTest 'Test1',
                        'Reservations;Companies;Posters',
                        'PC_prices;ReservationsPerDay;ShowcasedCompanies'
--     EXECUTE CreateTest 'Test2',
--                             'Reservations;Companies;Posters;Orders;NO_TABLE',
--                             'PC_prices;ReservationsPerDay;SOMETHING_ELSE'
--     EXECUTE CreateTest 'Test3', '', ''

GO

CREATE OR ALTER PROCEDURE CreateTest(@Name NVARCHAR(200), @Tables NVARCHAR(1000), @Views NVARCHAR(1000))
AS
    DECLARE @Test NVARCHAR(4000) = NULL
    SELECT @Test = TestID FROM Tests WHERE Name = @Name
    IF @Test IS NOT NULL
        PRINT 'Test "' + @Name + '" already exists and therefore it will not be created'
    ELSE
        BEGIN
    DECLARE @ObjectId INT = NULL
    IF @Tables = '' AND @Views = ''
        PRINT 'No tables or views, test will not be created'
    ELSE
        BEGIN
            INSERT INTO Tests (Name) VALUES (@Name)
            DECLARE @TestID INT = @@IDENTITY

            --Tables
            DECLARE @TableName NVARCHAR(4000), @Position INT
            DECLARE TableCursor CURSOR FOR SELECT S.value AS name,
            row_number() OVER (ORDER BY current_timestamp) AS position
            FROM String_Split(@Tables, N';') S

            OPEN TableCursor;

            FETCH NEXT FROM TableCursor INTO
                @TableName,
                @Position;
            DECLARE @TableId INT;

            WHILE @@FETCH_STATUS = 0
            BEGIN
                SET @ObjectId = NULL
                SELECT @ObjectId = object_id FROM sys.objects WHERE name = @TableName AND type = 'U'
                IF @ObjectId IS NULL
                    PRINT 'Table "' + @TableName + '" does not exist and will be ignored'
                ELSE
                    BEGIN
                        SET @TableId = NULL
                        SELECT @TableId = TableID FROM Tables WHERE Name = @TableName
                        IF @TableId IS NULL
                            BEGIN
                                INSERT INTO Tables (Name) VALUES (@TableName)
                                SET @TableId = @@IDENTITY
                            END

                        INSERT INTO TestTables (TestID, TableID, NoOfRows, Position) VALUES (@TestID, @TableId, 200, @Position)
                    END


                FETCH NEXT FROM TableCursor INTO
                    @TableName,
                    @Position;
            END;

            CLOSE TableCursor
            DEALLOCATE TableCursor

            --Views
            DECLARE @ViewName NVARCHAR(4000)
            DECLARE ViewCursor CURSOR FOR SELECT S.value AS name FROM String_Split(@Views, N';') S

            OPEN ViewCursor;

            FETCH NEXT FROM ViewCursor INTO
                @ViewName;

            DECLARE @ViewId INT;
            WHILE @@FETCH_STATUS = 0
            BEGIN
                SET @ObjectId = NULL
                SELECT @ObjectId = object_id FROM sys.objects WHERE name = @ViewName AND type = 'V'
                IF @ObjectId IS NULL
                    PRINT 'View "' + @ViewName + '" does not exist and will be ignored'
                ELSE
                    BEGIN
                        SET @ViewId = NULL
                        SELECT @ViewId = ViewID FROM Views WHERE Name = @ViewName
                        IF @ViewId IS NULL
                            BEGIN
                                INSERT INTO Views (Name) VALUES (@ViewName)
                                SET @ViewId = @@IDENTITY
                            END

                        INSERT INTO TestViews (TestID, ViewID) VALUES (@TestID, @ViewId)
                    END


                FETCH NEXT FROM ViewCursor INTO
                    @ViewName;
            END;

            CLOSE ViewCursor
            DEALLOCATE ViewCursor
        END
    END
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

    DECLARE TableCursor2 CURSOR FOR SELECT T2.Name FROM Tests T JOIN TestTables TT ON T.TestID = TT.TestID JOIN Tables T2 ON TT.TableID = T2.TableID
        WHERE T.Name = @TestName
        ORDER BY Position

    OPEN TableCursor2;

    FETCH NEXT FROM TableCursor2 INTO
        @Name;

    WHILE @@FETCH_STATUS = 0
        BEGIN
            DECLARE @Statement NVARCHAR(4000)= N'DELETE FROM ' + @Name
            EXECUTE sp_executesql @Statement

            FETCH NEXT FROM TableCursor2 INTO
                @Name;
        END;

    CLOSE TableCursor2;
    DEALLOCATE TableCursor2;


    DECLARE TableCursor CURSOR FOR SELECT T2.TableID, T2.Name, TT.NoOfRows FROM Tests T JOIN TestTables TT ON T.TestID = TT.TestID JOIN Tables T2 ON TT.TableID = T2.TableID
        WHERE T.Name = @TestName
        ORDER BY Position DESC

    OPEN TableCursor;

    FETCH NEXT FROM TableCursor INTO
        @Id,
        @Name,
        @NoOfRows;

    WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @StartAt = current_timestamp
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

    DECLARE
    @ViewId INT,
    @ViewName   NVARCHAR(200),
    @ViewStartAt DATETIME,
    @ViewEndAt DATETIME;

    DECLARE ViewCursor CURSOR FOR SELECT V.ViewID, V.Name FROM Tests T JOIN TestViews TV ON T.TestID = TV.TestID JOIN Views V ON TV.ViewID = V.ViewID
    WHERE T.Name = @TestName

    OPEN ViewCursor;

    FETCH NEXT FROM ViewCursor INTO
        @ViewId,
        @ViewName;

    WHILE @@FETCH_STATUS = 0
        BEGIN
            DECLARE @ViewStatement NVARCHAR(4000)= N'SELECT * FROM ' + @ViewName
            SET @ViewStartAt = current_timestamp
            EXECUTE sp_executesql @ViewStatement
            SET @ViewEndAt = current_timestamp

            INSERT INTO TestRunViews (TestRunID, ViewID, StartAt, EndAt) VALUES (@TestRunID, @ViewId, @ViewStartAt, @ViewEndAt)

            FETCH NEXT FROM ViewCursor INTO
                @ViewId,
                @ViewName;
        END;

    CLOSE ViewCursor;
    DEALLOCATE ViewCursor;

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

    DECLARE @ForeignColumnName NVARCHAR(4000)
    DECLARE @ForeignTable NVARCHAR(4000)
    DECLARE @ForeignColumn NVARCHAR(4000)
    DECLARE @ForeignMIN INT
    DECLARE @ForeignMAX INT

    SELECT TOP 1 @ForeignColumnName = name, @ForeignTable = foreign_table, @ForeignColumn = foreign_column
    FROM @Columns
    WHERE foreign_column IS NOT NULL AND is_identity = 0 AND type = 'int'
    ORDER BY type, name

    DECLARE @ColumnNames NVARCHAR(4000) = @NormalColumns

    IF NOT @ForeignColumnName = ''
        BEGIN
            SET @ColumnNames = @ColumnNames + ',' + @ForeignColumnName
            DECLARE @queryMIN NVARCHAR(4000) = 'SELECT @min = MIN('+@ForeignColumn+') FROM '+@ForeignTable
            EXECUTE sp_executesql @queryMIN, N'@min INT OUTPUT', @min = @ForeignMIN OUTPUT

            DECLARE @queryMAX NVARCHAR(4000) = 'SELECT @max = MAX('+@ForeignColumn+') FROM '+@ForeignTable
            EXECUTE sp_executesql @queryMAX, N'@max INT OUTPUT', @max = @ForeignMAX OUTPUT

        END

    DECLARE @count INT = 0
    DECLARE @IntValues NVARCHAR(4000)
    DECLARE @DateValues NVARCHAR(4000)
    DECLARE @StringValues NVARCHAR(4000)
    DECLARE @ForeignValue NVARCHAR(4000)
    DECLARE @Values NVARCHAR(4000)
    DECLARE @Statement NVARCHAR(4000)

    WHILE @count < @NoOfRows
    BEGIN
        SET @IntValues = NULL
        SELECT @IntValues = COALESCE(@IntValues + ', ', '') + ROUND(400*RAND(), 0)
        FROM @Columns
        WHERE foreign_column IS NULL AND is_identity = 0 AND type = 'int'
        ORDER BY name

        SET @DateValues = NULL
        SELECT @DateValues = COALESCE(@DateValues + ', ', '') + N''+char(39)+CONVERT(nvarchar,ROUND(200*RAND()+1805, 0))+'-12-'+CONVERT(nvarchar,ROUND(11*RAND()+1, 0))+char(39)
        FROM @Columns
        WHERE foreign_column IS NULL AND is_identity = 0 AND type = 'date'
        ORDER BY name

        SET @StringValues = NULL
        SELECT @StringValues = COALESCE(@StringValues + ', ', '') + N''+char(39)+'RANDOM_STRING'+CONVERT(nvarchar,ROUND(400*RAND(), 0)) +char(39)
        FROM @Columns
        WHERE foreign_column IS NULL AND is_identity = 0 AND type = 'nvarchar'
        ORDER BY name

        SET @ForeignValue = CONVERT(nvarchar,ROUND((@ForeignMAX - @ForeignMIN)*RAND() + @ForeignMIN, 0))

        SET @Values = N''
        IF NOT @IntValues = ''
            BEGIN
                SET @Values = @Values + ',' + @IntValues
            END
        IF NOT @DateValues = N''
            BEGIN
             SET @Values = @Values + ',' + @DateValues
            END
        IF NOT @StringValues = N''
            BEGIN
             SET @Values = @Values + ',' + @StringValues
            END

        IF NOT @ForeignColumnName = ''
        BEGIN
            SET @Values = @Values + ',' + @ForeignValue
        END

        SET @Values = STUFF(@Values, 1, 1, '')
        SET @Statement = N'INSERT INTO '+@TableName+' ('+ @ColumnNames +') VALUES ('+@Values+')'
        EXECUTE sp_executesql @Statement
        SET @count = @count + 1
    END
    PRINT 'Sample: ' + @Statement

GO