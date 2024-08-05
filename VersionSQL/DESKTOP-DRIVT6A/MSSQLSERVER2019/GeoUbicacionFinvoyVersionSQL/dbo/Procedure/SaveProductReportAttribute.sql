/****** Object:  Procedure [dbo].[SaveProductReportAttribute]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<John Doe>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SaveProductReportAttribute]
	 @Id int OUTPUT
	,@IdSection int
	,@Name varchar(250)
	,@IdType int
	,@DefaultValue varchar(MAX) = NULL
	,@Order int
	,@Required bit
	,@IdUser int = NULL
AS
BEGIN
	
	INSERT INTO ProductReportAttribute ([IdProductReportSection], [Name], [IdType],
		[DefaultValue], [Order], [Required], [IdUser], [CreatedDate], [Deleted])
	VALUES (@IdSection, @Name, @IdType, @DefaultValue, @Order, @Required, @IdUser, GETUTCDATE(), 0)

	SET @Id = SCOPE_IDENTITY()

	INSERT INTO [dbo].[Field]([Name], [IdFieldGroup], [Order], [IdProductReportAttribute])
	VALUES (@Name, 6, 80, @Id)

END
