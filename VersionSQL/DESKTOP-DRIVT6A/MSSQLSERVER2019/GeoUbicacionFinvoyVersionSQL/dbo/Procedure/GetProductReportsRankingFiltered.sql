/****** Object:  Procedure [dbo].[GetProductReportsRankingFiltered]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetProductReportsRankingFiltered]
	@DateFrom [sys].DATETIME,
	@DateTo [sys].datetime,
    @IdProduct [sys].[VARCHAR](max) = NULL,
    @IdPersonOfInterest [sys].[VARCHAR](max) = NULL,
    @IdPointOfInterest [sys].[VARCHAR](max) = NULL ,
	@ProductBarCodes [sys].[varchar](max) = NULL,
    @ProductCategoriesId [sys].[varchar](max) = NULL
	,@IdCompany [sys].[varchar](max) = NULL
	,@IdProductBrand [sys].[varchar](max) = NULL,
	@ConditionQuery [sys].[VARCHAR](max) = NULL,
	@IdUser [sys].[INT] = NULL
AS 
BEGIN

	IF @ConditionQuery IS NULL
	BEGIN
    
		SELECT		A.PersonOfInterestId, A.PersonOfInterestName, A.PersonOfInterestLastName, COUNT(1) AS ControlStockQuantity
		FROM(
		SELECT		S.[Id] AS PersonOfInterestId, S.[Name] AS PersonOfInterestName, S.[LastName] AS PersonOfInterestLastName, 
					PR.Id
		
		FROM		[dbo].[ProductReportDynamic] PR WITH (NOLOCK)
					INNER JOIN dbo.Product Prod WITH (NOLOCK) ON pr.IdProduct = Prod.Id
					INNER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON S.[Id] = PR.[IdPersonOfInterest]
					INNER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = PR.[IdPointOfInterest]
					LEFT JOIN [dbo].[ProductCategoryList] PCL WITH (NOLOCK) ON PCL.[IdProduct] = Prod.[Id]
					LEFT JOIN [dbo].[ProductCategory] PC WITH (NOLOCK) ON PCL.[IdProductCategory] = PC.[Id]
					LEFT JOIN   [dbo].[ProductReportAttributeValue] PRAV WITH (NOLOCK) ON PRAV.[IdProductReport] = PR.[Id]
					LEFT JOIN   [dbo].[ProductReportAttribute] PRAT WITH (NOLOCK) ON PRAT.[Id] = PRAV.[IdProductReportAttribute]
					LEFT OUTER JOIN	[dbo].[ProductBrand] PB WITH (NOLOCK) ON PB.[Id] = PROD.IdProductBrand
					LEFT OUTER JOIN	[dbo].[Company] CM WITH (NOLOCK) ON CM.[Id] = PB.IdCompany
		
		WHERE		PR.[ReportDateTime] BETWEEN @DateFrom AND @DateTo AND
					((@IdProduct IS NULL) OR dbo.CheckValueInList (PR.IdProduct, @IdProduct) = 1) AND
					((@IdPersonOfInterest IS NULL) OR dbo.CheckValueInList (pr.IdPersonOfinterest, @IdPersonOfInterest) = 1) AND
					((@IdPointOfInterest IS NULL) OR dbo.CheckValueInList (IdPointOfInterest, @IdPointOfInterest) = 1) AND
					((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
					((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
					((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
					((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) AND
					((@ProductBarCodes IS NULL) OR (dbo.CheckVarcharInList(Prod.[BarCode], @ProductBarCodes) = 1)) AND
					((@ProductCategoriesId IS NULL) OR (dbo.CheckValueInList(PCL.[IdProductCategory], @ProductCategoriesId) = 1)) 
					AND (@IdProductBrand IS NULL OR dbo.CheckValueInList(IIF(PB.[Id] IS NULL, 0, PB.[Id]), @IdProductBrand) = 1)
					AND (@IdCompany IS NULL OR dbo.CheckValueInList(IIF(CM.[Id] IS NULL, 0, CM.[Id]), @IdCompany) = 1)
					AND ((@IdUser IS NULL) OR (dbo.CheckUserInProductCompanies(Prod.[IdProductBrand], @IdUser) = 1)) AND
					(PRAV.[Id] IS NULL OR PRAT.[FullDeleted] = 0)
		
		GROUP BY	PR.Id, S.[Id], S.[Name], S.[LastName]) A

		GROUP BY	A.PersonOfInterestId, A.PersonOfInterestName, A.PersonOfInterestLastName
		ORDER BY	ControlStockQuantity DESC

    END
    ELSE
	BEGIN
	DECLARE @SqlQuery nvarchar(max)
		SET @SqlQuery = 
			N'	SELECT		A.PersonOfInterestId, A.PersonOfInterestName, A.PersonOfInterestLastName, COUNT(1) AS ControlStockQuantity
				FROM(
				SELECT		S.[Id] AS PersonOfInterestId, S.[Name] AS PersonOfInterestName, S.[LastName] AS PersonOfInterestLastName, 
							PR.Id
		
				FROM		[dbo].[ProductReportDynamic] PR WITH (NOLOCK)
							INNER JOIN dbo.Product Prod WITH (NOLOCK) ON pr.IdProduct = Prod.Id
							INNER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON S.[Id] = PR.[IdPersonOfInterest]
							INNER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = PR.[IdPointOfInterest]
							LEFT JOIN [dbo].[ProductCategoryList] PCL WITH (NOLOCK) ON PCL.[IdProduct] = Prod.[Id]
							LEFT JOIN [dbo].[ProductCategory] PC WITH (NOLOCK) ON PCL.[IdProductCategory] = PC.[Id]
				
				WHERE		PR.[ReportDateTime] BETWEEN @DateFrom AND @DateTo AND
							((@IdProduct IS NULL) OR dbo.CheckValueInList (PR.IdProduct, @IdProduct) = 1) AND
							((@IdPersonOfInterest IS NULL) OR dbo.CheckValueInList (pr.IdPersonOfinterest, @IdPersonOfInterest) = 1) AND
							((@IdPointOfInterest IS NULL) OR dbo.CheckValueInList (IdPointOfInterest, @IdPointOfInterest) = 1) AND
							((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
							((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
							((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
							((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) AND
							((@ProductBarCodes IS NULL) OR (dbo.CheckVarcharInList(Prod.[BarCode], @ProductBarCodes) = 1)) AND
							((@ProductCategoriesId IS NULL) OR (dbo.CheckValueInList(PCL.[IdProductCategory], @ProductCategoriesId) = 1))
							((@IdUser IS NULL) OR (dbo.CheckUserInProductCompanies(Prod.[IdProductBrand], @IdUser) = 1)) AND
							AND ' + @ConditionQuery + 'GROUP BY	PR.Id, S.[Id], S.[Name], S.[LastName]) A GROUP BY A.PersonOfInterestId, A.PersonOfInterestName, A.PersonOfInterestLastName  ORDER BY ControlStockQuantity DESC'

		EXECUTE sp_executesql @SqlQuery, N'@DateFrom datetime,
							@DateTo datetime,
							@IdProduct varchar(max),
							@IdPersonOfInterest varchar(max),
							@IdPointOfInterest varchar(max),
							@IdUser [sys].INT = NULL,
							@ProductBarCodes [sys].[varchar](max) = NULL,
							@ProductCategoriesId [sys].[varchar](max) = NULL',
							@DateFrom = @DateFrom,
							@DateTo = @DateTo,
							@IdProduct = @IdProduct,
							@IdPersonOfInterest = @IdPersonOfInterest,
							@IdPointOfInterest = @IdPointOfInterest,
							@IdUser = @IdUser,
							@ProductBarCodes = @ProductBarCodes,
							@ProductCategoriesId = @ProductCategoriesId
	END
END
