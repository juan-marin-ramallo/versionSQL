/****** Object:  Procedure [dbo].[GetPlannedFormsExcel]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gaston Legnani
-- Create date: 23/03/2016
-- Description:	SP para obtener SOLAMENTE LOS FORMULARIOS VENCIDOS para Excel
-- =============================================
CREATE PROCEDURE [dbo].[GetPlannedFormsExcel]

	 @DateFrom [sys].[datetime] = NULL
	,@DateTo [sys].[datetime] = NULL
	,@IdUser [sys].[int] = NULL
	,@FormIds [sys].[varchar](max) = NULL
	,@PointOfInterestIds [sys].[varchar](MAX) = NULL
	,@CategoryIds [sys].[varchar](max) = NULL
	,@OutsidePointOfInterest [sys].[bit] = NULL
AS
BEGIN
	DECLARE @SystemToday [sys].[datetime]
	SET @SystemToday = DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(GETUTCDATE())), 0)

	;WITH vForms([Id], [Name], [Date], [StartDate], [StartDateSystemTruncated],
                 [EndDate], [IdFormCategory], [AllPointOfInterest], [IdUser]) AS
    (
        SELECT	F.[Id], F.[Name], F.[Date],
                F.[StartDate], DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(F.[StartDate])), 0) AS StartDateSystemTruncated,
                F.[EndDate], F.[IdFormCategory], F.[AllPointOfInterest], F.[IdUser]
	    FROM	[dbo].[Form] F WITH (NOLOCK)
        WHERE   ((@FormIds IS NULL) OR (dbo.[CheckValueInList](F.[Id], @FormIds) = 1))
                AND ((@CategoryIds IS NULL) OR (dbo.[CheckValueInList](F.[IdFormCategory], @CategoryIds) = 1))
                AND F.[Deleted] = 0
    )

	SELECT		F.[Id], F.[Name],F.[Date], F.[StartDate], F.[EndDate], F.[IdFormCategory], P.[Identifier] AS PointOfInterestIdentifier,
				P.[Name] AS PointOfInterestName, FC.[Name] AS FormCategoryName, F.[AllPointOfInterest],
				[dbo].[CompletedFormsCountByPointOfInterest](F.[Id], P.[Id], NULL, NULL, NULL, @IdUser) AS CompletedFormsCount
	FROM		vForms F WITH(NOLOCK)
				INNER JOIN [dbo].[User] U WITH(NOLOCK) ON F.[IdUser] = U.[Id]
				LEFT JOIN [dbo].[AssignedForm] AF WITH(NOLOCK) ON F.[Id] = AF.[IdForm] 
				LEFT JOIN [dbo].[PointOfInterest] P WITH(NOLOCK) ON P.[Id] = AF.[IdPointOfInterest]
				LEFT JOIN [dbo].[FormCategory] FC WITH(NOLOCK) ON FC.[Id] = F.[IdFormCategory]
	WHERE		((@DateFrom IS NULL) OR (@DateTo IS NULL) OR F.[Date] BETWEEN @DateFrom AND @DateTo) AND
				F.[StartDateSystemTruncated] > @SystemToday AND
				((@PointOfInterestIds IS NULL) OR (F.[AllPointOfInterest] = 1 OR dbo.[CheckValueInList](P.[Id], @PointOfInterestIds) = 1)) AND
				(@OutsidePointOfInterest IS NULL OR (F.[AllPointOfInterest] = 0 AND @OutsidePointOfInterest = 1 AND P.[Id] IS NULL)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) AND
				AF.[Deleted] = 0 AND (P.Id IS NULL OR P.Deleted = 0)
	GROUP BY	F.[Id], F.[Name],F.[Date], F.[StartDate], F.[EndDate], F.[IdFormCategory], P.[Identifier], F.[AllPointOfInterest], P.[Name],
				FC.[Name], [dbo].[CompletedFormsCountByPointOfInterest](F.[Id], P.[Id], NULL, NULL, NULL, @IdUser)
	ORDER BY	F.[Date] desc
END

-- OLD)
-- BEGIN
-- 	SELECT		F.[Id], F.[Name],F.[Date], F.[StartDate], F.[EndDate], F.[IdFormCategory], P.[Identifier] AS PointOfInterestIdentifier,
-- 				P.[Name] AS PointOfInterestName, FC.[Name] AS FormCategoryName, F.[AllPointOfInterest],
-- 				[dbo].[CompletedFormsCountByPointOfInterest](F.[Id], P.[Id], NULL, NULL, NULL, @IdUser) AS CompletedFormsCount
-- 	FROM		[dbo].[Form] F WITH(NOLOCK)
-- 				INNER JOIN [dbo].[User] U WITH(NOLOCK) ON F.[IdUser] = U.[Id]
-- 				LEFT JOIN [dbo].[AssignedForm] AF WITH(NOLOCK) ON F.[Id] = AF.[IdForm] 
-- 				LEFT JOIN [dbo].[PointOfInterest] P WITH(NOLOCK) ON P.[Id] = AF.[IdPointOfInterest]
-- 				LEFT JOIN [dbo].[FormCategory] FC WITH(NOLOCK) ON FC.[Id] = F.[IdFormCategory]
-- 	WHERE		((@DateFrom IS NULL) OR (@DateTo IS NULL) OR F.[Date] BETWEEN @DateFrom AND @DateTo) AND
-- 				Tzdb.IsGreaterSystemDate(F.[StartDate], GETUTCDATE()) = 1 AND
-- 				((@FormIds IS NULL) OR (dbo.[CheckValueInList](F.[Id], @FormIds) = 1)) AND
-- 				((@CategoryIds IS NULL) OR (dbo.[CheckValueInList](F.[IdFormCategory], @CategoryIds) = 1)) AND
-- 				((@PointOfInterestIds IS NULL) OR (F.[AllPointOfInterest] = 1 OR dbo.[CheckValueInList](P.[Id], @PointOfInterestIds) = 1)) AND
-- 				(@OutsidePointOfInterest IS NULL OR (F.[AllPointOfInterest] = 0 AND @OutsidePointOfInterest = 1 AND P.[Id] IS NULL)) AND
-- 				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
-- 				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) AND
-- 				AF.[Deleted] = 0 AND F.[Deleted] = 0 AND (P.Id IS NULL OR P.Deleted = 0)
-- 	GROUP BY	F.[Id], F.[Name],F.[Date], F.[StartDate], F.[EndDate], F.[IdFormCategory], P.[Identifier], F.[AllPointOfInterest], P.[Name],
-- 				FC.[Name], [dbo].[CompletedFormsCountByPointOfInterest](F.[Id], P.[Id], NULL, NULL, NULL, @IdUser)
-- 	ORDER BY	F.[Date] desc
-- END
