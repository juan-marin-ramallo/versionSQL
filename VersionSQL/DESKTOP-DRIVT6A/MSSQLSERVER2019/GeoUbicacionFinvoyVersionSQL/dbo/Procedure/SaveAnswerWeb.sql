/****** Object:  Procedure [dbo].[SaveAnswerWeb]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 11/04/2018
-- Description:	SP para guardar una respuesta de un formulario desde la web
-- =============================================
CREATE PROCEDURE [dbo].[SaveAnswerWeb]
	@IdQuestion [sys].[int] = 0,
	@IdCompletedForm [sys].[int] = 0,
	@FreeText [sys].[varchar] (5000) = '',
	@CheckOption [sys].[bit] = 0,
	@YesNoOption [sys].[bit] = 0,
	@ImageName [sys].[varchar] (100) = '',
	@ImageUrl [sys].[varchar] (5000) = NULL,
	@ImageArray [sys].[image]  = null,
	@DateReply [sys].[datetime] = null,
	@Skipped [sys].[bit] = 0,
	@DoesNotApply [sys].[bit] = 0,
	@IdQuestionOption [sys].[int] = null,
	@ChosenTags [dbo].[IdTableType] readonly,
	@ResultCode [sys].[smallint] OUT

AS
BEGIN
	DECLARE @Id [sys].[int]
	DECLARE @QuestionType [sys].[varchar] (5)

	SET @QuestionType = (SELECT	[Type] 
						 FROM	[dbo].[Question] WITH (NOLOCK)
						 WHERE	[Id] = @IdQuestion)

	IF (@QuestionType IS NULL)
	BEGIN
		SET @ResultCode = -3
	END
	ELSE
	BEGIN
		INSERT INTO [dbo].[Answer]
			   ([IdQuestion], [IdCompletedForm], [QuestionType], [FreeText], [Check], [YNOption], 
			   [ImageName], [ImageEncoded], [DateReply], [Skipped], [DoesNotApply], [IdQuestionOption], [ImageUrl])     
		VALUES (@IdQuestion, @IdCompletedForm, @QuestionType, @FreeText, @CheckOption, @YesNoOption, 
				@ImageName, @ImageArray, @DateReply, @Skipped, @DoesNotApply, @IdQuestionOption, @ImageUrl)

		SET @Id = SCOPE_IDENTITY()

		INSERT INTO [dbo].[AnswerTag]([IdAnswer], [IdTag])
		SELECT @Id, t.Id
		FROM @ChosenTags t

		SET @ResultCode = 0
	END
END
