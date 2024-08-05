/****** Object:  Procedure [dbo].[SaveCheckinCheckout]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 09/01/2017
-- Description:	SP para guardar una marca de entrada/Salida manual
-- =============================================
CREATE PROCEDURE [dbo].[SaveCheckinCheckout]
(
	 @IdPersonOfInterest [sys].[int]
	,@IdPointOfInterest [sys].[int]
	,@StartDate [sys].[datetime]
	,@EndDate [sys].[datetime] = NULL
	,@ElapsedTime [sys].[time](7) = NULL
	,@Latitude [sys].DECIMAL(25,20) = NULL
	,@Longitude [sys].DECIMAL(25,20) = NULL
	,@ImageInUniqueName [sys].[varchar](256) = NULL
	,@ImageOutUniqueName [sys].[varchar](256) = NULL
    ,@TaskCompletition [sys].[bit] = 0
)
AS
BEGIN
	DECLARE @Now [sys].[datetime]
	SET @Now = GETUTCDATE()

	DECLARE @IdAux [sys].[int] = NULL
	DECLARE @IdPointOut [sys].[INT] = (SELECT TOP 1 [Id] FROM [dbo].[GetNearPointsOfInterestWithConfRoute](@IdPersonOfInterest, @Latitude, @Longitude))

	IF NOT EXISTS (SELECT 1 FROM [dbo].[PointOfInterestManualVisited] WITH (NOLOCK) WHERE
								[IdPointOfInterest] = @IdPointOfInterest AND 
								[IdPersonOfInterest] = @IdPersonOfInterest
								AND [CheckInDate] = @StartDate AND [CheckOutDate] = @EndDate)
	BEGIN

		SET @IdAux = (SELECT TOP(1) [Id] FROM [dbo].[PointOfInterestManualVisited] WITH (NOLOCK) WHERE
									[IdPointOfInterest] = @IdPointOfInterest AND 
									[IdPersonOfInterest] = @IdPersonOfInterest
									AND [CheckInDate] IS NOT NULL AND [CheckOutDate] IS NULL AND
									Tzdb.AreSameSystemDates([CheckInDate], @EndDate) = 1
								ORDER BY [Id] DESC)

		IF @IdAux IS NULL
		BEGIN
				IF NOT EXISTS (SELECT 1 FROM [dbo].[PointOfInterestManualVisited] WHERE
								[IdPointOfInterest] = @IdPointOfInterest AND 
								[IdPersonOfInterest] = @IdPersonOfInterest
								AND [CheckInDate] = @StartDate)
				BEGIN
					INSERT INTO [dbo].[PointOfInterestManualVisited]([IdPersonOfInterest], [IdPointOfInterest], [CheckInDate], 
							[CheckOutDate], [CheckOutLatitude], [CheckOutLongitude], [CheckOutPointOfInterestId],[ElapsedTime],[ReceivedDate]
                            , [DeletedByNotVisited], [Edited], [CheckInImageName], [CheckOutImageName], [TaskCompletition])
					VALUES(@IdPersonOfInterest, @IdPointOfInterest, @StartDate, @EndDate, @Latitude, @Longitude, @IdPointOut, @ElapsedTime, @Now
                            , 0, 0, @ImageInUniqueName, @ImageOutUniqueName, @TaskCompletition)

					SET @IdAux = SCOPE_IDENTITY()

					EXEC [dbo].[SavePointsOfInterestActivity]
						 @IdPersonOfInterest = @IdPersonOfInterest
						,@IdPointOfInterest = @IdPointOfInterest
						,@DateIn = @StartDate
						,@DateOut = @EndDate
						,@ElapsedTime = @ElapsedTime
						,@AutomaticValue = 2
						,@IdPointOfInterestManualVisited = @IdAux
				END
		END
		ELSE
		BEGIN
				UPDATE	[dbo].[PointOfInterestManualVisited]
				SET		[CheckOutDate] = @EndDate, [ElapsedTime] = @ElapsedTime, [ReceivedDate] = @Now, [CheckOutImageName] = @ImageOutUniqueName
						,[CheckOutLatitude] = @Latitude, [CheckOutLongitude] = @Longitude, [CheckOutPointOfInterestId] = @IdPointOut, [TaskCompletition] = @TaskCompletition
				WHERE	[Id] = @IdAux

				EXEC [dbo].[UpdatePointsOfInterestActivity]
					 @IdPointOfInterest = @IdPointOfInterest
					,@DateIn = @StartDate
					,@DateOut = @EndDate
					,@ElapsedTime = @ElapsedTime
					,@AutomaticValue = 2
					,@IdPointOfInterestManualVisited = @IdAux
		END
	END

	SELECT @IdAux

END
