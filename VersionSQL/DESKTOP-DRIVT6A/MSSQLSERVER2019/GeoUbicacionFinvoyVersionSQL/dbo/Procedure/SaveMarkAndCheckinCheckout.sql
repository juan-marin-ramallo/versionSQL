/****** Object:  Procedure [dbo].[SaveMarkAndCheckinCheckout]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		FS
-- Create date: 20/03/2020
-- Description:	SP para guardar una marca y hacer checkin/out en punto
-- =============================================
CREATE PROCEDURE [dbo].[SaveMarkAndCheckinCheckout]
(
	 @IdPersonOfInterest [sys].[int]
	,@IdPointOfInterest [sys].[int]
	,@Type [sys].[varchar](5)
	,@Date [sys].[datetime]
	,@Latitude [sys].[decimal](25, 20)
	,@Longitude [sys].[decimal](25, 20)
	,@Accuracy [sys].[decimal](8, 1)	
	,@ImageUniqueName [sys].[varchar](256) = null
)
AS
BEGIN

	DECLARE @IdParentMark [sys].[int]
	DECLARE @LatLong [sys].[geography]
	
	DECLARE @ConfTimeBetweenEnters [sys].[int] = Parse((SELECT [Value] FROM [dbo].[ConfigurationTranslated] WITH (NOLOCK) WHERE [Id] = 9) as int)
	DECLARE @LastVisitId [sys].[int] = NULL
	DECLARE @LastVisitCheckInDate [sys].[datetime]
	--DECLARE @LastVisitCheckOutDate [sys].[datetime]
	DECLARE @ElapsedTime [sys].[time](7)

	--SELECT TOP 1 @LastVisitId = Id, @LastVisitCheckInDate = [CheckInDate], @LastVisitCheckOutDate = [CheckOutDate]
	--FROM dbo.[PointOfInterestManualVisited]
	--WHERE IdPersonOfInterest = @IdPersonOfInterest
	--ORDER BY ISNULL(CheckOutDate, CheckInDate) DESC

	SET @LatLong = GEOGRAPHY::STPointFromText('POINT(' + CAST(@Longitude AS VARCHAR(25)) + ' ' + CAST(@Latitude AS VARCHAR(25)) + ')', 4326)

	IF NOT EXISTS (SELECT 1 FROM [dbo].[Mark] WITH (NOLOCK) WHERE [IdPersonOfInterest] = @IdPersonOfInterest  
				AND [Type] = @Type AND [Date] = @Date)
	BEGIN
		IF @Type <> 'E'
		BEGIN
			--Tengo que ir a buscar la ultima entrada que haya para esta persona (que puede ser de cualquier dia)
			SET @IdParentMark = (SELECT TOP(1) [Id] FROM [dbo].[Mark] WITH (NOLOCK) 
			WHERE [IdPersonOfInterest] = @IdPersonOfInterest AND [Type] = 'E' ORDER BY [Id] DESC)
				
			INSERT INTO [dbo].[Mark]([IdPointOfInterest],[IdPersonOfInterest], [Type], [Date], [Latitude], [Longitude], [Accuracy], [IdParent], [ReceivedDate], [LatLong])
			VALUES(@IdPointOfInterest, @IdPersonOfInterest, @Type, @Date, @Latitude, @Longitude, @Accuracy, @IdParentMark, GETUTCDATE(), @LatLong)
		
			IF @Type = 'S'
			BEGIN
				SELECT TOP 1 @LastVisitId = Id, @LastVisitCheckInDate = [CheckInDate]
				FROM dbo.[PointOfInterestManualVisited]
				WHERE IdPersonOfInterest = @IdPersonOfInterest AND IdPointOfInterest = @IdPointOfInterest
				ORDER BY ISNULL(CheckOutDate, CheckInDate) DESC

				SET @ElapsedTime =  CONVERT(varchar,(@Date-@LastVisitCheckInDate),108)

				UPDATE	dbo.[PointOfInterestManualVisited]
				SET		[CheckOutDate] = @Date, [ElapsedTime] = @ElapsedTime, [ReceivedDate] = GETUTCDATE()
						,[CheckOutLatitude] = @Latitude, [CheckOutLongitude] = @Longitude, [CheckOutPointOfInterestId] = @IdPointOfInterest
						,[CheckOutImageName] = @ImageUniqueName
				WHERE	[Id] = @LastVisitId

				
				EXEC [dbo].[UpdatePointsOfInterestActivity]
					@IdPointOfInterest = @IdPointOfInterest
					,@DateIn = @LastVisitCheckInDate
					,@DateOut = @Date
					,@ElapsedTime = @ElapsedTime
					,@AutomaticValue = 2
					,@IdPointOfInterestManualVisited = @LastVisitId
			END
		END
		ELSE
		BEGIN
			INSERT INTO [dbo].[Mark]([IdPointOfInterest],[IdPersonOfInterest], [Type], [Date], [Latitude], [Longitude], [Accuracy], [ReceivedDate], [LatLong])
			VALUES (@IdPointOfInterest, @IdPersonOfInterest, @Type, @Date, @Latitude, @Longitude, @Accuracy, GETUTCDATE(), @LatLong)

			INSERT INTO [dbo].[PointOfInterestManualVisited]([IdPersonOfInterest], [IdPointOfInterest], [CheckInDate], 
							[CheckOutDate], [CheckOutLatitude], [CheckOutLongitude], [CheckOutPointOfInterestId],[ElapsedTime],[ReceivedDate], [DeletedByNotVisited], [Edited], [CheckInImageName])
			VALUES(@IdPersonOfInterest, @IdPointOfInterest, @Date, NULL, @Latitude, @Longitude, @IdPointOfInterest, NULL, GETUTCDATE(), 0, 0, @ImageUniqueName)

			SET @LastVisitId = SCOPE_IDENTITY()

			
			EXEC [dbo].[SavePointsOfInterestActivity]
					@IdPersonOfInterest = @IdPersonOfInterest
					,@IdPointOfInterest = @IdPointOfInterest
					,@DateIn = @Date
					,@AutomaticValue = 2
					,@IdPointOfInterestManualVisited = @LastVisitId
		END
	END
	
	SELECT @LastVisitId
END
