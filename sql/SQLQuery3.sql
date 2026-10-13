
USE WorldBankEconomicDB;
GO

SELECT
    indicator_code,
    COUNT(*) AS nombre_lignes,
    COUNT(DISTINCT country_code) AS nombre_pays,
    MIN([year]) AS premiere_annee,
    MAX([year]) AS derniere_annee
FROM bronze.world_bank_raw
GROUP BY indicator_code;
