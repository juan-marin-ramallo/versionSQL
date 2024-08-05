/****** Object:  Procedure [dbo].[GetShareOfShelfSimilarReports]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 27/03/2019
-- Description:	SP para obtener el reporte Share of shelf
-- =============================================
CREATE PROCEDURE [dbo].[GetShareOfShelfSimilarReports]
(
	 @IdShareOfShelf [sys].[int]
	,@Limit [sys].[int]
)
AS
BEGIN

	SELECT	SOS.[Id], SOS.[Date], SOS.[PointOfInterestId], PointOfInterestName,SOS.[PointOfInterestIdentifier], 
			SOS.[HierarchyLevel1Id], SOS.[HierarchyLevel2Id], SOS.[HierarchyLevel1Name], SOS.[HierarchyLevel2Name], SOS.[HierarchyLevel1SapId], SOS.[HierarchyLevel2SapId],
			SOS.[BrandId], SOS.[BrandName], SOS.[BrandIdentifier],
			SOS.[ItemId], SOS.[Total], SOS.[ProductMinSalesQuantity], SOS.[ProductMinUnitsPackage],
			SOS.[ProductMaxSalesQuantity], SOS.[ProductInStock]
	
	FROM		dbo.[GetShareOfShelfSimilarReport](@IdShareOfShelf,@Limit) AS SOS

	ORDER BY	SOS.[Date] DESC, SOS.[Id] DESC, SOS.Total DESC--, PCL.Id ASC
END
