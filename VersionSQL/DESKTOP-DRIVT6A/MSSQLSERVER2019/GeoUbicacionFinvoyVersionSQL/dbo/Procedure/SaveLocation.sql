/****** Object:  Procedure [dbo].[SaveLocation]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 20/09/2012
-- Description:	SP para guardar una ubicación
-- =============================================
CREATE PROCEDURE [dbo].[SaveLocation]
(
	 @IdPersonOfInterest [sys].[int]
	,@Date [sys].[datetime]
	,@Latitude [sys].[decimal](25, 20)
	,@Longitude [sys].[decimal](25, 20)
	,@Accuracy [sys].[decimal](8, 1) = NULL
	,@BatteryLevel [sys].[decimal](5, 2) 
)
AS
BEGIN
	DECLARE @Id [sys].[int]
	DECLARE @CurrentLocationDate [sys].[datetime]
    
	DECLARE @LatLong [sys].[GEOGRAPHY]
    SET @LatLong = GEOGRAPHY::STPointFromText('POINT(' + CAST(@Longitude AS VARCHAR(25)) + ' ' + CAST(@Latitude AS VARCHAR(25)) + ')', 4326)

	INSERT INTO [dbo].[Location]([IdPersonOfInterest], [ReceivedDate], [Date], [Latitude], [Longitude], [Accuracy], [Processed], [LatLong], [BatteryLevel])
	VALUES (@IdPersonOfInterest, GETUTCDATE(), @Date, @Latitude, @Longitude, @Accuracy, 0, @LatLong, @BatteryLevel)

	SELECT @Id = SCOPE_IDENTITY()

	SET @CurrentLocationDate = (SELECT [Date] FROM [dbo].[CurrentLocation] WITH (NOLOCK) WHERE [IdPersonOfInterest] = @IdPersonOfInterest)
	IF @CurrentLocationDate IS NULL
	BEGIN
		INSERT INTO [dbo].[CurrentLocation]([IdPersonOfInterest], [IdLocation], [Date], [Latitude], [Longitude], [Accuracy], [LatLong], [BatteryLevel])
		VALUES (@IdPersonOfInterest, @Id, @Date, @Latitude, @Longitude, @Accuracy, @LatLong, @BatteryLevel)
	END
	ELSE IF @Date >= @CurrentLocationDate
	BEGIN
		UPDATE	[dbo].[CurrentLocation]
		SET		[IdLocation] = @Id,
				[Date] = @Date,
				[Latitude] = @Latitude,
				[Longitude] = @Longitude,
				[Accuracy] = @Accuracy,
				[LatLong] = @LatLong,
				[BatteryLevel] = @BatteryLevel
		WHERE	[IdPersonOfInterest] = @IdPersonOfInterest
	END
END
