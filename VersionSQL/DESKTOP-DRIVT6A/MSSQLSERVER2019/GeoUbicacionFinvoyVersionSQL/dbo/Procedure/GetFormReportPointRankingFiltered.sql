/****** Object:  Procedure [dbo].[GetFormReportPointRankingFiltered]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gaston Legnani
-- Create date: 04/04/2018
-- Description:	SP para obtener el ranking de puntos CON SUS TAREAS COMPLETADAS
-- =============================================
CREATE PROCEDURE [dbo].[GetFormReportPointRankingFiltered]

	 @DateFrom [sys].[datetime] = NULL
	,@DateTo [sys].[datetime] = NULL
	,@FormIds [sys].[varchar](MAX) = NULL
	,@PointOfInterestIds [sys].[varchar](MAX) = NULL
	,@StockersIds [sys].[varchar](MAX) = NULL
	,@CategoryIds [sys].[varchar](MAX) = NULL
	,@TypeIds [sys].[varchar](max) = NULL
	,@TagIds [sys].[varchar](MAX) = NULL
	,@IdUser [sys].[INT] = NULL
	,@IdCompanies [sys].[varchar](MAX) = NULL
AS
BEGIN
	 
	DECLARE @DateFromLocal [sys].[datetime] 
	DECLARE @DateToLocal [sys].[datetime] 
	DECLARE @FormIdsLocal [sys].[varchar](MAX)
	DECLARE @PointOfInterestIdsLocal [sys].[varchar](MAX)
	DECLARE @StockersIdsLocal [sys].[varchar](MAX)
	DECLARE @CategoryIdsLocal [sys].[varchar](MAX)
	DECLARE @TypeIdsLocal [sys].[varchar](max)
	DECLARE @TagIdsLocal [sys].[varchar](max)
	DECLARE @IdUserLocal [sys].[INT]
	DECLARE @OutsidePointOfInterestLocal [sys].[bit]
	DECLARE @IdCompaniesLocal [sys].[varchar](max)

	SET @DateFromLocal = @DateFrom
	SET @DateToLocal =  @DateTo
	SET @FormIdsLocal = @FormIds
	SET @PointOfInterestIdsLocal = @PointOfInterestIds
	SET @StockersIdsLocal = @StockersIds
	SET @CategoryIdsLocal = @CategoryIds
	SET @TypeIdsLocal = @TypeIds
	SET @TagIdsLocal = @TagIds
	SET @IdUserLocal = @IdUser
	SET @IdCompaniesLocal = @IdCompanies

	IF (@FormIdsLocal IS NOT NULL)
	BEGIN
		SELECT  P.[Id] AS PointOfInterestId, P.[Name] AS PointOfInterestName, P.[Identifier] AS PointOfInterestIdentifier, 
				COUNT(DISTINCT CF.[Id]) CompletedFormsQuantity 
		FROM    [dbo].[PointOfInterest] P with(nolock)
				INNER JOIN [dbo].[CompletedForm] CF with(nolock) ON CF.[IdPointOfInterest] = P.[Id]
				INNER JOIN [dbo].[Form] F with(nolock) ON F.[Id] = CF.[IdForm]
				LEFT OUTER JOIN [dbo].[PersonOfInterest] S with(nolock) ON S.[Id] = CF.[IdPersonOfInterest]
				LEFT OUTER JOIN [dbo].[Answer] A ON CF.Id = A.IdCompletedForm AND a.QuestionType = 'TAG'
				LEFT OUTER JOIN [dbo].[AnswerTag] ATA ON A.Id = ATA.IdAnswer
		WHERE	
			((@DateFromLocal IS NULL) OR (@DateToLocal IS NULL) OR (CF.[Date] >= @DateFromLocal AND CF.[Date] <= @DateToLocal)) AND
			((@FormIdsLocal IS NULL) OR (dbo.[CheckValueInList](F.[Id], @FormIdsLocal) = 1)) AND
			((@CategoryIdsLocal IS NULL) OR (dbo.[CheckValueInList](F.[IdFormCategory], @CategoryIdsLocal) = 1)) AND
			((@TypeIdsLocal IS NULL) OR (dbo.[CheckValueInList](F.[IdFormType], @TypeIdsLocal) = 1)) AND
			((@PointOfInterestIdsLocal IS NULL) OR (dbo.[CheckValueInList](P.[Id], @PointOfInterestIdsLocal) = 1)) AND
			((@IdCompaniesLocal IS NULL) OR (dbo.[CheckValueInList](F.[IdCompany], @IdCompaniesLocal) = 1)) AND
			((@StockersIdsLocal IS NULL) OR (dbo.[CheckValueInList](CF.[IdPersonOfInterest], @StockersIdsLocal) = 1)) AND
			((@TagIdsLocal IS NULL) OR ((@TagIdsLocal = '-1' AND ATA.IdAnswer is null) OR (@TagIdsLocal <> '-1' AND ATA.IdTag IS NOT NULL AND dbo.[CheckValueInList](ATA.[IdTag], @TagIdsLocal) = 1))) AND
			((@IdUserLocal IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUserLocal) = 1)) AND
			((@IdUserLocal IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUserLocal) = 1)) AND
			((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUserLocal) = 1)) AND
			((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[Id], @IdUserLocal) = 1))
			AND ((@IdUser IS NULL) OR (dbo.CheckUserInFormCompanies(F.[IdCompany], @IdUser) = 1)) 
		--AND S.Deleted = 0 AND P.Deleted = 0
		GROUP BY	P.[Id], P.[Name], P.[Identifier]

		UNION

		SELECT  P.[Id] AS PointOfInterestId, P.[Name] AS PointOfInterestName, P.[Identifier] AS PointOfInterestIdentifier, 
				0 AS CompletedFormsQuantity 

		FROM    [dbo].[PointOfInterest] P with(nolock)
				INNER JOIN [dbo].[AssignedForm] AF with(nolock) ON AF.[IdPointOfInterest] = P.[Id] and af.[Deleted] = 0
				--LEFT JOIN [dbo].[Form] F ON F.[Id] = AF.[IdForm]

		WHERE	
				((@PointOfInterestIdsLocal IS NULL) OR (dbo.[CheckValueInList](P.[Id], @PointOfInterestIdsLocal) = 1)) AND
				((@FormIdsLocal IS NULL) OR (@FormIdsLocal LIKE '%,'+CAST(AF.[IdForm] AS varchar)+',%' )) AND
				((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[Id], @IdUserLocal) = 1)) AND
				((@IdUserLocal IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUserLocal) = 1))
				--AND P.Deleted = 0 
				AND P.[Id] NOT IN 
				(
					SELECT  P.[Id] 
					FROM    [dbo].[PointOfInterest] P with(nolock)
							INNER JOIN [dbo].[CompletedForm] CF with(nolock) ON CF.[IdPointOfInterest] = P.[Id]
							INNER JOIN [dbo].[Form] F with(nolock) ON F.[Id] = CF.[IdForm]
							LEFT OUTER JOIN [dbo].[PersonOfInterest] S with(nolock) ON S.[Id] = CF.[IdPersonOfInterest]
					WHERE	
					((@DateFromLocal IS NULL) OR (@DateToLocal IS NULL) OR (CF.[Date] >= @DateFromLocal AND CF.[Date] <= @DateToLocal)) AND
					((@FormIdsLocal IS NULL) OR (dbo.[CheckValueInList](F.[Id], @FormIdsLocal) = 1)) AND
					((@CategoryIdsLocal IS NULL) OR (dbo.[CheckValueInList](F.[IdFormCategory], @CategoryIdsLocal) = 1)) AND
					((@TypeIdsLocal IS NULL) OR (dbo.[CheckValueInList](F.[IdFormType], @TypeIdsLocal) = 1)) AND
					((@IdCompaniesLocal IS NULL) OR (dbo.[CheckValueInList](F.[IdCompany], @IdCompaniesLocal) = 1)) AND
					((@StockersIdsLocal IS NULL) OR (dbo.[CheckValueInList](CF.[IdPersonOfInterest], @StockersIdsLocal) = 1)) AND
					((@IdUserLocal IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(CF.[IdPersonOfInterest], @IdUserLocal) = 1)) AND
					((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUserLocal) = 1))
					AND ((@IdUser IS NULL) OR (dbo.CheckUserInFormCompanies(F.[IdCompany], @IdUser) = 1)) 
				)
		-- AND P.Deleted = 0
		GROUP BY	P.[Id], P.[Name], P.[Identifier]
		ORDER BY CompletedFormsQuantity DESC
	END
	ELSE
	BEGIN
		SELECT  P.[Id] AS PointOfInterestId, P.[Name] AS PointOfInterestName, P.[Identifier] AS PointOfInterestIdentifier, 
			COUNT(DISTINCT CF.[Id]) CompletedFormsQuantity 
		FROM    [dbo].[PointOfInterest] P with(nolock)
				INNER JOIN [dbo].[CompletedForm] CF with(nolock) ON CF.[IdPointOfInterest] = P.[Id]
				INNER JOIN [dbo].[Form] F with(nolock) ON F.[Id] = CF.[IdForm]
				LEFT OUTER JOIN [dbo].[PersonOfInterest] S with(nolock) ON S.[Id] = CF.[IdPersonOfInterest]
				LEFT OUTER JOIN [dbo].[Answer] A ON CF.Id = A.IdCompletedForm AND a.QuestionType = 'TAG'
				LEFT OUTER JOIN [dbo].[AnswerTag] ATA ON A.Id = ATA.IdAnswer
		WHERE	
			((@DateFromLocal IS NULL) OR (@DateToLocal IS NULL) OR (CF.[Date] >= @DateFromLocal AND CF.[Date] <= @DateToLocal)) AND
			((@FormIdsLocal IS NULL) OR (dbo.[CheckValueInList](F.[Id], @FormIdsLocal) = 1)) AND
			((@CategoryIdsLocal IS NULL) OR (dbo.[CheckValueInList](F.[IdFormCategory], @CategoryIdsLocal) = 1)) AND
			((@TypeIdsLocal IS NULL) OR (dbo.[CheckValueInList](F.[IdFormType], @TypeIdsLocal) = 1)) AND
			((@PointOfInterestIdsLocal IS NULL) OR (dbo.[CheckValueInList](P.[Id], @PointOfInterestIdsLocal) = 1)) AND
			((@IdCompaniesLocal IS NULL) OR (dbo.[CheckValueInList](F.[IdCompany], @IdCompaniesLocal) = 1)) AND
			((@StockersIdsLocal IS NULL) OR (dbo.[CheckValueInList](CF.[IdPersonOfInterest], @StockersIdsLocal) = 1)) AND
			((@TagIdsLocal IS NULL) OR ((@TagIdsLocal = '-1' AND ATA.IdAnswer is null) OR (@TagIdsLocal <> '-1' AND ATA.IdTag IS NOT NULL AND dbo.[CheckValueInList](ATA.[IdTag], @TagIdsLocal) = 1))) AND
			((@IdUserLocal IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUserLocal) = 1)) AND
			((@IdUserLocal IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUserLocal) = 1)) AND
			((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUserLocal) = 1)) AND
			((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[Id], @IdUserLocal) = 1))
			AND ((@IdUser IS NULL) OR (dbo.CheckUserInFormCompanies(F.[IdCompany], @IdUser) = 1)) 
		--AND S.Deleted = 0 AND P.Deleted = 0
		GROUP BY	P.[Id], P.[Name], P.[Identifier]

		UNION

		SELECT  P.[Id] AS PointOfInterestId, P.[Name] AS PointOfInterestName, P.[Identifier] AS PointOfInterestIdentifier, 
				0 AS CompletedFormsQuantity 

		FROM    [dbo].[PointOfInterest] P with(nolock)
				--INNER JOIN [dbo].[AssignedForm] AF with(nolock) ON AF.[IdPointOfInterest] = P.[Id] and af.[Deleted] = 0
				--LEFT JOIN [dbo].[Form] F ON F.[Id] = AF.[IdForm]

		WHERE	
				((@PointOfInterestIdsLocal IS NULL) OR (dbo.[CheckValueInList](P.[Id], @PointOfInterestIdsLocal) = 1)) AND
				((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[Id], @IdUserLocal) = 1)) AND
				((@IdUserLocal IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUserLocal) = 1))
				--AND P.Deleted = 0 
				AND P.[Id] NOT IN 
				(
					SELECT  P.[Id] 
					FROM    [dbo].[PointOfInterest] P with(nolock)
							INNER JOIN [dbo].[CompletedForm] CF with(nolock) ON CF.[IdPointOfInterest] = P.[Id]
							INNER JOIN [dbo].[Form] F with(nolock) ON F.[Id] = CF.[IdForm]
							LEFT OUTER JOIN [dbo].[PersonOfInterest] S with(nolock) ON S.[Id] = CF.[IdPersonOfInterest]
					WHERE	
					((@DateFromLocal IS NULL) OR (@DateToLocal IS NULL) OR (CF.[Date] >= @DateFromLocal AND CF.[Date] <= @DateToLocal)) AND
					((@FormIdsLocal IS NULL) OR (dbo.[CheckValueInList](F.[Id], @FormIdsLocal) = 1)) AND
					((@CategoryIdsLocal IS NULL) OR (dbo.[CheckValueInList](F.[IdFormCategory], @CategoryIdsLocal) = 1)) AND
			((@TypeIdsLocal IS NULL) OR (dbo.[CheckValueInList](F.[IdFormType], @TypeIdsLocal) = 1)) AND
					((@IdCompaniesLocal IS NULL) OR (dbo.[CheckValueInList](F.[IdCompany], @IdCompaniesLocal) = 1)) AND
					((@StockersIdsLocal IS NULL) OR (dbo.[CheckValueInList](CF.[IdPersonOfInterest], @StockersIdsLocal) = 1)) AND
					((@IdUserLocal IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(CF.[IdPersonOfInterest], @IdUserLocal) = 1)) AND
					((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUserLocal) = 1))
					AND ((@IdUser IS NULL) OR (dbo.CheckUserInFormCompanies(F.[IdCompany], @IdUser) = 1)) 
				)

		GROUP BY	P.[Id], P.[Name], P.[Identifier]
		ORDER BY CompletedFormsQuantity DESC
	END
	

END
