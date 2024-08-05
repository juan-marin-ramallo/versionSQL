/****** Object:  Procedure [dbo].[GetCatalogExclusiveProductIdsFromPoint]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetCatalogExclusiveProductIdsFromPoint]
	 @IdCatalog [int]
	,@IdPointOfInterest [int]
AS
BEGIN

	SELECT P.[Id]
	FROM Product P
	JOIN CatalogProduct CP ON CP.[IdProduct] = P.[Id]
	JOIN CatalogPointOfInterest CPOI ON CPOI.[IdCatalog] = CP.[IdCatalog]
	JOIN ProductPointOfInterest PPOI ON PPOI.[IdProduct] = P.[Id] AND PPOI.[IdPointOfInterest] = CPOI.[IdPointOfInterest] AND PPOI.[IdCatalog] = CPOI.[IdCatalog]
	WHERE CP.[IdCatalog] = @IdCatalog 
	  AND CPOI.[IdPointOfInterest] = @IdPointOfInterest
	  AND P.[Id] NOT IN (
		SELECT P1.[Id]
		FROM Product P1
		JOIN CatalogProduct CP1 ON CP1.[IdProduct] = P1.[Id]
		JOIN CatalogPointOfInterest CPOI1 ON CPOI1.[IdCatalog] = CP1.[IdCatalog]
		WHERE CP1.[IdCatalog] <> @IdCatalog 
		  AND CPOI1.[IdPointOfInterest] = @IdPointOfInterest
	  )

END
