/****** Object:  Procedure [dbo].[SaveFormEngage]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================

-- Description:	SP para guardar un formulario duplicado
-- =============================================
CREATE PROCEDURE [dbo].[SaveFormEngage]
 
	 @Id [sys].[int] OUTPUT
	,@IdPointOfInterest [sys].[varchar](MAX) = NULL
	,@IdPersonOfInterest [sys].[varchar](MAX) = NULL
	,@FirstQuestionText [sys].[varchar](MAX) = NULL
	,@StartDate [sys].DATETIME = NULL
	,@EndDate [sys].DATETIME = NULL
	,@Description [sys].[varchar](250) = NULL
	,@IdFormToDuplicate [sys].[int]
AS
BEGIN

	INSERT INTO [dbo].[Form]([Name], [Date], [IdUser], [Deleted],[StartDate],[EndDate],[IdFormCategory], 
				[AllPointOfInterest], [AllPersonOfInterest], [NonPointOfInterest], [OneTimeAnswer], [Description], [IsWeighted], [CompleteMultipleTimes])
	SELECT		[Name], [Date], [IdUser], [Deleted], @StartDate, @EndDate, [IdFormCategory], 0, 0, 0, 0, [Description],0, 0
	FROM		[dbo].[Form]
	WHERE		[Id] = @IdFormToDuplicate
	
	SELECT @Id = SCOPE_IDENTITY()

	INSERT INTO [dbo].[AssignedForm]([IdForm], [IdPointOfInterest], [Date],[Deleted], [DeletedDate], [IdPersonOfInterest])
	VALUES		(@Id, @IdPointOfInterest, GETUTCDATE(), 0, NULL, @IdPersonOfInterest)
	

	--Copio Question y QuestionOption

	declare @Type [sys].[varchar](5)
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
	,@IdAux [sys].int
	,@IdNewQuestion [sys].int

	DECLARE cur CURSOR FOR SELECT Q.[Id], Q.[Required], Q.[Text], Q.[Type], Q.[Hint], Q.[YesIsProblem], Q.[NoIsProblem],
									Q.[ImageEncoded], Q.[Weight], Q.[IsNoWeighted], Q.[DefaultAnswerText]
	FROM dbo.Question Q
	WHERE IdForm = @IdFormToDuplicate
	order by Id 

	OPEN cur

	FETCH NEXT FROM cur INTO @IdAux, @Required, @Text, @Type, @Hint, @YesIsProblem, @NoIsProblem, @ImageArray, @Weight, @IsNoWeighted, @DefaultAnswerText

	WHILE @@FETCH_STATUS = 0 
	BEGIN

		IF @Type = 'TI' AND @Text = 'Título'
		begin
			SET @Text = @FirstQuestionText
		end
		INSERT INTO [dbo].[Question]([Required], [Text], [Type], [Hint], [YesIsProblem], [NoIsProblem],
									[ImageEncoded], [Weight], [IsNoWeighted], [DefaultAnswerText])
		VALUES		(@Required, @Text, @Type, @Hint, @YesIsProblem, @NoIsProblem, @ImageArray, @Weight, @IsNoWeighted, @DefaultAnswerText)

		SET @IdNewQuestion = SCOPE_IDENTITY()

		IF EXISTS (SELECT 1 FROM [dbo].[QuestionOption] WHERE IdQuestion = @IdAux)
		BEGIN

			insert into [dbo].[QuestionOption]([IdQuestion], [Text], [Default], [Weight])
			SELECT		 @IdNewQuestion, [Text], [Default], [Weight]
						FROM [dbo].[QuestionOption] WHERE [IdQuestion] = @IdAux

		END
	
		FETCH NEXT FROM cur INTO @IdAux, @Required, @Text, @Type, @Hint, @YesIsProblem, @NoIsProblem, @ImageArray, @Weight, @IsNoWeighted, @DefaultAnswerText

	END

	CLOSE cur    
	DEALLOCATE cur


--	OLD
-- 	INSERT INTO [dbo].[Form]([Name], [Date], [IdUser], [Deleted],[StartDate],[EndDate],[IdFormCategory])
-- 	VALUES (@Name, GETUTCDATE(), @IdUser, 0, @StartDate, @EndDate, @IdFormCategory)
-- 
-- 	SELECT @Id = SCOPE_IDENTITY()
-- 
-- 	INSERT INTO [dbo].[AssignedForm]([IdForm], [IdPointOfInterest], [Date], [Deleted])
-- 	(SELECT @Id AS IdForm, P.[Id] AS [IdPointOfInterest], GETUTCDATE(), 0 AS [Deleted]
-- 	 FROM	[dbo].[PointOfInterest] P
-- 	 WHERE	dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1
--	)
END
