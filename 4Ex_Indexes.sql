--https://course.sgu.ru/mod/assign/view.php?id=36323

Use BlogDB
Go

SET STATISTICS IO ON 
-- число страниц, считанных из КЭШа данных
-- число страниц, считанных с диска и число страниц, помещенных в кэш для запроса 
SET STATISTICS TIME ON 
-- отображает процессорное время в миллисекундах, которое было использовано для синтаксического анализа, компиляции и выполнения каждой инструкции

--CREATE NONCLUSTERED INDEX IX_Users 
--ON Users (UserName)
--GO

CREATE NONCLUSTERED INDEX IX_Cities
ON Cities (CountryId)
INCLUDE (CityName)
GO

CREATE UNIQUE CLUSTERED INDEX IX_LikesCl
ON Likes (USERID, POSTID)
Go

CREATE UNIQUE NONCLUSTERED INDEX IX_Likes
ON Likes (USERID, POSTID)
Go

--CREATE NONCLUSTERED INDEX IX_Comments
--  ON Comments (UserId)
--  INCLUDE (PostId);
--GO

CREATE NONCLUSTERED INDEX IX_Posts_with_theme
ON Posts (PostId)
INCLUDE (PostTitle)
WHERE PostId >2000
GO

--CREATE NONCLUSTERED INDEX IX_Comments
--  ON Comments (PostText)
--  WITH ( DATA_COMPRESSION = ROW )
--GO

--1) Запросов c использованием различных видов соединений таблиц (в том числе самосоединения).
--2) Фильтрация данных в запросах с использованием предикатов (EXISTS, IN, ALL, SOME/ANY, BETWEEN, LIKE).
--3) Запросы с использованием функций для  работы со строками (REPLACE, SUBSTRING, STUFF).
--4) Запросы с использованием функций даты и времени (DATEPART,DATEADD,DATEDIFF,  GETDATE()).
--5) Запросы с использованием агрегатных функций, группировок (GROUP BY) и фильтрации групп (HAVING).
--6) Вложенные запросы
--7) Запросы с использованием UNION и INTERSECT

--1.1)
SELECT z.CityId, u.CityId from Cities z WITH(Index(IX_Cities)) Inner Join Cities u on u.CountryId = z.CountryId
--SELECT z.CityId, u.CountryId from Cities z Full Outer Join Countries u on u.CountryId = z.CountryId
--SELECT z.CityId, u.CountryId from Cities z LEFT OUTER JOIN Countries u on u.CountryId = z.CountryId
--SELECT z.CityId, u.CountryId from Cities z Right OUTER JOIN Countries u on u.CountryId = z.CountryId
--SELECT z.CityId, u.CountryId from Cities z, Countries u 
--1.2)
SELECT z.CityId from Cities z WITH(Index(IX_Cities)) where CityId BETWEEN 10 AND 10000
--1.3)
SELECT REPLACE(CityName,'1','2'), CityId from Cities WITH(Index(IX_Cities))
--1.4)
SELECT CAST(GETDATE() AS int)+ CityId from Cities WITH(Index(IX_Cities))
--1.5)
SELECT z.CityId from Cities z WITH(Index(IX_Cities)) Group By CityId Having z.CityId BETWEEN 10 AND 10000
--1.6)
SELECT z.CityName from Cities z WITH(Index(IX_Cities)) where Exists(select * from Users u where u.CityId = z.CityId)
--1.7)
SELECT CityId, CityName from Cities union SELECT CityId, CityName from Cities WITH(Index(IX_Cities))

--PK
--2.1)
SELECT z.AuthorId, u.PostTitle from Posts z Inner Join Posts u on u.PostId = z.PostId
--2.2)
SELECT z.PostId from Posts z where PostTitle Like N'%a'
--2.3)
SELECT STUFF(z.PostTitle,2,3,N'AAAAA') from Posts z
--2.4)
SELECT CAST(GETDATE() as smalldatetime) - p.PostDate from Posts p
--2.5)
SELECT z.PostId from Posts z Group By PostId Having z.PostId BETWEEN 10 AND 10000
--2.6)
SELECT z.PostTitle from Posts z where Exists(select * from Users u where u.UserId = z.AuthorId)
--2.7)
SELECT PostId, PostTitle from Posts INTERSECT SELECT PostId, PostTitle from Posts

--LikeCl
--3.1)
SELECT z.PostId from Likes z WITH(Index(IX_LikesCl)) Full Outer Join Likes u on u.PostId = z.UserId
--3.2)
SELECT z.UserId from Likes z WITH(Index(IX_LikesCl)) where z.PostId = any (Select PostId from Likes)
--3.3)
SELECT Substring(N'AAAAA' + Cast(z.PostId as nvarchar),2,4) from Likes z WITH(Index(IX_LikesCl))
--3.4)
SELECT GETDATE() + l.UserId from Likes l WITH(Index(IX_LikesCl))
--3.5)
SELECT l.UserId, p.PostTitle from Likes l WITH(Index(IX_LikesCl)) join Posts p on p.PostId = l.PostId Group By l.UserId, PostTitle Having l.UserId >100
--3.6)
SELECT l.PostId from Likes l WITH(Index(IX_LikesCl)) where Exists(select * from Posts p where p.PostId = l.PostId)
--3.7)
SELECT UserId, PostId from Likes WITH(Index(IX_LikesCl)) UNION SELECT UserId, PostId from Likes WITH(Index(IX_LikesCl))

