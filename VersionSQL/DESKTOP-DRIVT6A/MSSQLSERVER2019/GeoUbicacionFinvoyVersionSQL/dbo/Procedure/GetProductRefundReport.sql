/****** Object:  Procedure [dbo].[GetProductRefundReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 27/10/2015
-- Description:	SP para obtener el reporte de devolucion de stock
-- Change: Matias Corso - 14/10/2016 - Agrego filtros de producto por codigo de barras y categoría 
-- =============================================
CREATE PROCEDURE [dbo].[GetProductRefundReport]
(
	 @DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
	,@IdProducts [sys].[varchar](max) = NULL
	,@ProductBarCodes [sys].[varchar](max) = NULL
	,@ProductCategoriesId [sys].[varchar](max) = NULL
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL
	,@IdPointsOfInterest [sys].[varchar](max) = NULL
	,@IdCompany [sys].[varchar](max) = NULL
	,@IdProductBrand [sys].[varchar](max) = NULL
	,@IdUser [sys].INT = NULL
)
AS
BEGIN

	SELECT		PR.[Id], PR.[Date] AS ProductRefundDate, PR.[Quantity], PR.[Description],
				PR.[IdPointOfInterest] AS PointOfInterestId, POI.[Name] AS PointOfInterestName, 
				POI.[Identifier] AS PointOfInterestIdentifier, POI.[Address] AS PointOfInterestAddress,
				PR.[IdPersonOfInterest] AS PersonOfInterestId, S.[Name] AS PersonOfInterestName, 
				S.[LastName] AS PersonOfInterestLastName, S.[Identifier] AS PersonOfInterestIdentifier,
				P.[Id] AS ProductId, P.[Name] AS ProductName, P.[Identifier] as [ProductIdentifier], P.[BarCode], P.[Indispensable],
				PC.Id AS ProductCategoryId, PC.Name AS ProductCategoryName,
				PRAV.[IdProductRefundAttribute], PRAV.[Value] AS ProductRefundAttributeValue, PRAV.[Id] AS IdProductRefundAttributeValue,
				PRAT.[IdType] AS IdProductRefundAttributeType, 
				PRO.[Text] AS ProductRefundAttributeOption,
				PRAV.[ImageEncoded] AS ProductRefundAttributeImage, PRAV.[ImageUrl] AS ProductRefundAttributeImageUrl,
				PRAV.[ImageName] AS ProductRefundAttributeImageName,
				PRATYPE.[Id] AS IdProductRefundAttributeType, PB.[Id] AS BrandId, PB.[Identifier] AS BrandIdentifier, PB.[Name] AS BrandName
				,C.[Id] AS CompanyId, C.[Identifier] AS CompanyIdentifier, C.[Name] AS CompanyName

	FROM		[dbo].[ProductRefund] PR WITH(NOLOCK) 
				INNER JOIN	[dbo].[PersonOfInterest] S WITH(NOLOCK) ON S.[Id]= PR.[IdPersonOfInterest]
				INNER JOIN	[dbo].[PointOfInterest] POI ON POI.[Id] = PR.[IdPointOfInterest]
				INNER JOIN	[dbo].[Product] P WITH(NOLOCK) ON P.[Id] = PR.[IdProduct]
				LEFT JOIN	[dbo].[ProductBrand] PB WITH(NOLOCK) ON P.[IdProductBrand] = PB.[Id]
				LEFT JOIN	[dbo].[Company] C WITH(NOLOCK) ON PB.[IdCompany] = C.[Id]
				LEFT JOIN	[dbo].[ProductCategoryList] PCL WITH(NOLOCK) ON PCL.[IdProduct] = P.[Id]
				LEFT JOIN	[dbo].[ProductCategory] PC WITH(NOLOCK) ON PCL.[IdProductCategory] = PC.[Id]
				LEFT JOIN   [dbo].[ProductRefundAttributeValue] PRAV WITH(NOLOCK) ON PRAV.[IdProductRefund] = PR.[Id]
				LEFT JOIN   [dbo].[ProductRefundAttribute] PRAT WITH(NOLOCK) ON PRAT.[Id] = PRAV.[IdProductRefundAttribute]
				LEFT JOIN   [dbo].[ProductRefundAttributeOption] PRO WITH(NOLOCK) ON PRO.[Id] = PRAV.[IdProductRefundAttributeOption]
				LEFT JOIN	[dbo].[ProductReportAttributeTypeTranslated] PRATYPE WITH(NOLOCK) ON PRATYPE.[Id] = PRAT.[IdType]
	
	WHERE		PR.[Date] BETWEEN @DateFrom AND @DateTo AND
				((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
				((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(POI.[Id], @IdPointsOfInterest) = 1)) AND
				((@IdProducts IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdProducts) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(poi.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(POI.[IdDepartment], @IdUser) = 1)) AND
				((@ProductBarCodes IS NULL) OR (dbo.CheckVarcharInList(P.[BarCode], @ProductBarCodes) = 1)) AND
				((@ProductCategoriesId IS NULL) OR (dbo.CheckValueInList(PC.[Id], @ProductCategoriesId) = 1))
				AND (@IdProductBrand IS NULL OR dbo.CheckValueInList(IIF(PB.[Id] IS NULL, 0, PB.[Id]), @IdProductBrand) = 1)
				AND (@IdCompany IS NULL OR dbo.CheckValueInList(IIF(C.[Id] IS NULL, 0, C.[Id]), @IdCompany) = 1)
				AND (PRAV.[Id] IS NULL OR PRAT.[FullDeleted] = 0)
				AND ((@IdUser IS NULL) OR (dbo.CheckUserInProductCompanies(P.[IdProductBrand], @IdUser) = 1))

	ORDER BY	PR.[Date] DESC, PR.[Id], PCL.[Id]
END
