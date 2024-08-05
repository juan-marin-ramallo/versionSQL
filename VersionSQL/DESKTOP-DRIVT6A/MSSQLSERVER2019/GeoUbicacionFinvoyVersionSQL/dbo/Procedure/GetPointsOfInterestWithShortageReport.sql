/****** Object:  Procedure [dbo].[GetPointsOfInterestWithShortageReport]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetPointsOfInterestWithShortageReport]
	 @DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
	,@IdProduct [sys].[varchar](max) = NULL
	,@ProductBarCodes [sys].[varchar](max) = NULL
	,@ProductCategoriesId [sys].[varchar](max) = NULL
	,@IdPointOfInterest [sys].[varchar](max) = NULL
	,@IdPersonOfInterest [sys].[varchar](max) = NULL
	,@IdShortageType [sys].[varchar](max) = NULL
	,@IdCompany [sys].[varchar](max) = NULL
	,@IdProductBrand [sys].[varchar](max) = NULL
	,@IdUser [sys].INT = NULL
AS 
BEGIN

	
		CREATE TABLE #ProductsFiltered
		(
			IdProduct [sys].[int]
		)


		INSERT INTO #ProductsFiltered(IdProduct)
		SELECT DISTINCT P.[Id]
		FROM [dbo].[Product] P WITH (NOLOCK)
		left JOIN	[dbo].[ProductCategoryList] PCL ON PCL.[IdProduct] = P.[Id]
				LEFT OUTER JOIN	[dbo].[ProductBrand] PB WITH (NOLOCK) ON PB.[Id] = P.IdProductBrand
				LEFT OUTER JOIN	[dbo].[Company] CM WITH (NOLOCK) ON CM.[Id] = PB.IdCompany
		WHERE ((@IdProduct IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdProduct) = 1)) 
				AND	((@ProductBarCodes IS NULL) OR (dbo.CheckValueInList(P.[Id], @ProductBarCodes) = 1)) 
				AND	((@ProductCategoriesId IS NULL) OR (dbo.CheckValueInList(PCL.[IdProductCategory], @ProductCategoriesId) = 1)) 
				AND (@IdProductBrand IS NULL OR dbo.CheckValueInList(IIF(PB.[Id] IS NULL, 0, PB.[Id]), @IdProductBrand) = 1)
				AND (@IdCompany IS NULL OR dbo.CheckValueInList(IIF(CM.[Id] IS NULL, 0, CM.[Id]), @IdCompany) = 1)
				AND ((@IdUser IS NULL) OR (dbo.CheckUserInProductCompanies(P.[IdProductBrand], @IdUser) = 1)) 

	SELECT		P.[Id], P.[Name], 
				P.[Address], P.[Latitude], P.[Longitude], P.[Radius], P.[MinElapsedTimeForVisit], P.[IdDepartment],
				P.[Identifier]

	FROM		dbo.[ProductMissingPointOfInterest] PM
				INNER JOIN	[dbo].[PointOfInterest] P ON P.[Id] = PM.[IdPointOfInterest]
				INNER JOIN	[dbo].[PersonOfInterest] S ON S.[Id] = PM.[IdPersonOfInterest]

	WHERE		PM.[Date] BETWEEN @DateFrom AND @DateTo AND
				PM.[MissingConfirmation] = 1 AND PM.[Deleted] = 0 AND
				((@IdPointOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointOfInterest) = 1)) AND
				((@IdPersonOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonOfInterest) = 1)) AND
				((@IdShortageType IS NULL) OR (dbo.CheckValueInList(PM.[IdProductMissingType], @IdShortageType) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))
				AND ((PM.[MissingConfirmation] = 0) OR EXISTS (SELECT 1 FROM
																[dbo].[ProductMissingReport] PMR 
																INNER JOIN	#ProductsFiltered P ON P.[IdProduct] = PMR.[IdProduct]
																WHERE PMR.[IdMissingProductPoi] = PM.[Id]))
				--AND ((@IdProduct IS NULL) OR EXISTS(
				--							SELECT 1 FROM
				--							[dbo].[ProductMissingReport] PMR 
				--							INNER JOIN	[dbo].[Product] P ON P.[Id] = PMR.[IdProduct]
				--							WHERE PMR.[IdMissingProductPoi] = PM.[Id] AND  
				--							(dbo.CheckValueInList(P.[Id], @IdProduct) = 1)))
				--AND ((@ProductBarCodes IS NULL) OR EXISTS(
				--							SELECT 1 FROM
				--							[dbo].[ProductMissingReport] PMR 
				--							INNER JOIN	[dbo].[Product] P ON P.[Id] = PMR.[IdProduct]
				--							WHERE PMR.[IdMissingProductPoi] = PM.[Id] AND  
				--							(dbo.CheckValueInList(P.[Id], @ProductBarCodes) = 1)))
				--AND ((@ProductCategoriesId IS NULL) OR EXISTS(
				--							SELECT 1 FROM
				--							[dbo].[ProductMissingReport] PMR 
				--							INNER JOIN	[dbo].[ProductCategoryList] PCL ON PCL.[IdProduct] = PMR.[IdProduct]
				--							WHERE PMR.[IdMissingProductPoi] = PM.[Id] AND  
				--							(dbo.CheckValueInList(PCL.[IdProductCategory], @ProductCategoriesId) = 1)))

	ORDER BY	PM.[Date] DESC
	DROP TABLE #ProductsFiltered

END
