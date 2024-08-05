/****** Object:  Procedure [dbo].[GetFormQuestionById]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 02/06/2015
-- Description:	SP para obtener UNA PREGUNTA POR SU ID
-- =============================================
CREATE PROCEDURE [dbo].[GetFormQuestionById]
	@IdQuestion [sys].[int]
AS
BEGIN
	SELECT		Q.[Id], Q.[Required], Q.[Text], Q.[Type] AS QuestionTypeCode, 
				QT.[Description] AS QuestionTypeDescription, Q.[Hint], Q.[YesIsProblem], Q.[NoIsProblem], 
				Q.[ImageEncoded] AS FileEncoded
	FROM		[dbo].[Question] Q WITH (NOLOCK)
				INNER JOIN [dbo].[QuestionTypeTranslated] QT WITH (NOLOCK) ON Q.[Type] = QT.[Code]			
	WHERE		Q.[Id] = @IdQuestion		
	GROUP BY	Q.[Id], Q.[Required], Q.[Text], Q.[Type] , 
				QT.[Description], Q.[Hint], Q.[YesIsProblem], Q.[NoIsProblem],Q.[ImageEncoded] 
END
