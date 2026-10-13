
USE WorldBankEconomicDB;
GO

SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    WITH Doublons AS (
        SELECT
            id,
            ROW_NUMBER() OVER (
                PARTITION BY country_code, [year], indicator_code
                ORDER BY id
            ) AS numero_ligne
        FROM bronze.world_bank_raw
        WHERE indicator_code = 'NY.GDP.MKTP.CD'
    )
    DELETE FROM Doublons
    WHERE numero_ligne > 1;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO

SELECT
    indicator_code,
    COUNT(*) AS nombre_lignes
FROM bronze.world_bank_raw
GROUP BY indicator_code;
GO
