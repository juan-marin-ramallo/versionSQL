/****** Object:  Procedure [dbo].[DeleteAssetType]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DeleteAssetType]
(
	 @Id [sys].[int]
)
AS
BEGIN
		UPDATE	[dbo].[AssetType]
		
		SET		[EditedDate] = GETUTCDATE(),
				[Deleted] = 1
 		
		WHERE	 [Id] = @Id

END
