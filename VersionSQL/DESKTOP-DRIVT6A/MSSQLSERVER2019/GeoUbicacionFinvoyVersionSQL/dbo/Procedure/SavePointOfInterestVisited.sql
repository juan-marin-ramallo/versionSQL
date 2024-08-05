/****** Object:  Procedure [dbo].[SavePointOfInterestVisited]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 03/06/2015
-- Description:	SP para guardar un punto de interés visitado
-- =============================================
CREATE PROCEDURE [dbo].[SavePointOfInterestVisited]
(
	 @IdPersonOfInterest [sys].[int]
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
	DECLARE @Id [sys].[int]

	INSERT INTO [dbo].[PointOfInterestVisited] ([IdPersonOfInterest], [IdLocationIn], [LocationInDate], [IdLocationOut], [LocationOutDate], [IdPointOfInterest], [ElapsedTime], [DeletedByNotVisited], [InHourWindow])
	VALUES (@IdPersonOfInterest, @IdLocationIn, @LocationInDate, @IdLocationOut, @LocationOutDate, @IdPointOfInterest, @ElapsedTime, @DeletedByNotVisited, [dbo].[IsVisitedLocationInPointHourWindowIgnoreConfig](@IdPointOfInterest, @LocationInDate, @LocationOutDate))

	SET @Id = SCOPE_IDENTITY()

	EXEC [dbo].[SavePointsOfInterestActivity]
		 @IdPersonOfInterest = @IdPersonOfInterest
		,@IdPointOfInterest = @IdPointOfInterest
		,@DateIn = @LocationInDate
		,@DateOut = @LocationOutDate
		,@ElapsedTime = @ElapsedTime
		,@AutomaticValue = 1
		,@IdPointOfInterestVisited = @Id
END
