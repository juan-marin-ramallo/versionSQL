/****** Object:  Procedure [dbo].[GetZonePersonsOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 26/08/2016
-- Description:	SP para obtener las personas de interes de una zona
-- =============================================
CREATE PROCEDURE [dbo].[GetZonePersonsOfInterest]
(
	@IdZone [sys].[int]
)
AS
BEGIN
	SELECT		P.[Id], P.[Name], P.[LastName]
	FROM		[dbo].[PersonOfInterest] P WITH (NOLOCK)
				INNER JOIN [dbo].[PersonOfInterestZone] PIZ WITH (NOLOCK) ON PIZ.[IdPersonOfInterest] = P.[Id]
	WHERE		PIZ.[IdZone] = @IdZone AND P.[Deleted] = 0
END
