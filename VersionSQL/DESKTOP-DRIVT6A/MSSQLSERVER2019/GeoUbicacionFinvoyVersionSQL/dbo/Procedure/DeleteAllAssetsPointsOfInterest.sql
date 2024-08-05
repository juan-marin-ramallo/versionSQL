/****** Object:  Procedure [dbo].[DeleteAllAssetsPointsOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[DeleteAllAssetsPointsOfInterest]
AS 
BEGIN
	UPDATE [dbo].[AssetPointOfInterest]
	SET [Deleted] = 1,
		[DateTo] = GETUTCDATE()
END
