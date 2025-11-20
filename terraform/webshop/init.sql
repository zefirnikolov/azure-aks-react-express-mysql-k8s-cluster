DECLARE @db  sysname       = N'$(DBNAME)';
DECLARE @app nvarchar(256) = N'$(APPLOGIN)';
DECLARE @pwd nvarchar(128) = N'$(APPPASSWORD)';

IF DB_NAME() <> @db
BEGIN
    DECLARE @switch nvarchar(max) = N'USE ' + QUOTENAME(@db) + N';';
    EXEC(@switch);
END

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = @app)
BEGIN
    CREATE USER [$(APPLOGIN)] WITH PASSWORD = '$(APPPASSWORD)';
END

IF NOT EXISTS (
    SELECT 1
    FROM sys.database_role_members rm
    JOIN sys.database_principals r ON rm.role_principal_id = r.principal_id
    JOIN sys.database_principals u ON rm.member_principal_id = u.principal_id
    WHERE r.name = N'db_datareader' AND u.name = @app
)
    ALTER ROLE db_datareader ADD MEMBER [$(APPLOGIN)];

IF NOT EXISTS (
    SELECT 1
    FROM sys.database_role_members rm
    JOIN sys.database_principals r ON rm.role_principal_id = r.principal_id
    JOIN sys.database_principals u ON rm.member_principal_id = u.principal_id
    WHERE r.name = N'db_datawriter' AND u.name = @app
)
    ALTER ROLE db_datawriter ADD MEMBER [$(APPLOGIN)];

IF OBJECT_ID(N'dbo.products', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.products
    (
        id    INT IDENTITY(1,1) PRIMARY KEY,
        name  NVARCHAR(255) NOT NULL,
        price DECIMAL(5,2)  NOT NULL
    );
END

MERGE dbo.products AS target
USING (
    VALUES
    (N'apples-green', 5.15),
    (N'apples-red', 5.36),
    (N'lemons-yellow', 2.51),
    (N'lemons-limes', 7.59),
    (N'cherries-first-class', 9.99),
    (N'carrots-purple', 2.56),
    (N'carrots-orange', 1.36),
    (N'lettuce-top-quality', 4.99),
    (N'potatoes', 1.50),
    (N'potatoes-sweet', 3.44),
    (N'bread-white', 1.50),
    (N'bread-steinalderbrod', 2.44),
    (N'bagels-white', 0.35),
    (N'bagels-sesame', 0.50),
    (N'baguettes-white', 2.44),
    (N'chicken-roasted', 15.15),
    (N'chicken-cool', 7.42),
    (N'beef-roasted-steak-cut', 12.53),
    (N'beef-steak', 14.58),
    (N'fish-salmon-fillet', 15.69),
    (N'fish-salmon-raw', 12.69),
    (N'chocolate-with-nuts', 2.59),
    (N'chocolate-white', 2.99),
    (N'candy-gummy-bears', 4.54),
    (N'candy-bonbons', 4.54),
    (N'ice-cream-cone', 1.99),
    (N'ice-cream-stick', 1.99),
    (N'alcoholic-whiskey', 63.44),
    (N'alcoholic-wine', 15.15),
    (N'alcohol-free-spring-water', 1.42),
    (N'alcohol-free-juice', 2.57),
    (N'kitchenware-pack', 3.89)
) AS src(name, price)
ON target.name = src.name
WHEN NOT MATCHED BY TARGET THEN
    INSERT (name, price) VALUES (src.name, src.price);
