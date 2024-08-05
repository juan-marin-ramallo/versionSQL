/****** Object:  Procedure [dbo].[GetFormsExcel]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gaston Legnani
-- Create date: 02/06/2015
-- Description:	SP para obtener los formularios a usar en el reporte de excel
-- =============================================
CREATE PROCEDURE [dbo].[GetFormsExcel]

	 @IdUser [sys].[int] = NULL
	,@FormIds [sys].[varchar](max) = NULL
	,@PointOfInterestIds [sys].[varchar](MAX) = NULL
	,@CategoryIds [sys].[varchar](max) = NULL
  ,@TypeIds [sys].[varchar](max) = NULL
	,@OutsidePointOfInterest [sys].[bit] = NULL
	,@FilterOption [sys].[int] = NULL
	,@AllForms [sys].[bit] = NULL
AS
BEGIN
	DECLARE @SystemToday [sys].[datetime]
	SET @SystemToday = DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(GETUTCDATE())), 0)

    ;WITH vForms([Id], [Name], [Date], [Deleted], [StartDate], [StartDateSystemTruncated],
                 [EndDate], [EndDateSystemTruncated], [IdFormCategory], [IdFormType],
                 [AllPointOfInterest], [Description], [OneTimeAnswer], [IdUser], [IdCompany]) AS
    (
        SELECT	F.[Id], F.[Name], F.[Date], F.[Deleted],
                F.[StartDate], DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(F.[StartDate])), 0) AS StartDateSystemTruncated,
                F.[EndDate], DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(F.[EndDate])), 0) AS EndDateSystemTruncated,
                F.[IdFormCategory], F.[IdFormType], F.[AllPointOfInterest], F.[Description], F.[OneTimeAnswer],
                F.[IdUser], F.[IdCompany]
	    FROM	[dbo].[Form] F WITH (NOLOCK)
        WHERE   ((@FormIds IS NULL) OR (dbo.[CheckValueInList](F.[Id], @FormIds) = 1))
                AND	((@CategoryIds IS NULL) OR (dbo.[CheckValueInList](F.[IdFormCategory], @CategoryIds) = 1))
                AND	((@TypeIds IS NULL) OR (dbo.[CheckValueInList](F.[IdFormType], @TypeIds) = 1))
                AND ((@AllForms = 1) OR (F.[IdUser] = @IdUser))
    )

	SELECT		F.[Id], F.[Name],F.[Date], F.[StartDate], F.[EndDate], F.[IdFormCategory], P.[Identifier] AS PointOfInterestIdentifier,
				P.[Name] AS PointOfInterestName, FC.[Name] AS FormCategoryName, F.[IdFormType], PT.[Name] AS FormTypeName,
        F.[AllPointOfInterest], F.[Description], F.[OneTimeAnswer],
				[dbo].[CompletedFormsCountByPointOfInterest](F.[Id], P.[Id], NULL, NULL, NULL, @IdUser) AS CompletedFormsCount,
				C.[Id] as IdCompany, C.[Name] as CompanyName
	
	FROM		vForms F WITH (NOLOCK)
				INNER JOIN [dbo].[User] U WITH (NOLOCK) ON F.[IdUser] = U.[Id]
				LEFT JOIN [dbo].[AssignedForm] AF WITH (NOLOCK) ON F.[Id] = AF.[IdForm] 
				LEFT JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = AF.[IdPointOfInterest]
				LEFT JOIN [dbo].[FormCategory] FC WITH (NOLOCK) ON FC.[Id] = F.[IdFormCategory]
        LEFT JOIN [dbo].[Parameter] PT WITH (NOLOCK) ON PT.[Id] = F.[IdFormType]
				LEFT JOIN [dbo].[Company] C WITH (NOLOCK) ON C.[Id] = F.[IdCompany]

	WHERE		((@PointOfInterestIds IS NULL) OR (F.[AllPointOfInterest] = 1 OR dbo.[CheckValueInList](P.[Id], @PointOfInterestIds) = 1)) AND
				(@OutsidePointOfInterest IS NULL OR (F.[AllPointOfInterest] = 0 AND @OutsidePointOfInterest = 1 AND P.[Id] IS NULL)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) AND
				AF.[Deleted] = 0 AND (P.Id IS NULL OR P.Deleted = 0)
				AND
				((@FilterOption = 1)
					OR (@FilterOption = 2 AND F.[Deleted] = 0 AND F.[StartDateSystemTruncated] <= @SystemToday AND F.[EndDateSystemTruncated] >= @SystemToday) --ACTIVOS
					OR (@FilterOption = 3 AND F.[Deleted] = 0 AND F.[EndDateSystemTruncated] < @SystemToday) -- VENCIDOS
					OR (@FilterOption = 4 AND F.[Deleted] = 1) -- DESACTIVADOS
					OR (@FilterOption = 5 AND F.[Deleted] = 0 AND F.[StartDateSystemTruncated] > @SystemToday) -- PLANIFICADOS
				)

	GROUP BY	F.[Id], F.[Name],F.[Date], F.[StartDate], F.[EndDate], F.[IdFormCategory], P.[Identifier], P.[Name],F.[AllPointOfInterest],
				FC.[Name], F.[IdFormType], PT.[Name], [dbo].[CompletedFormsCountByPointOfInterest](F.[Id], P.[Id], NULL, NULL, NULL, @IdUser),
        F.[Description], F.[OneTimeAnswer], C.[Id], C.[Name]
	
	ORDER BY	F.[Date] desc
END

-- OLD)
-- BEGIN
-- 	DECLARE @Now [sys].[datetime]
-- 	SET @Now = GETUTCDATE()

-- 	SELECT		F.[Id], F.[Name],F.[Date], F.[StartDate], F.[EndDate], F.[IdFormCategory], P.[Identifier] AS PointOfInterestIdentifier,
-- 				P.[Name] AS PointOfInterestName, FC.[Name] AS FormCategoryName, F.[AllPointOfInterest], 	F.[Description], F.[OneTimeAnswer],
-- 				[dbo].[CompletedFormsCountByPointOfInterest](F.[Id], P.[Id], NULL, NULL, NULL, @IdUser) AS CompletedFormsCount,
-- 				C.[Id] as IdCompany, C.[Name] as CompanyName
	
-- 	FROM		[dbo].[Form] F WITH(NOLOCK)
-- 				INNER JOIN [dbo].[User] U WITH(NOLOCK) ON F.[IdUser] = U.[Id]
-- 				LEFT JOIN [dbo].[AssignedForm] AF WITH(NOLOCK) ON F.[Id] = AF.[IdForm] 
-- 				LEFT JOIN [dbo].[PointOfInterest] P WITH(NOLOCK) ON P.[Id] = AF.[IdPointOfInterest]
-- 				LEFT JOIN [dbo].[FormCategory] FC WITH(NOLOCK) ON FC.[Id] = F.[IdFormCategory]
-- 				LEFT JOIN [dbo].[Company] C ON C.[Id] = F.[IdCompany]

-- 	WHERE		((@FormIds IS NULL) OR (dbo.[CheckValueInList](F.[Id], @FormIds) = 1)) AND
-- 				((@CategoryIds IS NULL) OR (dbo.[CheckValueInList](F.[IdFormCategory], @CategoryIds) = 1)) AND
-- 				((@PointOfInterestIds IS NULL) OR (F.[AllPointOfInterest] = 1 OR dbo.[CheckValueInList](P.[Id], @PointOfInterestIds) = 1)) AND
-- 				(@OutsidePointOfInterest IS NULL OR (F.[AllPointOfInterest] = 0 AND @OutsidePointOfInterest = 1 AND P.[Id] IS NULL)) AND
-- 				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
-- 				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) AND
-- 				AF.[Deleted] = 0 AND (P.Id IS NULL OR P.Deleted = 0)
-- 				AND ((@AllForms = 1) OR (F.[IdUser] = @IdUser))
-- 				AND
-- 				((@FilterOption = 1)
-- 					OR (@FilterOption = 2 AND F.[Deleted] = 0 AND Tzdb.IsLowerOrSameSystemDate(F.[StartDate], @Now) = 1 AND Tzdb.IsGreaterOrSameSystemDate(F.[EndDate], @Now) = 1) --ACTIVOS
-- 					OR (@FilterOption = 3 AND F.[Deleted] = 0 AND Tzdb.IsLowerSystemDate(F.[EndDate], @Now) = 1) -- VENCIDOS
-- 					OR (@FilterOption = 4 AND F.[Deleted] = 1) -- DESACTIVADOS
-- 					OR (@FilterOption = 5 AND F.[Deleted] = 0 AND Tzdb.IsGreaterSystemDate(F.[StartDate], @Now) = 1) -- PLANIFICADOS
-- 				)

-- 	GROUP BY	F.[Id], F.[Name],F.[Date], F.[StartDate], F.[EndDate], F.[IdFormCategory], P.[Identifier], P.[Name],F.[AllPointOfInterest],
-- 				FC.[Name], [dbo].[CompletedFormsCountByPointOfInterest](F.[Id], P.[Id], NULL, NULL, NULL, @IdUser), F.[Description], F.[OneTimeAnswer], C.[Id], C.[Name]
	
-- 	ORDER BY	F.[Date] desc
-- END
