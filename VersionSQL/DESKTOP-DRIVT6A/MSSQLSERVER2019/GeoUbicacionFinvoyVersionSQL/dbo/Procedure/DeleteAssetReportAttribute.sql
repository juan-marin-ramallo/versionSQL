/****** Object:  Procedure [dbo].[DeleteAssetReportAttribute]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DeleteAssetReportAttribute]
	@Id int
AS
BEGIN
	
	UPDATE [dbo].[AssetReportAttribute]
	SET [Deleted] = 1
	WHERE [Id] = @Id

	UPDATE [dbo].[AssetReportAttributeOption]
	SET [Deleted] = 1
	WHERE [IdAssetReportAttribute] = @Id

	UPDATE  [dbo].[Field]
	SET		[Deleted] = 1,
			[FullDeleted] = 1
	WHERE	[IdAssetReportAttribute] = @Id

END
