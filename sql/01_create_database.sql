
USE master;
GO

IF DB_ID(N'WorldBankEconomicDB') IS NULL
BEGIN
    CREATE DATABASE WorldBankEconomicDB;
END;
GO

SELECT name
FROM sys.databases
WHERE name = N'WorldBankEconomicDB';
GO
  