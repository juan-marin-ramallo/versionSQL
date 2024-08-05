﻿/****** Object:  Procedure [dbo].[GetFormsImagesReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 07/05/2021
-- Description:	SP para obtener la información de imágenes de tareas para un reporte
-- =============================================
CREATE PROCEDURE [dbo].[GetFormsImagesReport]
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
		[Id] int,
		[Name] varchar(50),
		[LastName] varchar(50),
		[Identifier] varchar(20)
	)

	INSERT INTO #Persons([Id], [Name], [LastName], [Identifier])
	SELECT	[Id], [Name], [LastName], [Identifier]
	FROM	[dbo].[PersonOfInterest] WITH (NOLOCK)
	WHERE	(CASE WHEN @IdUser IS NULL THEN 1 ELSE dbo.CheckUserInPersonOfInterestZones([Id], @IdUser) END) = 1
			AND (CASE WHEN @IdUser IS NULL THEN 1 ELSE dbo.CheckDepartmentInUserDepartments([IdDepartment], @IdUser) END) = 1

	CREATE TABLE #PersonsZones
	(
		[IdPersonOfInterest] int,
		[IdZone] int,
		[ZoneDescription] varchar(100)
	)

	INSERT INTO #PersonsZones([IdPersonOfInterest], [IdZone], [ZoneDescription])
	SELECT	SZ.[IdPersonOfInterest], SZ.[IdZone], Z.[Description] AS ZoneDescription
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

	CREATE TABLE #AnswersImages
	(
		[Id] int,
		[IdCompletedForm] int,
		[ImageEncoded] varbinary(MAX),
		[ImageUrl] varchar(5000)
	)

	INSERT INTO #AnswersImages([Id], [IdCompletedForm], [ImageEncoded], [ImageUrl])
	SELECT	[Id], [IdCompletedForm], [ImageEncoded], [ImageUrl]
	FROM	[dbo].[Answer] WITH (NOLOCK)
	WHERE	[QuestionType] = 'CAM'
			AND [ImageName] IS NOT NULL AND [ImageName] <> ''

	CREATE TABLE #AnswersTags
	(
		[Id] int,
		[IdCompletedForm] int
	)

	INSERT INTO #AnswersTags([Id], [IdCompletedForm])
	SELECT	[Id], [IdCompletedForm]
	FROM	[dbo].[Answer] WITH (NOLOCK)
	WHERE	[QuestionType] = 'TAG'

	SELECT		FC.[Id] AS FormCategoryId, FC.[Name] AS FormCategoryName, COUNT(AI.[Id]) OVER (PARTITION BY FC.[Id]) FormCategoryImagesCount,
				SZ.[IdZone], SZ.[ZoneDescription], COUNT(AI.[Id]) OVER (PARTITION BY FC.[Id], SZ.[IdZone]) ZoneImagesCount,
				S.[Id] AS PersonOfInterestId, S.[Name] AS PersonOfInterestName, S.[LastName] AS PersonOfInterestLastName, S.[Identifier] AS PersonOfInterestIdentifier,
				COUNT(AI.[Id]) OVER (PARTITION BY FC.[Id], SZ.[IdZone], S.[Id]) PersonOfInterestImagesCount,
				P.[Id] AS PointOfInterestId, P.[Name] AS PointOfInterestName, P.[Identifier] AS PointOfInterestIdentifier,
				COUNT(AI.[Id]) OVER (PARTITION BY FC.[Id], SZ.[IdZone], S.[Id], P.[Id]) PointOfInterestImagesCount,
				AI.[ImageEncoded], AI.[ImageUrl], CF.[Date] AS CompletedFormDate
	
	FROM		#Forms F WITH (NOLOCK)
				LEFT OUTER JOIN [dbo].[FormCategory] FC WITH (NOLOCK) ON FC.[Id] = F.[IdFormCategory]
				INNER JOIN [dbo].[CompletedForm] CF WITH (NOLOCK) ON CF.[IdForm] = F.[Id]
				LEFT OUTER JOIN #Points P WITH (NOLOCK) ON P.[Id] = CF.[IdPointOfInterest]
				LEFT OUTER JOIN [dbo].[PointOfInterestZone] PZ WITH (NOLOCK) ON PZ.[IdPointOfInterest] = P.[Id]
				LEFT OUTER JOIN #Persons S WITH (NOLOCK) ON S.[Id] = CF.[IdPersonOfInterest]
				LEFT OUTER JOIN #PersonsZones SZ WITH (NOLOCK) ON SZ.[IdPersonOfInterest] = S.[Id]
				INNER JOIN #AnswersImages AI WITH (NOLOCK) ON CF.Id = AI.IdCompletedForm
				LEFT OUTER JOIN #AnswersTags A WITH (NOLOCK) ON CF.Id = A.IdCompletedForm
				LEFT OUTER JOIN [dbo].[AnswerTag] ATA WITH (NOLOCK) ON A.Id = ATA.IdAnswer
	WHERE		
				((@DateFrom IS NULL) OR (@DateTo IS NULL) OR (CF.[Date] >= @DateFrom AND CF.[Date] <= @DateTo)) AND
				((@FormIds IS NULL) OR (dbo.[CheckValueInList](F.[Id], @FormIds) = 1)) AND
				((@PointOfInterestIds IS NULL) OR (dbo.[CheckValueInList](CF.[IdPointOfInterest], @PointOfInterestIds) = 1)) AND
				((@PointOfInterestZoneIds IS NULL) OR (dbo.[CheckValueInList](PZ.[IdZone], @PointOfInterestZoneIds) = 1)) AND
				((@Hierarchy1Ids IS NULL AND @Hierarchy2Ids IS NULL) OR (CF.[IdPointOfInterest] IS NOT NULL AND P.[Id] IS NOT NULL)) AND
				((@PersonOfInterestIds IS NULL) OR (dbo.[CheckValueInList](CF.[IdPersonOfInterest], @PersonOfInterestIds) = 1)) AND
				((@PersonOfInterestZoneIds IS NULL) OR (dbo.[CheckValueInList](SZ.[IdZone], @PersonOfInterestZoneIds) = 1)) AND
				((@TagIds IS NULL) OR ((@TagIds = '-1' AND ATA.IdAnswer is null) OR (@TagIds <> '-1' AND ATA.IdTag IS NOT NULL AND dbo.[CheckValueInList](ATA.[IdTag], @TagIds) = 1))) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(CF.[IdPointOfInterest], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(CF.[IdPointOfInterest], @IdUser) = 1))
	
	GROUP BY	FC.[Id], FC.[Name],
				SZ.[IdZone], SZ.[ZoneDescription],
				S.[Id], S.[Name], S.[LastName], S.[Identifier],
				P.[Id], P.[Name], P.[Identifier],
				AI.[Id], AI.[ImageEncoded], AI.[ImageUrl], CF.[Date]
	
	ORDER BY	FC.[Name],
				SZ.[ZoneDescription],
				S.[Name], S.[LastName],
				P.[Name],
				AI.[Id]

	DROP TABLE #AnswersTags
	DROP TABLE #AnswersImages
	DROP TABLE #Points
	DROP TABLE #PersonsZones
	DROP TABLE #Persons
	DROP TABLE #Forms
END
