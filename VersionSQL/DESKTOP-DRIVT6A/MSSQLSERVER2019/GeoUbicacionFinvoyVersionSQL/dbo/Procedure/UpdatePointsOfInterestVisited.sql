/****** Object:  Procedure [dbo].[UpdatePointsOfInterestVisited]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 19/10/2016
-- Description:	SP para actualizar varios puntos de interés visitados
-- =============================================
CREATE PROCEDURE [dbo].[UpdatePointsOfInterestVisited]
(
	@PointsOfInterestVisited [dbo].PointOfInterestVisitedTableType READONLY
)
AS
BEGIN
	UPDATE	PV
	SET		[IdLocationIn] = P.[IdLocationIn]
		   ,[LocationInDate] = P.[LocationInDate]
		   ,[IdLocationOut] = P.[IdLocationOut]
		   ,[LocationOutDate] = P.[LocationOutDate]
		   ,[IdPointOfInterest] = P.[IdPointOfInterest]
		   ,[ElapsedTime] = P.[ElapsedTime]
		   ,[DeletedByNotVisited] = P.[DeletedByNotVisited]
		   ,[LatitudeIn] = IIF(P.[LatitudeIn] IS NULL OR  P.[LatitudeIn] = 0, PV.LatitudeIn, p.[LatitudeIn])
		   ,[LongitudeIn] = IIF(P.[LongitudeIn] IS NULL OR  P.[LongitudeIn] = 0, PV.[LongitudeIn], p.[LongitudeIn]) 		   
		   ,[InHourWindow] = [dbo].[IsVisitedLocationInPointHourWindowIgnoreConfig](P.IdPointOfInterest, P.LocationInDate, P.LocationOutDate)
	FROM	[dbo].[PointOfInterestVisited] PV
			INNER JOIN @PointsOfInterestVisited P ON P.[Id] = PV.[Id]
END
