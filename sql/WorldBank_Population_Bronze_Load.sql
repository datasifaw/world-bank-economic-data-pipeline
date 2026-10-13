
USE WorldBankEconomicDB;
GO

SELECT
    indicator_code,
    COUNT(*) AS nombre_lignes,
    COUNT(DISTINCT country_code) AS nombre_pays,
    SUM(CASE WHEN [value] IS NULL THEN 1 ELSE 0 END) AS valeurs_nulles
FROM bronze.world_bank_raw
GROUP BY indicator_code
ORDER BY indicator_code;
GO
