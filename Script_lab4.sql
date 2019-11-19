CREATE OR ALTER PROCEDURE CreateTestTables
AS
    CREATE TABLE [Tables]
    (

        [TableID] [int] IDENTITY (1, 1)                               NOT NULL,

        [Name]    [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL

    ) ON [PRIMARY]


    CREATE TABLE [TestRunTables]
    (

        [TestRunID] [int]      NOT NULL,

        [TableID]   [int]      NOT NULL,

        [StartAt]   [datetime] NOT NULL,

        [EndAt]     [datetime] NOT NULL

    ) ON [PRIMARY]


    CREATE TABLE [TestRunViews]
    (

        [TestRunID] [int]      NOT NULL,

        [ViewID]    [int]      NOT NULL,

        [StartAt]   [datetime] NOT NULL,

        [EndAt]     [datetime] NOT NULL

    ) ON [PRIMARY]


    CREATE TABLE [TestRuns]
    (

        [TestRunID]   [int] IDENTITY (1, 1)                                 NOT NULL,

        [Description] [nvarchar](2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,

        [StartAt]     [datetime]                                            NULL,

        [EndAt]       [datetime]                                            NULL

    ) ON [PRIMARY]


    CREATE TABLE [TestTables]
    (

        [TestID]   [int] NOT NULL,

        [TableID]  [int] NOT NULL,

        [NoOfRows] [int] NOT NULL,

        [Position] [int] NOT NULL

    ) ON [PRIMARY]


    CREATE TABLE [TestViews]
    (

        [TestID] [int] NOT NULL,

        [ViewID] [int] NOT NULL

    ) ON [PRIMARY]


    CREATE TABLE [Tests]
    (

        [TestID] [int] IDENTITY (1, 1)                               NOT NULL,

        [Name]   [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL

    ) ON [PRIMARY]


    CREATE TABLE [Views]
    (

        [ViewID] [int] IDENTITY (1, 1)                               NOT NULL,

        [Name]   [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL

    ) ON [PRIMARY]


    ALTER TABLE [Tables]
        WITH NOCHECK ADD
            CONSTRAINT [PK_Tables] PRIMARY KEY CLUSTERED
                (
                 [TableID]
                    ) ON [PRIMARY]


    ALTER TABLE [TestRunTables]
        WITH NOCHECK ADD
            CONSTRAINT [PK_TestRunTables] PRIMARY KEY CLUSTERED
                (
                 [TestRunID],
                 [TableID]
                    ) ON [PRIMARY]


    ALTER TABLE [TestRunViews]
        WITH NOCHECK ADD
            CONSTRAINT [PK_TestRunViews] PRIMARY KEY CLUSTERED
                (
                 [TestRunID],
                 [ViewID]
                    ) ON [PRIMARY]


    ALTER TABLE [TestRuns]
        WITH NOCHECK ADD
            CONSTRAINT [PK_TestRuns] PRIMARY KEY CLUSTERED
                (
                 [TestRunID]
                    ) ON [PRIMARY]


    ALTER TABLE [TestTables]
        WITH NOCHECK ADD
            CONSTRAINT [PK_TestTables] PRIMARY KEY CLUSTERED
                (
                 [TestID],
                 [TableID]
                    ) ON [PRIMARY]


    ALTER TABLE [TestViews]
        WITH NOCHECK ADD
            CONSTRAINT [PK_TestViews] PRIMARY KEY CLUSTERED
                (
                 [TestID],
                 [ViewID]
                    ) ON [PRIMARY]


    ALTER TABLE [Tests]
        WITH NOCHECK ADD
            CONSTRAINT [PK_Tests] PRIMARY KEY CLUSTERED
                (
                 [TestID]
                    ) ON [PRIMARY]


    ALTER TABLE [Views]
        WITH NOCHECK ADD
            CONSTRAINT [PK_Views] PRIMARY KEY CLUSTERED
                (
                 [ViewID]
                    ) ON [PRIMARY]


    ALTER TABLE [TestRunTables]
        ADD
            CONSTRAINT [FK_TestRunTables_Tables] FOREIGN KEY
                (
                 [TableID]
                    ) REFERENCES [Tables] (
                                           [TableID]
                    ) ON DELETE CASCADE ON UPDATE CASCADE ,

            CONSTRAINT [FK_TestRunTables_TestRuns] FOREIGN KEY
                (
                 [TestRunID]
                    ) REFERENCES [TestRuns] (
                                             [TestRunID]
                    ) ON DELETE CASCADE ON UPDATE CASCADE
    ALTER TABLE [TestRunViews]
        ADD
            CONSTRAINT [FK_TestRunViews_TestRuns] FOREIGN KEY
                (
                 [TestRunID]
                    ) REFERENCES [TestRuns] (
                                             [TestRunID]
                    ) ON DELETE CASCADE ON UPDATE CASCADE ,

            CONSTRAINT [FK_TestRunViews_Views] FOREIGN KEY
                (
                 [ViewID]
                    ) REFERENCES [Views] (
                                          [ViewID]
                    ) ON DELETE CASCADE ON UPDATE CASCADE
    ALTER TABLE [TestTables]
        ADD
            CONSTRAINT [FK_TestTables_Tables] FOREIGN KEY
                (
                 [TableID]
                    ) REFERENCES [Tables] (
                                           [TableID]
                    ) ON DELETE CASCADE ON UPDATE CASCADE ,

            CONSTRAINT [FK_TestTables_Tests] FOREIGN KEY
                (
                 [TestID]
                    ) REFERENCES [Tests] (
                                          [TestID]
                    ) ON DELETE CASCADE ON UPDATE CASCADE
    ALTER TABLE [TestViews]
        ADD
            CONSTRAINT [FK_TestViews_Tests] FOREIGN KEY
                (
                 [TestID]
                    ) REFERENCES [Tests] (
                                          [TestID]
                    ),

            CONSTRAINT [FK_TestViews_Views] FOREIGN KEY
                (
                 [ViewID]
                    ) REFERENCES [Views] (
                                          [ViewID]
                    )
GO

CREATE OR ALTER PROCEDURE DropTestTables
AS
    IF exists(SELECT *
              FROM dbo.sysobjects
              WHERE id = object_id(N'[FK_TestRunTables_Tables]')
                AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
    ALTER TABLE [TestRunTables]
        DROP CONSTRAINT FK_TestRunTables_Tables
    IF exists(SELECT *
              FROM dbo.sysobjects
              WHERE id = object_id(N'[FK_TestTables_Tables]')
                AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
    ALTER TABLE [TestTables]
        DROP CONSTRAINT FK_TestTables_Tables
    IF exists(SELECT *
              FROM dbo.sysobjects
              WHERE id = object_id(N'[FK_TestRunTables_TestRuns]')
                AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
    ALTER TABLE [TestRunTables]
        DROP CONSTRAINT FK_TestRunTables_TestRuns
    IF exists(SELECT *
              FROM dbo.sysobjects
              WHERE id = object_id(N'[FK_TestRunViews_TestRuns]')
                AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
    ALTER TABLE [TestRunViews]
        DROP CONSTRAINT FK_TestRunViews_TestRuns
    IF exists(SELECT *
              FROM dbo.sysobjects
              WHERE id = object_id(N'[FK_TestTables_Tests]')
                AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
    ALTER TABLE [TestTables]
        DROP CONSTRAINT FK_TestTables_Tests
    IF exists(SELECT *
              FROM dbo.sysobjects
              WHERE id = object_id(N'[FK_TestViews_Tests]')
                AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
    ALTER TABLE [TestViews]
        DROP CONSTRAINT FK_TestViews_Tests
    IF exists(SELECT *
              FROM dbo.sysobjects
              WHERE id = object_id(N'[FK_TestRunViews_Views]')
                AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
    ALTER TABLE [TestRunViews]
        DROP CONSTRAINT FK_TestRunViews_Views
    IF exists(SELECT *
              FROM dbo.sysobjects
              WHERE id = object_id(N'[FK_TestViews_Views]')
                AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
    ALTER TABLE [TestViews]
        DROP CONSTRAINT FK_TestViews_Views
    IF exists(SELECT *
              FROM dbo.sysobjects
              WHERE id = object_id(N'[Tables]')
                AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
        DROP TABLE [Tables]


    IF exists(SELECT *
              FROM dbo.sysobjects
              WHERE id = object_id(N'[TestRunTables]')
                AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
        DROP TABLE [TestRunTables]


    IF exists(SELECT *
              FROM dbo.sysobjects
              WHERE id = object_id(N'[TestRunViews]')
                AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
        DROP TABLE [TestRunViews]


    IF exists(SELECT *
              FROM dbo.sysobjects
              WHERE id = object_id(N'[TestRuns]')
                AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
        DROP TABLE [TestRuns]


    IF exists(SELECT *
              FROM dbo.sysobjects
              WHERE id = object_id(N'[TestTables]')
                AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
        DROP TABLE [TestTables]


    IF exists(SELECT *
              FROM dbo.sysobjects
              WHERE id = object_id(N'[TestViews]')
                AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
        DROP TABLE [TestViews]


    IF exists(SELECT *
              FROM dbo.sysobjects
              WHERE id = object_id(N'[Tests]')
                AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
        DROP TABLE [Tests]


    IF exists(SELECT *
              FROM dbo.sysobjects
              WHERE id = object_id(N'[Views]')
                AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
        DROP TABLE [Views]
GO