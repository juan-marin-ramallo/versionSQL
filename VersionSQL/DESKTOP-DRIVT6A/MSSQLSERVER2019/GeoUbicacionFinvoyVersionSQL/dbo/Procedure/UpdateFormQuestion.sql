/****** Object:  Procedure [dbo].[UpdateFormQuestion]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateFormQuestion]
	 @Id int
	,@Text varchar(250)
	,@Hint [sys].[varchar](150) = NULL
	,@Required bit
	,@Weight int
	,@DefaultAnswerText [sys].[varchar](5000) = NULL
AS
BEGIN

	UPDATE Question
	SET  [Text] = @Text
		,[Hint] = @Hint
		,[Required] = @Required
		,[Weight] = @Weight
		,[DefaultAnswerText] = @DefaultAnswerText 
	WHERE [Id] = @Id

END
