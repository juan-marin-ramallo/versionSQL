/****** Object:  Procedure [dbo].[GetMarkTravelLocations]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 04/06/2021
-- Description:	SP para obtener las ubicaciones obtenidas
--				entre una marca de entrada y su correspondiente
--				marca de salida dada por parámetros.
-- =============================================
CREATE PROCEDURE [dbo].[GetMarkTravelLocations]
     @Id [sys].[int]
AS
BEGIN
    DECLARE @DateFrom [sys].[datetime]
	--DECLARE @DateRestFrom [sys].[datetime]
	--DECLARE @DateRestTo [sys].[datetime]
	DECLARE @DateTo [sys].[datetime]
	DECLARE @IdMarkStart [sys].[int]
	DECLARE @IdPersonOfInterest [sys].[int]

	SELECT	@DateTo = [Date], @IdMarkStart = [IdParent], @IdPersonOfInterest = [IdPersonOfInterest]
	FROM	[dbo].[Mark] WITH (NOLOCK)
	WHERE	[Id] = @Id

	SELECT	@DateFrom = [Date]
	FROM	[dbo].[Mark] WITH (NOLOCK)
	WHERE	[Id] = @IdMarkStart

	--SELECT	@DateRestFrom = [Date]
	--FROM	[dbo].[Mark] WITH (NOLOCK)
	--WHERE	[IdParent] = @IdMarkStart AND [Type] = 'ED'

	--SELECT	@DateRestTo = [Date]
	--FROM	[dbo].[Mark] WITH (NOLOCK)
	--WHERE	[IdParent] = @IdMarkStart AND [Type] = 'SD'

	SELECT		L.[Id], L.[Latitude], L.[Longitude]
	FROM		[dbo].[Location] L WITH (NOLOCK)
	WHERE		L.[IdPersonOfInterest] = @IdPersonOfInterest
				AND L.[Date] >=  DATEADD(MINUTE,-3,@DateFrom) and L.[Date] <= DATEADD(MINUTE,3,@DateTo)
				--AND ((@DateRestFrom IS NULL OR @DateRestTo IS NULL) OR (L.[Date] NOT BETWEEN @DateRestFrom AND @DateRestTo))
				And not exists (select 1 from PointOfInterestVisited poiv WITH (NOLOCK) WHERE poiv.IdPersonOfInterest = @IdPersonOfInterest and L.[Date] > DATEADD(MINUTE, 5, poiv.LocationInDate) and L.[Date] < DATEADD(MINUTE, -5, poiv.LocationOutDate))
				And not exists (select 1 from PointOfInterestManualVisited POIMV WITH (NOLOCK) WHERE POIMV.IdPersonOfInterest = @IdPersonOfInterest and L.[Date]> DATEADD(MINUTE, 5, POIMV.CheckInDate) and L.[Date] < DATEADD(MINUTE, -5, POIMV.CheckOutDate))
				--AND NOT EXISTS (SELECT TOP(1) 1 FROM [dbo].[PointOfInterestVisited] POIV WITH (NOLOCK) WHERE POIV.[IdPersonOfInterest] = L.[IdPersonOfInterest] AND POIV.[LocationInDate] < L.[Date] AND POIV.[LocationOutDate] > L.[Date])
				--AND NOT EXISTS (SELECT TOP(1) 1 FROM [dbo].[PointOfInterestManualVisited] POIMV where POIMV.[IdPersonOfInterest] = L.[IdPersonOfInterest] AND POIMV.[CheckInDate] < L.[Date] AND POIMV.[CheckOutDate] > L.[Date])
	ORDER BY	L.[Date]
END
