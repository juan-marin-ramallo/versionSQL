/****** Object:  Procedure [dbo].[GetPointsOfInterestWithNoZone]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 03/03/2015
-- Description:	Rtorna todos los puntos de interes independientemente de si tengan zona asociada o no
-- =============================================
CREATE PROCEDURE [dbo].[GetPointsOfInterestWithNoZone]	
AS
BEGIN
	
		SELECT		P.[Id], P.[Name], P.[Address], P.[Latitude], P.[Longitude], P.[Identifier]
	FROM		[dbo].[PointOfInterest] P
				LEFT OUTER JOIN [dbo].[PointOfInterestZone] PZ ON PZ.[IdPointOfInterest] = P.[Id]
	WHERE		P.[Deleted] = 0 AND				
				PZ.[IdPointOfInterest] IS NULL
	GROUP BY	P.[Id], P.[Name], P.[Address], P.[Latitude], P.[Longitude], P.[Identifier]
END
