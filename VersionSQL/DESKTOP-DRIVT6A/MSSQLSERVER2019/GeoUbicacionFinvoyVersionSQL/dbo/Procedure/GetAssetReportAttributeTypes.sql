/****** Object:  Procedure [dbo].[GetAssetReportAttributeTypes]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetAssetReportAttributeTypes]
AS
BEGIN
	
	SELECT [Id], [Description]
	FROM AssetReportAttributeTypeTranslated WITH (NOLOCK)
	ORDER BY [Order] ASC

END
