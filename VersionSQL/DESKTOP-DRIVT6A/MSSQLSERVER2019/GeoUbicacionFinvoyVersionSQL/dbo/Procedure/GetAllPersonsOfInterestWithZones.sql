/****** Object:  Procedure [dbo].[GetAllPersonsOfInterestWithZones]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 02/04/2018
-- Description:	SP para obtener todas las personas y sus zonas
-- =============================================
CREATE PROCEDURE [dbo].[GetAllPersonsOfInterestWithZones]
AS
BEGIN
	SELECT		P.[Id] as IdPersonOfInterest, Z.[Id], Z.[Description]
	
	FROM		[dbo].[PersonOfInterest] P
				INNER JOIN [dbo].[PersonOfInterestZone] PIZ ON PIZ.[IdPersonOfInterest] = P.[Id]
				INNER JOIN [dbo].[ZoneTranslated] Z ON PIZ.[IdZone] = Z.[Id]
	
	WHERE		Z.[ApplyToAllPersonOfInterest] = 0

	UNION

	SELECT		P.[Id] as IdPersonOfInterest, 0 AS Id, '' AS Description
	
	FROM		[dbo].[PersonOfInterest] P
	
	WHERE		P.[Id] NOT IN (
				SELECT IdPersonOfInterest from [dbo].[PersonOfInterestZone] PIZ
				INNER JOIN [dbo].[ZoneTranslated] Z ON PIZ.[IdZone] = Z.[Id]
				WHERE		Z.[ApplyToAllPersonOfInterest] = 0)


	ORDER BY	P.[Id] 
END
