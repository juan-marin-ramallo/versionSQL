/****** Object:  Procedure [dbo].[GetPointOfInterestZones]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 15/08/2014
-- Description:	SP para obtener las zonas de un punto de interés
-- =============================================
CREATE PROCEDURE [dbo].[GetPointOfInterestZones]
(
	@IdPointOfInterest [sys].[int]
)
AS
BEGIN
	SELECT		Z.[Id], Z.[Description]
	FROM		[dbo].[ZoneTranslated] Z WITH (NOLOCK)
				INNER JOIN [dbo].[PointOfInterestZone] POIZ ON POIZ.[IdZone] = Z.[Id]
	WHERE		POIZ.[IdPointOfInterest] = @IdPointOfInterest
END
