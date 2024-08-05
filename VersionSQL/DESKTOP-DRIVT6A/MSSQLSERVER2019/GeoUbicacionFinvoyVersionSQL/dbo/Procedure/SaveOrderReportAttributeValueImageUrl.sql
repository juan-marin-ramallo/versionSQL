/****** Object:  Procedure [dbo].[SaveOrderReportAttributeValueImageUrl]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SaveOrderReportAttributeValueImageUrl]

    @IdAttributeValue [sys].[int],
	@ImageUrl [sys].[varchar](5000),	
	@ResultCode [sys].[smallint] OUT

AS
BEGIN
	
	UPDATE 	[dbo].[OrderReportAttributeValue]
	SET [ImageUrl] = @ImageUrl
	WHERE [Id] = @IdAttributeValue
	
	SELECT @ResultCode = 0
	
END
