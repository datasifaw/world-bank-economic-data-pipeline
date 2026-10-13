
USE WorldBankEconomicDB;
GO

SELECT
    indicator_code,
    COUNT(*) AS nombre_lignes,
    COUNT(DISTINCT country_code) AS nombre_pays,
    MIN([year]) AS premiere_annee,
    MAX([year]) AS derniere_annee,
    SUM(CASE WHEN [value] IS NULL THEN 1 ELSE 0 END)
        AS valeurs_nulles
FROM silver.economic_indicators
GROUP BY indicator_code
ORDER BY indicator_code;
GO

SELECT
    country_code,
    [year],
    indicator_code,
    [value]
FROM silver.economic_indicators
WHERE country_code = 'USA'
  AND [year] = 2025
  AND indicator_code = 'FP.CPI.TOTL.ZG';
GO
