
-- --------------------------------------------------
-- Entity Designer DDL Script for SQL Server 2005, 2008, 2012 and Azure
-- --------------------------------------------------
-- Date Created: 01/06/2022 14:31:16
-- Generated from EDMX file: C:\Users\ivanm\Desktop\PPPK_Projects\DZ4\ChessGameManager\ChessGameManager\Model.edmx
-- --------------------------------------------------

SET QUOTED_IDENTIFIER OFF;
GO
USE [ChessGames];
GO
IF SCHEMA_ID(N'dbo') IS NULL EXECUTE(N'CREATE SCHEMA [dbo]');
GO

-- --------------------------------------------------
-- Dropping existing FOREIGN KEY constraints
-- --------------------------------------------------

IF OBJECT_ID(N'[dbo].[FK_ChessGameUploadedFile]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[UploadedFiles] DROP CONSTRAINT [FK_ChessGameUploadedFile];
GO
IF OBJECT_ID(N'[dbo].[FK_FirstPlayerChessGame]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[ChessGames] DROP CONSTRAINT [FK_FirstPlayerChessGame];
GO
IF OBJECT_ID(N'[dbo].[FK_SecondPlayerChessGame]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[ChessGames] DROP CONSTRAINT [FK_SecondPlayerChessGame];
GO

-- --------------------------------------------------
-- Dropping existing tables
-- --------------------------------------------------

IF OBJECT_ID(N'[dbo].[ChessGames]', 'U') IS NOT NULL
    DROP TABLE [dbo].[ChessGames];
GO
IF OBJECT_ID(N'[dbo].[UploadedFiles]', 'U') IS NOT NULL
    DROP TABLE [dbo].[UploadedFiles];
GO
IF OBJECT_ID(N'[dbo].[People]', 'U') IS NOT NULL
    DROP TABLE [dbo].[People];
GO

-- --------------------------------------------------
-- Creating all tables
-- --------------------------------------------------

-- Creating table 'ChessGames'
CREATE TABLE [dbo].[ChessGames] (
    [IDChessGame] int IDENTITY(1,1) NOT NULL,
    [Location] nvarchar(50)  NOT NULL,
    [SecondPlayer_IDPerson] int  NOT NULL,
    [FirstPlayer_IDPerson] int  NOT NULL
);
GO

-- Creating table 'UploadedFiles'
CREATE TABLE [dbo].[UploadedFiles] (
    [IDUploadedFille] int IDENTITY(1,1) NOT NULL,
    [Name] nvarchar(50)  NOT NULL,
    [ContentType] nvarchar(20)  NOT NULL,
    [Content] varbinary(max)  NOT NULL,
    [ChessGameIDChessGame] int  NOT NULL
);
GO

-- Creating table 'People'
CREATE TABLE [dbo].[People] (
    [IDPerson] int IDENTITY(1,1) NOT NULL,
    [FirstName] nvarchar(50)  NOT NULL,
    [LastName] nvarchar(50)  NOT NULL,
    [Age] int  NOT NULL,
    [Email] nvarchar(50)  NOT NULL
);
GO

-- --------------------------------------------------
-- Creating all PRIMARY KEY constraints
-- --------------------------------------------------

-- Creating primary key on [IDChessGame] in table 'ChessGames'
ALTER TABLE [dbo].[ChessGames]
ADD CONSTRAINT [PK_ChessGames]
    PRIMARY KEY CLUSTERED ([IDChessGame] ASC);
GO

-- Creating primary key on [IDUploadedFille] in table 'UploadedFiles'
ALTER TABLE [dbo].[UploadedFiles]
ADD CONSTRAINT [PK_UploadedFiles]
    PRIMARY KEY CLUSTERED ([IDUploadedFille] ASC);
GO

-- Creating primary key on [IDPerson] in table 'People'
ALTER TABLE [dbo].[People]
ADD CONSTRAINT [PK_People]
    PRIMARY KEY CLUSTERED ([IDPerson] ASC);
GO

-- --------------------------------------------------
-- Creating all FOREIGN KEY constraints
-- --------------------------------------------------

-- Creating foreign key on [ChessGameIDChessGame] in table 'UploadedFiles'
ALTER TABLE [dbo].[UploadedFiles]
ADD CONSTRAINT [FK_ChessGameUploadedFile]
    FOREIGN KEY ([ChessGameIDChessGame])
    REFERENCES [dbo].[ChessGames]
        ([IDChessGame])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_ChessGameUploadedFile'
CREATE INDEX [IX_FK_ChessGameUploadedFile]
ON [dbo].[UploadedFiles]
    ([ChessGameIDChessGame]);
GO

-- Creating foreign key on [SecondPlayer_IDPerson] in table 'ChessGames'
ALTER TABLE [dbo].[ChessGames]
ADD CONSTRAINT [FK_SecondPlayerChessGame]
    FOREIGN KEY ([SecondPlayer_IDPerson])
    REFERENCES [dbo].[People]
        ([IDPerson])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_SecondPlayerChessGame'
CREATE INDEX [IX_FK_SecondPlayerChessGame]
ON [dbo].[ChessGames]
    ([SecondPlayer_IDPerson]);
GO

-- Creating foreign key on [FirstPlayer_IDPerson] in table 'ChessGames'
ALTER TABLE [dbo].[ChessGames]
ADD CONSTRAINT [FK_FirstPlayerChessGame]
    FOREIGN KEY ([FirstPlayer_IDPerson])
    REFERENCES [dbo].[People]
        ([IDPerson])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_FirstPlayerChessGame'
CREATE INDEX [IX_FK_FirstPlayerChessGame]
ON [dbo].[ChessGames]
    ([FirstPlayer_IDPerson]);
GO

-- --------------------------------------------------
-- Script has ended
-- --------------------------------------------------