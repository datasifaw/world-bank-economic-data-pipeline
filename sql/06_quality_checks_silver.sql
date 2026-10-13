
USE WorldBankEconomicDB;
GO

-- 1. Couverture par indicateur
SELECT
    indicator_code,
    COUNT(*) AS nombre_lignes,
    COUNT(DISTINCT country_code) AS nombre_pays,
    MIN([year]) AS premiere_annee,
    MAX([year]) AS derniere_annee,
    SUM(CASE WHEN [value] IS NULL THEN 1 ELSE 0 END) AS valeurs_nulles
FROM silver.economic_indicators
GROUP BY indicator_code
ORDER BY indicator_code;

-- 2. Doublons sur la clé métier
SELECT
    country_code,
    [year],
    indicator_code,
    COUNT(*) AS occurrences
FROM silver.economic_indicators
GROUP BY country_code, [year], indicator_code
HAVING COUNT(*) > 1;

-- 3. Pays, années ou indicateurs hors périmètre
SELECT *
FROM silver.economic_indicators
WHERE country_code NOT IN ('FRA', 'DEU', 'USA', 'CHN', 'JPN', 'IND')
   OR [year] NOT BETWEEN 2015 AND 2026
   OR indicator_code NOT IN (
       'NY.GDP.MKTP.CD',
       'FP.CPI.TOTL.ZG',
       'SL.UEM.TOTL.ZS',
       'SP.POP.TOTL'
   );

-- 4. Valeurs manquantes
SELECT
    country_code,
    [year],
    indicator_code,
    [value]
FROM silver.economic_indicators
WHERE [value] IS NULL
ORDER BY indicator_code, country_code, [year];

-- 5. Valeurs économiques potentiellement incohérentes
SELECT
    country_code,
    [year],
    indicator_code,
    [value]
FROM silver.economic_indicators
WHERE (
    indicator_code IN ('NY.GDP.MKTP.CD', 'SP.POP.TOTL')
    AND [value] IS NOT NULL
    AND [value] <= 0
)
OR (
    indicator_code = 'SL.UEM.TOTL.ZS'
    AND [value] IS NOT NULL
    AND ([value] < 0 OR [value] > 100)
);

-- 6. Synthèse générale
SELECT
    COUNT(*) AS total_lignes,
    COUNT(DISTINCT country_code) AS total_pays,
    COUNT(DISTINCT indicator_code) AS total_indicateurs,
    SUM(CASE WHEN [value] IS NULL THEN 1 ELSE 0 END) AS total_nulls
FROM silver.economic_indicators;
GO
  