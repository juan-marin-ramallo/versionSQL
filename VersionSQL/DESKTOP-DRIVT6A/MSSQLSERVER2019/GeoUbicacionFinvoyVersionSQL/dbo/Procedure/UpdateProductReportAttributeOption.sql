/****** Object:  Procedure [dbo].[UpdateProductReportAttributeOption]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateProductReportAttributeOption]
	 @Id int
	,@Text varchar(100)
	,@IsDefault bit
AS
BEGIN
	
	UPDATE [dbo].[ProductReportAttributeOption]
	SET [Text] = @Text, [IsDefault] = @IsDefault
	WHERE [Id] = @Id

END
