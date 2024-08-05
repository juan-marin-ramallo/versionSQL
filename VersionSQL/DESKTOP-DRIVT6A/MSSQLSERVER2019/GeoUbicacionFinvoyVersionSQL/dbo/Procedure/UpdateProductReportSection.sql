/****** Object:  Procedure [dbo].[UpdateProductReportSection]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateProductReportSection]
	 @Id int
	,@Name varchar(100)
	,@Description varchar(500) = NULL
	,@Order int
AS
BEGIN
	IF EXISTS (SELECT 1 FROM [dbo].[ProductReportSection] WHERE [Name] = @Name AND [Deleted] = 0 AND @Id <> [Id]) BEGIN
		SELECT -1 AS Id;
	END ELSE BEGIN
		UPDATE dbo.[ProductReportSection]
		SET [Name] = @Name, 
			[Description] = @Description, 
			[Order] = @Order
		WHERE [Id] = @Id

		SELECT @Id as Id;
	END
END
