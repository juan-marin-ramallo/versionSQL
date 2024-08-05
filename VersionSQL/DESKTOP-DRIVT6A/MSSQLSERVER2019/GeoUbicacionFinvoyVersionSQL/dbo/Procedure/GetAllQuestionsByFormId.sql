/****** Object:  Procedure [dbo].[GetAllQuestionsByFormId]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Diego Cáceres
-- Create date: 22-09-2014
-- Description:	SP para obtener las preguntas de un formulario
-- =============================================
CREATE PROCEDURE [dbo].[GetAllQuestionsByFormId]
	 @IdForm [sys].[int]
AS
BEGIN
	SELECT		Q.[Id], F.[Id] AS FormId, F.[Name] AS FormName, F.[IsWeighted] AS [FormIsWeighted],
				Q.[Required], Q.[Text], Q.[Type] AS QuestionTypeCode, QT.[Description] AS QuestionTypeDescription, 
				Q.[Hint], Q.[YesIsProblem], Q.[NoIsProblem], Q.[Weight], Q.[IsNoWeighted], QO.[Id] AS [QuestionOptionId], QO.[Text] AS [QuestionOptionText], QO.[Weight] AS [QuestionOptionWeight]
	
	FROM		[dbo].[Question] Q WITH (NOLOCK)
				INNER JOIN [dbo].[Form] F WITH (NOLOCK) ON F.[Id] = Q.[IdForm]
				INNER JOIN [dbo].[QuestionTypeTranslated] QT WITH (NOLOCK) ON Q.[Type] = QT.[Code]
				LEFT OUTER JOIN [dbo].[QuestionOption] QO WITH (NOLOCK) ON QO.IdQuestion = Q.[Id]
	WHERE		F.[Id] = @IdForm 		
	GROUP BY	Q.[Id], F.[Id], F.[Name], F.[IsWeighted], Q.[Required], Q.[Text], Q.[Type],
				QT.[Description], Q.[Hint], Q.[YesIsProblem], Q.[NoIsProblem], Q.[Weight], Q.[IsNoWeighted], QO.[Id], QO.[Text], QO.[Weight]
	ORDER BY	Q.[Id]
END
