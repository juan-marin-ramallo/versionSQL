/****** Object:  Procedure [dbo].[GetFormGeneralQuestions]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 02/06/2015
-- Description:	SP para obtener las preguntas de un formulario
-- =============================================
CREATE PROCEDURE [dbo].[GetFormGeneralQuestions]
	@IdForm [sys].[int]
AS
BEGIN
	DECLARE @IdFormLocal [sys].[int]
	SET @IdFormLocal = @IdForm

	SELECT		Q.[Id], F.[Id] AS FormId, F.[Name] AS FormName,F.[IsWeighted] AS [FormIsWeighted], Q.[Required], 
				Q.[Text], Q.[Type] AS QuestionTypeCode, QTT.[Description] AS QuestionTypeDescription, Q.[Hint],
				Q.[YesIsProblem], Q.[NoIsProblem], Q.[ImageEncoded] AS FileEncoded, Q.[Weight], Q.[IsNoWeighted],
				Q.[DefaultAnswerText], Q.[Section], Q.[RedirectToSection], Q.[RedirectToSectionAlternative],
				QO.[Id] AS [QuestionOptionId], QO.[Text] AS [QuestionOptionText], 
				QO.[Default] AS [QuestionOptionDefault], QO.[IsNotApply] AS QuestionOptionISNotApply,
				QO.[Weight] AS [QuestionOptionWeight], QO.[RedirectToSection] AS [QuestionOptionRedirectToSection],
				QT.[IdTag]
	
	FROM		[dbo].[Question] Q WITH (NOLOCK)
				INNER JOIN [dbo].[Form] F  WITH (NOLOCK) ON F.[Id] = Q.[IdForm] AND F.[Id] = @IdFormLocal
				INNER JOIN [dbo].[QuestionTypeTranslated] QTT  WITH (NOLOCK) ON Q.[Type] = QTT.[Code]
				LEFT OUTER JOIN [dbo].[QuestionOption] QO  WITH (NOLOCK) ON Q.[Id] = QO.[IdQuestion]
				LEFT OUTER JOIN [dbo].[QuestionTag] QT ON QT.[IdQuestion] = Q.[Id]
				LEFT OUTER JOIN [dbo].[Tag] T ON QT.[IdTag] = T.[Id]

	WHERE T.Id Is NULL OR T.Deleted = 0

	GROUP BY	Q.[Id], F.[Id], F.[Name], F.[IsWeighted], Q.[Required], Q.[Text], Q.[Type],
				QTT.[Description], Q.[Hint], Q.[YesIsProblem], Q.[NoIsProblem], Q.[Weight], 
				Q.[IsNoWeighted], Q.[ImageEncoded], Q.[DefaultAnswerText],
				Q.[Section], Q.[RedirectToSection], Q.[RedirectToSectionAlternative],
				QO.[Id], QO.[Text], QO.[Default], QO.[IsNotApply], QO.[Weight], QO.[RedirectToSection],
				QT.[IdTag]
	ORDER BY	Q.[Id]
END
