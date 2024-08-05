/****** Object:  Procedure [dbo].[GetCompletedImageAnswers]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 11/07/2018
-- Description:	SP paa obtener las respuestas con foto.
-- =============================================
CREATE PROCEDURE [dbo].[GetCompletedImageAnswers]
	@IdForm [sys].[int]= NULL

AS
BEGIN

	DECLARE @IdFormLocal [sys].[int] = @IdForm


	SELECT		A.[Id] AS AnswerId, A.[ImageEncoded] AS ImageArray, A.[ImageName] as ImageName
	
	FROM		[dbo].[CompletedForm] CF WITH (NOLOCK)
				INNER JOIN [dbo].[Question] Q WITH (NOLOCK) ON CF.[IdForm] = Q.[IdForm] AND Q.[Type] = 'CAM'
				INNER JOIN [dbo].[Answer] A WITH (NOLOCK) ON CF.[Id] = A.[IdCompletedForm] AND A.[IdQuestion] = Q.[Id] 
															AND A.[ImageEncoded] IS NOT NULL
	
	WHERE		@IdFormLocal IS NULL OR CF.[IdForm] = @IdFormLocal 
					
END
