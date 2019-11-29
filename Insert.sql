-- Insert rows into tables
use BlogDB
go

INSERT into Languages
( 
 LanguageName
)
VALUES
(N'Китайский'),
(N'Английский'),
(N'Испанский'),
(N'Арабский'),
(N'Русский'),
(N'Португальский'),
(N'Немецкий'),
(N'Французский')
GO

INSERT into Themes
( 
 ThemeName
)
VALUES
(N'IT'),
(N'Юмор'),
(N'Политика'),
(N'Искуство'),
(N'Финансы'),
(N'Наука'),
(N'Разное')
GO

-- Random string
Create procedure RandomStringTest 
@count int, @str nvarchar(255) output
as begin
	declare @ind int = 1;
	set @str = N''

	while @ind < @count begin
		set @ind += 1;
		set @str = Concat(@str, char(CAST(RAND()*26 AS int)+97));
	end
end;
Go
-- Countries
Create procedure InsertCountries 
@count int
as begin
	declare @ind int = 1;
	declare @str nvarchar(255);
	while @ind <= @count begin
		EXEC RandomStringTest 6, @str output
		set @ind += 1;
		insert into Countries(CountryName) Values (Concat(@str, N' country'))
	end
end;
Go
-- Cities
Create procedure InsertCities
@count int
as begin
	declare @ind int = 1;
	declare @str nvarchar(255);

	while @ind <= @count begin
		EXEC RandomStringTest 5, @str output
		set @ind += 1;
		insert into Cities(CountryId, CityName) Values ((select Top 1 CountryId from Countries order by newid()) ,Concat(@str, N' city'))
	end
end;
Go
-- Users
Create procedure InsertUsers
@count int
as begin
	declare @ind int = 1;
	declare @str nvarchar(255);

	while @ind <= @count begin
		EXEC RandomStringTest 3, @str output
		set @ind += 1;
		insert into Users(CityId, UserName) Values ( (select Top 1 CityId from Cities order by newid()) ,Concat(@str, N' user'))
	end
end;
Go
-- Posts
Create procedure InsertPosts
@count int
as begin
	declare @ind int = 1;
	declare @title nvarchar(20);
	declare @text nvarchar(40);
	while @ind <= @count begin
		set @ind += 1;

		EXEC RandomStringTest 20, @title output
		EXEC RandomStringTest 40, @text output
		insert into Posts(PostTitle, PostText, AuthorId, ThemeId, LanguageId) 
		Values 
		(@title,@text,(select Top 1 UserId from Users order by newid()),
		(select Top 1 ThemeId from Themes order by newid()),
		(select Top 1 LanguageId from Languages order by newid()))
	end
end;
Go
-- Comments
Create procedure InsertComments
@count int
as begin
	declare @ind int = 1;
	declare @text nvarchar(40);
	while @ind <= @count begin
		set @ind += 1;

		EXEC RandomStringTest 40, @text output
		insert into Comments(PostText, UserId, PostId) 
		Values 
		(@text,
		(select Top 1 UserId from Users order by newid()),
		(select Top 1 PostId from Posts order by newid()))
	end
end;
Go
-- Likes
Create procedure InsertLikes
@count int
as begin
	declare @ind int = 1;
	declare @text nvarchar(40);
	while @ind <= @count begin
		set @ind += 1;

		EXEC RandomStringTest 40, @text output
		insert into Likes( UserId, PostId) 
		Values 
		((select Top 1 UserId from Users z order by newid()),
		(select Top 1 PostId from Posts s order by newid())) 
	end
end;
Go
-- Execute
Exec InsertCountries @count = 100;
Exec InsertCities @count = 100;
Exec InsertUsers @count = 1000;
Exec InsertPosts @count = 6000;
Exec InsertComments @count = 5000;
Exec InsertLikes @count = 10000;
