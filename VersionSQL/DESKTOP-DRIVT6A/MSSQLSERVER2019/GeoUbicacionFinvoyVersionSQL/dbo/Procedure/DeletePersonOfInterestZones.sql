/****** Object:  Procedure [dbo].[DeletePersonOfInterestZones]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 16/11/2015
-- Description:	SP para eliminar las zonas de una persona de interés
-- =============================================
CREATE PROCEDURE [dbo].[DeletePersonOfInterestZones]
(
	 @IdPersonOfInterest [sys].[int]
)
AS
BEGIN
	DELETE FROM	[dbo].[PersonOfInterestZone]
	WHERE		IdPersonOfInterest = @IdPersonOfInterest
				AND	IdZone NOT IN (SELECT Id FROM [dbo].[ZoneTranslated] WITH (NOLOCK) WHERE ApplyToAllPersonOfInterest = 1)
END
