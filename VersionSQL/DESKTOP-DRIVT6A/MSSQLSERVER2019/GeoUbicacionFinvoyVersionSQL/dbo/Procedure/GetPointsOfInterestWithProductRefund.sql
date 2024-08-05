/****** Object:  Procedure [dbo].[GetPointsOfInterestWithProductRefund]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetPointsOfInterestWithProductRefund]
	 @DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
	,@IdProduct [sys].[varchar](max) = NULL
	,@ProductBarCodes [sys].[varchar](max) = NULL
	,@ProductCategoriesId [sys].[varchar](max) = NULL
	,@IdPointOfInterest [sys].[varchar](max) = NULL
	,@IdPersonOfInterest [sys].[varchar](max) = NULL
	,@IdCompany [sys].[varchar](max) = NULL
	,@IdProductBrand [sys].[varchar](max) = NULL
	,@IdUser [sys].INT = NULL
AS 
BEGIN

	SELECT		P.[Id], P.[Name], 
				P.[Address], P.[Latitude], P.[Longitude], P.[Radius], P.[MinElapsedTimeForVisit], P.[IdDepartment],
				P.[Identifier]

	FROM		dbo.[ProductRefund] PR
				INNER JOIN	[dbo].[PointOfInterest] P ON P.[Id] = PR.[IdPointOfInterest]
				INNER JOIN	[dbo].[PersonOfInterest] S ON S.[Id] = PR.[IdPersonOfInterest]
				INNER JOIN	[dbo].[Product] PROD ON PROD.[Id] = PR.[IdProduct]
				LEFT JOIN [dbo].[ProductCategoryList] PCL ON PCL.[IdProduct] = PROD.[Id]
				LEFT JOIN [dbo].[ProductCategory] PC ON PCL.[IdProductCategory] = PC.[Id]
				LEFT OUTER JOIN	[dbo].[ProductBrand] PB WITH (NOLOCK) ON PB.[Id] = PROD.IdProductBrand
				LEFT OUTER JOIN	[dbo].[Company] CM WITH (NOLOCK) ON CM.[Id] = PB.IdCompany

	WHERE		PR.[Date] BETWEEN @DateFrom AND @DateTo AND
				((@IdPointOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointOfInterest) = 1)) AND
				((@IdPersonOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonOfInterest) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) AND
				((@IdProduct IS NULL) OR (dbo.CheckValueInList(PROD.[Id], @IdProduct) = 1)) AND
				((@ProductBarCodes IS NULL) OR (dbo.CheckVarcharInList(PROD.[BarCode], @ProductBarCodes) = 1))AND
				((@ProductCategoriesId IS NULL) OR (dbo.CheckVarcharInList (PC.[Id], @ProductCategoriesId) = 1))
				AND (@IdProductBrand IS NULL OR dbo.CheckValueInList(IIF(PB.[Id] IS NULL, 0, PB.[Id]), @IdProductBrand) = 1)
				AND (@IdCompany IS NULL OR dbo.CheckValueInList(IIF(CM.[Id] IS NULL, 0, CM.[Id]), @IdCompany) = 1)
				AND ((@IdUser IS NULL) OR (dbo.CheckUserInProductCompanies(PROD.[IdProductBrand], @IdUser) = 1))
	GROUP BY P.[Id], P.[Name], 
				P.[Address], P.[Latitude], P.[Longitude], P.[Radius], P.[MinElapsedTimeForVisit], P.[IdDepartment],
				P.[Identifier], PR.[Date]
	ORDER BY	PR.[Date] DESC

END
