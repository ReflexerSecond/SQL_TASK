-- 1

-- Inner join
SELECT * FROM Cities INNER JOIN Users
ON Cities.CityId =  Users.CityId
GO

-- -- Outer join
SELECT c.CityName, u.UserName
FROM Cities c
LEFT OUTER JOIN Users u ON u.CityId = c.CityId

-- Cross join
SELECT * FROM Users CROSS JOIN Cities

-- Cross apply
SELECT * 
FROM Countries b1 
CROSS APPLY (
    SELECT c.CityName, u.UserName FROM Users u
    JOIN Cities c ON u.CityId = c.CityId
    WHERE u.UserId % 2 = 0
) X;

-- Between
SELECT * FROM Countries 
WHERE CountryId BETWEEN 10 AND 20

-- Exist
Select *
FROM Countries AS co
WHERE EXISTS 
(SELECT * 
    FROM Cities as ci
    WHERE co.CountryId = ci.CountryId
)
GO

-- IN
SELECT * FROM Users u
JOIN Cities c
On c.CityId = u.CityId 
WHERE c.CityName IN (
    N'Москва', N'Саратов'
);

-- SOME ANY
IF 10 < SOME (SELECT CountryId FROM Countries)
    PRINT 'TRUE'
ELSE
    PRINT 'FALSE';

IF 10 < SOME (SELECT CityId FROM Cities)
    PRINT 'TRUE'
ELSE
    PRINT 'FALSE';

-- LIKE 
SELECT * FROM Cities c 
WHERE c.CityName NOT LIKE 'М%'

-- CAST 
SELECT 9.5 AS Original,
       CAST(9.5 AS INT) AS [int],
       CAST(9.5 AS DECIMAL(6, 4)) AS [decimal];

-- CONVERT
SELECT 9.5 AS Original,
       CONVERT(INT, 9.5) AS [int],
       CONVERT(DECIMAL(6, 4), 9.5) AS [decimal];

-- NULL
SELECT UserName
FROM Users u
WHERE CityId IS NULL

-- Case
SELECT u.UserName,
CASE WHEN (NOT(u.CityId = 1)) OR (u.CityId IS NULL)
 THEN N'Не Москва'
  ELSE c.CityName
  END 
 FROM Users u
LEFT Join Cities c ON u.CityId = c.CityId

--COALESCE
SELECT UserName,
COALESCE (IIF(CityId>10 or CityId is Null,CityId,0),-1)
FROM Users

-- UPPER
SELECT UPPER(UserName) 
FROM Users

-- LOWER
SELECT LOWER(UserName) 
FROM Users

-- STR
SELECT UserName,N'№' + STR(UserId) + N' Test'
FROM Users
Order By UserName
-- DATE
SELECT SYSDATETIME() AS [SYSDATETIME],  
    SYSDATETIMEOFFSET() AS [SYSDATETIMEOFFSET],  
    SYSUTCDATETIME() AS [SYSUTCDATETIME],  
    CURRENT_TIMESTAMP AS [CURRENT_TIMESTAMP],  
    GETDATE() AS [GETDATE],  
    GETUTCDATE() AS [GETUTCDATE];  

-- HAVING
SELECT CountryId
FROM Countries 
GROUP BY CountryId
HAVING Max(Countryid) <50

