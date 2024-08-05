/****** Object:  Procedure [dbo].[GetPersonOfInterestPointsOfInterestVisited]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 29/05/2015
-- Description:	SP para obtener los puntos de interés visitados de una Persona de Interes
-- =============================================
CREATE PROCEDURE [dbo].[GetPersonOfInterestPointsOfInterestVisited]
(
	@IdPersonOfInterest [sys].[int]
)
AS
BEGIN
	SELECT		POIV.[Id], POIV.[IdPersonOfInterest], POIV.[IdLocationIn], POIV.[LocationInDate], POIV.[LatitudeIn], POIV.[LongitudeIn], POIV.[IdLocationOut], POIV.[LocationOutDate], POIV.[IdPointOfInterest], POIV.[ElapsedTime], POIV.[ClosedByChangeOfDay]
	FROM		[dbo].[PointOfInterestVisited] POIV WITH (NOLOCK)
	WHERE		POIV.[IdPersonOfInterest] = @IdPersonOfInterest
				-- Se comento porque causaba marcas de entrada repetidas fuera de la ventana horaria
				-- AND [dbo].IsVisitedLocationInPointHourWindow(POIV.[IdPointOfInterest], POIV.[LocationInDate], POIV.[LocationOutDate]) = 1
	GROUP BY	POIV.[Id], POIV.[IdPersonOfInterest], POIV.[IdLocationIn], POIV.[LocationInDate], POIV.[LatitudeIn], POIV.[LongitudeIn], POIV.[IdLocationOut], POIV.[LocationOutDate], POIV.[IdPointOfInterest], POIV.[ElapsedTime], POIV.[ClosedByChangeOfDay]

	-- OLD)
	--SELECT		POIV.[Id], S.[Id] AS IdPersonOfInterest, S.[Name] AS PersonOfInterestName, S.[LastName] AS PersonOfInterestLastName, [IdLocationIn], LIN.[Date] AS LocationInDate, [IdLocationOut], LOUT.[Date] AS LocationOutDate, POIV.[IdPointOfInterest], P.[Name] AS PointOfInterestName, [ElapsedTime]
	--FROM		[dbo].[PointOfInterestVisited] POIV WITH (NOLOCK) 
	--			INNER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = POIV.[IdPointOfInterest]
	--			INNER JOIN [dbo].[Location] LIN WITH (NOLOCK) ON LIN.[Id] = POIV.[IdLocationIn]
	--			LEFT OUTER JOIN [dbo].[Location] LOUT WITH (NOLOCK) ON LOUT.[Id] = POIV.[IdLocationOut]
	--			INNER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON S.[Id] = LIN.[IdPersonOfInterest]
	--WHERE		LIN.IdPersonOfInterest = @IdPersonOfInterest
	--GROUP BY	POIV.[Id], S.[Id], S.[Name], S.[LastName], [IdLocationIn], LIN.[Date], [IdLocationOut], LOUT.[Date], POIV.[IdPointOfInterest], P.[Name], [ElapsedTime]
END
