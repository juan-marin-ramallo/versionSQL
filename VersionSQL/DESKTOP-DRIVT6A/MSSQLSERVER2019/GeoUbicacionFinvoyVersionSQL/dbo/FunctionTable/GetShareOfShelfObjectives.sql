/****** Object:  TableFunction [dbo].[GetShareOfShelfObjectives]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 27/03/2019
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[GetShareOfShelfObjectives]
(
	 @IdProductCategories [sys].[varchar](max) = NULL 
	,@IdZone [sys].[varchar](max) = NULL
	,@IdPOIHierarchyLevel1 [sys].[varchar](max) = NULL
	,@IdPOIHierarchyLevel2 [sys].[varchar](max) = NULL
	,@IdProductBrand [sys].[varchar](max) = NULL
	,@IdCompany [sys].[varchar](max) = NULL 
	,@IdUser [sys].INT = NULL
)
RETURNS @t TABLE ([Id] [sys].[INT], [IdProductCategory] [sys].[INT], [ProductCategoryName] [sys].[varchar](50)
				,[IdZone] [sys].[INT], [ZoneName] [sys].[varchar](100)
				,[IdPOIHierarchyLevel1] [sys].[INT], [POIHierarchyLevel1Name] [sys].[varchar](100)
				,[IdPOIHierarchyLevel2] [sys].[INT], [POIHierarchyLevel2Name] [sys].[varchar](100)
				,IdShareOfShelfObjectiveItem [sys].[INT], IdProductBrand [sys].[INT], [ProductBrandName] [sys].[varchar](50), [Value] [sys].[decimal](5,2))
AS
BEGIN
	
	INSERT INTO @t 
	SELECT		 SOS.[Id], SOS.[IdProductCategory], PC.[Name] as [ProductCategoryName]
				,SOS.[IdZone], Z.[Description] as [ZoneName]
				,SOS.[IdPOIHierarchyLevel1], POIH1.[Name] as [POIHierarchyLevel1Name]
				,SOS.[IdPOIHierarchyLevel2], POIH2.[Name] as [POIHierarchyLevel2Name]
				,SI.Id AS IdShareOfShelfObjectiveItem, SI.IdProductBrand, B.[Name] AS [ProductBrandName], SI.[Value]
	
	FROM		[dbo].[ShareOfShelfObjective] SOS WITH (NOLOCK)
				INNER JOIN	[dbo].[ProductCategory] PC WITH (NOLOCK) ON SOS.[IdProductCategory] = PC.Id
				LEFT OUTER JOIN	[dbo].[Zone] Z WITH (NOLOCK) ON SOS.[IdZone] = Z.Id
				LEFT OUTER JOIN	[dbo].[POIHierarchyLevel1] POIH1 WITH (NOLOCK) ON SOS.[IdPOIHierarchyLevel1] = POIH1.Id
				LEFT OUTER JOIN	[dbo].[POIHierarchyLevel2] POIH2 WITH (NOLOCK) ON SOS.[IdPOIHierarchyLevel2] = POIH2.Id
				LEFT OUTER JOIN	[dbo].[ShareOfShelfObjectiveItem] SI WITH (NOLOCK) ON SOS.[Id] = SI.IdShareOfShelfObjective
				LEFT OUTER JOIN	[dbo].[ProductBrand] B WITH (NOLOCK) ON B.[Id] = SI.IdProductBrand
				LEFT OUTER JOIN	[dbo].[Company] C WITH (NOLOCK) ON C.[Id] = B.IdCompany
	
	WHERE		SOS.Deleted = 0 
				AND (@IdProductCategories IS NULL OR dbo.CheckValueInList(SOS.[IdProductCategory], @IdProductCategories) = 1) 
				AND (@IdZone IS NULL OR dbo.CheckValueInList(SOS.[IdZone], @IdZone) = 1) 
				AND (@IdPOIHierarchyLevel1 IS NULL OR dbo.CheckValueInList(SOS.[IdPOIHierarchyLevel1], @IdPOIHierarchyLevel1) = 1) 
				AND (@IdPOIHierarchyLevel2 IS NULL OR dbo.CheckValueInList(SOS.[IdPOIHierarchyLevel2], @IdPOIHierarchyLevel2) = 1) 
				AND (@IdProductBrand IS NULL OR dbo.CheckValueInList(IIF(B.[Id] IS NULL, 0, B.[Id]), @IdProductBrand) = 1)
				AND (@IdCompany IS NULL OR dbo.CheckValueInList(IIF(C.[Id] IS NULL, 0, C.[Id]), @IdCompany) = 1)
				AND (@IdUser IS NULL OR dbo.CheckZoneInUserZones(SOS.[IdZone], @IdUser) = 1) 
				AND ((@IdUser IS NULL) OR (dbo.CheckUserInProductCompanies(SI.[IdProductBrand], @IdUser) = 1)) 

	GROUP BY	SOS.[Id], SOS.[IdProductCategory], PC.[Name]
				,SOS.[IdZone], Z.[Description]
				,SOS.[IdPOIHierarchyLevel1], POIH1.[Name]
				,SOS.[IdPOIHierarchyLevel2], POIH2.[Name]
				,SI.Id, SI.IdProductBrand, B.[Name], SI.[Value]
	
	--ORDER BY	Z.[Description] DESC, POIH1.[Name] DESC, POIH2.[Name] ASC
	RETURN 

END
