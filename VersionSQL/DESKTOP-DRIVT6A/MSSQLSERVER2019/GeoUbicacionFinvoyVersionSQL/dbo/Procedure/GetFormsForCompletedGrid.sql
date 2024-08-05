/****** Object:  Procedure [dbo].[GetFormsForCompletedGrid]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gaston Legnani
-- Create date: 02/06/2015
-- Description:	SP para obtener los formularios
-- =============================================
CREATE PROCEDURE [dbo].[GetFormsForCompletedGrid]

	 @IdUser [sys].[int] = NULL
	,@IdPersonOfInterest [sys].[int] = NULL
	,@FormIds [sys].[varchar](max) = NULL
	,@PointOfInterestIds [sys].[varchar](MAX) = NULL
	,@CategoryIds [sys].[varchar](max) = NULL
	,@OutsidePointOfInterest [sys].[bit] = NULL
	,@FilterOption [sys].[int] = 2
	,@AllForms [sys].[bit] = 1
AS
BEGIN
	DECLARE @IdUserLocal [sys].[int]
	DECLARE @FormIdsLocal [sys].[varchar](max)
	DECLARE @PointOfInterestIdsLocal [sys].[varchar](MAX)
	DECLARE @CategoryIdsLocal [sys].[varchar](max)
	DECLARE @FilterOptionLocal [sys].[int]
	DECLARE @AllFormsLocal [sys].[bit]
	DECLARE @OutsidePointOfInterestLocal [sys].[bit]

	SET @IdUserLocal = @IdUser
	SET @FormIdsLocal = @FormIds
	SET @PointOfInterestIdsLocal = @PointOfInterestIds
	SET @CategoryIdsLocal = @CategoryIds
	SET @FilterOptionLocal = @FilterOption
	SET @AllFormsLocal = @AllForms
	SET @OutsidePointOfInterestLocal = @OutsidePointOfInterest

	DECLARE @SystemToday [sys].[datetime]
	SET @SystemToday = DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(GETUTCDATE())), 0)

	;WITH vPointOfInterest(Id, IdDepartment) AS
	(
		SELECT	P.[Id], P.[IdDepartment]
		FROM	[dbo].[PointOfInterest] P  with (nolock)
		WHERE	((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUserLocal) = 1))
				AND ((@IdUserLocal IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUserLocal) = 1))
	),
	vAssignedForm(IdPointOfInterest, IdForm, IdPersonOfInterest, Deleted) AS
	(
		SELECT	AF.[IdPointOfInterest], AF.[IdForm], AF.[IdPersonOfInterest], AF.[Deleted]
		FROM	[dbo].[AssignedForm] AF  with (nolock)
		WHERE	AF.[Deleted] = 0
				--AND ((@FormIds IS NULL) OR (dbo.[CheckValueInList](AF.[IdForm], @FormIds) = 1))
	),
    vForms([Id], [Name], [Date], [Deleted], [DeletedDate], [StartDate], [StartDateSystemTruncated],
           [EndDate], [EndDateSystemTruncated], [IdFormCategory], [AllPointOfInterest],
           [AllPersonOfInterest], [NonPointOfInterest], [Description], [OneTimeAnswer],
           [IsWeighted], [IdUser]) AS
    (
        SELECT	F.[Id], F.[Name], F.[Date], F.[Deleted], F.[DeletedDate],
                F.[StartDate], DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(F.[StartDate])), 0) AS StartDateSystemTruncated,
                F.[EndDate], DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(F.[EndDate])), 0) AS EndDateSystemTruncated,
                F.[IdFormCategory], F.[AllPointOfInterest], F.[AllPersonOfInterest],
                F.[NonPointOfInterest], F.[Description], F.[OneTimeAnswer], F.[IsWeighted],
                F.[IdUser]
	    FROM	[dbo].[Form] F WITH (NOLOCK)
        WHERE   F.[Deleted] = 0
                AND F.[AllowWebComplete] = 1 --Solo tareas que puedan ser completadas desde la web
                AND ((@CategoryIdsLocal IS NULL) OR (dbo.[CheckValueInList](F.[IdFormCategory], @CategoryIdsLocal) = 1))
				AND ((@FormIdsLocal IS NULL) OR (dbo.[CheckValueInList](F.[Id], @FormIdsLocal) = 1))
				AND ((@AllFormsLocal = 1) OR (F.[IdUser] = @IdUserLocal))
    )

	SELECT		F.[Id], F.[Name], U.[Id] AS IdUser, U.[Name] AS UserName, U.[LastName] AS UserLastName, 
				F.[Date], F.[Deleted], F.[DeletedDate], F.[StartDate], F.[EndDate], F.[IdFormCategory], 
				FC.[Name] AS FormCategoryName, F.[AllPointOfInterest], F.[AllPersonOfInterest], F.[NonPointOfInterest],
				F.[Description], F.[OneTimeAnswer], F.[IsWeighted]
	
	FROM		vForms F WITH(NOLOCK)
				INNER JOIN [dbo].[User] U WITH (NOLOCK) ON F.[IdUser] = U.[Id]
				INNER JOIN vAssignedForm AF WITH (NOLOCK) ON F.[Id] = AF.[IdForm] 
				LEFT JOIN vPointOfInterest P WITH (NOLOCK) ON P.[Id] = AF.[IdPointOfInterest]
				LEFT JOIN [dbo].[FormCategory] FC WITH (NOLOCK) ON FC.[Id] = F.[IdFormCategory]
	
	WHERE		(@PointOfInterestIdsLocal IS NULL OR (F.[AllPointOfInterest] = 1 OR dbo.[CheckValueInList](P.[Id], @PointOfInterestIdsLocal) = 1)) AND
				(@OutsidePointOfInterestLocal IS NULL OR (F.[AllPointOfInterest] = 0 AND (@OutsidePointOfInterestLocal = 1 AND P.[Id] IS NULL)))
				AND
				((@FilterOptionLocal = 1) 
					OR (@FilterOptionLocal = 2 AND F.[Deleted] = 0 AND (F.[StartDateSystemTruncated] <= @SystemToday AND F.[EndDateSystemTruncated] >= @SystemToday)) --ACTIVOS
					OR (@FilterOptionLocal = 3 AND F.[Deleted] = 0 AND (F.[EndDateSystemTruncated] < @SystemToday)) -- VENCIDOS
					OR (@FilterOptionLocal = 4 AND F.[Deleted] = 1) -- DESACTIVADOS
					OR (@FilterOptionLocal = 5 AND F.[Deleted] = 0 AND (F.[StartDateSystemTruncated] > @SystemToday)) -- PLANIFICADOS
				)
				AND AF.[IdPersonOfInterest] = @IdPersonOfInterest 
				AND AF.[Deleted] = 0

	GROUP BY	F.[Id], F.[Name], U.[Id], U.[Name], U.[LastName], F.[Date], F.[Deleted], F.[Description], F.[OneTimeAnswer],
				F.[DeletedDate], F.[StartDate], F.[EndDate], F.[IdFormCategory], FC.[Name], F.[AllPointOfInterest], 
				F.[AllPersonOfInterest], F.[NonPointOfInterest], F.[IsWeighted]
	
	ORDER BY	F.[Date] desc
END

-- OLD)
-- BEGIN

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

-- 	DECLARE @Now [sys].[datetime]
--     SET @Now = GETUTCDATE()

-- 	;WITH vPointOfInterest(Id, IdDepartment) AS
-- 	(
-- 		SELECT	P.[Id], P.[IdDepartment]
-- 		FROM	[dbo].[PointOfInterest] P  with (nolock)
-- 		WHERE	((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUserLocal) = 1))
-- 				AND ((@IdUserLocal IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUserLocal) = 1))
-- 	),
-- 	vAssignedForm(IdPointOfInterest, IdForm, IdPersonOfInterest, Deleted) AS
-- 	(
-- 		SELECT	AF.[IdPointOfInterest], AF.[IdForm], AF.[IdPersonOfInterest], AF.[Deleted]
-- 		FROM	[dbo].[AssignedForm] AF  with (nolock)
-- 		WHERE	AF.[Deleted] = 0
-- 				--AND ((@FormIds IS NULL) OR (dbo.[CheckValueInList](AF.[IdForm], @FormIds) = 1))
-- 	)

-- 	SELECT		F.[Id], F.[Name], U.[Id] AS IdUser, U.[Name] AS UserName, U.[LastName] AS UserLastName, 
-- 				F.[Date], F.[Deleted], F.[DeletedDate], F.[StartDate], F.[EndDate], F.[IdFormCategory], 
-- 				FC.[Name] AS FormCategoryName, F.[AllPointOfInterest], F.[AllPersonOfInterest], F.[NonPointOfInterest],
-- 				F.[Description], F.[OneTimeAnswer], F.[IsWeighted]
	
-- 	FROM		[dbo].[Form] F WITH(NOLOCK)
-- 				INNER JOIN [dbo].[User] U WITH(NOLOCK) ON F.[IdUser] = U.[Id]
-- 				INNER JOIN vAssignedForm AF WITH(NOLOCK) ON F.[Id] = AF.[IdForm] 
-- 				LEFT JOIN vPointOfInterest P WITH(NOLOCK) ON P.[Id] = AF.[IdPointOfInterest]
-- 				LEFT JOIN [dbo].[FormCategory] FC WITH(NOLOCK) ON FC.[Id] = F.[IdFormCategory]
	
-- 	WHERE		((@CategoryIdsLocal IS NULL) OR (dbo.[CheckValueInList](F.[IdFormCategory], @CategoryIdsLocal) = 1)) AND
-- 				(@PointOfInterestIdsLocal IS NULL OR (F.[AllPointOfInterest] = 1 OR dbo.[CheckValueInList](P.[Id], @PointOfInterestIdsLocal) = 1)) AND
-- 				((@FormIdsLocal IS NULL) OR (dbo.[CheckValueInList](F.[Id], @FormIdsLocal) = 1)) AND
-- 				(@OutsidePointOfInterestLocal IS NULL OR (F.[AllPointOfInterest] = 0 AND (@OutsidePointOfInterestLocal = 1 AND P.[Id] IS NULL))) AND
-- 				((@AllFormsLocal = 1) OR (F.[IdUser] = @IdUserLocal))
-- 				AND
-- 				((@FilterOptionLocal = 1) 
-- 					OR (@FilterOptionLocal = 2 AND F.[Deleted] = 0 AND (Tzdb.IsLowerOrSameSystemDate(F.[StartDate], @Now) = 1 AND Tzdb.IsGreaterOrSameSystemDate(F.[EndDate], @Now) = 1)) --ACTIVOS
-- 					OR (@FilterOptionLocal = 3 AND F.[Deleted] = 0 AND (Tzdb.IsLowerSystemDate(F.[EndDate], @Now) = 1)) -- VENCIDOS
-- 					OR (@FilterOptionLocal = 4 AND F.[Deleted] = 1) -- DESACTIVADOS
-- 					OR (@FilterOptionLocal = 5 AND F.[Deleted] = 0 AND (Tzdb.IsGreaterSystemDate(F.[StartDate], @Now) = 1)) -- PLANIFICADOS
-- 				)
-- 				AND AF.[IdPersonOfInterest] = @IdPersonOfInterest 
-- 				AND F.[Deleted] = 0 AND AF.[Deleted] = 0
-- 				AND F.[AllowWebComplete] = 1 --Solo tareas que puedan ser completadas desde la web

-- 	GROUP BY	F.[Id], F.[Name], U.[Id], U.[Name], U.[LastName], F.[Date], F.[Deleted], F.[Description], F.[OneTimeAnswer],
-- 				F.[DeletedDate], F.[StartDate], F.[EndDate], F.[IdFormCategory], FC.[Name], F.[AllPointOfInterest], 
-- 				F.[AllPersonOfInterest], F.[NonPointOfInterest], F.[IsWeighted]
	
-- 	ORDER BY	F.[Date] desc
-- END
