
USE WorldBankEconomicDB;
GO

-- Créer le schéma Silver si nécessaire
IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = 'silver'
)
    EXEC('CREATE SCHEMA silver');
GO

-- Créer la table Silver
IF OBJECT_ID('silver.economic_indicators', 'U') IS NULL
BEGIN
    CREATE TABLE silver.economic_indicators (
        country_code VARCHAR(3) NOT NULL,
        [year] INT NOT NULL,
        indicator_code VARCHAR(30) NOT NULL,
        [value] FLOAT NULL,
        updated_at DATETIME2 NOT NULL
            DEFAULT SYSUTCDATETIME(),

        CONSTRAINT PK_silver_economic_indicators
            PRIMARY KEY (
                country_code,
                [year],
                indicator_code
            ),

        CONSTRAINT CK_silver_year
            CHECK ([year] BETWEEN 1960 AND 2100)
    );
END;
GO

-- Vérifier la création
SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'silver';
GO
