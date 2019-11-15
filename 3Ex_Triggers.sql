USE BlogDB;
GO

CREATE TRIGGER Users_INSERT ON Users
AFTER INSERT
AS
INSERT INTO Users (UserName)
SELECT 'Добавлен новый пользователь: ' + UserName
FROM INSERTED
Go 

CREATE TRIGGER Countries_INSERT ON Countries
INSTEAD OF INSERT
AS
PRINT 'Нельзя добавить страну'

CREATE TRIGGER User_UPDATE ON Users
AFTER UPDATE
AS
INSERT INTO Users (UserName)
SELECT 'Обновлён пользователь: ' + UserName
FROM INSERTED
Go 

CREATE TRIGGER Like_UPDATE ON Likes
AFTER UPDATE
AS
SELECT 'Лайки не могут быть изменены'
FROM INSERTED
Go 

CREATE TRIGGER Post_DELETE ON Posts
AFTER DELETE
AS
INSERT INTO Posts (PostId)
SELECT 'Пост #' + PostId + ' был успешно удалён'
FROM INSERTED
GO 

CREATE TRIGGER Language_DELETE ON Languages
INSTEAD OF DELETE
AS
PRINT 'Язык не может быть удалён'
GO 