/****** Object:  Procedure [dbo].[GetLastCompletedGenericForm]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 03/06/2015
-- Description:	SP paa obtener los datos de un formulario generico completo
-- =============================================
CREATE PROCEDURE [dbo].[GetLastCompletedGenericForm]
	@IdForm [sys].[int],
	@IdPersonOfInterest [sys].[int]
AS
BEGIN
	SELECT		CF.[Id], CF.[Date], S.[Name] AS PersonOfInterestName, S.[LastName] AS PersonOfInterestLastName
				, Q.[Id] AS QuestionID, Q.[Text] AS QuestionText, Q.[Type] AS QuestionType, A.[Id] AS AnswerId, 
				A.[FreeText] AS AnswerFreeText, A.[Check] AS AnswerCheck, A.[YNOption] AS AnswerYesNoOption, A.[ImageName] AS AnswerImageName, 
				A.[ImageEncoded] AS AnswerImageArray, A.[DateReply], A.[Skipped], A.[DoesNotApply], A.[ImageUrl], 
				QO.[Text] AS AnswerOptionText, PRO.[Name] AS ProductName, PRO.[Identifier] AS ProductIdentifier,
				AT.[IdTag], T.[Name] AS TagName
	FROM		[dbo].[CompletedForm] CF
				INNER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON CF.[IdPersonOfInterest] = S.[Id]
				LEFT OUTER JOIN [dbo].[Question] Q WITH (NOLOCK) ON CF.[IdForm] = Q.[IdForm]
				LEFT OUTER JOIN [dbo].[Answer] A WITH (NOLOCK) ON CF.[Id] = A.[IdCompletedForm] AND A.[IdQuestion] = Q.[Id] 
				LEFT OUTER JOIN [dbo].[QuestionOption] QO WITH (NOLOCK) ON A.[IdQuestionOption] = QO.[Id]
				LEFT OUTER JOIN [dbo].[AnswerTag] AT WITH (NOLOCK) ON AT.[IdAnswer] = A.[Id] AND A.[QuestionType] = 'TAG'
				LEFT OUTER JOIN [dbo].[Tag] T ON T.[Id] = AT.[IdTag]
				LEFT OUTER JOIN [dbo].[Product] PRO WITH (NOLOCK) ON Q.[Type] = 'CODE' AND A.[FreeText] = PRO.[BarCode] 			
	WHERE		CF.[IdForm] = @IdForm 
				AND CF.IdPersonOfInterest = @IdPersonOfInterest
				AND CF.[Id] = (SELECT TOP 1 CF1.Id 
								FROM [dbo].[CompletedForm] CF1 
								WHERE CF1.[IdForm] = @IdForm AND CF1.IdPersonOfInterest = @IdPersonOfInterest
								ORDER BY CF1.[Date] desc)
	GROUP BY	CF.[Id], CF.[Date], S.[Name], S.[LastName], 
				Q.[Id], Q.[Text], Q.[Type], A.[Id], A.[FreeText], A.[Check], A.[YNOption], A.[ImageName], 
				A.[ImageEncoded], A.[DateReply], A.[Skipped], A.[DoesNotApply], A.[ImageUrl], QO.[Text], PRO.[Name], PRO.[Identifier],
				AT.[IdTag], T.[Name]
	ORDER BY	Q.[Id]
END
