/****** Object:  Procedure [dbo].[SaveQuestionOption]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  GL  
-- Create date: 21/07/2015  
-- Description: SP para guardar una opcion de una pregunta CON MULTIPLES OPCIONES  
-- =============================================  
CREATE PROCEDURE [dbo].[SaveQuestionOption]  
(
	 @Id [sys].[int] OUTPUT
	,@Text [sys].[varchar](100)  
	,@Default [sys].[bit]  
	,@IsNotApply [sys].[bit] = NULL  
	,@IdQuestion [sys].[int]  
	,@Weight [sys].[int] = NULL  
	,@RedirectToSection [sys].[int] = NULL
)  
AS  
BEGIN  
	INSERT INTO [dbo].[QuestionOption]([Text], [Default], [IsNotApply], [IdQuestion], [Weight], [RedirectToSection])
	VALUES (@Text, @Default, @IsNotApply, @IdQuestion, @Weight, @RedirectToSection)

	SELECT @Id = SCOPE_IDENTITY()
END
