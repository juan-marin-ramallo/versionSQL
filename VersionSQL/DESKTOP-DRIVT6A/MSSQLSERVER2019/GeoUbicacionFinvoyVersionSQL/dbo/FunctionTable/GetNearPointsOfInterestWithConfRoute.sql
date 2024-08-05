/****** Object:  TableFunction [dbo].[GetNearPointsOfInterestWithConfRoute]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		FS
-- Create date: 28/11/19
-- Description:	SP para obtener puntos cerca de persona respetando configuración de usar en ruta
-- =============================================
CREATE FUNCTION [dbo].[GetNearPointsOfInterestWithConfRoute] (
 	@IdPersonOfInterest [sys].[int],
	@Latitude [sys].[decimal](25, 20) = NULL,
	@Longitude [sys].[decimal](25, 20) = NULL
	)
	RETURNS @t TABLE (Id [sys].[int], Name [sys].[VARCHAR](100), Identifier [sys].[VARCHAR](50), 
				[Address] [sys].[VARCHAR](250), Latitude [sys].[DECIMAL](25, 20), Longitude [sys].[DECIMAL](25, 20), 
				Radius [sys].[int], [NFCTagId] [sys].[VARCHAR](20))	
AS
BEGIN
	DECLARE @PersonOfInterestLatLong [sys].[geography] 
	DECLARE @IdPersonOfInterestLocal [sys].[int] = @IdPersonOfInterest
	DECLARE @LatitudeLocal [sys].[decimal](25, 20) = @Latitude
	DECLARE @LongitudeLocal [sys].[decimal](25, 20) = @Longitude
	
	DECLARE @ConfValueUsePointsInRoute [sys].[varchar](250) = (SELECT [Value] FROM [dbo].[ConfigurationTranslated] WITH (NOLOCK) WHERE [Id] = 4067)
	DECLARE @SystemToday [sys].[datetime]
	SET @SystemToday = DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(GETUTCDATE())), 0)
	
	IF @LatitudeLocal IS NULL AND @LongitudeLocal IS NULL
	BEGIN
		SET @PersonOfInterestLatLong = (SELECT TOP 1 [LatLong] FROM [dbo].[CurrentLocation] WITH (NOLOCK) WHERE [IdPersonOfInterest] = @IdPersonOfInterestLocal ORDER BY [Date] DESC)
	END
	ELSE
	BEGIN
		SET @PersonOfInterestLatLong = GEOGRAPHY::STPointFromText('POINT(' + CAST(@LongitudeLocal AS VARCHAR(25)) + ' ' + CAST(@LatitudeLocal AS VARCHAR(25)) + ')', 4326)
	END

	--IF @ConfValueUsePointsInRoute = '1'
	--BEGIN

		;WITH PersonRoutesDetail([Id], [RouteDate], [RouteDateSystem], [IdRoutePointOfInterest]) AS
		(
			SELECT	RD.[Id], RD.[RouteDate], Tzdb.FromUtc(RD.[RouteDate]) AS RouteDateSystem, RD.[IdRoutePointOfInterest]
			FROM	[dbo].[RouteDetail] RD WITH (NOLOCK)
			WHERE	RD.[Disabled] = 0
		),
		TodayPersonRoutes([IdRouteDetail], [IdPointOfInterest]) AS
		(
			SELECT	RD.[Id], RP.[IdPointOfInterest]
			FROM	[dbo].[RouteGroup] RG WITH (NOLOCK) 
					INNER JOIN [dbo].[RoutePointOfInterest] RP WITH (NOLOCK) ON RP.[IdRouteGroup] = RG.[Id]
					INNER JOIN PersonRoutesDetail RD WITH (NOLOCK) ON RD.[IdRoutePointOfInterest] = RP.[Id] AND RD.[RouteDateSystem] >= @SystemToday AND RD.[RouteDateSystem] < DATEADD(DAY, 1, @SystemToday)
			WHERE	RG.[IdPersonOfInterest] = @IdPersonOfInterestLocal
		), 
		PointsNearInRoute([Id], [Name], [Identifier], [Address], [Latitude], [Longitude], [Radius], [NFCTagId], [InRoute]) AS 
		(
			SELECT	P.[Id], P.[Name], P.[Identifier], 
						P.[Address], P.[Latitude] , P.[Longitude], 
						P.[Radius], P.[NFCTagId], IIF(TPR.[IdRouteDetail] IS NULL, 0, 1) AS [InRoute]
			FROM	[dbo].[PointOfInterest] P WITH (NOLOCK)		
					LEFT OUTER JOIN TodayPersonRoutes TPR WITH (NOLOCK) ON TPR.[IdPointOfInterest] = P.[Id]
			WHERE	P.[Deleted] = 0
					AND P.[LatLong].STDistance(@PersonOfInterestLatLong) <= P.[Radius]
					AND (@ConfValueUsePointsInRoute = '0' OR TPR.[IdRouteDetail] IS NOT NULL)
			GROUP BY P.[Id], P.[Name], P.[Identifier], P.[Address], P.[Latitude], P.[Longitude], P.[Radius], P.[NFCTagId], IIF(TPR.[IdRouteDetail] IS NULL, 0, 1)
		)
		INSERT INTO @t 
		SELECT	TOP(1) P.[Id], P.[Name], P.[Identifier], 
					P.[Address], P.[Latitude] , P.[Longitude], 
					P.[Radius], P.[NFCTagId]
		FROM	PointsNearInRoute P WITH (NOLOCK)
		ORDER BY [InRoute] desc, GEOGRAPHY::STPointFromText('POINT(' + CAST(P.Longitude AS VARCHAR(25)) + ' ' + CAST(P.Latitude AS VARCHAR(25)) + ')', 4326).STDistance(@PersonOfInterestLatLong) ASC
	--END
	--ELSE
	--BEGIN
	--	INSERT INTO @t 
	--	SELECT P.[Id], P.[Name], P.[Identifier], 
	--				P.[Address], P.[Latitude] , P.[Longitude], 
	--				P.[Radius], P.[NFCTagId] 	
	--	FROM [dbo].[PointOfInterest] P WITH (NOLOCK) 
	--	WHERE P.[Deleted] = 0 AND P.[LatLong].STDistance(@PersonOfInterestLatLong) <= P.[Radius]
	--	ORDER BY P.[LatLong].STDistance(@PersonOfInterestLatLong) ASC
	--END
	RETURN
END
