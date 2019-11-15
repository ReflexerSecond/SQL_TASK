USE BlogDB;
GO

CREATE TRIGGER Users_INSERT ON Users
AFTER INSERT
AS
INSERT INTO Users (UserName)
SELECT '�������� ����� ������������: ' + UserName
FROM INSERTED
Go 

CREATE TRIGGER Countries_INSERT ON Countries
INSTEAD OF INSERT
AS
PRINT '������ �������� ������'

CREATE TRIGGER User_UPDATE ON Users
AFTER UPDATE
AS
INSERT INTO Users (UserName)
SELECT '������� ������������: ' + UserName
FROM INSERTED
Go 

CREATE TRIGGER Like_UPDATE ON Likes
AFTER UPDATE
AS
SELECT '����� �� ����� ���� ��������'
FROM INSERTED
Go 

CREATE TRIGGER Post_DELETE ON Posts
AFTER DELETE
AS
INSERT INTO Posts (PostId)
SELECT '���� #' + PostId + ' ��� ������� �����'
FROM INSERTED
GO 

CREATE TRIGGER Language_DELETE ON Languages
INSTEAD OF DELETE
AS
PRINT '���� �� ����� ���� �����'
GO 