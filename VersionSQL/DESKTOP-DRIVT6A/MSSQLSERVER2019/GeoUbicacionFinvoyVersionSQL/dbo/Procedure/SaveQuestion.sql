/****** Object:  Procedure [dbo].[SaveQuestion]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 03/06/2015
-- Description:	SP para guardar una pregunta de formulario
-- =============================================
CREATE PROCEDURE [dbo].[SaveQuestion]
	
	 @Id [sys].[int] OUTPUT	
	,@Type [sys].[varchar](5)
	,@Required [sys].[bit]
	,@IdForm [sys].[int]
	,@Text [sys].[varchar](250)
	,@Hint [sys].[varchar](150) = NULL
	,@YesIsProblem [sys].[bit] = NULL
	,@NoIsProblem [sys].[bit] = NULL
	,@ImageArray [sys].[varbinary](MAX) = NULL
	,@Weight [sys].[int] = NULL
	,@IsNoWeighted [sys].[bit] = NULL
	,@DefaultAnswerText [sys].[varchar](5000) = NULL
	,@TagsIds IdTableType readonly
	,@Section [sys].[int] = NULL
	,@RedirectToSection [sys].[int] = NULL
	,@RedirectToSectionAlternative [sys].[int] = NULL
AS
BEGIN
	INSERT INTO [dbo].[Question]([Type], [Required], [IdForm], [Text], [Hint], [YesIsProblem], [NoIsProblem], 
						[ImageEncoded], [Weight], [IsNoWeighted], [DefaultAnswerText], [Section], [RedirectToSection], [RedirectToSectionAlternative])
	VALUES (@Type, @Required, @IdForm, @Text, @Hint, @YesIsProblem, @NoIsProblem, @ImageArray, @Weight, @IsNoWeighted, @DefaultAnswerText, @Section, @RedirectToSection, @RedirectToSectionAlternative)

	SELECT @Id = SCOPE_IDENTITY()
	
	INSERT INTO [dbo].[QuestionTag](IdQuestion, IdTag)
	SELECT @Id, t.Id
	FROM @TagsIds t
END
