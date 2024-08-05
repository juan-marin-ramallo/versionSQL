/****** Object:  Procedure [dbo].[UpdateAllProductPointOfInterestChangeLog]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateAllProductPointOfInterestChangeLog]
AS
BEGIN

	UPDATE	[dbo].[ProductPointOfInterestChangeLog] 
	SET		[LastUpdatedDate] = GETUTCDATE()

	INSERT INTO [dbo].[ProductPointOfInterestChangeLog]  ([IdPointOfInterest], [LastUpdatedDate])
	SELECT	poi.[Id], GETUTCDATE()
	FROM	[dbo].[PointOfInterest] AS poi
	WHERE	POI.[Deleted] = 0
			AND NOT EXISTS (SELECT 1 FROM [dbo].[ProductPointOfInterestChangeLog] AS prpoi 
							WHERE prpoi.[IdPointOfInterest] = poi.[Id])

END
