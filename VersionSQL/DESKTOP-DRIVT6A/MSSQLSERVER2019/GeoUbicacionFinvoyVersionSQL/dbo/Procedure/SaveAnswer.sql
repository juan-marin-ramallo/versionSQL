/****** Object:  Procedure [dbo].[SaveAnswer]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Diego Cáceres
-- Create date: 02/10/2014
-- Description:	SP para guardar una respuesta de un formulario 
-- =============================================
CREATE PROCEDURE [dbo].[SaveAnswer]
	@IdQuestion [sys].[int] = 0,
	@IdCompletedForm [sys].[int] = 0,
	@FreeText [sys].[varchar] (5000) = '',
	@CheckOption [sys].[bit] = 0,
	@YesNoOption [sys].[bit] = 0,
	@ImageName [sys].[varchar] (100) = '',
	@ImageArray [sys].[image]  = null,
	@DateReply [sys].[datetime] = null,
	@Skipped [sys].[bit] = 0,
	@IdQuestionOption [sys].[int] = null,
	@DoesNotApply [sys].[bit],
	@TagIds [dbo].[IdTableType] READONLY,
	@ResultCode [sys].[smallint] OUT

AS
BEGIN
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
		DECLARE @Id [sys].[int]

			IF @QuestionType = 'TAG'
			BEGIN
				SET @Skipped = IIF(EXISTS (SELECT top(1) 1 FROM @TagIds), 0, 1)
			END

			INSERT INTO [dbo].[Answer]
				   ([IdQuestion], [IdCompletedForm], [QuestionType], [FreeText], [Check], [YNOption], 
				   [ImageName], [ImageEncoded], [DateReply], [Skipped], [IdQuestionOption], [DoesNotApply])     
			VALUES (@IdQuestion, @IdCompletedForm, @QuestionType, @FreeText, @CheckOption, @YesNoOption, 
					@ImageName, @ImageArray, @DateReply, @Skipped, @IdQuestionOption, @DoesNotApply)
    
		SELECT @Id = SCOPE_IDENTITY()

		IF EXISTS (SELECT TOP(1) 1 FROM @TagIds)
		BEGIN
			INSERT INTO [dbo].[AnswerTag]([IdAnswer], [IdTag])
			SELECT  @Id, [Id]
			FROM    @TagIds
		END

		SET @ResultCode = 0
	END
END
