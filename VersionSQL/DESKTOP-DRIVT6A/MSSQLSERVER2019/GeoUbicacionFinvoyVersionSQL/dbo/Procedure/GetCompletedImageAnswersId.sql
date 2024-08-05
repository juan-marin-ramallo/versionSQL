/****** Object:  Procedure [dbo].[GetCompletedImageAnswersId]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 23/04/2018
-- Description:	SP paa obtener los ids de las respuestas con foto.
-- =============================================
CREATE PROCEDURE [dbo].[GetCompletedImageAnswersId]
	@IdForm [sys].[int],
	@DateFrom [sys].[datetime],
	@DateTo [sys].[datetime],
	@PointOfInterestIds [sys].[varchar](MAX) = NULL,
	@StockersIds [sys].[varchar](MAX) = NULL,
	@TagIds [sys].[varchar](MAX) = NULL,
	@OutsidePointOfInterest [sys].[bit] = NULL,
	@IdUser [sys].[INT] = NULL
AS
BEGIN

	DECLARE @IdFormLocal [sys].[int] = @IdForm
	DECLARE @DateFromLocal [sys].[datetime] = @DateFrom
	DECLARE @DateToLocal [sys].[datetime] = @DateTo
	DECLARE @PointOfInterestIdsLocal [sys].[varchar](MAX) = @PointOfInterestIds
	DECLARE @StockersIdsLocal [sys].[varchar](MAX) = @StockersIds
	DECLARE @TagIdsLocal [sys].[varchar](MAX) = @TagIds
	DECLARE @OutsidePointOfInterestLocal [sys].[bit] = @OutsidePointOfInterest
	DECLARE @IdUserLocal [sys].[INT] = @IdUser


	SELECT		A.[Id] AS AnswerId
	
	FROM		[dbo].[CompletedForm] CF WITH (NOLOCK)
				left outer JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON CF.[IdPointOfInterest]= P.[Id]
				INNER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON CF.[IdPersonOfInterest] = S.[Id]
				LEFT OUTER JOIN [dbo].[Answer] ATF ON CF.Id = ATF.IdCompletedForm AND ATF.QuestionType = 'TAG'
				LEFT OUTER JOIN [dbo].[AnswerTag] ATAF ON ATF.Id = ATAF.IdAnswer
				INNER JOIN [dbo].[Question] Q WITH (NOLOCK) ON CF.[IdForm] = Q.[IdForm] AND Q.[Type] = 'CAM'
				INNER JOIN [dbo].[Answer] A WITH (NOLOCK) ON CF.[Id] = A.[IdCompletedForm] AND A.[IdQuestion] = Q.[Id] 
															AND (A.[ImageEncoded] IS NOT NULL OR A.[ImageUrl] IS NOT NULL)
				LEFT  JOIN [dbo].[Form] FM WITH (NOLOCK) ON FM.[Id] = CF.[IdForm]	
	
	WHERE		CF.[IdForm] = @IdFormLocal AND CF.[Date] BETWEEN @DateFromLocal AND @DateToLocal AND
				((@PointOfInterestIdsLocal IS NULL) OR (dbo.[CheckValueInList](CF.[IdPointOfInterest], @PointOfInterestIdsLocal) = 1)) AND
				(@OutsidePointOfInterestLocal IS NULL OR (@OutsidePointOfInterestLocal = 1 AND FM.[NonPointOfInterest] = 1)) AND
				((@StockersIdsLocal IS NULL) OR (dbo.[CheckValueInList](CF.[IdPersonOfInterest], @StockersIdsLocal) = 1)) AND
				((@TagIdsLocal IS NULL) OR ((@TagIdsLocal = '-1' AND ATAF.IdAnswer is null) OR (@TagIdsLocal <> '-1' AND ATAF.IdTag IS NOT NULL AND dbo.[CheckValueInList](ATAF.[IdTag], @TagIdsLocal) = 1))) AND
				((@IdUserLocal IS NULL) OR (dbo.CheckUserInPointOfInterestZones(CF.[IdPointOfInterest], @IdUserLocal) = 1)) AND
				((@IdUserLocal IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUserLocal) = 1)) AND
                ((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUserLocal) = 1)) AND
				((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUserLocal) = 1))

	
	GROUP BY	A.[Id]
	
	ORDER BY	A.[Id]
END
