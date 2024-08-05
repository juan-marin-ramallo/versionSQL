/****** Object:  Procedure [dbo].[UpdateProductMissing]    Committed by VersionSQL https://www.versionsql.com ******/

-- =======================================================
-- Author: Barbarini Cristian
-- Create date: 18/07/22
-- Description: SP para actualizar el reporte de Faltantes
-- =======================================================
CREATE PROCEDURE [dbo].[UpdateProductMissing]
(
	@IdProductMissing INT,
	@Products [ProductMissingTableType] READONLY
)
AS BEGIN
	IF EXISTS (SELECT TOP 1 Id FROM dbo.ProductMissingPointOfInterest NOLOCK WHERE Id = @IdProductMissing)
	BEGIN
		DELETE FROM ProductMissingReport WHERE IdMissingProductPoi = @IdProductMissing
		INSERT INTO ProductMissingReport
		SELECT @IdProductMissing, IdProduct
		FROM @Products
		WHERE IdProduct NOT IN (SELECT IdProduct FROM ProductMissingReport NOLOCK WHERE IdMissingProductPoi = @IdProductMissing)
	END

	DECLARE @MissingConfirmation BIT = 0;
	SELECT @MissingConfirmation = CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END FROM @Products
	UPDATE ProductMissingPointOfInterest SET IsValid = 1, MissingConfirmation = @MissingConfirmation, ValidationDate = GETUTCDATE() WHERE Id = @IdProductMissing
END
