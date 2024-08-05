/****** Object:  Procedure [dbo].[SavePointsOfInterestVisited]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 19/10/2016
-- Description:	SP para guardar varios puntos de interés visitados
-- =============================================
CREATE PROCEDURE [dbo].[SavePointsOfInterestVisited]
(
	@PointsOfInterestVisited [dbo].PointOfInterestVisitedTableType READONLY
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Id [sys].[int]
	DECLARE @CursorIdPersonOfInterest [int]
	DECLARE @CursorIdLocationIn [int]
	DECLARE @CursorLocationInDate [datetime]
	DECLARE @CursorIdLocationOut [int]
	DECLARE @CursorLocationOutDate [datetime]
	DECLARE @CursorIdPointOfInterest [int]
	DECLARE @CursorElapsedTime [time](7)
	DECLARE @CursorDeletedByNotVisited [bit]
	DECLARE @CursorLatitudeIn [decimal](25, 20)
	DECLARE @CursorLongitudeIn [decimal](25, 20)
 
	DECLARE CUR_IDS CURSOR FAST_FORWARD FOR
		SELECT IdPersonOfInterest,IdLocationIn,LocationInDate,IdLocationOut,LocationOutDate,IdPointOfInterest,ElapsedTime,DeletedByNotVisited,LatitudeIn,LongitudeIn
		FROM   @PointsOfInterestVisited
		ORDER BY Id 

	OPEN CUR_IDS
	FETCH NEXT FROM CUR_IDS INTO @CursorIdPersonOfInterest,@CursorIdLocationIn,@CursorLocationInDate,@CursorIdLocationOut,@CursorLocationOutDate,@CursorIdPointOfInterest,@CursorElapsedTime,@CursorDeletedByNotVisited,@CursorLatitudeIn,@CursorLongitudeIn
 
	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO [dbo].[PointOfInterestVisited] ([IdPersonOfInterest], [IdLocationIn], [LocationInDate], [IdLocationOut], [LocationOutDate], [IdPointOfInterest], [ElapsedTime], [DeletedByNotVisited], [LatitudeIn], [LongitudeIn], [InHourWindow])
		VALUES	(@CursorIdPersonOfInterest,@CursorIdLocationIn,@CursorLocationInDate,@CursorIdLocationOut,@CursorLocationOutDate,@CursorIdPointOfInterest,@CursorElapsedTime,@CursorDeletedByNotVisited,@CursorLatitudeIn,@CursorLongitudeIn, [dbo].[IsVisitedLocationInPointHourWindowIgnoreConfig](@CursorIdPointOfInterest, @CursorLocationInDate, @CursorLocationOutDate))
		
		SET @Id = SCOPE_IDENTITY()

		EXEC [dbo].[SavePointsOfInterestActivity]
			 @IdPersonOfInterest = @CursorIdPersonOfInterest
			,@IdPointOfInterest = @CursorIdPointOfInterest
			,@DateIn = @CursorLocationInDate
			,@DateOut = @CursorLocationOutDate
			,@ElapsedTime = @CursorElapsedTime
			,@AutomaticValue = 1
			,@IdPointOfInterestVisited = @Id

	   FETCH NEXT FROM CUR_IDS INTO @CursorIdPersonOfInterest,@CursorIdLocationIn,@CursorLocationInDate,@CursorIdLocationOut,@CursorLocationOutDate,@CursorIdPointOfInterest,@CursorElapsedTime,@CursorDeletedByNotVisited,@CursorLatitudeIn,@CursorLongitudeIn
	END
	CLOSE CUR_IDS
	DEALLOCATE CUR_IDS

	SET NOCOUNT OFF;
END
