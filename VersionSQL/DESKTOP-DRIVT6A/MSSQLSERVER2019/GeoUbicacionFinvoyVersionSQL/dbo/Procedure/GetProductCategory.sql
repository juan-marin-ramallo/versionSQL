/****** Object:  Procedure [dbo].[GetProductCategory]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Matias Corso
-- Create date: 12/10/2016
-- Description:	SP para obtener las categorías de los productos
-- Modified date: 24/10/2023
-- Description:	Se parametriza el sp para que retorne la categoria de productos de acuerdo a la configuracion OrdenCategoriasProducto
-- =============================================
CREATE PROCEDURE [dbo].[GetProductCategory]
	@IdOptions [sys].[VARCHAR](max) = NULL
AS
BEGIN

	DECLARE @OrderByName AS [sys].[bit]

	SET @OrderByName = (SELECT [Value] FROM dbo.[Configuration] WHERE IdConfigurationGroup = 2 and [Name] = 'OrderProductCategory')
	

	SELECT		PC.[Id], PC.[Name] as ProductCategoryName, PC.[Description], PC.[CreatedDate], PC.[IdUser], U.[Name], U.[LastName], PC.[Deleted], PC.[Order]

	FROM		[dbo].[ProductCategory] PC
				INNER JOIN [dbo].[User] U ON U.[Id] = PC.[IdUser]
	
	WHERE		PC.[Deleted] = 0 AND
				((@IdOptions IS NULL) OR (dbo.CheckValueInList(PC.[Id], @IdOptions) = 1))
	
	ORDER BY 
				CASE @OrderByName WHEN 1 THEN PC.[Name] END,
				CASE @OrderByName WHEN 0 THEN PC.[Order] END,
				CASE @OrderByName WHEN 0 THEN PC.[Name] END
END
