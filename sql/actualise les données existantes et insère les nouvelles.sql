
USE WorldBankEconomicDB;
GO

SET XACT_ABORT ON;
GO

BEGIN TRY
    BEGIN TRANSACTION;

    ;WITH DonneesNettoyees AS (
        SELECT
            country_code,
            [year],
            indicator_code,
            [value],
            ROW_NUMBER() OVER (
                PARTITION BY country_code, [year], indicator_code
                ORDER BY
                    CASE WHEN [value] IS NULL THEN 1 ELSE 0 END,
                    loaded_at DESC,
                    id DESC
            ) AS numero_ligne
        FROM bronze.world_bank_raw
        WHERE country_code IN (
            'FRA', 'DEU', 'USA', 'CHN', 'JPN', 'IND'
        )
          AND [year] BETWEEN 2015 AND 2026
          AND indicator_code IN (
              'NY.GDP.MKTP.CD',
              'FP.CPI.TOTL.ZG',
              'SL.UEM.TOTL.ZS',
              'SP.POP.TOTL'
          )
    )
    UPDATE cible
    SET
        cible.[value] = source.[value],
        cible.updated_at = SYSUTCDATETIME()
    FROM silver.economic_indicators AS cible
    INNER JOIN DonneesNettoyees AS source
        ON cible.country_code = source.country_code
       AND cible.[year] = source.[year]
       AND cible.indicator_code = source.indicator_code
    WHERE source.numero_ligne = 1;

    ;WITH DonneesNettoyees AS (
        SELECT
            country_code,
            [year],
            indicator_code,
            [value],
            ROW_NUMBER() OVER (
                PARTITION BY country_code, [year], indicator_code
                ORDER BY
                    CASE WHEN [value] IS NULL THEN 1 ELSE 0 END,
                    loaded_at DESC,
                    id DESC
            ) AS numero_ligne
        FROM bronze.world_bank_raw
        WHERE country_code IN (
            'FRA', 'DEU', 'USA', 'CHN', 'JPN', 'IND'
        )
          AND [year] BETWEEN 2015 AND 2026
          AND indicator_code IN (
              'NY.GDP.MKTP.CD',
              'FP.CPI.TOTL.ZG',
              'SL.UEM.TOTL.ZS',
              'SP.POP.TOTL'
          )
    )
    INSERT INTO silver.economic_indicators (
        country_code,
        [year],
        indicator_code,
        [value]
    )
    SELECT
        source.country_code,
        source.[year],
        source.indicator_code,
        source.[value]
    FROM DonneesNettoyees AS source
    WHERE source.numero_ligne = 1
      AND NOT EXISTS (
          SELECT 1
          FROM silver.economic_indicators AS cible
          WHERE cible.country_code = source.country_code
            AND cible.[year] = source.[year]
            AND cible.indicator_code = source.indicator_code
      );

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO
