/****** Object:  Procedure [dbo].[UpdatePointOfInterestVisited]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 03/06/2015
-- Description:	SP para actualizar un punto de interés visitado
-- =============================================
CREATE PROCEDURE [dbo].[UpdatePointOfInterestVisited]
(
	 @Id [sys].[int]
	,@IdLocationIn [sys].[int]
	,@LocationInDate [sys].[datetime]
    ,@IdLocationOut [sys].[int] = NULL
	,@LocationOutDate [sys].[datetime] = NULL
    ,@IdPointOfInterest [sys].[int]
    ,@ElapsedTime [sys].[time](7) = NULL
	,@DeletedByNotVisited [sys].BIT = 0
)
AS
BEGIN
	DECLARE @IdPersonOfInterest [sys].[int]

	IF @DeletedByNotVisited = 1
	BEGIN
		EXEC [dbo].[DeletePointsOfInterestActivity]
				 @AutomaticValue = 1
				,@IdPointOfInterestVisited = @Id
				,@IdPointOfInterestManualVisited = NULL
	END
	ELSE
	BEGIN
		SET @IdPersonOfInterest = (SELECT TOP 1 IdPersonOfInterest FROM dbo.PointOfInterestVisited WHERE Id = @Id ORDER BY Id)		
		EXEC [dbo].[SavePointsOfInterestActivity]
			 @IdPersonOfInterest = @IdPersonOfInterest
			,@IdPointOfInterest = @IdPointOfInterest
			,@DateIn = @LocationInDate
			,@DateOut = @IdLocationOut
			,@ElapsedTime = @ElapsedTime
			,@AutomaticValue = 1
			,@IdPointOfInterestVisited = @Id
	END

	UPDATE	[dbo].[PointOfInterestVisited]
	SET		[IdLocationIn] = @IdLocationIn
		   ,[LocationInDate] = @LocationInDate
		   ,[IdLocationOut] = @IdLocationOut
		   ,[LocationOutDate] = @LocationOutDate
		   ,[IdPointOfInterest] = @IdPointOfInterest
		   ,[ElapsedTime] = @ElapsedTime
		   ,[DeletedByNotVisited] = @DeletedByNotVisited
		   ,[InHourWindow] = [dbo].[IsVisitedLocationInPointHourWindowIgnoreConfig](@IdPointOfInterest, @LocationInDate, @LocationOutDate)
	WHERE	[Id] = @Id
END
