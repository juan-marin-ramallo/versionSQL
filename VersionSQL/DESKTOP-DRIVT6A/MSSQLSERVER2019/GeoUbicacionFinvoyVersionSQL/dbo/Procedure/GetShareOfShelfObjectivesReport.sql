/****** Object:  Procedure [dbo].[GetShareOfShelfObjectivesReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 27/03/2019
-- Description:	SP para obtener el reporte Share of shelf
-- =============================================
CREATE PROCEDURE [dbo].[GetShareOfShelfObjectivesReport]
(
	 @DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
	,@IdProductCategorySOS [sys].[int]
	,@IdZone [sys].[int] = NULL
	,@IdPOIHierarchyLevel1 [sys].[int] = NULL
	,@IdPOIHierarchyLevel2 [sys].[int] = NULL

	,@IdProduct [sys].[varchar](max) = NULL
	,@IdProductCategories [sys].[varchar](max) = NULL
	,@IdProductBrand [sys].[varchar](max) = NULL
	,@IdCompany [sys].[varchar](max) = NULL
	,@IdPointOfInterest [sys].[varchar](max) = NULL
	,@IdPersonOfInterest [sys].[varchar](max) = NULL
	,@IsManual [sys].[bit] = NULL
	,@IdUser [sys].INT = NULL
)
AS
BEGIN	
	;WITH ActiveObjectives AS (
		SELECT Id, IdZone, IdPOIHierarchyLevel1, IdPOIHierarchyLevel2
		FROM  [dbo].[ShareOfShelfObjective]
		WHERE Deleted = 0 AND IdProductCategory = @IdProductCategorySOS 
			AND (IdZone = @IdZone OR IdPOIHierarchyLevel1 = @IdPOIHierarchyLevel1 OR IdPOIHierarchyLevel2 = @IdPOIHierarchyLevel2)
	),
	SegmentInfo AS (
		SELECT Z.[Id] as IdZone, Z.[Description] as ZoneName, NULL as IdPOIHierarchyLevel1, NULL as POIHierarchyLevel1Name, NULL as IdPOIHierarchyLevel2,NULL as POIHierarchyLevel2Name
		FROM [dbo].[Zone] Z WITH (NOLOCK)
		WHERE Z.Id = @IdZone
		UNION ALL
		SELECT NULL as IdZone, NULL as ZoneName, PH1.[Id] as IdPOIHierarchyLevel1,PH1.[Name] as POIHierarchyLevel1Name, NULL as IdPOIHierarchyLevel2,NULL as POIHierarchyLevel2Name
		FROM [dbo].[POIHierarchyLevel1] PH1 WITH (NOLOCK)
		WHERE PH1.Id = @IdPOIHierarchyLevel1
		UNION ALL
		SELECT NULL as IdZone, NULL as ZoneName, NULL as IdPOIHierarchyLevel1, NULL as POIHierarchyLevel1Name,PH2.[Id] as IdPOIHierarchyLevel2,PH2.[Name] as POIHierarchyLevel2Name
		FROM [dbo].[POIHierarchyLevel2] PH2 WITH (NOLOCK)
		WHERE PH2.Id = @IdPOIHierarchyLevel2
	)
	SELECT SI.[Id] as ObjectiveId
			, SUM(SOS.[Total]) AS [Total] 
			, SI.[Value] as ObjectiveValue
			, ISNULL(C.[IsMain], SOS.CompanyIsMain) AS [IsMain]
			, ISNULL(SI.[IdProductBrand], SOS.[BrandId]) AS [IdBrand]
			, ISNULL(B.[Name], SOS.[BrandName]) AS [BrandName]
			, ISNULL(B.[Identifier], SOS.[BrandIdentifier]) AS [BrandIdentifier]
			, SEGM.IdZone
			, SEGM.ZoneName
			, SEGM.IdPOIHierarchyLevel1
			, SEGM.POIHierarchyLevel1Name
			, SEGM.IdPOIHierarchyLevel2
			, SEGM.POIHierarchyLevel2Name
	FROM ActiveObjectives SOSO WITH (NOLOCK)
		LEFT OUTER JOIN	[dbo].[ShareOfShelfObjectiveItem] SI WITH (NOLOCK) ON SOSO.[Id] = SI.IdShareOfShelfObjective
		LEFT OUTER JOIN	[dbo].[ProductBrand] B WITH (NOLOCK) ON B.[Id] = SI.IdProductBrand 
		LEFT OUTER JOIN	[dbo].[Company] C WITH (NOLOCK) ON C.[Id] = B.IdCompany
		FULL OUTER JOIN [dbo].[GetShareOfShelfReport](@DateFrom,@DateTo,@IdProductCategorySOS,@IdProduct,@IdProductCategories,@IdProductBrand,@IdCompany,@IdPointOfInterest,@IdPersonOfInterest,@IsManual,@IdUser) AS SOS
			ON SOS.BrandId = B.Id
		,SegmentInfo AS SEGM
	GROUP BY  SI.[Id], SI.[Value]
			, ISNULL(C.[IsMain], SOS.CompanyIsMain)
			, ISNULL(SI.[IdProductBrand], SOS.[BrandId])
			, ISNULL(B.[Name], SOS.[BrandName])
			, ISNULL(B.[Identifier], SOS.[BrandIdentifier])
			, SEGM.IdZone, SEGM.ZoneName, SEGM.IdPOIHierarchyLevel1, SEGM.POIHierarchyLevel1Name, SEGM.IdPOIHierarchyLevel2, SEGM.POIHierarchyLevel2Name
	ORDER BY ISNULL(C.[IsMain], SOS.CompanyIsMain) DESC, ISNULL(B.[Name], SOS.[BrandName]) ASC
END
