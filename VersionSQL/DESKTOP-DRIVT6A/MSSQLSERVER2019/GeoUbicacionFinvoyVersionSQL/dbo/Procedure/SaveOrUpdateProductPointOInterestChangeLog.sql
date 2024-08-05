/****** Object:  Procedure [dbo].[SaveOrUpdateProductPointOInterestChangeLog]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SaveOrUpdateProductPointOInterestChangeLog](
	 @IdProduct [sys].[int] = NULL,
	 @IdPointOfInterest [sys].[int] = NULL
)
AS 
BEGIN
	DECLARE @Now [sys].[datetime]
	SET @Now = GETUTCDATE()

	IF EXISTS (SELECT 1 FROM [dbo].[ProductPointOfInterestChangeLog] WITH(NOLOCK)
			WHERE [IdPointOfInterest] = @IdPointOfInterest)
	BEGIN
			UPDATE	[dbo].[ProductPointOfInterestChangeLog] 
			SET		[LastUpdatedDate] = @Now
			WHERE	[IdPointOfInterest] = @IdPointOfInterest
	END
	ELSE
	BEGIN
			INSERT INTO [dbo].[ProductPointOfInterestChangeLog]([IdPointOfInterest],[LastUpdatedDate])
			VALUES		(@IdPointOfInterest, @Now)
	END
END	
