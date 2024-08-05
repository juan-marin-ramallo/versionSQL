/****** Object:  Procedure [dbo].[GetZones]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 22/10/2012
-- Description:	SP para obtener las zonas
-- =============================================
CREATE PROCEDURE [dbo].[GetZones]
(
	 @IdZones [sys].[varchar](1000) = NULL
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL
	,@IdPointsOfInterest [sys].[varchar](max) = NULL
	,@IdUser [sys].[int] = NULL
)
AS
BEGIN
	;WITH vPointsZones([IdZone], [IdPointOfInterest]) AS
	(
		SELECT	[IdZone], [IdPointOfInterest]
		FROM	[dbo].[PointOfInterestZone] WITH (NOLOCK)
		WHERE	(CASE WHEN @IdPointsOfInterest IS NULL THEN 1 ELSE dbo.CheckValueInList([IdPointOfInterest], @IdPointsOfInterest) END) = 1
	),
	vPersonsZones([IdZone], [IdPersonOfInterest]) AS
	(
		SELECT	[IdZone], [IdPersonOfInterest]
		FROM	[dbo].[PersonOfInterestZone] WITH (NOLOCK)
		WHERE	(CASE WHEN @IdPersonsOfInterest IS NULL THEN 1 ELSE dbo.CheckValueInList([IdPersonOfInterest], @IdPersonsOfInterest) END) = 1
	)

	
	SELECT		[Id], [Description], [Date], [ApplyToAllPointOfInterest], [ApplyToAllPersonOfInterest]
	
	FROM		[dbo].[ZoneTranslated] Z WITH (NOLOCK)
				LEFT JOIN vPointsZones POIZ WITH (NOLOCK) ON POIZ.[IdZone] =  Z.[Id]
				LEFT JOIN vPersonsZones PIZ WITH (NOLOCK) ON PIZ.[IdZone] =  Z.[Id]
	
	WHERE		(CASE WHEN @IdZones IS NULL THEN 1 ELSE dbo.CheckValueInList(Z.[Id], @IdZones) END) = 1
				AND (CASE WHEN @IdUser IS NULL THEN 1 ELSE dbo.CheckZoneInUserZones(Z.[Id], @IdUser) END) = 1
	
	GROUP BY	[Id], [Description], [Date], [ApplyToAllPointOfInterest], [ApplyToAllPersonOfInterest]
	ORDER BY	[Description]
END
-- OLD)
--BEGIN
	
--	SELECT		[Id], [Description], [Date], [ApplyToAllPointOfInterest], [ApplyToAllPersonOfInterest]
	
--	FROM		[dbo].[ZoneTranslated] Z WITH (NOLOCK)
--				left JOIN [dbo].[PointOfInterestZone] POIZ WITH (NOLOCK) ON POIZ.[IdZone] =  Z.[Id]
--				left JOIN [dbo].[PersonOfInterestZone] PIZ WITH (NOLOCK) ON PIZ.[IdZone] =  Z.[Id]
	
--	WHERE		((@IdZones IS NULL) OR (dbo.CheckValueInList(Z.[Id], @IdZones) = 1)) AND
--				((@IdUser IS NULL) OR (dbo.CheckZoneInUserZones(Z.[Id], @IdUser) = 1)) AND
--				((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(PIZ.[IdPersonOfInterest], @IdPersonsOfInterest) = 1)) AND
--				((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(POIZ.[IdPointOfInterest], @IdPointsOfInterest) = 1))
	
--	GROUP BY	[Id], [Description], [Date], [ApplyToAllPointOfInterest], [ApplyToAllPersonOfInterest]
--	ORDER BY	[Description]
--END
