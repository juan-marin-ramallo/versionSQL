/****** Object:  Procedure [dbo].[GetFormsPointsOfInterestImages]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 05/05/2021
-- Description:	SP para obtener la cantidad de imágenes de tareas por puntos de interés
-- =============================================
CREATE PROCEDURE [dbo].[GetFormsPointsOfInterestImages]
	 @DateFrom [sys].[datetime] = NULL
	,@DateTo [sys].[datetime] = NULL
	,@IdFormCategory [sys].[int] = NULL
	,@IdZone [sys].[int] = NULL
	,@IdPersonOfInterest [sys].[int] = NULL
	,@FormIds [sys].[varchar](MAX) = NULL
	,@Hierarchy1Ids [sys].[varchar](MAX) = NULL
	,@Hierarchy2Ids [sys].[varchar](MAX) = NULL
	,@PointOfInterestIds [sys].[varchar](MAX) = NULL
	,@PointOfInterestZoneIds [sys].[varchar](MAX) = NULL
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
	WHERE	((@IdFormCategory IS NULL AND [IdFormCategory] IS NULL) OR ([IdFormCategory] = @IdFormCategory))
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

	CREATE TABLE #PersonsZones
	(
		[IdPersonOfInterest] int,
		[IdZone] int
	)

	INSERT INTO #PersonsZones([IdPersonOfInterest], [IdZone])
	SELECT	SZ.[IdPersonOfInterest], SZ.[IdZone]
	FROM	[dbo].[PersonOfInterestZone] SZ WITH (NOLOCK)
			INNER JOIN [dbo].[Zone] Z WITH (NOLOCK) ON Z.[Id] = SZ.[IdZone]
	WHERE	Z.[ApplyToAllPersonOfInterest] = 0 -- Exclude All Persons Of Interest zone

	CREATE TABLE #Points
	(
		[Id] int,
		[Name] varchar(100),
		[Identifier] varchar(50)
	)

	INSERT INTO #Points([Id], [Name], [Identifier])
	SELECT	[Id], [Name], [Identifier]
	FROM	[dbo].[PointOfInterest] WITH (NOLOCK)
	WHERE	(CASE WHEN @Hierarchy1Ids IS NULL THEN 1 ELSE dbo.[CheckValueInList]([GrandfatherId], @Hierarchy1Ids) END) = 1
			AND (CASE WHEN @Hierarchy2Ids IS NULL THEN 1 ELSE dbo.[CheckValueInList]([FatherId], @Hierarchy2Ids) END) = 1

	SELECT  P.[Id] AS PointOfInterestId, P.[Name] AS PointOfInterestName, P.[Identifier] AS PointOfInterestIdentifier,
			COUNT(DISTINCT AI.[Id]) ImagesCount
	FROM    #Forms F WITH (NOLOCK)
			INNER JOIN [dbo].[CompletedForm] CF WITH (NOLOCK) ON CF.[IdForm] = F.[Id]
			LEFT OUTER JOIN #Points P WITH (NOLOCK) ON P.[Id] = CF.[IdPointOfInterest]
			LEFT OUTER JOIN [dbo].[PointOfInterestZone] PZ WITH (NOLOCK) ON PZ.[IdPointOfInterest] = P.[Id]
			INNER JOIN #Persons S WITH (NOLOCK) ON S.[Id] = CF.[IdPersonOfInterest]
			LEFT OUTER JOIN #PersonsZones SZ WITH (NOLOCK) ON SZ.[IdPersonOfInterest] = S.[Id]
            INNER JOIN [dbo].[Answer] AI WITH (NOLOCK) ON CF.Id = AI.IdCompletedForm AND AI.QuestionType = 'CAM' AND AI.[ImageName] IS NOT NULL AND AI.[ImageName] <> ''
			LEFT OUTER JOIN [dbo].[Answer] A WITH (NOLOCK) ON CF.Id = A.IdCompletedForm AND A.QuestionType = 'TAG'
			LEFT OUTER JOIN [dbo].[AnswerTag] ATA WITH (NOLOCK) ON A.Id = ATA.IdAnswer
	WHERE
			CF.[IdPersonOfInterest] = @IdPersonOfInterest AND
			(SZ.[IdPersonOfInterest] IS NULL OR SZ.[IdZone] = @IdZone) AND
			((@DateFrom IS NULL) OR (@DateTo IS NULL) OR (CF.[Date] >= @DateFrom AND CF.[Date] <= @DateTo)) AND
			((@FormIds IS NULL) OR (dbo.[CheckValueInList](F.[Id], @FormIds) = 1)) AND
			((@Hierarchy1Ids IS NULL AND @Hierarchy2Ids IS NULL) OR (CF.[IdPointOfInterest] IS NOT NULL AND P.[Id] IS NOT NULL)) AND
			((@PointOfInterestIds IS NULL) OR (dbo.[CheckValueInList](CF.[IdPointOfInterest], @PointOfInterestIds) = 1)) AND
			((@PointOfInterestZoneIds IS NULL) OR (dbo.[CheckValueInList](PZ.[IdZone], @PointOfInterestZoneIds) = 1)) AND
			((@TagIds IS NULL) OR ((@TagIds = '-1' AND ATA.IdAnswer is null) OR (@TagIds <> '-1' AND ATA.IdTag IS NOT NULL AND dbo.[CheckValueInList](ATA.[IdTag], @TagIds) = 1))) AND
			((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(CF.[IdPointOfInterest], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(CF.[IdPointOfInterest], @IdUser) = 1))
	GROUP BY	P.[Id], P.[Name], P.[Identifier]
	ORDER BY	P.[Name]

	DROP TABLE #Points
	DROP TABLE #PersonsZones
	DROP TABLE #Persons
	DROP TABLE #Forms
END
