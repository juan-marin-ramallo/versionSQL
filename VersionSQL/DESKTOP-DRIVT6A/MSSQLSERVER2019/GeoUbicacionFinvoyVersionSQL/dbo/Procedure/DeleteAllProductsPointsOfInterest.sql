/****** Object:  Procedure [dbo].[DeleteAllProductsPointsOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[DeleteAllProductsPointsOfInterest]
AS 
BEGIN
	DECLARE @Now [sys].[datetime]
    SET @Now = GETUTCDATE()

	DELETE FROM [dbo].[ProductPointOfInterest]
	DELETE FROM [dbo].[CatalogPointOfInterest]
	
	UPDATE	[dbo].[ProductPointOfInterestChangeLog] 
	SET		[LastUpdatedDate] = @Now

	INSERT INTO [dbo].[ProductPointOfInterestChangeLog]  ([IdPointOfInterest], [LastUpdatedDate])
	SELECT	poi.[Id], @Now
	FROM	[dbo].[PointOfInterest] AS poi
	WHERE	POI.[Deleted] = 0
			AND NOT EXISTS (SELECT 1 FROM [dbo].[ProductPointOfInterestChangeLog] AS prpoi 
							WHERE prpoi.[IdPointOfInterest] = poi.[Id])

END
