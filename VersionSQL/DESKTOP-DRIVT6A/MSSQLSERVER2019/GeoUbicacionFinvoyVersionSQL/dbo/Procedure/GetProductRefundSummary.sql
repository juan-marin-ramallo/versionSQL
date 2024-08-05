/****** Object:  Procedure [dbo].[GetProductRefundSummary]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 25/11/2015
-- Description:	SP para obtener el resumen de devolucion de stock
-- =============================================
CREATE PROCEDURE [dbo].[GetProductRefundSummary]
(
	 @DateFrom [sys].DATETIME
	,@DateTo [sys].DATETIME 
	,@IdUser [sys].INT = NULL
)
AS
BEGIN

	SELECT		PR.[Id], PR.[Date] AS ProductRefundDate, PR.[Quantity], PR.[Description],
				PR.[IdPointOfInterest] AS PointOfInterestId, POI.[Name] AS PointOfInterestName, 
				POI.[Identifier] AS PointOfInterestIdentifier, POI.[Address] AS PointOfInterestAddress,
				PR.[IdPersonOfInterest] AS PersonOfInterestId, S.[Name] AS PersonOfInterestName, 
				S.[LastName] AS PersonOfInterestLastName, S.[Identifier] AS PersonOfInterestIdentifier,
				P.[Id] AS ProductId, P.[Name] AS ProductName, P.[BarCode], P.[Identifier] AS ProductIdentifier, P.[Indispensable],
				PC.Id AS ProductCategoryId, PC.Name AS ProductCategoryName, PB.[Id] AS BrandId, PB.[Identifier] AS BrandIdentifier, PB.[Name] AS BrandName
				,C.[Id] AS CompanyId, C.[Identifier] AS CompanyIdentifier, C.[Name] AS CompanyName

	FROM		[dbo].[ProductRefund] PR
				INNER JOIN [dbo].[PersonOfInterest] S ON S.[Id]= PR.[IdPersonOfInterest]
				INNER JOIN [dbo].[PointOfInterest] POI ON POI.[Id] = PR.[IdPointOfInterest]
				INNER JOIN [dbo].[Product] P ON P.[Id] = PR.[IdProduct]
				LEFT JOIN [dbo].[ProductCategoryList] PCL ON PCL.[IdProduct] = P.[Id]
				LEFT JOIN [dbo].[ProductCategory] PC ON PCL.[IdProductCategory] = PC.[Id]
				LEFT JOIN	[dbo].[ProductBrand] PB WITH(NOLOCK) ON P.[IdProductBrand] = PB.[Id]
				LEFT JOIN	[dbo].[Company] C WITH(NOLOCK) ON PB.[IdCompany] = C.[Id]

	WHERE		--CAST(PR.[Date] AS [sys].[date]) BETWEEN CAST(@DateFrom AS [sys].[date]) AND CAST(@DateTo AS [sys].[date]) AND
				PR.[Date] BETWEEN @DateFrom AND @DateTo AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(poi.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(POI.[IdDepartment], @IdUser) = 1))
				AND ((@IdUser IS NULL) OR (dbo.CheckUserInProductCompanies(P.[IdProductBrand], @IdUser) = 1))
	
	ORDER BY	PR.[Date], PR.[Id] DESC
END
