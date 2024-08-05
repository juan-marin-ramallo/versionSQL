/****** Object:  Procedure [dbo].[DeleteAssetPointOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[DeleteAssetPointOfInterest](
   @Id [sys].[int]
)
AS 
BEGIN
	UPDATE [dbo].[AssetPointOfInterest]
	SET [Deleted] = 1,
		[DateTo] = GETUTCDATE()
	WHERE [Id] = @Id
END
