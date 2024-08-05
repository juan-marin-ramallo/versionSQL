/****** Object:  Procedure [dbo].[GetCompletedFormById]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 17/04/2018
-- Description:	SP paa obtener los datos de un formulario completo en particular
-- =============================================
CREATE PROCEDURE [dbo].[GetCompletedFormById]
	@IdCompletedForm [sys].[int],
	@ReturnImages [sys].[bit] = 0
AS
BEGIN

	DECLARE @IdCompletedFormLocal [sys].[int] = @IdCompletedForm
	DECLARE @ReturnImagesLocal [sys].[bit] = @ReturnImages

	SELECT	CF.[Id], CF.[IdProduct], Q.[Id] AS QuestionID, Q.[Text] AS QuestionText, Q.[Type] AS QuestionType, A.[Id] AS AnswerId,
			Q.[Weight] AS [QuestionWeight], Q.[IsNoWeighted] AS [QuestionIsNoWeighted],
			A.[FreeText] AS AnswerFreeText, A.[Check] AS AnswerCheck, A.[YNOption] AS AnswerYesNoOption, 
			A.[ImageName] AS AnswerImageName,
			(CASE @ReturnImagesLocal WHEN 1 THEN A.[ImageEncoded] ELSE NULL END) AS AnswerImageArray, 
			(CASE @ReturnImagesLocal WHEN 1 THEN A.[ImageUrl] ELSE NULL END) AS ImageUrl,
			A.[DateReply], A.[Skipped], A.[DoesNotApply], QO.[Text] AS AnswerOptionText,QO.[Id] AS AnswerOptionId, 
			QO.[Weight] AS [AnswerOptionWeight], QO.[IsNotApply] AS AnswerOptionIsNotApply, CF.[IdForm], CF.[Date],
			AT.[IdTag], T.[Name] AS TagName, CF.[IdPointOfInterest]
	
	FROM	[dbo].[CompletedForm] CF WITH (NOLOCK)
			LEFT OUTER JOIN [dbo].[Question] Q WITH (NOLOCK) ON CF.[IdForm] = Q.[IdForm]
			LEFT OUTER JOIN [dbo].[Answer] A WITH (NOLOCK) ON CF.[Id] = A.[IdCompletedForm] AND A.[IdQuestion] = Q.[Id] 
			LEFT OUTER JOIN [dbo].[QuestionOption] QO WITH (NOLOCK) ON A.[IdQuestionOption] = QO.[Id]
			LEFT OUTER JOIN [dbo].[AnswerTag] AT WITH (NOLOCK) ON AT.[IdAnswer] = A.[Id] AND A.[QuestionType] = 'TAG'
			LEFT OUTER JOIN [dbo].[Tag] T ON T.[Id] = AT.[IdTag]
	
	WHERE	CF.[Id] = @IdCompletedFormLocal
	
	GROUP BY	CF.[Id],
				CF.[IdProduct],
				Q.[Id], Q.[Text], Q.[Type], A.[Id], A.[FreeText], A.[Check], A.[YNOption], 
				A.[ImageName], Q.[Weight], Q.[IsNoWeighted],
				A.[DateReply], A.[Skipped], A.[DoesNotApply], QO.[Text], QO.[Weight],QO.[Id], QO.[IsNotApply],
				(CASE @ReturnImagesLocal WHEN 1 THEN A.[ImageEncoded] ELSE NULL END), 
				(CASE @ReturnImagesLocal WHEN 1 THEN A.[ImageUrl] ELSE NULL END), CF.[IdForm], CF.[Date],
				AT.[IdTag], T.[Name], CF.[IdPointOfInterest]
	
	ORDER BY	Q.[Id]
END
