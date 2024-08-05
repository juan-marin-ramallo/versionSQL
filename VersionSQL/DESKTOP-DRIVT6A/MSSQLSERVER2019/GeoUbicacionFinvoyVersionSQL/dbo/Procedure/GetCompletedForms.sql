/****** Object:  Procedure [dbo].[GetCompletedForms]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Diego Cáceres
-- Create date: 17/10/2014
-- Description:	SP para obtener los formularios completados
-- =============================================
CREATE PROCEDURE [dbo].[GetCompletedForms]
	
	 @DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
	,@FormIds [sys].[varchar](MAX) = NULL
	,@TagIds [sys].[varchar](MAX) = NULL
	,@PointOfInterestIds [sys].[varchar](MAX) = NULL
	,@StockersIds [sys].[varchar](MAX) = NULL
	,@IdUser [sys].[INT] = NULL
	,@CategoryIds [sys].[varchar](max) = NULL
	,@OutsidePointOfInterest [sys].[bit] = NULL
AS
BEGIN

	DECLARE @DateFromTruncated [sys].[datetime]
	DECLARE @DateToTruncated [sys].[datetime]
	DECLARE @FormIdsLocal [sys].[varchar](MAX)
	DECLARE @TagIdsLocal [sys].[varchar](MAX)
	DECLARE @PointOfInterestIdsLocal [sys].[varchar](MAX)
	DECLARE @StockersIdsLocal [sys].[varchar](MAX)
	DECLARE @IdUserLocal [sys].[INT]
	DECLARE @CategoryIdsLocal [sys].[varchar](max)

	SET @DateFromTruncated = @DateFrom
	SET @DateToTruncated = @DateTo
	SET @FormIdsLocal = @FormIds
	SET @TagIdsLocal = @TagIds
	SET @PointOfInterestIdsLocal = @PointOfInterestIds
	SET @StockersIdsLocal = @StockersIds
	SET @IdUserLocal = @IdUser
	SET @CategoryIdsLocal = @CategoryIds

	SELECT		F.[Id], F.[Name], F.[IsWeighted], U.[Id] AS IdUser, U.[Name] AS UserName, U.[LastName] AS UserLastName, 
				F.[Date], F.[Deleted], F.[DeletedDate], COUNT(1) AS CompletedForms, F.[IdFormCategory], FC.[Name] AS FormCategoryName,
				COUNT(DISTINCT(P.[Id])) AS CompletedPointsCount
	
	FROM		[dbo].[Form] F
				INNER JOIN [dbo].[User] U ON F.[IdUser] = U.[Id]
				INNER JOIN [dbo].[CompletedForm] CF ON F.[Id] = CF.[IdForm]
				LEFT OUTER JOIN [dbo].[PointOfInterest] P ON P.[Id] = CF.[IdPointOfInterest]
				INNER JOIN [dbo].[PersonOfInterest] S ON S.[Id] = CF.[IdPersonOfInterest]
				LEFT JOIN [dbo].[FormCategory] FC ON FC.[Id] = F.[IdFormCategory]
				left outer join [dbo].[Answer] A ON CF.Id = A.IdCompletedForm AND a.QuestionType = 'TAG'
				left outer join [dbo].[AnswerTag] ATA ON A.Id = ATA.IdAnswer
	
	WHERE		(CF.[Date] >= @DateFromTruncated AND CF.[Date] <= @DateToTruncated) AND 
				((@FormIdsLocal IS NULL) OR (dbo.[CheckValueInList](F.[Id], @FormIdsLocal) = 1)) AND
				((@CategoryIdsLocal IS NULL) OR (dbo.[CheckValueInList](F.[IdFormCategory], @CategoryIdsLocal) = 1)) AND
				((@PointOfInterestIdsLocal IS NULL) OR (dbo.[CheckValueInList](CF.[IdPointOfInterest], @PointOfInterestIdsLocal) = 1)) AND
				((@OutsidePointOfInterest IS NULL) OR (@OutsidePointOfInterest = 1 AND F.[NonPointOfInterest] = 1)) AND
				((@StockersIdsLocal IS NULL) OR (dbo.[CheckValueInList](CF.[IdPersonOfInterest], @StockersIdsLocal) = 1)) AND
				((@TagIdsLocal IS NULL) OR ((@TagIdsLocal = '-1' AND ATA.IdAnswer is null) OR (@TagIdsLocal <> '-1' AND dbo.[CheckValueInList](ATA.[IdTag], @TagIdsLocal) = 1))) AND
				((@IdUserLocal IS NULL) OR (dbo.CheckUserInPointOfInterestZones(CF.[IdPointOfInterest], @IdUserLocal) = 1)) AND
				((@IdUserLocal IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUserLocal) = 1)) AND
                ((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUserLocal) = 1)) AND
				((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUserLocal) = 1))
				AND ((@IdUserLocal IS NULL) OR (dbo.CheckUserInFormCompanies(F.[IdCompany], @IdUserLocal) = 1)) 
	GROUP BY	F.[Id], F.[Name], F.[IsWeighted], U.[Id], U.[Name], U.[LastName], F.[Date], F.[Deleted], F.[DeletedDate], 
				F.[IdFormCategory], FC.[Name]
	
	ORDER BY	F.[Date] desc
END
