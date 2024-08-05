/****** Object:  Procedure [dbo].[UpdatePointsOfInterestActivity]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 19/10/2016
-- Description:	SP para guardar varios puntos de interés visitados
-- =============================================
CREATE PROCEDURE [dbo].[UpdatePointsOfInterestActivity]
(
	 @IdPointOfInterest [sys].[int]
    ,@DateIn [sys].[datetime]
    ,@DateOut [sys].[datetime]
	,@ElapsedTime [sys].[time]
    ,@AutomaticValue [sys].[smallint]
	,@IdPointOfInterestManualVisited [sys].[int]
)
AS
BEGIN
	SET NOCOUNT OFF;
	DECLARE @Id [sys].[int]
	DECLARE @InHourWindow [sys].[bit]
	
	SELECT TOP 1 @Id = Id 
	FROM [dbo].[PointOfInterestActivity] 
	WHERE @IdPointOfInterestManualVisited IS NOT NULL AND IdPointOfInterestManualVisited = @IdPointOfInterestManualVisited

	SET @InHourWindow = [dbo].[IsVisitedLocationInPointHourWindowIgnoreConfig](@IdPointOfInterest, @DateIn, ISNULL(@DateOut, @DateIn))

	IF @Id IS NOT NULL AND @AutomaticValue = 2
	BEGIN
		UPDATE [dbo].[PointOfInterestActivity]
		SET  [DateIn] = @DateIn
			,[DateOut] = @DateOut
			,[ElapsedTime] = @ElapsedTime
			,[InHourWindow] = @InHourWindow
		WHERE Id = @Id
	END
END
