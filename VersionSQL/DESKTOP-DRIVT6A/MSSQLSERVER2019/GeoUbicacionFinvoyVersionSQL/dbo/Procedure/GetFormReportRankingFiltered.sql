/****** Object:  Procedure [dbo].[GetFormReportRankingFiltered]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gaston Legnani
-- Create date: 06/05/2016
-- Description:	SP para obtener el ranking de personas CON SUS TAREAS COMPLETADAS
-- =============================================
CREATE PROCEDURE [dbo].[GetFormReportRankingFiltered]

	 @DateFrom [sys].[datetime] = NULL
	,@DateTo [sys].[datetime] = NULL
	,@FormIds [sys].[varchar](MAX) = NULL
	,@PointOfInterestIds [sys].[varchar](MAX) = NULL
	,@StockersIds [sys].[varchar](MAX) = NULL
	,@CategoryIds [sys].[varchar](MAX) = NULL
	,@TypeIds [sys].[varchar](max) = NULL
	,@TagIds [sys].[varchar](MAX) = NULL
	,@IdUser [sys].[INT] = NULL
	,@OutsidePointOfInterest [sys].[bit] = NULL
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
	SET @OutsidePointOfInterestLocal = @OutsidePointOfInterest
	SET @IdCompaniesLocal = @IdCompanies

	CREATE TABLE #TempResultPersonOfInterest
    ( 
		PersonOfInterestId INT,
		PersonOfInterestName VARCHAR(50),
		PersonOfInterestLastName VARCHAR(50),
    );

	IF @FormIdsLocal IS NOT NULL
	BEGIN

		INSERT INTO #TempResultPersonOfInterest(PersonOfInterestId, PersonOfInterestName, PersonOfInterestLastName)
		SELECT  S.[Id] AS PersonOfInterestId, S.[Name] AS PersonOfInterestName, S.[LastName] AS PersonOfInterestLastName
		FROM    [dbo].[PersonOfInterest] S with(nolock) 
				INNER JOIN [dbo].[AssignedForm] AF  with(nolock) ON AF.[IdPersonOfInterest] = S.[Id] AND AF.[Deleted] = 0
				--AND ((@FormIdsLocal IS NULL) OR (dbo.[CheckValueInList](AF.[IdForm], @FormIdsLocal) = 1))
				--INNER JOIN [DBO].Form F with(nolock) ON F.[Id] = AF.[IdForm] 
				--AND Charindex(','+cast(F.Id as varchar(8000))+',', @FormIdsLocal) > 0
				--AND AF.IdForm = 6244
				 --AND (AF.[IdForm] IN (@FormIdsLocal))
				AND @FormIdsLocal LIKE '%,'+CAST(AF.[IdForm] AS varchar)+',%'

		WHERE  ((@StockersIdsLocal IS NULL) OR (dbo.[CheckValueInList](S.[Id], @StockersIdsLocal) = 1)) AND		
				((@IdUserLocal IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUserLocal) = 1)) AND
				((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUserLocal) = 1))
				--AND S.Deleted = 0 
		group by S.[Id], S.[Name], S.[LastName]

	END

	ELSE
	BEGIN


		INSERT INTO #TempResultPersonOfInterest(PersonOfInterestId, PersonOfInterestName, PersonOfInterestLastName)
		SELECT  S.[Id] AS PersonOfInterestId, S.[Name] AS PersonOfInterestName, S.[LastName] AS PersonOfInterestLastName

		FROM    [dbo].[PersonOfInterest] S with(nolock) 

		WHERE  ((@StockersIdsLocal IS NULL) OR (dbo.[CheckValueInList](S.[Id], @StockersIdsLocal) = 1)) AND		
				((@IdUserLocal IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUserLocal) = 1)) AND
				((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUserLocal) = 1))
				--AND S.Deleted = 0 
		group by S.[Id], S.[Name], S.[LastName]

	END

	select t.PersonOfInterestId, t.PersonOfInterestName, t.PersonOfInterestLastName, 
	IIF(a.CompletedFormsQuantity IS NOT NULL,a.CompletedFormsQuantity, 0) AS CompletedFormsQuantity
	from #TempResultPersonOfInterest T
	left join (

	SELECT  S.[Id] AS PersonOfInterestId, 
			COUNT(DISTINCT CF.Id) CompletedFormsQuantity 

	FROM    [dbo].[PersonOfInterest] S with(nolock)
			INNER JOIN [dbo].[CompletedForm] CF with(nolock) ON CF.[IdPersonOfInterest] = S.[Id]
			INNER JOIN [dbo].[Form] F with(nolock) ON F.[Id] = CF.[IdForm]
			LEFT OUTER JOIN [dbo].[PointOfInterest] P with(nolock) ON P.[Id] = CF.[IdPointOfInterest]
			left outer join [dbo].[Answer] A ON CF.Id = A.IdCompletedForm AND a.QuestionType = 'TAG'
			left outer join [dbo].[AnswerTag] ATA ON A.Id = ATA.IdAnswer
	WHERE	
	((@DateFromLocal IS NULL) OR (@DateToLocal IS NULL) OR (CF.[Date] >= @DateFromLocal AND CF.[Date] <= @DateToLocal)) AND
	((@FormIdsLocal IS NULL) OR (dbo.[CheckValueInList](F.[Id], @FormIdsLocal) = 1)) AND
	((@CategoryIdsLocal IS NULL) OR (dbo.[CheckValueInList](F.[IdFormCategory], @CategoryIdsLocal) = 1)) AND
	((@TypeIdsLocal IS NULL) OR (dbo.[CheckValueInList](F.[IdFormType], @TypeIdsLocal) = 1)) AND
	((@PointOfInterestIdsLocal IS NULL) OR (dbo.[CheckValueInList](CF.[IdPointOfInterest], @PointOfInterestIdsLocal) = 1)) AND
	(@OutsidePointOfInterestLocal IS NULL OR (@OutsidePointOfInterestLocal = 1 AND P.[Id] IS NULL)) AND
	((@IdCompaniesLocal IS NULL) OR (dbo.[CheckValueInList](F.[IdCompany], @IdCompaniesLocal) = 1)) AND
	((@StockersIdsLocal IS NULL) OR (dbo.[CheckValueInList](S.[Id], @StockersIdsLocal) = 1)) AND
	((@TagIdsLocal IS NULL) OR ((@TagIdsLocal = '-1' AND ATA.IdAnswer is null) OR (@TagIdsLocal <> '-1' AND ATA.IdTag IS NOT NULL AND dbo.[CheckValueInList](ATA.[IdTag], @TagIdsLocal) = 1))) AND
	((@IdUserLocal IS NULL) OR (dbo.CheckUserInPointOfInterestZones(CF.[IdPointOfInterest], @IdUserLocal) = 1)) AND
	((@IdUserLocal IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUserLocal) = 1)) AND
    ((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUserLocal) = 1)) AND
	((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(CF.[IdPointOfInterest], @IdUserLocal) = 1))
	AND ((@IdUser IS NULL) OR (dbo.CheckUserInFormCompanies(F.[IdCompany], @IdUser) = 1)) 

	--AND S.Deleted = 0 AND P.Deleted = 0
	GROUP BY	S.[Id], S.[Name], S.[LastName]
	) a on a.PersonOfInterestId = T.PersonOfInterestId
	ORDER BY CompletedFormsQuantity DESC
	--DROP TABLE temp;
	DROP TABLE #TempResultPersonOfInterest;


	-- OLD)
	--SELECT  S.[Id] AS PersonOfInterestId, S.[Name] AS PersonOfInterestName, S.[LastName] AS PersonOfInterestLastName, 
	--		COUNT(CF.IdForm) CompletedFormsQuantity 
	--FROM    [dbo].[PersonOfInterest] S WITH(NOLOCK)
	--		INNER JOIN [dbo].[CompletedForm] CF WITH(NOLOCK) ON CF.[IdPersonOfInterest] = S.[Id]
	--		INNER JOIN [dbo].[Form] F WITH(NOLOCK) ON F.[Id] = CF.[IdForm]
	--		LEFT OUTER JOIN [dbo].[PointOfInterest] P WITH(NOLOCK) ON P.[Id] = CF.[IdPointOfInterest]
	--WHERE	
	--((@DateFromLocal IS NULL) OR (@DateToLocal IS NULL) OR (CF.[Date] >= @DateFromLocal AND CF.[Date] <= @DateToLocal)) AND
	--((@FormIdsLocal IS NULL) OR (dbo.[CheckValueInList](F.[Id], @FormIdsLocal) = 1)) AND
	--((@CategoryIdsLocal IS NULL) OR (dbo.[CheckValueInList](F.[IdFormCategory], @CategoryIdsLocal) = 1)) AND
	--((@PointOfInterestIdsLocal IS NULL) OR (dbo.[CheckValueInList](CF.[IdPointOfInterest], @PointOfInterestIdsLocal) = 1)) AND
	--(@OutsidePointOfInterestLocal IS NULL OR (@OutsidePointOfInterestLocal = 1 AND P.[Id] IS NULL)) AND
	--((@StockersIdsLocal IS NULL) OR (dbo.[CheckValueInList](S.[Id], @StockersIdsLocal) = 1)) AND
	--((@IdUserLocal IS NULL) OR (dbo.CheckUserInPointOfInterestZones(CF.[IdPointOfInterest], @IdUserLocal) = 1)) AND
	--((@IdUserLocal IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUserLocal) = 1)) AND
 --   ((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUserLocal) = 1)) AND
	--((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(CF.[IdPointOfInterest], @IdUserLocal) = 1))
	----AND S.Deleted = 0 AND P.Deleted = 0
	--GROUP BY	S.[Id], S.[Name], S.[LastName]
	
	--UNION

	--SELECT  S.[Id] AS PersonOfInterestId, S.[Name] AS PersonOfInterestName, S.[LastName] AS PersonOfInterestLastName, 
	--		0 AS CompletedFormsQuantity 

	--FROM    [dbo].[PersonOfInterest] S WITH(NOLOCK)
	--		INNER JOIN [dbo].[AssignedForm] AF WITH(NOLOCK) ON AF.[IdPersonOfInterest] = S.[Id]

	--WHERE  ((@StockersIdsLocal IS NULL) OR (dbo.[CheckValueInList](S.[Id], @StockersIdsLocal) = 1)) AND
	--		((@FormIdsLocal IS NULL) OR (dbo.[CheckValueInList](AF.[IdForm], @FormIdsLocal) = 1)) AND
	--		((@IdUserLocal IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUserLocal) = 1)) AND
	--		((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUserLocal) = 1))
	--		AND S.Deleted = 0 AND AF.[Deleted] = 0 AND S.[Id] NOT IN 
	--		(
	--			SELECT  S.[Id] 
	--			FROM    [dbo].[PersonOfInterest] S WITH(NOLOCK)
	--					INNER JOIN [dbo].[CompletedForm] CF WITH(NOLOCK) ON CF.[IdPersonOfInterest] = S.[Id]
	--					INNER JOIN [dbo].[Form] F WITH(NOLOCK) ON F.[Id] = CF.[IdForm]
	--					LEFT OUTER JOIN [dbo].[PointOfInterest] P WITH(NOLOCK) ON P.[Id] = CF.[IdPointOfInterest]
	--			WHERE	
	--			((@DateFromLocal IS NULL) OR (@DateToLocal IS NULL) OR (CF.[Date] >= @DateFromLocal AND CF.[Date] <= @DateToLocal)) AND
	--			((@FormIdsLocal IS NULL) OR (dbo.[CheckValueInList](F.[Id], @FormIdsLocal) = 1)) AND
	--			((@CategoryIdsLocal IS NULL) OR (dbo.[CheckValueInList](F.[IdFormCategory], @CategoryIdsLocal) = 1)) AND
	--			((@PointOfInterestIdsLocal IS NULL) OR (dbo.[CheckValueInList](CF.[IdPointOfInterest], @PointOfInterestIdsLocal) = 1)) AND
	--			(@OutsidePointOfInterestLocal IS NULL OR (@OutsidePointOfInterestLocal = 1 AND P.[Id] IS NULL)) AND
	--			((@IdUserLocal IS NULL) OR (dbo.CheckUserInPointOfInterestZones(CF.[IdPointOfInterest], @IdUserLocal) = 1)) AND
	--			((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(CF.[IdPointOfInterest], @IdUserLocal) = 1))
	--		)
	---- AND P.Deleted = 0
	--ORDER BY CompletedFormsQuantity DESC
    
	

END
