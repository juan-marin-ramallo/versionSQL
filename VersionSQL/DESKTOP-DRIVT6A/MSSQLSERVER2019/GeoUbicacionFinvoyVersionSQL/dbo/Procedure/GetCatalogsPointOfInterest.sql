/****** Object:  Procedure [dbo].[GetCatalogsPointOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetCatalogsPointOfInterest]
	 @IdPointsOfInterest [sys].[varchar](max) = NULL
	,@IdCatalog [sys].[varchar](max) = NULL
	,@IdProductBrand [sys].[varchar](max) = NULL
	,@IdCompany [sys].[varchar](max) = NULL
	,@IdUser [sys].[int] = NULL
AS
BEGIN
	SELECT		P.[Id] AS PointOfInterestId, P.[Name] AS PointOfInterestName, P.[Address] AS PointOfInterestAddress, 
				P.[Identifier] AS PointOfInterestIdentifier,
				C.[Id] AS CatalogId, C.[Name] AS CatalogName

	FROM		[dbo].[CatalogPointOfInterest] CP WITH (NOLOCK)
				INNER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = CP.[IdPointOfInterest]
				INNER JOIN [dbo].[Catalog] C WITH (NOLOCK) ON CP.[IdCatalog] = C.[Id]
				LEFT OUTER JOIN [dbo].[CatalogProduct] CPR WITH (NOLOCK) ON CPR.[IdCatalog] = CP.[IdCatalog]
				LEFT OUTER JOIN [dbo].[Product] PR WITH(NOLOCK) ON  PR.Id = CPR.IdProduct
				LEFT OUTER JOIN [dbo].[PointOfInterestZone] PZ WITH (NOLOCK) ON PZ.[IdPointOfInterest] = P.[Id]
				LEFT OUTER JOIN	[dbo].[ProductBrand] B WITH (NOLOCK) ON B.[Id] = PR.IdProductBrand
				LEFT OUTER JOIN	[dbo].[Company] CM WITH (NOLOCK) ON CM.[Id] = B.IdCompany
	
	WHERE		P.[Deleted] = 0 AND C.[Deleted] = 0 AND
				((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckZoneInUserZones(PZ.[IdZone], @IdUser) = 1))AND
				((@IdCatalog IS NULL) OR (dbo.CheckValueInList(C.[Id], @IdCatalog) = 1)) 	
				AND (@IdProductBrand IS NULL OR dbo.CheckValueInList(IIF(B.[Id] IS NULL, 0, B.[Id]), @IdProductBrand) = 1)
				AND (@IdCompany IS NULL OR dbo.CheckValueInList(IIF(CM.[Id] IS NULL, 0, CM.[Id]), @IdCompany) = 1)
	
	GROUP BY	P.[Id], P.[Name], P.[Address], P.[Identifier], C.[Id], C.[Name]
	
	ORDER BY	P.[Name], C.[Name]		
END
