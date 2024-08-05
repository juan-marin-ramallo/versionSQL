/****** Object:  Procedure [dbo].[GetForms]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gaston Legnani
-- Create date: 02/06/2015
-- Description:	SP para obtener los formularios
-- =============================================
CREATE PROCEDURE [dbo].[GetForms]

	 @IdUser [sys].[int] = NULL
	,@FormIds [sys].[varchar](max) = NULL
	,@PointOfInterestIds [sys].[varchar](MAX) = NULL
	,@CategoryIds [sys].[varchar](max) = NULL
	,@TypeIds [sys].[varchar](max) = NULL
	,@OutsidePointOfInterest [sys].[bit] = NULL
	,@FilterOption [sys].[int] = 2
	,@AllForms [sys].[bit] = 1
	,@IsFormPlus [sys].[bit] = 0
	,@ProductIds [sys].[varchar](max) = NULL
	,@ProductCategoryIds [sys].[varchar](max) = NULL
AS
BEGIN
	DECLARE @SystemToday [sys].[datetime]
	SET @SystemToday = DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(GETUTCDATE())), 0)

	DECLARE @IdUserLocal [sys].[int]
	DECLARE @FormIdsLocal [sys].[varchar](max)
	DECLARE @PointOfInterestIdsLocal [sys].[varchar](MAX)
	DECLARE @CategoryIdsLocal [sys].[varchar](max)
	DECLARE @TypeIdsLocal [sys].[varchar](max)
	DECLARE @FilterOptionLocal [sys].[int]
	DECLARE @AllFormsLocal [sys].[bit]
	DECLARE @OutsidePointOfInterestLocal [sys].[bit]
	
	DECLARE @HasProductFilters BIT = 0 

	SET @IdUserLocal = @IdUser
	SET @FormIdsLocal = @FormIds
	SET @PointOfInterestIdsLocal = @PointOfInterestIds
	SET @CategoryIdsLocal = @CategoryIds
	SET @TypeIdsLocal = @TypeIds
	SET @FilterOptionLocal = @FilterOption
	SET @AllFormsLocal = @AllForms
	SET @OutsidePointOfInterestLocal = @OutsidePointOfInterest

	SELECT	P.[Id]
	INTO	#PointOfInterestOfUser
	FROM	[dbo].[PointOfInterest] P WITH (NOLOCK)
	WHERE	((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUserLocal) = 1))
			AND ((@IdUserLocal IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUserLocal) = 1))

	CREATE TABLE #IdFormsWithProduct (
		IdForm INT
		)


	IF (@ProductIds IS NOT NULL 
		OR @ProductCategoryIds  IS NOT NULL)
	BEGIN	

		SET @HasProductFilters = 1

		INSERT INTO 
			#IdFormsWithProduct
		SELECT 
			IdForm = FormPlus.IdForm
		FROM
			[dbo].[FormPlus] FormPlus
			inner join dbo.Form F
				on FormPlus.Idform = f.id
			INNER JOIN [dbo].[FormPlusProduct] FPProduct 
				ON FormPlus.Id = FPProduct.IdFormPlus
			INNER JOIN [dbo].[Product] Product 
				ON FPProduct.IdProduct = Product.Id
			LEFT JOIN [dbo].[ProductCategoryList] ProductCategory
				ON Product.Id = ProductCategory.IdProduct
		WHERE
			((@ProductIds IS NULL) OR (CHARINDEX(',' + CAST(Product.[Id] AS [sys].[varchar](10)) + ',', @ProductIds) > 0))
		    AND ((@ProductCategoryIds IS NULL) OR (CHARINDEX(',' + CAST(ProductCategory.[Id] AS [sys].[varchar](10)) + ',', @ProductCategoryIds) > 0))
		
		UNION 
		
		SELECT
			IdForm = FormPlus.IdForm
		FROM
			--INNER JOIN dbo.CatalogProduct as CP on CP.IdProduct = P.Id
		
		[dbo].[FormPlus] FormPlus
			inner join dbo.Form F
				on FormPlus.Idform = f.id
			INNER JOIN [dbo].[FormPlusCatalog] FPCatalog
				ON FormPlus.Id = FPCatalog.IdFormPlus
			INNER JOIN dbo.CatalogProduct CP 
				on FPCatalog.IdCatalog = CP.IdCatalog
			INNER JOIN [dbo].[Product] Product 
				ON CP.IdProduct = Product.Id
			LEFT JOIN [dbo].[ProductCategoryList] ProductCategory
				ON Product.Id = ProductCategory.IdProduct
		WHERE
			((@ProductIds IS NULL) OR (CHARINDEX(',' + CAST(Product.[Id] AS [sys].[varchar](10)) + ',', @ProductIds) > 0))
		    AND ((@ProductCategoryIds IS NULL) OR (CHARINDEX(',' + CAST(ProductCategory.[IdProductCategory] AS [sys].[varchar](10)) + ',', @ProductCategoryIds) > 0))
		    
		
	END


	;WITH vAssignedForm(IdPointOfInterest, IdForm) AS
	(
		SELECT	AF.[IdPointOfInterest], AF.[IdForm]
		FROM	[dbo].[AssignedForm] AF WITH (NOLOCK)
		WHERE	AF.[Deleted] = 0
		GROUP BY AF.[IdPointOfInterest], AF.[IdForm]
				--AND ((@FormIds IS NULL) OR (dbo.[CheckValueInList](AF.[IdForm], @FormIds) = 1))
	),
    vForms([Id], [Name], [Date], [Deleted], [DeletedDate], [StartDate],
           [EndDate], [IdFormCategory], [IdFormType], [AllPointOfInterest],
           [AllPersonOfInterest], [NonPointOfInterest], [Description], [OneTimeAnswer],
           [IsWeighted], [AllowWebComplete], [CompleteMultipleTimes], [IdUser], [IdCompany]) AS
    (
        SELECT	F.[Id], F.[Name], F.[Date], F.[Deleted], F.[DeletedDate],
                F.[StartDate],
                F.[EndDate],
                F.[IdFormCategory], F.[IdFormType],  F.[AllPointOfInterest], F.[AllPersonOfInterest],
                F.[NonPointOfInterest], F.[Description], F.[OneTimeAnswer], F.[IsWeighted],
                F.[AllowWebComplete], F.[CompleteMultipleTimes], F.[IdUser], F.[IdCompany]
	    FROM	[dbo].[Form] F WITH (NOLOCK)
        WHERE   ((@CategoryIdsLocal IS NULL) OR (CHARINDEX(',' + CAST(F.[IdFormCategory] AS [sys].[varchar](10)) + ',', @CategoryIdsLocal) > 0))
        AND ((@TypeIdsLocal IS NULL) OR (CHARINDEX(',' + CAST(F.[IdFormType] AS [sys].[varchar](10)) + ',', @TypeIdsLocal) > 0))
				AND ((@FormIdsLocal IS NULL) OR (CHARINDEX(',' + CAST(F.[Id] AS [sys].[varchar](10)) + ',', @FormIdsLocal) > 0))
				AND ((@AllFormsLocal = 1) OR (F.[IdUser] = @IdUserLocal)) AND
				((@FilterOptionLocal = 1)
					OR (@FilterOptionLocal = 2 AND F.[Deleted] = 0 AND DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(F.[StartDate])), 0) <= @SystemToday AND DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(F.[EndDate])), 0)  >= @SystemToday) --ACTIVOS
					OR (@FilterOptionLocal = 3 AND F.[Deleted] = 0 AND DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(F.[EndDate])), 0)  < @SystemToday) -- VENCIDOS
					OR (@FilterOptionLocal = 4 AND F.[Deleted] = 1) -- DESACTIVADOS
					OR (@FilterOptionLocal = 5 AND F.[Deleted] = 0 AND DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(F.[StartDate])), 0) > @SystemToday) -- PLANIFICADOS
				)
				AND (F.IsFormPlus = @IsFormPlus)
    )
	
		SELECT		F.[Id], F.[Name], U.[Id] AS IdUser, U.[Name] AS UserName, U.[LastName] AS UserLastName, 
					F.[Date], F.[Deleted], F.[DeletedDate], F.[StartDate], F.[EndDate], F.[IdFormCategory],
					FC.[Name] AS FormCategoryName, F.[IdFormType], PT.[Name] AS FormTypeName, F.[AllPointOfInterest],
			F.[AllPersonOfInterest], F.[NonPointOfInterest], F.[Description], F.[OneTimeAnswer],
			F.[IsWeighted], F.[AllowWebComplete], F.[CompleteMultipleTimes], F.[IdCompany]
	
		FROM		[dbo].[User] U WITH (NOLOCK)
					INNER JOIN vForms F WITH (NOLOCK) ON F.[IdUser] = U.[Id]
					LEFT JOIN [dbo].[FormCategory] FC WITH (NOLOCK) ON FC.[Id] = F.[IdFormCategory]
					LEFT JOIN [dbo].[Parameter] PT WITH (NOLOCK) ON PT.[Id] = F.[IdFormType]
					INNER JOIN vAssignedForm AF WITH (NOLOCK) ON F.[Id] = AF.[IdForm]
					LEFT OUTER JOIN #PointOfInterestOfUser P ON P.[Id] = AF.[IdPointOfInterest]
					--INNER JOIN #IdFormsWithProduct IDFP WITH (NOLOCK) ON @HasProductFilters = 0 OR( F.[Id] = IDFP.[IdForm]
					--												AND (@HasProductFilters = 1))
					

		WHERE		(@PointOfInterestIdsLocal IS NULL OR (F.[AllPointOfInterest] = 1 OR CHARINDEX(',' + CAST(P.[Id] AS [sys].[varchar](10)) + ',', @PointOfInterestIdsLocal) > 0)) AND
					(@OutsidePointOfInterestLocal IS NULL OR (F.[AllPointOfInterest] = 0 AND (@OutsidePointOfInterestLocal = 1 AND P.[Id] IS NULL)))
					AND (@HasProductFilters = 0 
						OR (F.Id IN (SELECT IdForm FROM #IdFormsWithProduct))
					)
					
		GROUP BY	F.[Id], F.[Name], U.[Id], U.[Name], U.[LastName], F.[Date], F.[Deleted], F.[Description], F.[OneTimeAnswer],
					F.[DeletedDate], F.[StartDate], F.[EndDate], F.[IdFormCategory], FC.[Name], F.[IdFormType], PT.[Name],
			F.[AllPointOfInterest], F.[AllPersonOfInterest], F.[NonPointOfInterest], F.[IsWeighted], F.[AllowWebComplete],
			F.[CompleteMultipleTimes], F.[IdCompany]
	
		ORDER BY	F.[Date] desc
	DROP TABLE #PointOfInterestOfUser
	DROP TABLE #IdFormsWithProduct
END

-- OLD)
-- BEGIN
-- 	DECLARE @Now [sys].[datetime]
-- 	SET @Now = GETUTCDATE()
	
-- 	DECLARE @IdUserLocal [sys].[int]
-- 	DECLARE @FormIdsLocal [sys].[varchar](max)
-- 	DECLARE @PointOfInterestIdsLocal [sys].[varchar](MAX)
-- 	DECLARE @CategoryIdsLocal [sys].[varchar](max)
-- 	DECLARE @FilterOptionLocal [sys].[int]
-- 	DECLARE @AllFormsLocal [sys].[bit]
-- 	DECLARE @OutsidePointOfInterestLocal [sys].[bit]

-- 	SET @IdUserLocal = @IdUser
-- 	SET @FormIdsLocal = @FormIds
-- 	SET @PointOfInterestIdsLocal = @PointOfInterestIds
-- 	SET @CategoryIdsLocal = @CategoryIds
-- 	SET @FilterOptionLocal = @FilterOption
-- 	SET @AllFormsLocal = @AllForms
-- 	SET @OutsidePointOfInterestLocal = @OutsidePointOfInterest

-- 	SELECT	P.[Id]
-- 	INTO	#PointOfInterestOfUser
-- 	FROM	[dbo].[PointOfInterest] P WITH (NOLOCK)
-- 	WHERE	((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUserLocal) = 1))
-- 			AND ((@IdUserLocal IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUserLocal) = 1))

-- 	;WITH vAssignedForm(IdPointOfInterest, IdForm) AS
-- 	(
-- 		SELECT	AF.[IdPointOfInterest], AF.[IdForm]
-- 		FROM	[dbo].[AssignedForm] AF  with (nolock)
-- 		WHERE	AF.[Deleted] = 0
-- 				--AND ((@FormIds IS NULL) OR (dbo.[CheckValueInList](AF.[IdForm], @FormIds) = 1))
-- 	)

-- 	SELECT		F.[Id], F.[Name], U.[Id] AS IdUser, U.[Name] AS UserName, U.[LastName] AS UserLastName, 
-- 				F.[Date], F.[Deleted], F.[DeletedDate], F.[StartDate], F.[EndDate], F.[IdFormCategory], 
-- 				FC.[Name] AS FormCategoryName, F.[AllPointOfInterest], F.[AllPersonOfInterest], F.[NonPointOfInterest],
-- 				F.[Description], F.[OneTimeAnswer], F.[IsWeighted], F.[AllowWebComplete], F.[IdCompany]
	
-- 	FROM		[dbo].[User] U WITH (NOLOCK)
-- 				INNER JOIN [dbo].[Form] F ON F.[IdUser] = U.[Id]
-- 				LEFT JOIN [dbo].[FormCategory] FC ON FC.[Id] = F.[IdFormCategory]
-- 				INNER JOIN vAssignedForm AF ON F.[Id] = AF.[IdForm]
-- 				LEFT OUTER JOIN #PointOfInterestOfUser P ON P.[Id] = AF.[IdPointOfInterest]

-- 	WHERE		((@CategoryIdsLocal IS NULL) OR (CHARINDEX(',' + CAST(F.[IdFormCategory] AS [sys].[varchar](10)) + ',', @CategoryIdsLocal) > 0)) AND
-- 				(@PointOfInterestIdsLocal IS NULL OR (F.[AllPointOfInterest] = 1 OR CHARINDEX(',' + CAST(P.[Id] AS [sys].[varchar](10)) + ',', @PointOfInterestIdsLocal) > 0)) AND
-- 				((@FormIdsLocal IS NULL) OR (CHARINDEX(',' + CAST(F.[Id] AS [sys].[varchar](10)) + ',', @FormIdsLocal) > 0)) AND
-- 				(@OutsidePointOfInterestLocal IS NULL OR (F.[AllPointOfInterest] = 0 AND (@OutsidePointOfInterestLocal = 1 AND P.[Id] IS NULL))) AND
-- 				((@AllFormsLocal = 1) OR (F.[IdUser] = @IdUserLocal))
-- 				AND
-- 				((@FilterOptionLocal = 1)
-- 					OR (@FilterOptionLocal = 2 AND F.[Deleted] = 0 AND Tzdb.IsLowerOrSameSystemDate(F.[StartDate], @Now) = 1 AND Tzdb.IsGreaterOrSameSystemDate(F.[EndDate], @Now) = 1) --ACTIVOS
-- 					OR (@FilterOptionLocal = 3 AND F.[Deleted] = 0 AND Tzdb.IsLowerSystemDate(F.[EndDate], @Now) = 1) -- VENCIDOS
-- 					OR (@FilterOptionLocal = 4 AND F.[Deleted] = 1) -- DESACTIVADOS
-- 					OR (@FilterOptionLocal = 5 AND F.[Deleted] = 0 AND Tzdb.IsGreaterSystemDate(F.[StartDate], @Now) = 1) -- PLANIFICADOS
-- 				)
	
-- 	GROUP BY	F.[Id], F.[Name], U.[Id], U.[Name], U.[LastName], F.[Date], F.[Deleted], F.[Description], F.[OneTimeAnswer],
-- 				F.[DeletedDate], F.[StartDate], F.[EndDate], F.[IdFormCategory], FC.[Name], F.[AllPointOfInterest], 
-- 				F.[AllPersonOfInterest], F.[NonPointOfInterest], F.[IsWeighted], F.[AllowWebComplete], F.[IdCompany]
	
-- 	ORDER BY	F.[Date] desc

-- 	DROP TABLE #PointOfInterestOfUser
-- END
