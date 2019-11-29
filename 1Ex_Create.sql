use [master];
ALTER DATABASE BlogDB SET OFFLINE WITH ROLLBACK IMMEDIATE;
Go
ALTER DATABASE BlogDB SET ONLINE;
Go
DROP DATABASE BlogDB;
Go
/* Create database */
CREATE DATABASE BlogDB;
GO

/* Use current*/
USE BlogDB;
GO

/*Create tables */
CREATE TABLE Languages (
    LanguageId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    LanguageName NVARCHAR(255) NOT NULL
);

CREATE TABLE Themes (
    ThemeId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ThemeName NVARCHAR(255) NOT NULL
);

CREATE TABLE Countries (
    CountryId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    CountryName NVARCHAR(255) NOT NULL
);

CREATE TABLE Cities (
    CityName NVARCHAR(255) NOT NULL,
    CityId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,

    CountryId INT NOT NULL

    CONSTRAINT FK_Countries_Cities FOREIGN KEY (CountryId)
    REFERENCES Countries (CountryId)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

CREATE TABLE Users (
    UserName NVARCHAR(255) NOT NULL,
    UserId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	UserLastActivity SMALLDATETIME,

    CityId INT

    CONSTRAINT FK_Cities_Users FOREIGN KEY (CityId)
    REFERENCES Cities (CityId)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

CREATE TABLE Posts (
    PostTitle NVARCHAR(255) NOT NULL,
	PostText NVARCHAR(255) NOT NULL,
	PostDate SMALLDATETIME,
    PostId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,

	AuthorId INT

    CONSTRAINT FK_Users_Posts FOREIGN KEY (AuthorId)
    REFERENCES Users (UserId)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

    ThemeId INT

    CONSTRAINT FK_Themes_Posts FOREIGN KEY (ThemeId)
    REFERENCES Themes (ThemeId)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

	LanguageId INT

    CONSTRAINT FK_Languages_Posts FOREIGN KEY (LanguageId)
    REFERENCES Languages (LanguageId)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION    
);

CREATE TABLE Likes (
    PostId INT NOT NULL

    CONSTRAINT FK_Posts_Likes FOREIGN KEY (PostId)
    REFERENCES Posts (PostId)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

	UserId INT

    CONSTRAINT FK_Users_Likes FOREIGN KEY (UserId)
    REFERENCES Users (UserId)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION    
);

CREATE TABLE Comments (
	PostText NVARCHAR(255) NOT NULL,
    CommentId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,

    PostId INT NOT NULL

    CONSTRAINT FK_Posts_Comments FOREIGN KEY (PostId)
    REFERENCES Posts (PostId)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

	UserId INT

    CONSTRAINT FK_Users_Comments FOREIGN KEY (UserId)
    REFERENCES Users (UserId)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION    
);