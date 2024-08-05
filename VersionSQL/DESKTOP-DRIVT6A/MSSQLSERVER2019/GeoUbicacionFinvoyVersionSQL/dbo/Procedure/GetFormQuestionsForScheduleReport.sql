/****** Object:  Procedure [dbo].[GetFormQuestionsForScheduleReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 15/07/2022
-- Description:	Devuelve las preguntas de una
--				tarea dada para la definición de
--				condiciones en el envío de reportes
-- =============================================
CREATE PROCEDURE [dbo].[GetFormQuestionsForScheduleReport]
	@IdForm [sys].[int]
AS
BEGIN
	SELECT		Q.[Id], Q.[Text], Q.[Type] AS QuestionTypeCode, QT.[Description] AS QuestionTypeDescription, 
				QO.[Id] AS [IdQuestionOption], QO.[Text] AS [QuestionOptionText]
	
	FROM		[dbo].[Question] Q WITH (NOLOCK)
				INNER JOIN [dbo].[QuestionTypeTranslated] QT WITH (NOLOCK) ON Q.[Type] = QT.[Code]
				LEFT OUTER JOIN [dbo].[QuestionOption] QO WITH (NOLOCK) ON QO.IdQuestion = Q.[Id]

	WHERE		Q.[IdForm] = @IdForm
				AND Q.[Type] IN ('FT', 'CODE', 'NUM', 'CK', 'YN', 'MO','PC') --'DATE', 
	
	GROUP BY	Q.[Id], Q.[Text], Q.[Type], QT.[Description],
				QO.[Id], QO.[Text]
	
	ORDER BY	Q.[Id]
END
