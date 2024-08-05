/****** Object:  Procedure [dbo].[GetCompletedFormsByIdApi]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetCompletedFormsByIdApi]
	 @IdForm [sys].[int]
	,@DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
	,@PointOfInterestIds [sys].[varchar](MAX) = NULL
	,@StockersIds [sys].[varchar](MAX) = NULL
	,@OutsidePointOfInterest [sys].[bit] = NULL
	,@QuestionsIds [sys].[varchar] (MAX) = NULL
	,@IdUser [sys].[INT] = NULL
AS
BEGIN
	SELECT		Min(CF.[Id]) AS Id, CF.[Date], CF.[StartDate], ISNULL(P.[Latitude], CF.[Latitude]) AS [Latitude], ISNULL(P.[Longitude], 
				CF.[Longitude]) AS [Longitude], P.[Id] AS PointOfInterestId, P.[Identifier] AS PointOfInterestIdentifier, ISNULL(P.[Name], '') AS PointOfInterestName, ISNULL(P.[Address], '') AS PointOfInterestAddress, S.[Name] AS PersonOfInterestName, S.[LastName] AS PersonOfInterestLastName
				, Q.[Id] AS QuestionID, Q.[Text] AS QuestionText, Q.[Type] AS QuestionType, A.[Id] AS AnswerId,
				Q.[Weight] AS [QuestionWeight], Q.[IsNoWeighted] AS [QuestionIsNoWeighted],
				A.[FreeText] AS AnswerFreeText, A.[Check] AS AnswerCheck, A.[YNOption] AS AnswerYesNoOption,
				A.[ImageName] AS AnswerImageName, A.[DateReply], A.[Skipped],
				QO.[Text] AS AnswerOptionText, PRO.[Name] AS ProductName, PRO.[Identifier] AS ProductIdentifier,
				QO.[Id] AS AnswerOptionId, QO.[Weight] AS [AnswerOptionWeight],
				FM.[IsWeighted] AS IsWeightedForm
	
	FROM		[dbo].[CompletedForm] CF WITH(NOLOCK)
				LEFT OUTER JOIN [dbo].[PointOfInterest] P WITH(NOLOCK) ON CF.[IdPointOfInterest]= P.[Id]
				INNER JOIN [dbo].[PersonOfInterest] S WITH(NOLOCK) ON CF.[IdPersonOfInterest] = S.[Id]
				LEFT OUTER JOIN [dbo].[Question] Q WITH(NOLOCK) ON CF.[IdForm] = Q.[IdForm]
				LEFT OUTER JOIN [dbo].[Answer] A WITH(NOLOCK) ON CF.[Id] = A.[IdCompletedForm] AND A.[IdQuestion] = Q.[Id] 
				LEFT OUTER JOIN [dbo].[QuestionOption] QO WITH(NOLOCK) ON A.[IdQuestionOption] = QO.[Id]
				LEFT OUTER JOIN [dbo].[Product] PRO WITH(NOLOCK) ON Q.[Type] = 'CODE' AND A.[FreeText] = PRO.[BarCode] AND PRO.[Deleted] = 0		
				LEFT OUTER JOIN [dbo].[Form] FM WITH(NOLOCK) ON FM.[Id] = @IdForm
	
	WHERE		CF.[IdForm] = @IdForm AND CF.[Date] BETWEEN @DateFrom AND @DateTo AND
				((@PointOfInterestIds IS NULL) OR (dbo.[CheckValueInList](CF.[IdPointOfInterest], @PointOfInterestIds) = 1)) AND
				(@OutsidePointOfInterest IS NULL OR (@OutsidePointOfInterest = 1 AND P.[Id] IS NULL)) AND
				((@StockersIds IS NULL) OR (dbo.[CheckValueInList](CF.[IdPersonOfInterest], @StockersIds) = 1)) AND
				((@QuestionsIds IS NULL) OR (dbo.[CheckValueInList](Q.[Id], @QuestionsIds) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(CF.[IdPointOfInterest], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
                ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))
	
	GROUP BY	CF.[Id], CF.[Date], CF.[StartDate], ISNULL(P.[Latitude], CF.[Latitude]), ISNULL(P.[Longitude], CF.[Longitude]), P.[Id], P.[Identifier], ISNULL(P.[Name], ''), ISNULL(P.[Address], ''), S.[Name], S.[LastName], 
				Q.[Id], Q.[Text], Q.[Type], A.[Id], A.[FreeText], A.[Check], A.[YNOption], A.[ImageName], Q.[Weight], Q.[IsNoWeighted],
				A.[ImageEncoded], A.[DateReply], A.[Skipped], QO.[Id], QO.[Text], PRO.[Name], PRO.[Identifier], QO.[Weight], FM.[IsWeighted]
	
	ORDER BY	S.[Name], S.[LastName], CF.[Date] asc, CF.[Id] asc, Q.[Id]
END
