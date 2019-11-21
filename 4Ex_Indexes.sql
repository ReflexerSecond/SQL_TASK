Use BlogDB
Go

CREATE Unique NONCLUSTERED INDEX IX_Users 
ON Users (UserName)
GO

--select * from Users WITH(Index(IX_Users))

CREATE NONCLUSTERED INDEX IX_INCLUDE_USERS
  ON Users (UserName)
  INCLUDE (CityId);
GO

--CREATE NONCLUSTERED INDEX IX_FullUSER
--ON Users (UserName, CityId)
--WHERE CityId IS NOT NULL;
--GO

--ALTER INDEX IX_Users ON Users
--  REORGANIZE
--GO

CREATE CLUSTERED INDEX IX_Likes
ON Likes (UserId)
GO

--CREATE NONCLUSTERED INDEX IX_Likes2
--ON Likes (PostId)
--GO

--select * from Likes WITH(Index(IX_Likes))
--Select * from Likes WITH(Index(IX_Likes2))

CREATE NONCLUSTERED INDEX IX_Posts_with_theme
ON Posts (PostId)
INCLUDE (PostTitle,ThemeId)
WHERE ThemeId is NOT Null
GO

--Select * from Posts where ThemeId is not null
--Select * from Posts WITH(Index(IX_Posts_with_theme)) where ThemeId is not null
--Select PostTitle,ThemeId from Posts WITH(Index(IX_Posts_with_theme)) where ThemeId is not null

CREATE NONCLUSTERED INDEX IX_Country
  ON Countries (CountryName Desc)
  WITH ( DATA_COMPRESSION = ROW )
GO

--Select CountryName from Countries


SELECT UserId, PostId
from Users u WITH(Index(IX_Users)) RIGHT OUTER JOIN Posts p
ON u.UserId = p.AuthorId
WHERE UserName like N'¿%' 

SELECT REPLACE(UserName,'¿','¡'), PostId
from Users u WITH(Index(IX_Users)) LEFT OUTER JOIN Posts p
ON u.UserId = p.AuthorId

SELECT USERNAME
from Users u WITH(Index(IX_Users)) FULL OUTER JOIN Posts p
ON u.UserId = p.AuthorId
GROUP BY UserName, PostId
HAVING POSTID IS NULL

SELECT UserId, POSTID
from Users u WITH(Index(IX_Users)) INNER JOIN Posts p
ON u.UserId = p.AuthorId
WHERE P.PostId = (SELECT MAX(PostId) FROM LIKES L WHERE L.PostId = P.PostId)

--
select * from posts p  where (select Count(*) from Likes l where p.PostId = l.postid)!= 0

SELECT p.PostTitle, l.UserId as Likes
from Posts p RIGHT OUTER JOIN Likes l WITH(Index(IX_Likes))
ON p.PostId = l.PostId
WHERE p.PostTitle like N'“%' 

SELECT REPLACE(PostTitle,'“','¿¿¿'), UserId
from Likes l WITH(Index(IX_Likes)) LEFT OUTER JOIN Posts p
ON l.PostId = p.PostId

SELECT p.PostTitle, Count(l.PostId) as LikesSum
from Likes l WITH(Index(IX_Likes)) FULL OUTER JOIN Posts p
ON l.PostId = p.PostId
GROUP BY p.PostTitle, l.PostId
HAVING Count(l.PostId)!=0

--WHERE P.PostId = (SELECT MAX(PostId) FROM LIKES L WITH(Index(IX_Likes)) WHERE L.PostId = P.PostId)