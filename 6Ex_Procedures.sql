Use BlogDB
GO
CREATE PROCEDURE AddUser
    @name  NVARCHAR(255)
AS
   INSERT Users(
        UserName
    ) 
    VALUES (
        @name
    )
GO

CREATE PROCEDURE AddUserCity
    @userId int,
	@cityId int
	
AS
   Update Users
    SET cityId = @cityId
	WHERE userId = @userId
GO

CREATE PROCEDURE AddFullUser
	@name  NVARCHAR(255),
	@cityId int
	AS
	EXEC dbo.AddUser @name = @name;
	DECLARE @temp int = (select MAX(userId) from Users);
	EXEC dbo.AddUserCity @userId = @temp, @cityId = @cityId;
	GO

--EXEC dbo.AddFullUser @name = N'Тарас Бульба', @cityId = 1;
--select * from Users where userId = (select MAX(UserId) from users)


CREATE PROCEDURE AddLike
    @UserId int,
	@PostId int
AS
	IF exists (select * from Posts where (PostId = @PostId) AND (AuthorId != @UserId)) 
	INSERT Likes
    ( 
        UserId, PostId
    )
	VALUES
    (
		@UserId , @PostId
    )
GO

--EXEC dbo.AddLike @UserId = 2, @PostId = 2;
--select * from dbo.AUTORS_POPULARITY
--EXEC dbo.AddLike @UserId = 1, @PostId = 2;
--select * from dbo.AUTORS_POPULARITY

CREATE PROCEDURE ThemeSearch
    @pattern NVARCHAR(255)
AS
SELECT * from Themes where ThemeName Like @pattern + N'%' 
GO

--EXEC dbo.ThemeSearch @pattern = N'i';