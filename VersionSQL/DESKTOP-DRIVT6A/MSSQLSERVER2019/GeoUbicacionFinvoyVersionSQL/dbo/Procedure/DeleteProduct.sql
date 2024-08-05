/****** Object:  Procedure [dbo].[DeleteProduct]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[DeleteProduct]
   @Id int
     
 
AS 
BEGIN
    SET NOCOUNT ON;

	DECLARE @Now [sys].[datetime]
    SET @Now = GETUTCDATE()

    UPDATE	[dbo].[Product]
	SET		[Deleted] = 1
	WHERE	[Id] = @Id

	--DELETE 
	--FROM	[dbo].[ProductPointOfInterest]
	--WHERE	[IdProduct] = @Id

	DELETE 
	FROM	[dbo].[CatalogProduct]
	WHERE	[IdProduct] = @Id

	UPDATE	[dbo].[ProductPointOfInterestChangeLog] 
	SET		[LastUpdatedDate] = @Now

	INSERT INTO [dbo].[ProductPointOfInterestChangeLog]  ([IdPointOfInterest], [LastUpdatedDate])
	SELECT	poi.[Id], @Now
	FROM	[dbo].[PointOfInterest] AS poi
	WHERE	POI.[Deleted] = 0
			AND NOT EXISTS (SELECT 1 FROM [dbo].[ProductPointOfInterestChangeLog] AS prpoi 
							WHERE prpoi.[IdPointOfInterest] = poi.[Id])

END
