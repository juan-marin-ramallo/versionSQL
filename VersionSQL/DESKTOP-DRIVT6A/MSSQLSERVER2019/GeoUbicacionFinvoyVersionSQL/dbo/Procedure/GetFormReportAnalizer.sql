/****** Object:  Procedure [dbo].[GetFormReportAnalizer]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		FS
-- Create date: 13/03/17
-- Description:	SP que obtiene la info necesaria para el reporte de formularios de modulo de BI
-- =============================================
CREATE PROCEDURE [dbo].[GetFormReportAnalizer]
	 @IdForm [sys].[int] 
	,@DateFrom [sys].[datetime] 
	,@DateTo [sys].[datetime] 
	,@PersonsOfInterestIds [sys].[varchar](MAX) = null
	,@PointsOfInterestIds [sys].[varchar](MAX) = null
	,@IdUser [sys].[int] = NULL
AS
BEGIN

	-- Get all data from the form
	SELECT	F.[Id], F.[Name], F.[Deleted], F.[DeletedDate], F.[StartDate], F.[EndDate], F.[IdFormCategory], F.[Description], F.[OneTimeAnswer], F.[IsWeighted]
			, Q.[Id] AS QuestionId, Q.[Required], Q.[Text], Q.[Type], Q.[Hint], Q.[YesIsProblem], Q.[NoIsProblem], Q.[ImageEncoded], Q.[Weight], Q.[IsNoWeighted]
			, QO.[Id] AS QuestionOptionId, QO.[Text] AS QuestionOptionText, QO.[Default] as QuestionOptionDefault, QO.[Weight] as QuestionOptionWeight
	FROM	[dbo].[Form] F WITH (NOLOCK)
			INNER JOIN [dbo].[Question] Q WITH (NOLOCK) ON F.Id = Q.IdForm
			LEFT  JOIN [dbo].[QuestionOption] QO WITH (NOLOCK) ON Q.Id = QO.IdQuestion
	WHERE	F.Id = @IdForm
	ORDER BY F.Id, Q.Id ASC, QO.Id ASC

	-- Get Completed form data
	SELECT	CF.[Id], CF.[Date], ISNULL(P.[Latitude], CF.[Latitude]) AS [Latitude], ISNULL(P.[Longitude], CF.[Longitude]) AS [Longitude], P.[Identifier] AS PointOfInterestIdentifier, ISNULL(P.[Name], '') AS PointOfInterestName, ISNULL(P.[Id], 0) AS PointOfInterestId
			, S.[Name] AS PersonOfInterestName, S.[LastName] AS PersonOfInterestLastName
			, Q.[Id] AS QuestionId, Q.[Text] AS QuestionText, Q.[Type] AS QuestionType, Q.[Weight] AS [QuestionWeight], Q.[IsNoWeighted] AS [QuestionIsNoWeighted]
			, A.[Id] AS AnswerId, A.[FreeText] AS AnswerFreeText, A.[Check] AS AnswerCheck, A.[YNOption] AS AnswerYesNoOption, A.[ImageName] AS AnswerImageName, A.[ImageEncoded] AS AnswerImageArray, Tzdb.ToUtc(CAST(Tzdb.FromUtc(A.[DateReply]) AS [sys].[date])) AS AnswerDateReply, A.[Skipped] AS AnswerSkipped
			, A.[IdQuestionOption] as AnswerOptionId, QO.[Text] AS AnswerOptionText, PRO.[Name] AS ProductName, PRO.[Identifier] AS ProductIdentifier, QO.[Weight] AS [AnswerOptionWeight]
	FROM	[dbo].[CompletedForm] CF WITH (NOLOCK)
			LEFT JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON CF.[IdPointOfInterest]= P.[Id]
			INNER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON CF.[IdPersonOfInterest] = S.[Id]
			LEFT JOIN [dbo].[Question] Q WITH (NOLOCK) ON CF.[IdForm] = Q.[IdForm]
			LEFT JOIN [dbo].[Answer] A WITH (NOLOCK) ON CF.[Id] = A.[IdCompletedForm] AND A.[IdQuestion] = Q.[Id] 
			LEFT JOIN [dbo].[QuestionOption] QO WITH (NOLOCK) ON A.[IdQuestionOption] = QO.[Id]
			LEFT JOIN [dbo].[Product] PRO WITH (NOLOCK) ON Q.[Type] = 'CODE' AND A.[FreeText] = PRO.[BarCode] 			
	WHERE	CF.[IdForm] = @IdForm AND CF.[Date] BETWEEN @DateFrom AND @DateTo AND
				((@PointsOfInterestIds IS NULL) OR (dbo.[CheckValueInList](CF.[IdPointOfInterest], @PointsOfInterestIds) = 1)) AND
				--(@OutsidePointOfInterest IS NULL OR (@OutsidePointOfInterest = 1 AND P.[Id] IS NULL)) AND
				((@PersonsOfInterestIds IS NULL) OR (dbo.[CheckValueInList](CF.[IdPersonOfInterest], @PersonsOfInterestIds) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(CF.[IdPointOfInterest], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))
	GROUP BY	CF.[Id], CF.[Date], ISNULL(P.[Latitude], CF.[Latitude]), ISNULL(P.[Longitude], CF.[Longitude]), P.[Identifier], ISNULL(P.[Name], ''), ISNULL(P.[Id], 0), S.[Name], S.[LastName], 
				Q.[Id], Q.[Text], Q.[Type], A.[Id], A.[FreeText], A.[Check], A.[YNOption], A.[ImageName], Q.[Weight], Q.[IsNoWeighted],
				A.[ImageEncoded], A.[DateReply], A.[Skipped], A.[IdQuestionOption], QO.[Text], PRO.[Name], PRO.[Identifier], QO.[Weight]
	ORDER BY	S.[Name], S.[LastName], CF.[Date] ASC, CF.[Id] ASC, Q.[Id] ASC

END
