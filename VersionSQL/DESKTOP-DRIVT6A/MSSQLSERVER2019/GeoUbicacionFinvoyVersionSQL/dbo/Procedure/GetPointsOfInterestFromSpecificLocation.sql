/****** Object:  Procedure [dbo].[GetPointsOfInterestFromSpecificLocation]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Diego Cáceres
-- Create date: 03/11/2014
-- Description:	SP para obtener los datos de los puntos de interés cercanos a una posición específica
-- =============================================
CREATE PROCEDURE [dbo].[GetPointsOfInterestFromSpecificLocation]
	@Latitude decimal(25, 20),
	@Longitude decimal(25, 20) 	
AS
BEGIN
	DECLARE @CurrentLocationRadius [sys].[int]
	SET @CurrentLocationRadius = (SELECT CAST([Value] AS [sys].[int]) FROM [dbo].[ConfigurationTranslated] WITH (NOLOCK) WHERE [Id] = 12)

	DECLARE @LatLong [sys].[geography]
	SET @LatLong = [dbo].[ToGeography](@Latitude, @Longitude)
	
	SELECT		P.[Id], P.[Name], P.[Address], P.[Latitude], P.[Longitude], P.[Radius], P.[MinElapsedTimeForVisit], P.[IdDepartment]
	FROM		[dbo].[PointOfInterest] P WITH (NOLOCK)
				LEFT OUTER JOIN [dbo].[PointOfInterestZone] POIZ WITH (NOLOCK) ON POIZ.[IdPointOfInterest] = P.[Id]
	WHERE		P.[Deleted] = 0 AND				
				P.[LatLong].STDistance(@LatLong) < @CurrentLocationRadius
	GROUP BY	P.[Id], P.[Name], P.[Address], P.[Latitude], P.[Longitude], P.[Radius], P.[MinElapsedTimeForVisit], P.[IdDepartment]
END
