/****** Object:  Procedure [dbo].[GetFormsCategoriesImages]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 05/05/2021
-- Description:	SP para obtener la cantidad de imágenes detareas por categorías
-- =============================================
CREATE PROCEDURE [dbo].[GetFormsCategoriesImages]
	 @DateFrom [sys].[datetime] = NULL
	,@DateTo [sys].[datetime] = NULL
	,@FormIds [sys].[varchar](MAX) = NULL
	,@Hierarchy1Ids [sys].[varchar](MAX) = NULL
	,@Hierarchy2Ids [sys].[varchar](MAX) = NULL
	,@PointOfInterestIds [sys].[varchar](MAX) = NULL
	,@PointOfInterestZoneIds [sys].[varchar](MAX) = NULL
	,@PersonOfInterestIds [sys].[varchar](MAX) = NULL
	,@PersonOfInterestZoneIds [sys].[varchar](MAX) = NULL
	,@FormCategoryIds [sys].[varchar](MAX) = NULL
	,@TypeIds [sys].[varchar](max) = NULL
	,@TagIds [sys].[varchar](MAX) = NULL
	,@IdUser [sys].[INT] = NULL
	,@IdCompanies [sys].[varchar](MAX) = NULL
AS
BEGIN
	CREATE TABLE #Forms
	(
		[Id] int,
		[IdFormCategory] int
	)

	INSERT INTO #Forms([Id], [IdFormCategory])
	SELECT	[Id], [IdFormCategory]
	FROM	[dbo].[Form] WITH (NOLOCK)
	WHERE	(CASE WHEN @FormCategoryIds IS NULL THEN 1 ELSE dbo.[CheckValueInList]([IdFormCategory], @FormCategoryIds) END) = 1
			AND (CASE WHEN @TypeIds IS NULL THEN 1 ELSE dbo.[CheckValueInList]([IdFormType], @TypeIds) END) = 1
			AND (CASE WHEN @IdCompanies IS NULL THEN 1 ELSE dbo.[CheckValueInList]([IdCompany], @IdCompanies) END) = 1
			AND (CASE WHEN @IdUser IS NULL THEN 1 ELSE dbo.CheckUserInFormCompanies([IdCompany], @IdUser) END) = 1

	CREATE TABLE #Persons
	(
		[Id] int
	)

	INSERT INTO #Persons([Id])
	SELECT	[Id]
	FROM	[dbo].[PersonOfInterest] WITH (NOLOCK)
	WHERE	(CASE WHEN @IdUser IS NULL THEN 1 ELSE dbo.CheckUserInPersonOfInterestZones([Id], @IdUser) END) = 1
			AND (CASE WHEN @IdUser IS NULL THEN 1 ELSE dbo.CheckDepartmentInUserDepartments([IdDepartment], @IdUser) END) = 1

	CREATE TABLE #Points
	(
		[Id] int
	)

	INSERT INTO #Points([Id])
	SELECT	[Id]
	FROM	[dbo].[PointOfInterest] WITH (NOLOCK)
	WHERE	(CASE WHEN @Hierarchy1Ids IS NULL THEN 1 ELSE dbo.[CheckValueInList]([GrandfatherId], @Hierarchy1Ids) END) = 1
			AND (CASE WHEN @Hierarchy2Ids IS NULL THEN 1 ELSE dbo.[CheckValueInList]([FatherId], @Hierarchy2Ids) END) = 1

	SELECT  FC.[Id] AS FormCategoryId, FC.[Name] AS FormCategoryName, COUNT(DISTINCT AI.[Id]) ImagesCount
	FROM    #Forms F WITH (NOLOCK)
			LEFT OUTER JOIN [dbo].[FormCategory] FC WITH (NOLOCK) ON FC.[Id] = F.[IdFormCategory]
			INNER JOIN [dbo].[CompletedForm] CF WITH (NOLOCK) ON CF.[IdForm] = F.[Id]
			--INNER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = CF.[IdPointOfInterest]
			LEFT OUTER JOIN #Points P WITH (NOLOCK) ON P.[Id] = CF.[IdPointOfInterest]
			LEFT OUTER JOIN [dbo].[PointOfInterestZone] PZ WITH (NOLOCK) ON PZ.[IdPointOfInterest] = P.[Id]
			LEFT OUTER JOIN #Persons S WITH (NOLOCK) ON S.[Id] = CF.[IdPersonOfInterest]
			LEFT OUTER JOIN [dbo].[PersonOfInterestZone] SZ WITH (NOLOCK) ON SZ.[IdPersonOfInterest] = S.[Id]
            INNER JOIN [dbo].[Answer] AI WITH (NOLOCK) ON CF.Id = AI.IdCompletedForm AND AI.QuestionType = 'CAM' AND AI.[ImageName] IS NOT NULL AND AI.[ImageName] <> ''
			LEFT OUTER JOIN [dbo].[Answer] A WITH (NOLOCK) ON CF.Id = A.IdCompletedForm AND A.QuestionType = 'TAG'
			LEFT OUTER JOIN [dbo].[AnswerTag] ATA WITH (NOLOCK) ON A.Id = ATA.IdAnswer
	WHERE	
		((@DateFrom IS NULL) OR (@DateTo IS NULL) OR (CF.[Date] >= @DateFrom AND CF.[Date] <= @DateTo)) AND
		((@FormIds IS NULL) OR (dbo.[CheckValueInList](F.[Id], @FormIds) = 1)) AND
		--((@PointOfInterestIds IS NULL) OR (dbo.[CheckValueInList](P.[Id], @PointOfInterestIds) = 1)) AND
		((@PointOfInterestIds IS NULL) OR (dbo.[CheckValueInList](CF.[IdPointOfInterest], @PointOfInterestIds) = 1)) AND
		((@PointOfInterestZoneIds IS NULL) OR (dbo.[CheckValueInList](PZ.[IdZone], @PointOfInterestZoneIds) = 1)) AND
		((@Hierarchy1Ids IS NULL AND @Hierarchy2Ids IS NULL) OR (CF.[IdPointOfInterest] IS NOT NULL AND P.[Id] IS NOT NULL)) AND
		((@PersonOfInterestIds IS NULL) OR (dbo.[CheckValueInList](CF.[IdPersonOfInterest], @PersonOfInterestIds) = 1)) AND
		((@PersonOfInterestZoneIds IS NULL) OR (dbo.[CheckValueInList](SZ.[IdZone], @PersonOfInterestZoneIds) = 1)) AND
		((@TagIds IS NULL) OR ((@TagIds = '-1' AND ATA.IdAnswer is null) OR (@TagIds <> '-1' AND ATA.IdTag IS NOT NULL AND dbo.[CheckValueInList](ATA.[IdTag], @TagIds) = 1))) AND
		--((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
		((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(CF.[IdPointOfInterest], @IdUser) = 1)) AND
		--((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[Id], @IdUser) = 1)) AND
		((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(CF.[IdPointOfInterest], @IdUser) = 1))
	GROUP BY	FC.[Id], FC.[Name]
	ORDER BY	FC.[Name]

	DROP TABLE #Points
	DROP TABLE #Persons
	DROP TABLE #Forms
END
