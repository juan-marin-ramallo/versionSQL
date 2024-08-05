/****** Object:  Procedure [dbo].[SaveAssetReportAttributeValueImageUrl]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SaveAssetReportAttributeValueImageUrl]
	
	@IdAttributeValue [sys].[int],
	@ImageUrl [sys].[varchar](5000),	
	@ResultCode [sys].[smallint] OUT

AS
BEGIN
	
	UPDATE 	[dbo].[AssetReportAttributeValue]
	SET [ImageUrl] = @ImageUrl
	WHERE [Id] = @IdAttributeValue
	
	SELECT @ResultCode = 0
	
END
