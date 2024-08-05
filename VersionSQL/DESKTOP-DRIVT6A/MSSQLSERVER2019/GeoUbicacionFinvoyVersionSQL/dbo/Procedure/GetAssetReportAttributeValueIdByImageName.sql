/****** Object:  Procedure [dbo].[GetAssetReportAttributeValueIdByImageName]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetAssetReportAttributeValueIdByImageName]
	@ImageUniqueName varchar(100)
AS
BEGIN
	
	SELECT [Id]
	FROM AssetReportAttributeValue
	WHERE [ImageName] = @ImageUniqueName

END
