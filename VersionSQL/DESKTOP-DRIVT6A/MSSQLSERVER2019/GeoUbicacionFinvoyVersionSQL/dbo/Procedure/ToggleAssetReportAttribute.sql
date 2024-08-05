/****** Object:  Procedure [dbo].[ToggleAssetReportAttribute]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ToggleAssetReportAttribute]
	 @Id int
	,@Enable bit
AS
BEGIN
	
	UPDATE [dbo].[AssetReportAttribute]
	SET [Enabled] = @Enable
	WHERE [Id] = @Id

END
