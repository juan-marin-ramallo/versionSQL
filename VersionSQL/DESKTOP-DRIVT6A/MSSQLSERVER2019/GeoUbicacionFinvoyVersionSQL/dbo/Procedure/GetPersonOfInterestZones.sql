/****** Object:  Procedure [dbo].[GetPersonOfInterestZones]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 16/11/2015
-- Description:	SP para obtener las zonas de una persona de interés
-- =============================================
CREATE PROCEDURE [dbo].[GetPersonOfInterestZones]
(
	@IdPersonOfInterest [sys].[int]
)
AS
BEGIN
	SELECT		Z.[Id], Z.[Description]
	FROM		[dbo].[ZoneTranslated] Z WITH (NOLOCK)
				INNER JOIN [dbo].[PersonOfInterestZone] PIZ ON PIZ.[IdZone] = Z.[Id]
	WHERE		PIZ.[IdPersonOfInterest] = @IdPersonOfInterest
END
