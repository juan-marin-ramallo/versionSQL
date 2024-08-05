/****** Object:  Procedure [dbo].[SaveProductsAtPointsOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SaveProductsAtPointsOfInterest]
	 @ProductIds [varchar](8000)
	,@PointOfInterestIds [varchar](8000)
AS
BEGIN
	DECLARE @Now [sys].[datetime]
	SET @Now = GETUTCDATE()

	INSERT INTO [dbo].[ProductPointOfInterest]  ([IdPointOfInterest], [IdProduct], [TheoricalStock],[TheoricalPrice])
	SELECT	poi.[Id], pr.[Id], 0, 0
	FROM	[dbo].[PointOfInterest] AS poi WITH (NOLOCK), [dbo].[Product] AS pr WITH (NOLOCK)
	WHERE	[dbo].[CheckValueInList](poi.[Id], @PointOfInterestIds) > 0
			AND [dbo].[CheckValueInList](pr.[Id], @ProductIds) > 0
			AND NOT EXISTS (SELECT 1 FROM [dbo].[ProductPointOfInterest] AS prpoi WITH (NOLOCK) 
							WHERE prpoi.[IdPointOfInterest] = poi.[Id] AND prpoi.[IdProduct] = pr.[Id])

	UPDATE	[dbo].[ProductPointOfInterestChangeLog] 
	SET		[LastUpdatedDate] = @Now
	WHERE	[dbo].[CheckValueInList]([IdPointOfInterest], @PointOfInterestIds) > 0


	INSERT INTO [dbo].[ProductPointOfInterestChangeLog]  ([IdPointOfInterest], [LastUpdatedDate])
	SELECT	poi.[Id], @Now
	FROM	[dbo].[PointOfInterest] AS poi WITH (NOLOCK)
	WHERE	[dbo].[CheckValueInList](poi.[Id], @PointOfInterestIds) > 0
			AND NOT EXISTS (SELECT 1 FROM [dbo].[ProductPointOfInterestChangeLog] AS prpoi WITH (NOLOCK)
							WHERE prpoi.[IdPointOfInterest] = poi.[Id] )

END
