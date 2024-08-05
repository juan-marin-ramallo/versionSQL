/****** Object:  Procedure [dbo].[GetProductReportsFilteredGroupedPOI]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetProductReportsFilteredGroupedPOI]
	 @DateFrom datetime
	,@DateTo datetime
    ,@IdProduct varchar(max) = NULL
	,@Providers varchar(max) = NULL
	,@Brands varchar(max) = NULL
	,@Categories varchar(max) = NULL
    ,@IdPersonOfInterest varchar(max) = NULL
    ,@IdPointOfInterest varchar(max) = NULL
	,@ConditionQuery varchar(max) = NULL
	,@IdUser [sys].[int] = NULL
	,@MaxPoiCount [sys].[int] = 999999999
	,@ResultCode [sys].[smallint] OUT
AS 
BEGIN
    SET NOCOUNT ON;
	--SET @DateTo = DATEADD (ms, -1, DATEADD(dd, 1, @DateTo))
	-- Obtengo la cantidad de POIS

	DECLARE @PoiCount [sys].[int]
	SELECT @PoiCount = COUNT (DISTINCT pr.IdPointOfInterest) 
	FROM dbo.ProductReportDynamic PR 
		INNER JOIN dbo.Product P ON pr.IdProduct = P.Id
		INNER JOIN dbo.PointOfInterest poi ON pr.IdPointOfinterest = poi.Id
		INNER JOIN dbo.PersonOfInterest peoi ON peoi.[Id] = pr.[IdPersonOfInterest]
		LEFT JOIN [dbo].[ProductCategoryList] PCL ON PCL.[IdProduct] = P.[Id]
		LEFT JOIN [dbo].[ProductCategory] PC ON PCL.[IdProductCategory] = PC.[Id]

	WHERE	(Tzdb.ToUtc(CAST(Tzdb.FromUtc(pr.[ReportDateTime]) AS [sys].[date])) BETWEEN Tzdb.ToUtc(CAST(Tzdb.FromUtc(@DateFrom) AS [sys].[date])) AND Tzdb.ToUtc(CAST(Tzdb.FromUtc(@DateTo) AS [sys].[date]))) AND	
			((@IdPointOfInterest is null) OR dbo.CheckValueInList (pr.IdPointOfInterest, @IdPointOfInterest)=1) AND
			((@idProduct is null) OR dbo.CheckValueInList (PR.IdProduct, @IdProduct)=1) AND
			((@IdPersonOfInterest is null) OR dbo.CheckValueInList (pr.IdPersonOfinterest, @IdPersonOfInterest)=1) AND
			((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(peoi.[Id], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(pr.IdPointOfInterest, @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(poi.[IdDepartment], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckUserInProductCompanies(P.[IdProductBrand], @IdUser) = 1)) AND
			((@Categories IS NULL) OR (dbo.CheckValueInList(PCL.[IdProductCategory], @Categories) = 1))


	-- Si es mayor al máximo retoron 1
	IF  @PoiCount > @MaxPoiCount
	BEGIN
		SET @ResultCode = 1
	END
	-- Si no, realizo la consulta y retorno 0
	ELSE
	BEGIN
		SET @ResultCode = 0
		IF @ConditionQuery IS NULL
		BEGIN
			
			SELECT A.[IdPointOfInterest], A.[PointOfInterestName], A.[ReportDateTime]
					--,SUM (A.[Stock]) AS [Stock]

			FROM(
			SELECT	pr.[IdPointOfInterest], poi.Name AS [PointOfInterestName], 
					Tzdb.ToUtc(CAST(Tzdb.FromUtc(pr.[ReportDateTime]) AS [sys].[date])) AS [ReportDateTime], PR.Id--, pr.Stock
			
			FROM dbo.ProductReportDynamic pr
				INNER JOIN dbo.Product p ON p.[Id] = pr.[IdProduct] 
				INNER JOIN dbo.PointOfInterest poi ON poi.[Id] = pr.[IdPointOfInterest]
				INNER JOIN dbo.PersonOfInterest peoi ON peoi.[Id] = pr.[IdPersonOfInterest]
				LEFT JOIN [dbo].[ProductCategoryList] PCL ON PCL.[IdProduct] = P.[Id]
				LEFT JOIN [dbo].[ProductCategory] PC ON PCL.[IdProductCategory] = PC.[Id]
			
			WHERE (Tzdb.ToUtc(CAST(Tzdb.FromUtc(pr.[ReportDateTime]) AS [sys].[date])) BETWEEN Tzdb.ToUtc(CAST(Tzdb.FromUtc(@DateFrom) AS [sys].[date])) AND Tzdb.ToUtc(CAST(Tzdb.FromUtc(@DateTo) AS [sys].[date]))) AND	
				((@idProduct is null) OR dbo.CheckValueInList (PR.IdProduct, @IdProduct)=1) AND
				((@IdPersonOfInterest is null) OR dbo.CheckValueInList (pr.IdPersonOfinterest, @IdPersonOfInterest)=1) AND
				((@IdPointOfInterest is null) OR dbo.CheckValueInList (pr.IdPointOfInterest, @IdPointOfInterest)=1) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(peoi.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(poi.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(peoi.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(poi.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInProductCompanies(P.[IdProductBrand], @IdUser) = 1)) AND
				((@Categories IS NULL) OR (dbo.CheckValueInList(PCL.[IdProductCategory], @Categories) = 1))

			GROUP BY PR.Id, pr.IdPointOfInterest, poi.Name, Tzdb.ToUtc(CAST(Tzdb.FromUtc(ReportDateTime) AS [sys].[date]))
				--, pr.Stock
			) AS A
			GROUP BY A.[IdPointOfInterest], A.[PointOfInterestName], A.[ReportDateTime]
			ORDER BY ReportDateTime asc, IdPointOfInterest asc
		END
		ELSE
		BEGIN
		DECLARE @SqlQuery nvarchar(max)
			SET @SqlQuery = 
				N'SELECT A.[IdPointOfInterest], A.[PointOfInterestName], A.[ReportDateTime], 
					SUM (A.[Stock]) AS [Stock]

			FROM(
			SELECT	pr.[IdPointOfInterest], poi.Name AS [PointOfInterestName], 
					Tzdb.ToUtc(CAST(Tzdb.FromUtc(pr.[ReportDateTime]) AS [sys].[date])) AS [ReportDateTime], PR.Id, pr.Stock
				FROM dbo.ProductReportDynamic pr
					 INNER JOIN dbo.Product p ON p.[Id] = pr.[IdProduct] 
					 INNER JOIN dbo.PointOfInterest poi ON poi.[Id] = pr.[IdPointOfInterest]
					 INNER JOIN dbo.PersonOfInterest peoi ON peoi.[Id] = pr.[IdPersonOfInterest]
					 LEFT JOIN [dbo].[ProductCategoryList] PCL ON PCL.[IdProduct] = P.[Id]
					LEFT JOIN [dbo].[ProductCategory] PC ON PCL.[IdProductCategory] = PC.[Id]
				
				WHERE (Tzdb.ToUtc(CAST(Tzdb.FromUtc(pr.[ReportDateTime]) AS [sys].[date])) BETWEEN Tzdb.ToUtc(CAST(Tzdb.FromUtc(@DateFrom) AS [sys].[date])) AND Tzdb.ToUtc(CAST(Tzdb.FromUtc(@DateTo) AS [sys].[date]))) AND	
					((@idProduct is null) OR dbo.CheckValueInList (PR.IdProduct, @IdProduct)=1) AND
					((@IdPersonOfInterest is null) OR dbo.CheckValueInList (pr.IdPersonOfinterest, @IdPersonOfInterest)=1) AND
					((@IdPointOfInterest is null) OR dbo.CheckValueInList (pr.IdPointOfInterest, @IdPointOfInterest)=1) AND
					((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(peoi.[Id], @IdUser) = 1)) AND
					((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(poi.[Id], @IdUser) = 1)) AND
					((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(peoi.[IdDepartment], @IdUser) = 1)) AND
					((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(poi.[IdDepartment], @IdUser) = 1)) AND
					((@IdUser IS NULL) OR (dbo.CheckUserInProductCompanies(P.[IdProductBrand], @IdUser) = 1)) AND
					((@Categories IS NULL) OR (dbo.CheckValueInList(PCL.[IdProductCategory], @Categories) = 1))
					AND ' + @ConditionQuery +
				' GROUP BY PR.Id, pr.IdPointOfInterest, poi.Name, Tzdb.ToUtc(CAST(Tzdb.FromUtc(ReportDateTime) AS [sys].[date])), pr.Stock) A
					GROUP BY	A.[IdPointOfInterest], A.[PointOfInterestName], A.[ReportDateTime]
					ORDER BY ReportDateTime asc, IdPointOfInterest asc'

			EXECUTE sp_executesql @SqlQuery, N'@DateFrom datetime,
								@DateTo datetime,
								@IdProduct varchar(max),
								@IdPersonOfInterest varchar(max),
								@IdPointOfInterest varchar(max),
								@IdUser [sys].INT = NULL,
								@Providers varchar(max) = NULL,
								@Brands varchar(max) = NULL,
								@Categories varchar(max) = NULL',
								@DateFrom = @DateFrom,
								@DateTo = @DateTo,
								@IdProduct = @IdProduct,
								@IdPersonOfInterest = @IdPersonOfInterest,
								@IdPointOfInterest = @IdPointOfInterest,
								@IdUser = @IdUser, 
								@Providers = @Providers,
								@Brands = @Brands,
								@Categories = @Categories
		END
	END
END
