--https://course.sgu.ru/mod/assign/view.php?id=36324

use BlogDB
go

CREATE VIEW ACTIVE_COUNTRIES
WITH ENCRYPTION
AS
    Select CountryName
    FROM Countries AS u 
    WHERE EXISTS 
    (SELECT * FROM Cities as c
		inner Join Users z on z.CityId = c.CityId
        WHERE u.CountryId = c.CountryId 
    )
GO

sp_helptext @objName = ACTIVE_COUNTRIES
Go

CREATE VIEW POST_POPULARITY
AS
    SELECT p.PostId, 
	((Select COUNT(l.PostId) from Likes l where l.PostId = p.PostId) +
	(Select COUNT(c.PostId) from Comments c where c.PostId = p.PostId)) AS POPULARITY
	FROM Posts p 
GO

CREATE VIEW AUTORS_POPULARITY
AS
    SELECT u.UserName,
	((Select COUNT(l.PostId) from Likes l, posts p where (l.PostId = p.PostId) AND (p.AuthorId = u.UserId)) 
   + (Select COUNT(c.PostId) from Comments c, posts p where (c.PostId = p.PostId) AND (p.AuthorId = u.UserId))) AS POPULARITY
	FROM Users u
	where Exists (select PostId from posts p where p.AuthorId = u.UserId)
GO

CREATE VIEW COMMENTS_AUTHORS
AS
    SELECT u.UserName,
	(Select COUNT(c.UserId) from Comments c where c.UserId = u.UserId) AS COUNTS_OF_COMMENTS
	FROM Users u
	where Exists (select PostId from posts p where p.AuthorId = u.UserId)
GO

--2
CREATE VIEW CORRECT_USERS 
AS
    SELECT UserName, UserLastActivity
	FROM Users
	where UserLastActivity is not null
	WITH CHECK OPTION
GO

Insert Into CORRECT_USERS (UserName, UserLastActivity) SELECT u.UserName, u.UserLastActivity FROM Users u where u.UserId = 114
Insert Into CORRECT_USERS (UserName, UserLastActivity) SELECT u.UserName, u.UserLastActivity FROM Users u where u.UserId = 2
Go

--3
--SET NUMERIC_ROUNDABORT OFF;  
--SET ANSI_PADDING, ANSI_WARNINGS,
--    CONCAT_NULL_YIELDS_NULL, ARITHABORT,  
--    QUOTED_IDENTIFIER, ANSI_NULLS ON; 
--GO

CREATE VIEW Like_List
WITH SCHEMABINDING 
AS
    SELECT UserId, PostId FROM dbo.Likes
GO
--Clust
CREATE UNIQUE CLUSTERED INDEX IX_Likes on
Like_List(UserId, PostId)
GO

SELECT UserId, PostId FROM Like_List
Go
SELECT UserId, PostId FROM Like_List With(NOEXPAND)
Go

--End