/****** Object:  Procedure [dbo].[UpdateProductReportAttribute]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<John Doe>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateProductReportAttribute]
	 @Id int
	,@Name varchar(250)
	,@IdType int
	,@DefaultValue varchar(MAX) = NULL
	,@Order int
	,@Required bit
AS
BEGIN
	
	UPDATE [dbo].[ProductReportAttribute]
	SET  [Name] = @Name
		,[IdType] = @IdType
		,[DefaultValue] = @DefaultValue
		,[Order] = @Order
		,[Required] = @Required
	WHERE [Id] = @Id

	IF EXISTS (SELECT 1 FROM ProductReportAttribute WHERE [Id] = @Id AND [IsStar] = 1) BEGIN 
		EXEC [dbo].[UpdateAllProductPointOfInterestChangeLog]
	END

	UPDATE Field
	SET [Name] = @Name
	WHERE [IdProductReportAttribute] = @Id

	SELECT @Id AS Id

END
