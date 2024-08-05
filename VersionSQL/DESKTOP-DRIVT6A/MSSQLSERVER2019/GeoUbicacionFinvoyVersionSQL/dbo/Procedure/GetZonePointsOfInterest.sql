/****** Object:  Procedure [dbo].[GetZonePointsOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 26/08/2016
-- Description:	SP para obtener los puntos de interes de una zona
-- =============================================
CREATE PROCEDURE [dbo].[GetZonePointsOfInterest]
(
	@IdZone [sys].[int]
)
AS
BEGIN
	SELECT		P.[Id], P.[Name], P.[Identifier]
	FROM		[dbo].[PointOfInterest] P WITH (NOLOCK)
				INNER JOIN [dbo].[PointOfInterestZone] PIZ WITH (NOLOCK) ON PIZ.[IdPointOfInterest] = P.[Id]
	WHERE		PIZ.[IdZone] = @IdZone AND P.[Deleted] = 0
END
