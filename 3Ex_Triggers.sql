--Разработать и реализовать триггеры для операций INSERT, UPDATE, DELETE для проверки сложных ограничений, накладываемых на схему предметной области (не менее двух триггеров для каждого типа операции). 
--Не менее трех триггеров (любого типа) должны выполнять действия компенсирующего типа в связанных таблицах. 
--По одному триггеру для каждой операции должны быть триггерами instead of (триггеры должны содержать логику обработки данных - например, выполнение компенсирующих операций, расчетные данные, обработку сложного удаления или обновления данных). 
USE BlogDB;
GO
-- ins Insert user
CREATE TRIGGER Users_INSERT ON Users
INSTEAD OF INSERT
AS
	INSERT INTO Users (CityId, UserName, UserLastActivity)
	SELECT CityId, UserName, GETDATE()
	FROM INSERTED i
	Where Exists(select * from Cities c where c.CityId = i.CityId) and i.UserName !=N'DELETED'

	INSERT INTO Users (UserName, UserLastActivity)
	SELECT UserName, GETDATE()
	FROM INSERTED i
	Where NOT Exists(select * from Cities c where c.CityId = i.CityId) and i.UserName !=N'DELETED'
Go 
-- ins DELETE user
CREATE TRIGGER Users_DELETE ON Users
INSTEAD OF DELETE
AS
	Update Users 
	set UserName = N'DELETED', CityId = NULl
	from deleted d
	where Users.UserId = d.UserId

	Update Comments 
	set PostText = N'USER DELETED'
	from deleted d
	where Comments.UserId = d.UserId
GO 

--ins Insert Comment
CREATE TRIGGER Comment_Insert on Comments
INSTEAD OF INSERT
AS
	if(Exists(Select userName from Users u join inserted i on i.userId = u.userid where u.userId = i.userId and u.userName = N'DELETED'))
	Print 'Удалённый пользователь не может комментировать'
	else
	begin
		INSERT INTO Comments (UserId, PostId, PostText)
		SELECT UserId, PostId, PostText
		FROM INSERTED i;
		--Update Users 
		--set UserLastActivity = GETDATE()
		--from inserted d
		--where Users.UserId = d.UserId
	end
Go

--Aft insert comment
CREATE TRIGGER Comment_AInsert on Comments
AFTER INSERT
AS
		Update Users 
		set UserLastActivity = GETDATE()
		from inserted d
		where Users.UserId = d.UserId
Go

--Ins Update
CREATE TRIGGER Comment_UPDATEI ON Comments
Instead of UPDATE
AS
if(Exists(Select userName from Users u join inserted i on i.userId = u.userid where u.userId = i.userId and u.userName = N'DELETED'))
	Print 'Удалённый пользователь не может менять комментарий.'
else
	Update Comments 
	set PostText = d.PostText
	from inserted d
Go 
--Aft Update Comment
CREATE TRIGGER Comment_UPDATE ON Comments
AFTER UPDATE
AS
	Update Users 
	set UserLastActivity = GETDATE()
	from inserted d
	where Users.UserId = d.UserId
Go 
--Post ins Delete
CREATE TRIGGER Post_DELETE ON Posts
Instead of Delete
AS
	Delete from Likes where (select PostId from deleted) = Likes.PostId
	Delete from Comments where (select PostId from deleted) = Comments.PostId
	Delete from Posts where Posts.PostId = (select PostId from deleted)
Go 

--Delete from Posts where Posts.PostId = 5