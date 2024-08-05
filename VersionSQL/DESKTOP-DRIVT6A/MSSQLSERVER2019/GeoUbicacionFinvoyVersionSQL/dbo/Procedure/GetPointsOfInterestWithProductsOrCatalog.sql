/****** Object:  Procedure [dbo].[GetPointsOfInterestWithProductsOrCatalog]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Daniel Artigas
-- Create date: 28/04/2021
-- Description:	SP para obtener la información de los puntos de interés para ver en los dispositivos en cuanto a formularios, promociones, productos, activos, contratos y planimetrias.
-- =============================================
--exec GetPointsOfInterestWithProductsOrCatalog ',1021,',null,null,null,null,1
CREATE PROCEDURE [dbo].[GetPointsOfInterestWithProductsOrCatalog] (
	@IdPointsOfInterest [sys].[varchar](max) = NULL
	,@IdProduct [sys].[varchar](max) = NULL
	,@ProductCategoriesId [sys].[varchar](max) = NULL 
	,@IdCompany [sys].[varchar](max) = NULL
	,@IdProductBrand [sys].[varchar](max) = NULL
	,@IdUser [sys].[int] = NULL
)
AS
BEGIN
	
	SELECT		P.[Id], P.[Name], P.[Address], P.[Identifier]
	FROM		[dbo].[ProductPointOfInterest] PRP WITH (NOLOCK)
				INNER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = PRP.[IdPointOfInterest]
				left JOIN [dbo].[Product] PR WITH (NOLOCK) ON PRP.[IdProduct] = PR.[Id]
				LEFT JOIN [dbo].[PointOfInterestZone] PZ WITH (NOLOCK) ON PZ.[IdPointOfInterest] = P.[Id]
				LEFT JOIN [dbo].[ProductCategoryList] PCL WITH(NOLOCK) ON PCL.[IdProduct] = PR.[Id] 
				LEFT OUTER JOIN	[dbo].[ProductBrand] B WITH (NOLOCK) ON B.[Id] = PR.IdProductBrand
				LEFT OUTER JOIN	[dbo].[Company] CM WITH (NOLOCK) ON CM.[Id] = B.IdCompany
				LEFT JOIN [dbo].[CatalogPointOfInterest] C WITH (NOLOCK) ON C.IdPointOfInterest = P.Id
	WHERE		P.[Deleted] = 0 AND (pr.Deleted = 0 OR (C.IdCatalog is not null)) AND
				((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckZoneInUserZones(PZ.[IdZone], @IdUser) = 1)) AND
			    ((@IdProduct IS NULL) OR (dbo.CheckValueInList(PR.[Id], @IdProduct) = 1)) AND
				(@ProductCategoriesId IS NULL OR dbo.CheckValueInList(PCL.[IdProductCategory], @ProductCategoriesId) = 1) AND
				(@IdProductBrand IS NULL OR dbo.CheckValueInList(IIF(B.[Id] IS NULL, 0, B.[Id]), @IdProductBrand) = 1) AND 
				(@IdCompany IS NULL OR dbo.CheckValueInList(IIF(CM.[Id] IS NULL, 0, CM.[Id]), @IdCompany) = 1) AND
				(C.[IdCatalog] is not null or PRP.[Id] is not null)
	GROUP BY	P.[Id], P.[Name], P.[Address], P.[Identifier]
	ORDER BY	P.[Name]
END
