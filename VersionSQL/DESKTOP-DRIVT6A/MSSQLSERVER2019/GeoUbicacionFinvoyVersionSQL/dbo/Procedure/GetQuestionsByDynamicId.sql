/****** Object:  Procedure [dbo].[GetQuestionsByDynamicId]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  Cristian Barbarini  
-- Create date: 11/11/2023  
-- Description: SP para obtener las preguntas de un formulario  
-- =============================================  
CREATE PROCEDURE [dbo].[GetQuestionsByDynamicId]  
  @IdDynamic [sys].[int]  
AS  
BEGIN  
 SELECT  Q.[Id], F.[Id] AS FormId, F.[Name] AS FormName, F.[IsWeighted] AS [FormIsWeighted],  
    Q.[Required], Q.[Text], Q.[Type] AS QuestionTypeCode, QT.[Description] AS QuestionTypeDescription,   
    Q.[Hint], Q.[YesIsProblem], Q.[NoIsProblem], Q.[Weight], Q.[IsNoWeighted], QO.[Id] AS [QuestionOptionId], QO.[Text] AS [QuestionOptionText], QO.[Weight] AS [QuestionOptionWeight]  
   
 FROM  [dbo].[Question] Q WITH (NOLOCK)  
    INNER JOIN [dbo].[Form] F WITH (NOLOCK) ON F.[Id] = Q.[IdForm]  
    INNER JOIN [dbo].[QuestionTypeTranslated] QT WITH (NOLOCK) ON Q.[Type] = QT.[Code]  
    INNER JOIN [dbo].[FormPlus] FP WITH (NOLOCK) ON F.[Id] = FP.[IdForm]  
    INNER JOIN [dbo].[Dynamic] D WITH (NOLOCK) ON FP.[Id] = D.[IdFormPlus]
    LEFT OUTER JOIN [dbo].[QuestionOption] QO WITH (NOLOCK) ON QO.IdQuestion = Q.[Id]  
 WHERE  D.[Id] = @IdDynamic     
 GROUP BY Q.[Id], F.[Id], F.[Name], F.[IsWeighted], Q.[Required], Q.[Text], Q.[Type],  
    QT.[Description], Q.[Hint], Q.[YesIsProblem], Q.[NoIsProblem], Q.[Weight], Q.[IsNoWeighted], QO.[Id], QO.[Text], QO.[Weight]  
 ORDER BY Q.[Id]  
END