--Like
--4.1)
SELECT z.PostId from Likes z WITH(Index(IX_Likes)) Full Outer Join Likes u on u.PostId = z.UserId
--4.2)
SELECT z.UserId from Likes z WITH(Index(IX_Likes)) where z.PostId = any (Select PostId from Likes)
--4.3)
SELECT Substring(N'AAAAA' + Cast(z.PostId as nvarchar),2,4) from Likes z WITH(Index(IX_Likes))
--4.4)
SELECT GETDATE() + l.UserId from Likes l WITH(Index(IX_Likes))
--4.5)
SELECT l.UserId, p.PostTitle from Likes l WITH(Index(IX_Likes)) join Posts p on p.PostId = l.PostId Group By l.UserId, PostTitle Having l.UserId >100
--4.6)
SELECT l.PostId from Likes l WITH(Index(IX_Likes)) where Exists(select * from Posts p where p.PostId = l.PostId)
--4.7)
SELECT UserId, PostId from Likes WITH(Index(IX_Likes)) UNION SELECT UserId, PostId from Likes WITH(Index(IX_Likes))

--IX_Posts_with_theme
--5.1)
SELECT z.ThemeId, u.PostTitle from Posts z WITH(Index(IX_Posts_with_theme)) Inner Join Posts u WITH(Index(IX_Posts_with_theme)) on u.PostId = z.PostId  
WHERE u.PostId >2000 and z.PostId >2000

--5.2)
SELECT z.PostId from Posts z WITH(Index(IX_Posts_with_theme)) where PostTitle Like N'%a' and z.PostId >2000
--5.3)
SELECT STUFF(z.PostTitle,2,3,N'AAAAA') from Posts z WITH(Index(IX_Posts_with_theme)) where z.PostId >2000
--5.4)
SELECT CAST(GETDATE() as smalldatetime) - p.PostDate from Posts p WITH(Index(IX_Posts_with_theme)) where p.PostId >2000
--5.5)
SELECT z.PostId from Posts z WITH(Index(IX_Posts_with_theme)) where z.PostId >2000
Group By PostId Having z.PostId BETWEEN 10 AND 10000 
--5.6)
SELECT z.PostTitle from Posts z WITH(Index(IX_Posts_with_theme)) where Exists(select * from Users u where u.UserId = z.AuthorId) and  z.PostId >2000
--5.7)
SELECT PostId, PostTitle from Posts WITH(Index(IX_Posts_with_theme)) where PostId >2000
INTERSECT 
SELECT PostId, PostTitle from Posts WITH(Index(IX_Posts_with_theme)) where PostId >2000

--SELECT UserId, PostId
--from Users u WITH(Index(IX_Users)) RIGHT OUTER JOIN Posts p
--ON u.UserId = p.AuthorId
--WHERE UserName like N'a%' 

--SELECT REPLACE(UserName,'А','Б'), PostId
--from Users u WITH(Index(IX_Users)) LEFT OUTER JOIN Posts p
--ON u.UserId = p.AuthorId

--SELECT USERNAME
--from Users u WITH(Index(IX_Users)) FULL OUTER JOIN Posts p
--ON u.UserId = p.AuthorId
--GROUP BY UserName, PostId
--HAVING POSTID IS NULL

--SELECT UserId, POSTID
--from Users u WITH(Index(IX_Users)) INNER JOIN Posts p
--ON u.UserId = p.AuthorId
--WHERE P.PostId = (SELECT MAX(PostId) FROM LIKES L WHERE L.PostId = P.PostId)

----
--select * from posts p  where (select Count(*) from Likes l where p.PostId = l.postid)!= 0

--SELECT p.PostTitle, l.UserId as Likes
--from Posts p RIGHT OUTER JOIN Likes l WITH(Index(IX_Likes))
--ON p.PostId = l.PostId
--WHERE p.PostTitle like N'Т%' 

--SELECT REPLACE(PostTitle,'Т','ААА'), UserId
--from Likes l WITH(Index(IX_Likes)) LEFT OUTER JOIN Posts p
--ON l.PostId = p.PostId

--SELECT p.PostTitle, Count(l.PostId) as LikesSum
--from Likes l WITH(Index(IX_Likes)) FULL OUTER JOIN Posts p
--ON l.PostId = p.PostId
--GROUP BY p.PostTitle, l.PostId
--HAVING Count(l.PostId)!=0

--WHERE P.PostId = (SELECT MAX(PostId) FROM LIKES L WITH(Index(IX_Likes)) WHERE L.PostId = P.PostId)