
USE WorldBankEconomicDB;
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.schemas WHERE name = 'bronze'
)
    EXEC('CREATE SCHEMA bronze');
GO

IF OBJECT_ID('bronze.world_bank_raw', 'U') IS NULL
BEGIN
    CREATE TABLE bronze.world_bank_raw (
        id BIGINT IDENTITY(1,1) PRIMARY KEY,
        country_code VARCHAR(3) NOT NULL,
        [year] INT NOT NULL,
        indicator_code VARCHAR(30) NOT NULL,
        [value] FLOAT NULL,
        loaded_at DATETIME2 NOT NULL
            DEFAULT SYSUTCDATETIME()
    );
END;
GO

SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'bronze';
GO
  