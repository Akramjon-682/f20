-- Lesson 13 Homework - SQL Server Functions

-- 1. String Functions

-- LEN vs DATALENGTH
-- LEN() - String uzunligini qaytaradi (bo'sh joylarsiz)
-- DATALENGTH() - Stringning xotirada qancha joy egallashini qaytaradi
SELECT LEN('Hello ') AS LenResult, DATALENGTH('Hello ') AS DataLengthResult;

-- CHARINDEX
-- CHARINDEX(substring, string) - substring joylashgan indeksni topish
SELECT CHARINDEX('SQL', 'I love SQL Server') AS CharIndexResult;

-- CONCAT vs + operator
-- CONCAT() - NULL qiymatlarni avtomatik e’tiborsiz qoldiradi
SELECT CONCAT('Hello', ' ', 'World', NULL) AS ConcatResult;
-- + operatori esa NULL bo‘lsa butun string NULL qaytaradi
SELECT 'Hello' + ' ' + 'World' + NULL AS PlusOperatorResult;

-- REPLACE
-- REPLACE(string, old_value, new_value) - eski qiymatni yangi qiymat bilan almashtiradi
SELECT REPLACE('Microsoft SQL Server', 'Microsoft', 'MS') AS ReplaceResult;

-- SUBSTRING
-- SUBSTRING(string, start, length) - stringdan qism olish
SELECT SUBSTRING('SQL Server', 1, 3) AS SubstringResult;

-- 2. Mathematical Functions

-- ROUND
-- ROUND(number, decimals) - berilgan raqamni yaxlitlash
SELECT ROUND(123.456, 2) AS RoundResult;

-- ABS
-- ABS(number) - absolut qiymatni qaytaradi
SELECT ABS(-10) AS AbsResult;

-- POWER vs EXP
-- POWER(base, exponent) - bazani darajaga ko'tarish
SELECT POWER(2, 3) AS PowerResult;  -- 2^3 = 8
-- EXP(x) - e ning x-darajasini hisoblash
SELECT EXP(1) AS ExpResult;  -- e^1

-- CEILING vs FLOOR
-- CEILING() - eng yaqin katta butun son
SELECT CEILING(4.2) AS CeilingResult;
-- FLOOR() - eng yaqin kichik butun son
SELECT FLOOR(4.9) AS FloorResult;

-- 3. Date and Time Functions

-- GETDATE
-- GETDATE() - joriy sana va vaqtni qaytaradi
SELECT GETDATE() AS CurrentDateTime;

-- DATEDIFF
-- DATEDIFF(interval, start_date, end_date) - sana farqini hisoblash
SELECT DATEDIFF(DAY, '2024-01-01', '2024-03-10') AS DateDiffResult;

-- DATEADD
-- DATEADD(interval, number, date) - sanaga vaqt qo‘shish
SELECT DATEADD(MONTH, 3, '2024-01-01') AS DateAddResult;

-- FORMAT
-- FORMAT(date, format) - sanani belgilangan formatda chiqarish
SELECT FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') AS FormattedDate;

-- 4. Query Examples

-- String function usage: Customer email mask qilish
SELECT CustomerName, REPLACE(Email, '@', '[at]') AS MaskedEmail FROM Customers;

-- Mathematical function usage: Narxlarni solishtirish
SELECT ProductName, Price, ROUND(Price * 1.1, 2) AS NewPrice FROM Products;

-- Date function usage: Keyingi oyning boshi
SELECT DATEADD(MONTH, 1, DATEADD(DAY, -DAY(GETDATE()) + 1, GETDATE())) AS NextMonthStart;

-- 5. Performance Considerations

-- 1. String functions ko‘p ishlatilganda indekslardan samarali foydalanilmasligi mumkin
-- 2. Mathematical calculations optimallashtirish uchun oldindan hisoblab saqlash tavsiya etiladi
-- 3. Date functions bilan qidiruvlar indekslashga ta’sir qilishi mumkin

-- Optimization Example: Indexed search
-- WHERE CHARINDEX('SQL', ColumnName) > 0 - indekslardan foydalana olmaydi
-- Buning o‘rniga: WHERE ColumnName LIKE '%SQL%' ishlatish tavsiya etiladi

-- Puzzle 1: Count spaces in each row
SELECT texts, LEN(texts) - LEN(REPLACE(texts, ' ', '')) AS SpaceCount
FROM CountSpaces;

-- Alternative approach using CHARINDEX in a loop (for educational purposes only)
-- DECLARE @Text VARCHAR(100), @SpaceCount INT = 0
-- SET @Text = 'P Q R S '
-- WHILE CHARINDEX(' ', @Text) > 0
-- BEGIN
--    SET @SpaceCount = @SpaceCount + 1
--    SET @Text = STUFF(@Text, CHARINDEX(' ', @Text), 1, '')
-- END
-- SELECT @SpaceCount AS SpaceCount

-- Puzzle 2: Count different character types
DECLARE @inputString VARCHAR(1000) = 'AddsfsdfWUES 12*&';
SELECT 
    LEN(@inputString) - LEN(REPLACE(@inputString, 'A', ''))
    + LEN(@inputString) - LEN(REPLACE(@inputString, 'B', ''))
    + LEN(@inputString) - LEN(REPLACE(@inputString, 'C', ''))
    + ... AS UppercaseCount,
    LEN(@inputString) - LEN(REPLACE(@inputString, 'a', ''))
    + LEN(@inputString) - LEN(REPLACE(@inputString, 'b', ''))
    + LEN(@inputString) - LEN(REPLACE(@inputString, 'c', ''))
    + ... AS LowercaseCount,
    LEN(@inputString) - (UppercaseCount + LowercaseCount) AS OtherCount;

-- Puzzle 3: Generate a date sequence using a CTE
DECLARE @todate DATETIME, @fromdate DATETIME;
SET @fromdate = '2009-01-01';
SET @todate = '2009-12-31';

WITH DateSequence AS (
    SELECT @fromdate AS DateValue
    UNION ALL
    SELECT DATEADD(DAY, 1, DateValue)
    FROM DateSequence
    WHERE DateValue < @todate
)
SELECT DateValue, YEAR(DateValue) AS Year, MONTH(DateValue) AS Month, DAY(DateValue) AS Day
FROM DateSequence
OPTION (MAXRECURSION 366);

-- Puzzle 4: Split Name column into Name and Surname using different approaches
-- Approach 1: Using SUBSTRING and CHARINDEX
SELECT 
    Id, 
    SUBSTRING(Name, 1, CHARINDEX(',', Name) - 1) AS FirstName, 
    SUBSTRING(Name, CHARINDEX(',', Name) + 1, LEN(Name)) AS LastName
FROM TestMultipleColumns;

-- Approach 2: Using PARSENAME (replacing ',' with '.')
SELECT 
    Id, 
    PARSENAME(REPLACE(Name, ',', '.'), 2) AS FirstName, 
    PARSENAME(REPLACE(Name, ',', '.'), 1) AS LastName
FROM TestMultipleColumns;

-- Approach 3: Using STRING_SPLIT (for newer SQL Server versions)
SELECT Id, value AS NamePart
FROM TestMultipleColumns
CROSS APPLY STRING_SPLIT(Name, ',');
