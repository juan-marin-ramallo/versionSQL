/****** Object:  Procedure [dbo].[SaveProductRefundAttributeValueImage]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SaveProductRefundAttributeValueImage]

    @IdAttributeValue [sys].[int],
	@ImageArray [sys].[image],	
	@ResultCode [sys].[smallint] OUT

AS
BEGIN
	
	UPDATE 	[dbo].[ProductRefundAttributeValue]
	SET [ImageEncoded] = @ImageArray
	WHERE [Id] = @IdAttributeValue
	
	SELECT @ResultCode = 0
	
END
