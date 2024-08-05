/****** Object:  Procedure [dbo].[SaveOrUpdateCatalogsPointsOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SaveOrUpdateCatalogsPointsOfInterest]
	 @PointsOfInterestIds [sys].[varchar](8000)
	,@CatalogIds [sys].[varchar](8000)
AS
BEGIN 
	
	INSERT INTO [dbo].[CatalogPointOfInterest] ([IdPointOfInterest], [IdCatalog])
	SELECT	POI.[Id], C.[Id]
	FROM	[dbo].[PointOfInterest] AS POI, [dbo].[Catalog] AS C
	WHERE	[dbo].[CheckValueInList](POI.[Id], @PointsOfInterestIds) > 0
			AND [dbo].[CheckValueInList](C.[Id], @CatalogIds) > 0
			AND NOT EXISTS (SELECT 1 FROM [dbo].[CatalogPointOfInterest] AS CPOI 
							WHERE CPOI.[IdPointOfInterest] = POI.[Id] AND CPOI.[IdCatalog] = C.[Id])
END
