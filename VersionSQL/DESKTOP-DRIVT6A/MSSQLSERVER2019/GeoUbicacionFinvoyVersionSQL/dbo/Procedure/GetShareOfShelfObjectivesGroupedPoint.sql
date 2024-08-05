/****** Object:  Procedure [dbo].[GetShareOfShelfObjectivesGroupedPoint]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 27/03/2019
-- Description:	SP para obtener el reporte Share of shelf
-- =============================================
CREATE PROCEDURE [dbo].[GetShareOfShelfObjectivesGroupedPoint]
(
	 @IdProductCategories [sys].[varchar](max) = NULL 
	,@IdZone [sys].[varchar](max) = NULL
	,@IdPOIHierarchyLevel1 [sys].[varchar](max) = NULL
	,@IdPOIHierarchyLevel2 [sys].[varchar](max) = NULL
	,@IdProductBrand [sys].[varchar](max) = NULL
	,@IdCompany [sys].[varchar](max) = NULL 
	,@IdUser [sys].INT = NULL
)
AS
BEGIN
	SELECT  MIN(SOS.[Id]) AS [Id], SOS.[IdZone], SOS.[ZoneName]
				,SOS.[IdPOIHierarchyLevel1], SOS.[POIHierarchyLevel1Name]
				,SOS.[IdPOIHierarchyLevel2], SOS.[POIHierarchyLevel2Name]
	FROM dbo.[GetShareOfShelfObjectives](@IdProductCategories, @IdZone, @IdPOIHierarchyLevel1, @IdPOIHierarchyLevel2, @IdProductBrand, @IdCompany, @IdUser) AS SOS
	GROUP BY SOS.[IdZone], SOS.[ZoneName]
			,SOS.[IdPOIHierarchyLevel1], SOS.[POIHierarchyLevel1Name]
			,SOS.[IdPOIHierarchyLevel2], SOS.[POIHierarchyLevel2Name]
	ORDER BY IIF(SOS.[IdZone] IS NULL, 0, 1) desc, SOS.ZoneName asc, IIF(SOS.[IdPOIHierarchyLevel1] IS NULL, 0, 1) desc, SOS.[POIHierarchyLevel1Name] asc, SOS.[POIHierarchyLevel2Name] asc
END
