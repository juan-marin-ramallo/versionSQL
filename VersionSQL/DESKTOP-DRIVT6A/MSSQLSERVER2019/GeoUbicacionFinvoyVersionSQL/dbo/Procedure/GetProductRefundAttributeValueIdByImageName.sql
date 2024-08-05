/****** Object:  Procedure [dbo].[GetProductRefundAttributeValueIdByImageName]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetProductRefundAttributeValueIdByImageName]
	@ImageUniqueName varchar(100)
AS
BEGIN
	
	SELECT [Id]
	FROM ProductRefundAttributeValue
	WHERE [ImageName] = @ImageUniqueName

END
