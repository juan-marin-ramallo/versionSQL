/****** Object:  Procedure [dbo].[SaveProductRefundAttributeValueImageUrl]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SaveProductRefundAttributeValueImageUrl]

    @IdAttributeValue [sys].[int],
	@ImageUrl [sys].[varchar](5000),	
	@ResultCode [sys].[smallint] OUT

AS
BEGIN
	
	UPDATE 	[dbo].[ProductRefundAttributeValue]
	SET [ImageUrl] = @ImageUrl
	WHERE [Id] = @IdAttributeValue
	
	SELECT @ResultCode = 0
	
END
