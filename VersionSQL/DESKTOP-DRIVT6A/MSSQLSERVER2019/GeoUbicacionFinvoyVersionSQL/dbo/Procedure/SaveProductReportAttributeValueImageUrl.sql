/****** Object:  Procedure [dbo].[SaveProductReportAttributeValueImageUrl]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SaveProductReportAttributeValueImageUrl]

    @IdAttributeValue [sys].[int],
	@ImageUrl [sys].[varchar](5000),	
	@ResultCode [sys].[smallint] OUT

AS
BEGIN
	
	UPDATE 	[dbo].[ProductReportAttributeValue]
	SET [ImageUrl] = @ImageUrl
	WHERE [Id] = @IdAttributeValue
	
	SELECT @ResultCode = 0
	
END
