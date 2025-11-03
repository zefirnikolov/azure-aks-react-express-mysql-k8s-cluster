/* ===========================
   Server-scoped setup
   =========================== */

-- 1) Create database if it doesn't exist
IF DB_ID(N'$(DBNAME)') IS NULL
BEGIN
    DECLARE @sql nvarchar(max) =
        N'CREATE DATABASE [' + REPLACE(N'$(DBNAME)', N']', N']]') + N']';
    EXEC(@sql);
END
GO

-- 2) Create login if it doesn't exist (password embedded as a safely-quoted literal)
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = N'$(APPLOGIN)')
BEGIN
    DECLARE @pwd nvarchar(128) = N'$(APPPASSWORD)';
    DECLARE @sql nvarchar(max) =
      N'CREATE LOGIN [' + REPLACE(N'$(APPLOGIN)', N']', N']]') +
      N'] WITH PASSWORD = ' + QUOTENAME(@pwd, '''') + N', CHECK_POLICY = ON;';
    EXEC(@sql);
END
GO


/* ===========================
   Database-scoped setup
   (single dynamic batch to preserve USE context)
   =========================== */

DECLARE @db  sysname        = N'$(DBNAME)';
DECLARE @app nvarchar(256)  = N'$(APPLOGIN)';

DECLARE @dbWork nvarchar(max) = N'
USE ' + QUOTENAME(@db) + N';

-- 3) Create user mapped to the login if it does not exist
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N''' + REPLACE(@app, '''', '''''') + N''')
BEGIN
    CREATE USER ' + QUOTENAME(@app) + N' FOR LOGIN ' + QUOTENAME(@app) + N';
END

-- 4) Grant db_datareader / db_datawriter if not already a member (modern syntax)
IF NOT EXISTS (
    SELECT 1
    FROM sys.database_role_members rm
    JOIN sys.database_principals r ON rm.role_principal_id = r.principal_id
    JOIN sys.database_principals u ON rm.member_principal_id = u.principal_id
    WHERE r.name = N''db_datareader'' AND u.name = N''' + REPLACE(@app, '''', '''''') + N'''
)
    ALTER ROLE db_datareader ADD MEMBER ' + QUOTENAME(@app) + N';

IF NOT EXISTS (
    SELECT 1
    FROM sys.database_role_members rm
    JOIN sys.database_principals r ON rm.role_principal_id = r.principal_id
    JOIN sys.database_principals u ON rm.member_principal_id = u.principal_id
    WHERE r.name = N''db_datawriter'' AND u.name = N''' + REPLACE(@app, '''', '''''') + N'''
)
    ALTER ROLE db_datawriter ADD MEMBER ' + QUOTENAME(@app) + N';

-- 5) Schema + table
IF OBJECT_ID(N''dbo.products'', N''U'') IS NULL
BEGIN
    CREATE TABLE dbo.products
    (
        id    INT IDENTITY(1,1) PRIMARY KEY,
        name  NVARCHAR(255) NOT NULL,
        price DECIMAL(5,2)  NOT NULL
    );
END

-- 6) Seed data (idempotent)
MERGE dbo.products AS target
USING (
    VALUES
    (N''apples-green'', 5.15),
    (N''apples-red'', 5.36),
    (N''lemons-yellow'', 2.51),
    (N''lemons-limes'', 7.59),
    (N''cherries-first-class'', 9.99),
    (N''carrots-purple'', 2.56),
    (N''carrots-orange'', 1.36),
    (N''lettuce-top-quality'', 4.99),
    (N''potatoes'', 1.50),
    (N''potatoes-sweet'', 3.44),
    (N''bread-white'', 1.50),
    (N''bread-steinalderbrod'', 2.44),
    (N''bagels-white'', 0.35),
    (N''bagels-sesame'', 0.50),
    (N''baguettes-white'', 2.44),
    (N''chicken-roasted'', 15.15),
    (N''chicken-cool'', 7.42),
    (N''beef-roasted-steak-cut'', 12.53),
    (N''beef-steak'', 14.58),
    (N''fish-salmon-fillet'', 15.69),
    (N''fish-salmon-raw'', 12.69),
    (N''chocolate-with-nuts'', 2.59),
    (N''chocolate-white'', 2.99),
    (N''candy-gummy-bears'', 4.54),
    (N''candy-bonbons'', 4.54),
    (N''ice-cream-cone'', 1.99),
    (N''ice-cream-stick'', 1.99),
    (N''alcoholic-whiskey'', 63.44),
    (N''alcoholic-wine'', 15.15),
    (N''alcohol-free-spring-water'', 1.42),
    (N''alcohol-free-juice'', 2.57),
    (N''kitchenware-pack'', 3.89)
) AS src(name, price)
ON target.name = src.name
WHEN NOT MATCHED BY TARGET THEN
    INSERT (name, price) VALUES (src.name, src.price);
';

EXEC(@dbWork);
GO
-- 7) (Optional) Set default DB so the app login lands in mydb by default
ALTER LOGIN [$(APPLOGIN)] WITH DEFAULT_DATABASE = [$(DBNAME)];
GO
