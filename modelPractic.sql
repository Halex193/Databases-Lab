-- CREATE DATABASE ModelPractic ON (
--     NAME ='ModelPractic',
--     FILENAME ='D:\University\Databases\ModelPractic\ModelPractic.mdf')
-- USE ModelPractic

IF OBJECT_ID('RouteStations', 'U') IS NOT NULL
    DROP TABLE RouteStations
IF OBJECT_ID('Stations', 'U') IS NOT NULL
    DROP TABLE Stations
IF OBJECT_ID('Routes', 'U') IS NOT NULL
    DROP TABLE Routes
IF OBJECT_ID('Trains', 'U') IS NOT NULL
    DROP TABLE Trains
IF OBJECT_ID('TrainTypes', 'U') IS NOT NULL
    DROP TABLE TrainTypes


CREATE TABLE TrainTypes
(
    ttid        INT IDENTITY PRIMARY KEY,
    description NVARCHAR(500)
)

CREATE TABLE Trains
(
    tid  INT IDENTITY PRIMARY KEY,
    name NVARCHAR(500),
    ttid INT REFERENCES TrainTypes (ttid)
)

CREATE TABLE Routes
(
    rid  INT IDENTITY PRIMARY KEY,
    name NVARCHAR(500),
    tid  INT UNIQUE REFERENCES Trains (tid)
)

CREATE TABLE Stations
(
    sid  INT IDENTITY PRIMARY KEY,
    name NVARCHAR(500) UNIQUE
)
CREATE TABLE RouteStations
(
    rid       INT REFERENCES Routes (rid),
    sid       INT REFERENCES Stations (sid),
    arrival   TIME,
    departure TIME
        PRIMARY KEY (rid, sid)
)
GO

CREATE OR ALTER PROCEDURE StationOnRoute @Route NVARCHAR(500), @Station NVARCHAR(500), @Arrival TIME, @Departure TIME
AS
DECLARE
    @RouteID INT = (SELECT rid
                    FROM Routes
                    WHERE name = @Route)
DECLARE
    @StationID INT = (SELECT sid
                      FROM Stations
                      WHERE name = @Station)
    IF @RouteID IS NULL OR @StationID IS NULL
        BEGIN
            RAISERROR ('no such station / route', 16, 1)
            RETURN -1
        END
    IF EXISTS(SELECT *
              FROM RouteStations
              WHERE rid = @RouteID
                AND sid = @StationID)
        BEGIN
            UPDATE RouteStations
            SET arrival  = @Arrival,
                departure=@Departure
            WHERE rid = @RouteID
              AND sid = @StationID
        END
    ELSE
        BEGIN
            INSERT INTO RouteStations(rid, sid, arrival, departure) VALUES (@RouteID, @StationID, @Arrival, @Departure)
        END
GO

INSERT INTO TrainTypes VALUES ('regio'), ('interregio')
INSERT INTO Trains VALUES ('t1', 1), ('t2', 1),('t3', 1)
INSERT INTO Stations VALUES ('s1'), ('s2'), ('s3')
INSERT INTO Routes VALUES ('r1', 1), ('r2', 2), ('r3', 3)


SELECT * FROM TrainTypes
SELECT * FROM Trains
SELECT * FROM Stations
SELECT * FROM Routes
SELECT * FROM RouteStations

EXECUTE StationOnRoute 'r1', 's1', '6:10', '6:20'
EXECUTE StationOnRoute 'r1', 's2', '6:30', '6:40'
EXECUTE StationOnRoute 'r1', 's3', '6:45', '6:50'

CREATE OR ALTER VIEW RouteWithAllStations
AS
SELECT R.name
FROM Routes R
WHERE NOT EXISTS(
    SELECT S.sid
    FROM Stations S
    EXCEPT
    SELECT RS.sid
    FROM RouteStations RS
    WHERE RS.rid = R.rid)
GO

SELECT * FROM RouteWithAllStations

CREATE OR ALTER FUNCTION  FilterStationsByNumber(@R INT)  RETURNS TABLE
RETURN SELECT S.name
FROM Stations S
WHERE S.sid IN (
    SELECT RS.sid FROM RouteStations RS
    GROUP BY RS.sid HAVING COUNT(*) >= @R)

SELECT * FROM FilterStationsByNumber(1)